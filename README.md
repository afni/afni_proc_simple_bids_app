# afni_proc_simple_bids_app

First draft of making an afni_proc.py BIDS-App with "simple"
afni_proc.py processing (for single echo FMRI at the moment)

--------------------------------------------------------------------------

To run (see details in program help file): 

Execute the [scripts/run_ap_simple_bidsapp](scripts/run_ap_simple_bidsapp) script with 2 args:

     DIR_INPUT  : BIDS-formatted input directory
     DIR_OUTPUT : to-be-created output directory of processed sets

Example: 

     scripts/run_ap_simple_bidsapp bids_dataset afni_proc_dataset
