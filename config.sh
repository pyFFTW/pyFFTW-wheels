function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
    mkdir fftw
    cd fftw/
    curl -L "http://www.fftw.org/fftw-3.3.7.tar.gz" --output fftw-3.3.7.tar.gz
    tar -xzf fftw-3.3.7.tar.gz
    cd fftw-3.3.7
    export CFLAGS="-O3 -fomit-frame-pointer -fstrict-aliasing -ffast-math"
    export CONFIGURE="./configure --prefix=$PREFIX --with-pic --enable-shared --enable-threads --disable-fortran"
    $CONFIGURE --enable-float --enable-sse --enable-sse2 --enable-avx
    make -j 4
    make install
    # eval cd tests && make check-local && cd -
}

function run_tests {
    # Runs tests on installed distribution from an empty directory
    python --version
    python - <<-EOF
import numpy as np

import pyfftw.builders
from pyfftw.interfaces.numpy_fft import fftn
r = np.random.randn(32, 32, 32)

# the following transform will fail if MKL FFT routines are being linked to
# instead of the FFTW ones.  (MKL doesn't support FFT of only 1
# dimension of a 3D array).
# see:  https://github.com/pyFFTW/pyFFTW/issues/40
fftn(r, axes=(0, ))
    EOF
}
