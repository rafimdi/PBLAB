function calculate_pericytes_for_gui(orginized_out_cc)
len=length(orginized_out_cc.PixelIdxList);%amount of different pericytes should equal initial seed count
%pericytes_mats{len}=[];
%C=cast(zeros([size(raw_ch1) 3]),'uint16');
%C(:,:,:,1)=raw_ch1;
%C(:,:,:,2)=raw_ch3;
%D=cast(zeros(size(raw_ch1)),'uint16');
seed_locations={};
for k=1:len
    [X,Y,Z]=ind2sub(orginized_out_cc.ImageSize,orginized_out_cc.PixelIdxList{k});
    [seed_locations{k}.maxX,seed_locations{k}.minX]=find_crop_size(orginized_out_cc.ImageSize(2),X,100);
    [seed_locations{k}.maxY,seed_locations{k}.minY]=find_crop_size(orginized_out_cc.ImageSize(1),Y,100);
    [seed_locations{k}.maxZ,seed_locations{k}.minZ]=find_crop_size(orginized_out_cc.ImageSize(3),Z,100);
    %D(D>0)=0;

    %pts=create_sphere(size(raw_ch1),centroids(k),5);
    %D(pts)=65000;
    
    %D(seeds_cc_orginized.PixelIdxList{k})=65000;

    %C(:,:,:,3)=D;
    %pericytes_mats{k}=C(minx:maxx,miny:maxy,minz:maxz,:);
    %str=sprintf('%s_%d.mat',filename_prefix,k);
    %seed_image=C(minx:maxx,miny:maxy,minz:maxz,:);
    %save (str, 'seed_image');
end
save('seed_locations.mat','seed_locations');
end