# Taken from: https://github.com/conda-forge/pyfftw-feedstock/blob/master/recipe/run_test.py
import numpy as np

import pyfftw.builders
from pyfftw.interfaces.numpy_fft import fftn
r = np.random.randn(32, 32, 32)

# the following transform will fail if MKL FFT routines are being linked to
# instead of the FFTW ones.  (MKL doesn't support FFT of only 1
# dimension of a 3D array).
# see:  https://github.com/pyFFTW/pyFFTW/issues/40
fftn(r, axes=(0, ))
