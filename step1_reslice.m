 clear all;
close all;
clc;

addpath(genpath('C:\Users\Sun\Desktop\TCS\code\'));
path = 'C:\Users\Sun\Desktop\embolis\';
path_info = dir(path);

for i = 3:length(path_info)
    folder = [path path_info(i).name];
    % add dimension information to segmentation image
    img = load_untouch_nii([folder '\AXIAL.img']);
    seg = load_untouch_nii([folder '\' path_info(i).name '.img']);
    seg.hdr = img.hdr;
    save_untouch_nii(seg,[folder '\' path_info(i).name '_adm.img']);
    clear seg img
    disp([path_info(i).name ' is reslicing']);
    reslice_nii([folder '\AXIAL.img'], [folder '\AXIAL_reslice.img'],0.5);
    reslice_nii([folder '\' path_info(i).name '_adm.img'], [folder '\' path_info(i).name '_reslice.img'],0.5);
    clc;
end