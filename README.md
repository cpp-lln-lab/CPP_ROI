[![miss_hit](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/miss_hit.yml/badge.svg)](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/miss_hit.yml)
[![tests and coverage with matlab](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/run_tests_matlab.yml/badge.svg)](https://github.com/cpp-lln-lab/CPP_ROI/actions/workflows/run_tests_matlab.yml)
[![codecov](https://codecov.io/gh/cpp-lln-lab/CPP_ROI/branch/main/graph/badge.svg?token=8IoRQtbFUV)](https://codecov.io/gh/cpp-lln-lab/CPP_ROI)
![All Contributors](https://img.shields.io/badge/all_contributors-4-orange.svg?style=flat-square)

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

% The following adds the relevant folders to your path.
% This needs to be done once per session (your path will not be saved)

initCppRoi
```

If you are using CPP_SPM, you got nothing to do as CPP_ROI is already installed
as a submodule, and initialized when running `initCppSpm`.

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
    -   neurosynth probability maps
    -   A multi-modal parcellation of human cerebral cortex [@glasser_multi-modal_2016]
    -   the probabilistic maps of visual topography in human cortex [@wang2014]
        -   https://scholar.princeton.edu/napl/resources
    -   the probabilistic functional atlas of human occipito-temporal visual
        cortex [@rosenke2020]
    -   [extended Human Connectome Project multimodal parcellation atlas](https://github.com/wayalan/HCPex.git)
        of the human cortex and subcortical areas [@huang_extended_2022]

Also includes:

-   Yeo's 7 networks "atlas"
<!-- add REF and URL -->

<!-- ALL-CONTRIBUTORS-LIST:START - Do not remove or modify this section -->
<!-- prettier-ignore-start -->
<!-- markdownlint-disable -->
<table>
  <tr>
    <td align="center"><a href="https://github.com/marcobarilari"><img src="https://avatars.githubusercontent.com/u/38101692?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Marco Barilari</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=marcobarilari" title="Code">💻</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=marcobarilari" title="Documentation">📖</a> <a href="#ideas-marcobarilari" title="Ideas, Planning, & Feedback">🤔</a></td>
    <td align="center"><a href="https://github.com/Remi-Gau"><img src="https://avatars.githubusercontent.com/u/6961185?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Remi Gau</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=Remi-Gau" title="Code">💻</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=Remi-Gau" title="Documentation">📖</a> <a href="#infra-Remi-Gau" title="Infrastructure (Hosting, Build-Tools, etc)">🚇</a> <a href="#design-Remi-Gau" title="Design">🎨</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/pulls?q=is%3Apr+reviewed-by%3ARemi-Gau" title="Reviewed Pull Requests">👀</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/issues?q=author%3ARemi-Gau" title="Bug reports">🐛</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=Remi-Gau" title="Tests">⚠️</a></td>
    <td align="center"><a href="https://github.com/JeanneCaronGuyon"><img src="https://avatars.githubusercontent.com/u/8718798?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Jeanne Caron-Guyon </b></sub></a><br /><a href="#ideas-JeanneCaronGuyon " title="Ideas, Planning, & Feedback">🤔</a> <a href="#userTesting-JeanneCaronGuyon " title="User Testing">📓</a></td>
    <td align="center"><a href="https://github.com/iqrashahzad14"><img src="https://avatars.githubusercontent.com/u/75671348?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Iqra Shahzad</b></sub></a><br /><a href="#userTesting-iqrashahzad14" title="User Testing">📓</a></td>
    <td align="center"><a href="https://github.com/fedefalag"><img src="https://avatars2.githubusercontent.com/u/50373329?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Federica Falagiarda</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/issues?q=author%3Afedefalag" title="Bug reports">🐛</a> <a href="#userTesting-fedefalag" title="User Testing">📓</a></td>
    <td align="center"><a href="https://github.com/CerenB"><img src="https://avatars.githubusercontent.com/u/10451654?v=4?s=100" width="100px;" alt=""/><br /><sub><b>Ceren Battal</b></sub></a><br /><a href="https://github.com/cpp-lln-lab/CPP_ROI/commits?author=CerenB" title="Code">💻</a> <a href="https://github.com/cpp-lln-lab/CPP_ROI/pulls?q=is%3Apr+reviewed-by%3ACerenB" title="Reviewed Pull Requests">👀</a> <a href="#userTesting-CerenB" title="User Testing">📓</a></td>
  </tr>
</table>

<!-- markdownlint-restore -->
<!-- prettier-ignore-end -->

<!-- ALL-CONTRIBUTORS-LIST:END -->
