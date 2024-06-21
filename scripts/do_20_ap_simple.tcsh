#!/bin/tcsh

# AP simple: run afni_proc.py for full FMRI processing (for initial QC)

# Process a single subj+ses pair.

# This is a Desktop script.  Run it via partner run*.tcsh.


# initial exit code; we don't exit at fail, to copy partial results back
set ecode = 0

# ---------------------------------------------------------------------------
# top level definitions (constant across demo)
# ---------------------------------------------------------------------------

# labels
set dir_basic      = $1                # INPUT group level dir
set dir_ap         = $2                # OUTPUT group level dir
set subj           = $3
set ses            = $4
set ap_label       = 20_ap_simple

if ( "${subj}" == "" ) then
    echo "** ERROR: need 3 or 4 command line args:"
    echo "       DIR_INPUT  DIR_OUTPUT  SUBJ [SES]"
    exit 1
endif

# full file name for subj (which might optionally include ses)
set fsubj = ${subj}
if ( ${ses} != "" ) then
    set fsubj = ${fsubj}/${ses}
endif

# subject directories
set sdir_basic     = ${dir_basic}/${fsubj}
set sdir_func      = ${sdir_basic}/func
set sdir_anat      = ${sdir_basic}/anat
set sdir_ap        = ${dir_ap}/${fsubj}

# set output directory
set sdir_out = ${sdir_ap}
set lab_out  = AP

# --------------------------------------------------------------------------
# data and control variables
# --------------------------------------------------------------------------

setenv AFNI_COMPRESSOR GZIP

# dataset inputs
set task_label    = "" #task-rest_run-1

set dsets_epi     = ( ${sdir_func}/${subj}*${task_label}*bold.nii* )
set dset_anat_00  = ( ${sdir_anat}/${subj}*_T1w.nii.gz )

# want >0 EPI
if ( ${#dsets_epi} == 0 ) then
    echo "+* ERROR: need at least one EPI"
    exit 2
endif

# only want 1 anatomical
if ( `echo "${#dset_anat_00} > 1" | bc` ) then
    echo "+* WARN: more than 1 anatomical, just choosing first:"
    set dset_anat_00 = "${dset_anat_00[1]}"
    echo "   ${dset_anat_00}"
endif

# control variables
#set nt_rm         = 4       # number of time points to remove at start
#set blur_size     = 6       # blur size to apply 
#set final_dxyz    = 3       # final voxel size (isotropic dim)
#set cen_motion    = 0.2     # censor threshold for motion (enorm) 
#set cen_outliers  = 0.05    # censor threshold for outlier frac


# check available N_threads and report what is being used
set nthr_avail = `afni_system_check.py -disp_num_cpu`
set nthr_using = `afni_check_omp`

echo "++ INFO: Using ${nthr_using} of available ${nthr_avail} threads"


# ---------------------------------------------------------------------------
# run programs
# ---------------------------------------------------------------------------

# make output directory and go to it
\mkdir -p ${sdir_out}
cd ${sdir_out}

# create command script
set run_script = ap.cmd.${subj}

cat << EOF >! ${run_script}

# AP, run simple
#
# single-echo FMRI, simple processing for initial QC
# anatomical has skull on
# template will be default (MNI*SSW*.nii.gz)

ap_run_simple_rest.tcsh                                                \
    -run_ap                                                            \
    -subjid      ${subj}                                               \
    -anat        ${dset_anat_00}                                       \
    -epi         ${dsets_epi}

EOF

if ( ${status} ) then
    set ecode = 1
    goto COPY_AND_EXIT
endif

# execute AP command to make processing script
tcsh -xef ${run_script} |& tee output.ap.cmd.${subj}

if ( ${status} ) then
    set ecode = 2
    goto COPY_AND_EXIT
endif


# execute the proc script, saving text info
time tcsh -xef proc.${subj} |& tee output.proc.${subj}

if ( ${status} ) then
    set ecode = 3
    goto COPY_AND_EXIT
endif

echo "++ FINISHED ${lab_out}"

# ---------------------------------------------------------------------------

COPY_AND_EXIT:


if ( ${ecode} ) then
    echo "++ BAD FINISH: ${lab_out} (ecode = ${ecode})"
else
    echo "++ GOOD FINISH: ${lab_out}"
endif

exit ${ecode}

