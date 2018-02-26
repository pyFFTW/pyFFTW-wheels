function pre_build {
    # Any stuff that you need to do before you start building the wheels
    # Runs in the root directory of this repository.
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
