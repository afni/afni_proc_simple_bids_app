FROM afni/afni_make_build:AFNI_24.1.19

# Workaround for https://github.com/afni/afni/issues/646
# Placing under /opt/afni/data and setting AFNI_ATLAS_PATH so it would be
# a generic soluiton for both make and cmake builds
RUN wget -nv -O /tmp/afni_atlases.tgz https://afni.nimh.nih.gov/pub/dist/atlases/afni_atlases_dist_2024_0503.tgz && \
    mkdir "$AFNI_ROOT/../atlases" && \
    tar -xzf /tmp/afni_atlases.tgz -C "$AFNI_ROOT/../atlases" --strip-components=1 && \
    rm /tmp/afni_atlases.tgz
ENV AFNI_ATLAS_PATH=$AFNI_ROOT/../atlases

COPY scripts/* /usr/local/bin/
ENTRYPOINT ["/usr/local/bin/run_20_ap_simple"]

