FROM afni/afni_make_build:AFNI_24.1.19

COPY scripts/* /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/run_20_ap_simple"]

