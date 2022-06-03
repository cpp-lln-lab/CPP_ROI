[![miss_hit](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/miss_hit.yml/badge.svg)](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/miss_hit.yml)
[![tests and coverage with matlab](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/run_tests_matlab.yml/badge.svg)](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/run_tests_matlab.yml)
[![codecov](https://codecov.io/gh/cpp-lln-lab/CPP_ROI/branch/main/graph/badge.svg?token=8IoRQtbFUV)](https://codecov.io/gh/cpp-lln-lab/CPP_ROI)
<!-- ALL-CONTRIBUTORS-BADGE:START - Do not remove or modify this section -->
[![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)](#contributors-)
<!-- ALL-CONTRIBUTORS-BADGE:END -->

# CPP ROI

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

| Dependencies                                                    | Used version |
| --------------------------------------------------------------- | ------------ |
| [Matlab](https://www.mathworks.com/products/matlab.html)        | 20???        |
| or [octave](https://www.gnu.org/software/octave/)               | 4.?          |
| [SPM12](https://www.fil.ion.ucl.ac.uk/spm/software/spm12/)      | v7487        |
| [bids-matlab](https://github.com/bids-standard/bids-matlab.git) | >=0.1.0      |

-   Other dependencies (MarsBar) are shipped with CPP_ROI in the `lib` folder.

## Features

-   create ROI from probability maps
-   create ROI from atlas (see below)
-   create ROI filenames that are "BIDS-ish"
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
    -   the probabilistic functional atlas of human occipito-temporal visual cortex
        -   Rosenke, M., van Hoof, R., van den Hurk, J., Grill-Spector, K., & Goebel, R. (2021).
            A Probabilistic Functional Atlas of Human Occipito-Temporal Visual Cortex.
            Cerebral cortex (New York, N.Y. : 1991), 31(1), 603–619.
            https://doi.org/10.1093/cercor/bhaa246

Also includes:

-   Yeo's 7 networks "atlas"
<!-- add REF and URL -->

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars.githubusercontent.com/u/38101692?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marco Barilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=marcobarilari" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/Remi-Gau"><img src="https://avatars.githubusercontent.com/u/6961185?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=Remi-Gau" title="Code">💻</a></td>
    <td align="center"><a href="https://github.com/fedefalag"><img src="https://avatars2.githubusercontent.com/u/50373329?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Federica Falagiarda</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/issues?q=author%3Afedefalag" title="Bug reports">🐛</a> <a href="#userTesting-fedefalag" title="User Testing">📓</a></td>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars.githubusercontent.com/u/10451654?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ceren Battal</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=CerenB" title="Code">💻</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
