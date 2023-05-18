Taken from:

https://figshare.com/articles/dataset/HCP-MMP1_0_projected_on_MNI2009a_GM_volumetric_in_NIfTI_format/3501911

A volumetric version in MNI/ICBM 152 2009b NLIN Asymmetric space

Label description were taken from:

https://github.com/neurodata/neuroparc/blob/master/atlases/label/Human/Anatomical-labels-csv/Glasser.csv

Related citations:

Glasser, M. F., Coalson, T. S., Robinson, E. C., Hacker, C. D., Harwell, J.,
Yacoub, E., et al. (2016). A multi-modal parcellation of human cerebral cortex.
Nature. http://doi.org/10.1038/nature18933

Based on the Freesurfer version of the HCP-MMP1.0 parcellation
(https://figshare.com/articles/HCP-MMP1_0_projected_on_fsaverage/3498446), I
created a volumetric version of the HCP-MMP1.0 parcellation that was published
by Glasser et al. (Nature, 2016).

Please note that this volumetric version should be used and applied with great
care – and under certain circumstances only. According to the authors of the
original work, this fine parcellation could not have been achieved on a
volumetric basis but was only realizable using a multimodal surface-based
analysis (and co-registration). Thus, this volumetric version of their work is
not ideally suited to be used for standard brain-mapping approaches that use
(volumetric) nonlinear deformations. It is rather thought to be an accompanying
volumetric version to the surface-based version. Also, it could be used for
comparative purposes within MNI space (e.g. to compare it to other cortical
parcellations available in this space such as the AAL, Hammersmith, AICHA,
Mindboggle 101 atlases).

The conversion to volumetric space (projection to the ICBM 152 2009a NLIN
version within MNI space) is based on the fsaverage version of the HCP-MMP1.0
available here
(https://figshare.com/articles/HCP-MMP1_0_projected_on_fsaverage/3498446).
