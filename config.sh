function pre_build {
    set -e
    echo "Starting pre-build"

    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.

    echo 'Building fftw'
    # Taken from: https://github.com/conda-forge/fftw-feedstock/blob/master/recipe/build.sh
    export CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing -ffast-math"

    # TODO: make this a loop:
    # single
    echo 'Building fftw: single'
    build_simple fftw 3.3.7 \
        http://www.fftw.org/ tar.gz \
        --with-pic --enable-shared --enable-threads --disable-fortran \
        --enable-float --enable-sse --enable-sse2 --enable-avx
    echo 'Testing fftw: single'        
    eval cd fftw-3.3.7/tests && make check-local && cd -

    # Clear stamp file which prevents subsequent builds
    rm fftw-stamp

    # double
    echo 'Building fftw: double'
    build_simple fftw 3.3.7 \
        http://www.fftw.org/ tar.gz \
        --with-pic --enable-shared --enable-threads --disable-fortran \
        --enable-sse2 --enable-avx
    echo 'Testing fftw: double'        
    eval cd fftw-3.3.7/tests && make check-local && cd -

    # Clear stamp file which prevents subsequent builds
    rm fftw-stamp

    # long double (SSE2 and AVX not supported)
    echo 'Building fftw: long double'
    build_simple fftw 3.3.7 \
        http://www.fftw.org/ tar.gz \
        --with-pic --enable-shared --enable-threads --disable-fortran \
        --enable-long-double
    echo 'Testing fftw: long double'        
    eval cd fftw-3.3.7/tests && make check-local && cd -

    # Taken from: https://github.com/conda-forge/pyfftw-feedstock/blob/master/recipe/build.sh
    export C_INCLUDE_PATH=$BUILD_PREFIX/include  # required as fftw3.h installed here

    # define STATIC_FFTW_DIR so the patched setup.py will statically link FFTW
    export STATIC_FFTW_DIR=$BUILD_PREFIX/lib

    # TODO: These can be made into asserts per:
    # https://github.com/conda-forge/fftw-feedstock/blob/8eaa8a1c63e7fcb97c63c1ee8e33c62ef3afa9c7/recipe/meta.yaml#L29-L52
    ls -l $C_INCLUDE_PATH/fftw3*
    ls -l $STATIC_FFTW_DIR/libfftw3*

    # Clear CFLAGS from fftw build
    export CFLAGS=""

    if [ -z "$IS_OSX" ]; then
        # -Bsymbolic link flag to ensure MKL FFT routines don't shadow FFTW ones.
        # see:  https://github.com/pyFFTW/pyFFTW/issues/40
        export CFLAGS="$CFLAGS -Wl,-Bsymbolic"
    fi
}

function run_tests {
    echo "Starting tests..."
    python ../run_test.py
}
