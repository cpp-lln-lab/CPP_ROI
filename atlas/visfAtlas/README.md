visfAtlas in nifti volume format

The visfAtlas is based on N19 subjects. In FreeSurfer, it is aligned to the fsaverage brain. In BrainVoyager, it is aligned to a newly generated average brain for BrainVoyager, called the BVaverage. The BVaverage is distributed with this publication. The nifti volume atlas is aligned to the MNI colin27 brain.

Citing:

Please cite the article for use of the functional atlas as well as the BVaverage.

Rosenke, M., van Hoof, R., van den Hurk, J., Goebel, R. (2020). A probabilistic functional parcellation of human occipito-temporal cortex. TBD

To acknowledge using this atlas in your research, you might include a sentence like one of the following:

"We used the functional atlas of visual cortex developed by Rosenke et al. (2020)…”

Downloaded content:




Files

|MNI152\_T1\_1mm.nii.gz|The MNI152 brain the atlas is aligned too.|
| :- | :- |
|<p>visfAtlas\_MNI152\_volume.nii.gz</p><p></p><p></p><p></p><p>visfAtlas\_FSL.cmap</p><p>visfAtlas\_FSL.xml</p>|<p>The visfAtlas after nonlinear volumetric alignment to the MNI152 brain. Each ROI holds a specific intensity value, details described below.</p><p>Color-map for FSLeyes.</p><p>Atlas specification file for FSLeyes.</p>|




**visfAtlas intensity value to ROI mapping:**

1 = lh\_mFus\_faces

2 = lh\_pFus\_faces

3 = lh\_IOG\_faces

4 = lh\_OTS\_bodies

5 = lh\_ITG\_bodies

6 = lh\_MTG\_bodies

7 = lh\_LOS\_bodies

8 = lh\_pOTS\_characters

9 = lh\_IOS\_haracters

10 = lh\_CoS\_places

11 = lh\_hMT\_motion

12 = lh\_v1d\_retinotopic

13 = lh\_v2d\_retinotopic

14 = lh\_v3d\_retinotopic

15 = lh\_v1v\_retinotopic

16 = lh\_v2v\_retinotopic

17 = lh\_v3v\_retinotopic

18 = rh\_mFus\_faces

19 = rh\_pFus\_faces

20 = rh\_IOG\_faces

21 = rh\_OTS\_bodies

22 = rh\_ITG\_bodies

23 = rh\_MTG\_bodies

24 = rh\_LOS\_bodies

25 = rh\_CoS\_places

26 = rh\_TOS\_places

27 = rh\_hMT\_motion

28 = rh\_v1d\_retinotopic

29 = rh\_v2d\_retinotopic

30 = rh\_v3d\_retinotopic

31 = rh\_v1v\_retinotopic

32 = rh\_v2v\_retinotopic

33 = rh\_v3v\_retinotopic


**Import visfAtlas in FSLeyes** 

The atlas management tab in FSLeyes displays a list of all loaded atlases, and allows you to add and remove atlases from FSLeyes. The name of each atlas is shown in the list, but you can click and hold on an atlas to display the path to the atlas specification file.

You can load a new atlas into FSLeyes by clicking the + button and selecting the FSL atlas (.xml) specification file which describes the atlas. To find the management tab; select Settings – Orto View 1 and check the Atlas panel.

The maximum probability map can be visualized by opening the visfATlas\_volume.nii.gz file and loading the correct color map (visfAtlas\_FSL.cmap) through the overlay display panel.


