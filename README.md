<!-- lint disable -->

**Documentation**

**Code quality and style**

**Unit tests and coverage**

**How to cite**

**Contributors**

# CPP ROI

## :warning: :warning: :warning:

**This code is fairly unstable (:boom:) and might still change a lot.**

Also this code currently has 0% test coverage...

---

Set of Octave and Matlab functions, demos and scripts to help manage ROIs and to
play nice with BIDS datasets.

Mostly volume-based and SPM centric.

For surface based and freesurfer ROIs see for example:

-   https://github.com/noahbenson/neuropythy

## Installation

Download this repository and unzip the content where you want to install it.

Or clone the repo.

```bash
git clone https://github.com/cpp-lln-lab/CPP_ROI.git
```

Fire up Octave or Matlab and type

```matlab

cd CPP_ROI

% Th following adds the relevant folders to your path.
% This needs to be done once per session (your path will not be saved)

initCppRoi

```

If you are using CPP_SPM, you got nothing to do as CPP_ROI is already installed
as a submodule, and intitialized when running `initCppSpm`.

### Dependencies

TODO

| Dependencies                                               | Used version |
| ---------------------------------------------------------- | ------------ |
| [Matlab](https://www.mathworks.com/products/matlab.html)   | 20???        |
| or [octave](https://www.gnu.org/software/octave/)          | 4.?          |
| [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/) | v7487        |

-   bids-matlab (INSERT URL)

-   currently still needs some CPP_SPM function but ultimately should be
    standalone: this will most likely happen when some functions are passed to
    bids-matlab

-   Other dependencies (MarsBar) are shipped with CPP_ROI in the `lib` folder.

## Features

-   create ROI from probability maps
-   create ROI filenames that "BIDS-ish"
-   extract ROI with a given numerical label
-   extract ROI from one hemisphere
-   breaks a cluster image into several ROIs with each their own label

### Atlas

-   Can help generate ROI based on:
    -   the SPM Anatomy toolbox (INSERT URL)
    -   the SPM neuromorphometric atlas
    -   neurosynth probabilty maps
    -   the probabilistic maps of visual topography in human cortex:
        -   https://scholar.princeton.edu/napl/resources
        -   Wang, L., Mruczek, R. E., Arcaro, M. J., & Kastner, S. (2015).
            Probabilistic Maps of Visual Topography in Human Cortex. Cerebral
            cortex (New York, N.Y. : 1991), 25(10), 3911–3931.
            https://doi.org/10.1093/cercor/bhu277

Also includes:

-   Yeo's 7 networks "atlas"
    -   add REF and URL



## Contributing

## Contributors
