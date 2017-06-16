clear all;
close all;
clc;

path = 'E:\calcification study\resliced 3\';
path_info = dir(path);

for i = 3:length(path_info)
    folder = [path path_info(i).name];
    img = load_untouch_nii([folder '\AXIAL_reslice.img']);
    seg = load_untouch_nii([folder '\' path_info(i).name '_reslice.img']);
    
    % dialog asking for display image
    prompt = ['Enter display slice number: (' path_info(i).name ')'];
    dlg_title = 'Display slice';
    def = {'50'};
    num = inputdlg(prompt,dlg_title,1,def);
    num = str2num(num{1});
    clear prompt dlg_title def
    
    seg.img = round(seg.img);
    disp_img = seg.img(:,:,num);
    seg_tmp = zeros(size(disp_img,1),size(disp_img,2));
    seg_tmp(disp_img>0) = 1;
    disp_rgb = label2rgb(seg_tmp);
    f1 = figure(1);
    imshow(img.img(:,:,num),[]);
    hold on
    h = imshow(disp_rgb);
    set(h,'alphadata',0.3);
    % Construct a questdlg to determine correct orientation
    choice = questdlg('Is the orientation correct?', ...
        'Orientation', ...
        'Yes','Flip horizontal','Yes');
    % Handle response
    switch choice
        case 'Yes'
            close(f1);
        case 'Flip horizontal'
            close(f1);
            seg.img =  flipdim(seg.img,2);
            disp_img = seg.img(:,:,num);
            seg_tmp = zeros(size(disp_img,1),size(disp_img,2));
            seg_tmp(disp_img>0) = 1;
            disp_rgb = label2rgb(seg_tmp);
            f1 = figure(1);
            imshow(img.img(:,:,num),[]);
            hold on
            h = imshow(disp_rgb);
            set(h,'alphadata',0.3);
            pause(1)
            close(f1)
    end
    for j = 1:size(img.img,3)
        if mod(j,6) == 1
            img_slice = img.img(:,:,j);
            seg_slice = seg.img(:,:,j);
            for k = 1:10
                slice = zeros(size(seg_slice,1),size(seg_slice,2));
                slice(seg_slice == k) = img_slice(seg_slice == k);
                if (max(max(slice)) >= 130) && (max(max(slice) <= 199))
                    w(j,k) = 1;
                elseif (max(max(slice)) >= 200) && (max(max(slice) <= 299))
                    w(j,k) = 2;
                elseif (max(max(slice)) >= 300) && (max(max(slice) <= 399))
                    w(j,k) = 3;
                elseif max(max(slice)) >= 400
                    w(j,k) = 4;
                else
                    w(j,k) = 0;
                end
                A(j,k) = sum(sum(seg_slice == k))*img.hdr.dime.pixdim(2)*img.hdr.dime.pixdim(3);
            end
        end
    end
    A(A <= 1) = 0;
    TCS(i-2,:) = sum(w.*A);
    disp(['Finish TCS calculation of ' path_info(i).name]);
    clear A w
end
