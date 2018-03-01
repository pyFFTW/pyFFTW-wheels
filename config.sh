function pre_build {
    set -x
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.

    # https://github.com/matthew-brett/multibuild/pull/146
    yum install -y rsync

    # Taken from: https://github.com/conda-forge/fftw-feedstock/blob/master/recipe/build.sh
    export CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing -ffast-math"
    build_simple fftw 3.3.7 \
        http://www.fftw.org/ tar.gz \
        --with-pic --enable-shared --enable-threads --disable-fortran \
        --enable-float --enable-sse --enable-sse2 --enable-avx

    # eval cd tests && make check-local && cd -

    # Taken from: https://github.com/conda-forge/pyfftw-feedstock/blob/master/recipe/build.sh
    # Should this be in env_vars.sh ?
    export C_INCLUDE_PATH=$PREFIX/include  # required as fftw3.h installed here

    # define STATIC_FFTW_DIR so the patched setup.py will statically link FFTW
    export STATIC_FFTW_DIR=$PREFIX/lib
}

function run_tests {
    python ../run_test.py
}
