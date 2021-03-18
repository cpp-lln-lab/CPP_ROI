mni_template = '/home/remi/matlab/SPM/spm12/canonical/avg152T1.nii';

% X Y Z coordinates of right V5 in millimeters
location = [44 -67 0];

% radius in millimeters
radius = 2;

sphere.location = location;
sphere.radius = radius;

createRoi('sphere', sphere, mni_template, true);
spm_smooth('sphere_2-44_-67_0.nii', 's2_sphere_2-44_-67_0.nii', [2 2 2], 4)
