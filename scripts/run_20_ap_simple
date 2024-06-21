#!/bin/tcsh

# AP SIMPLE: run afni_proc.py for full FMRI processing (quick/simple proc)
#  -> the Desktop version

# This script runs a corresponding do_*.tcsh script for a given
# subj+ses pair. This script loops over subj+ses pairs from basic dir

# To execute:  
#     tcsh RUN_SCRIPT_NAME

# --------------------------------------------------------------------------

set dir_basic     = "$1"
set dir_output    = "$2"

if ( "${dir_output}" == "" ) then
    echo "** ERROR: need exactly 2 command line args:"
    echo "       DIR_INPUT  DIR_OUTPUT"
    exit 1
endif

# specify script to execute
set cmd           = 20_ap_simple

# basic and output need to be abs path
cd ${dir_basic}
set dir_basic = ${PWD}
cd -
\mkdir -p ${dir_output}
cd ${dir_output}
set dir_output = ${PWD}
cd -

# upper directories
set dir_scr       = $PWD
set dir_swarm     = ${dir_output}/code

# running
set scr_swarm     = ${dir_swarm}/swarm_${cmd}.tcsh
set scr_cmd       = ${dir_scr}/do_${cmd}.tcsh

# --------------------------------------------------------------------------

# make output directory and swarm directory, if not already existing
\mkdir -p ${dir_swarm}

# clear away older swarm script 
if ( -e ${scr_swarm} ) then
    \rm ${scr_swarm}
endif

# --------------------------------------------------------------------------

# get list of all subj IDs for proc
cd ${dir_basic}
set all_subj = ( sub-* )
cd -

cat <<EOF

++ Proc command:  ${cmd}
++ Found ${#all_subj} subj:

EOF

# -------------------------------------------------------------------------
# build swarm command

# loop over all subj
foreach subj ( ${all_subj} )

    # use python to check if we have session level
    cd ${dir_basic}/${subj}
    set check_ses = `python -c "import glob; print(glob.glob('ses-*'))" \
                            | sed 's/\[//g' | sed 's/\]//g'`
    cd -
    if ( "${check_ses}" == "" ) then
        # no session level
        set nses = 0
    else
        # have session level; get list of all ses for the subj
        cd ${dir_basic}/${subj}
        set all_ses = ( ses-* )
        set nses    = ${#all_ses}
        cd -
    endif

    if ( ${nses} ) then
        # loop over all ses
        foreach ses ( ${all_ses} )
            echo "++ Prepare cmd for: ${subj} - ${ses}"

            # add cmd to swarm script (verbosely, and don't use '-e')
            echo "tcsh -xf ${scr_cmd} ${dir_basic} ${dir_output} ${subj} ${ses}"    >> ${scr_swarm}
        end
    else
        echo "++ Prepare cmd for: ${subj}"

        # add cmd to swarm script (verbosely, and don't use '-e')
        echo "tcsh -xf ${scr_cmd} ${dir_basic} ${dir_output} ${subj} "    >> ${scr_swarm}
    endif
end

# -------------------------------------------------------------------------
# run swarm command
cd ${dir_scr}

echo "++ And start running: ${scr_swarm}"

#exit 0

##### add in later ####
tcsh ${scr_swarm}
