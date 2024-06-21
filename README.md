# afni_proc_simple_bids_app
First draft of making an afni_proc.py BIDS-App with "simple"
afni_proc.py processing

--------------------------------------------------------------------------

To run: 

Execute the run*.tcsh script with 2 args:

     DIR_INPUT  : BIDS-formatted input directory
     DIR_OUTPUT : to-be-created output directory of processed sets

Example: 

     tcsh run_20_ap_simple.tcsh group_dir_raw group_dir_proc