function pre_build {
    set -x
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    export CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing -ffast-math"
    build_simple fftw 3.3.7 \
        http://www.fftw.org/ tar.gz \
        --with-pic --enable-shared --enable-threads --disable-fortran \
        --enable-float --enable-sse --enable-sse2 --enable-avx

    # eval cd tests && make check-local && cd -
}

function run_tests {
    python ../run_test.py
}
