%segmentation_p recieves seeds- a matrix of relevant cellcentroids output from
%essential_pre_processing and per_ch a binary matrix outputted from
%thresholding_ch1 which represents the pericytes morphologies.
%
%segmentaion_p outputs begin_centroids- a list of all the centroids of the pericytes in the stack
%and orginized_out_cc a connected-compenenets array containing all the
%pericytes morphologies ordered in begin_centroids order

function [orginized_out_cc,begin_centroids]=segmentation_p(seeds,per_ch)%seed is 3d mask and pr_ch is localy thresholded mask
tic;
step=2;
counter=0;

%% validate seeds(before step dilation)
growth_ch=logical(per_ch);
seeds_mat_pre=logical(seeds);% nessesary for finding the growth difference
seeds_mat_pre=seeds_mat_pre.*growth_ch;
valid_centroids=find(seeds_mat_pre);
seeds_cc_pre=bwconncomp(seeds_mat_pre);% nessasary to remove seeds

if(length(seeds_cc_pre.PixelIdxList)<length(valid_centroids))
    pti='we have two adjacent seeds in the matrix, removing all adjacent seeds'
    for i1=1:length(seeds_cc_pre.PixelIdxList)
            memb=ismember(valid_centroids,seeds_cc_pre.PixelIdxList{i1});
            if(sum(memb)>1)
                memb_ind=find(memb);
                for i2=2:length(memb_ind) %keeps only the first of the seeds
                    valid_centroids(memb_ind(i2))=0;
                end
            end
    end
    valid_centroids(valid_centroids==0)=[];
    seeds_mat_pre(seeds_mat_pre>0)=0;
    seeds_mat_pre(valid_centroids)=1;
end
%% setting up strels begin_centroids and growth matrices
seeds_mat_out=seeds_mat_pre;
se=strel('cube',3);
se2=strel('cube',5);

% valid seed centroids(in growing process)
%nessasary to figure out which seed bodies are valid
begin_centroids=valid_centroids;

growth_matrix_for_borders=false(size(per_ch));% nessesary for borders
matrix_for_borders=cast(zeros(size(per_ch)),'uint8');% nessasary for borders sumation
%%
%% growth of seeds, seperation of meeting seeds,main loop 
while(~isempty(seeds_cc_pre.PixelIdxList))
   %% growth
    seeds_mat_post=imdilate(seeds_mat_pre,se);% standard dialation
    seeds_mat_post(growth_ch==0)=0;
    seeds_cc_post=bwconncomp(seeds_mat_post);% now lets check the growth cc
    %% checking for meetup and resolving by seperation
    if(length(seeds_cc_post.PixelIdxList)~=length(seeds_cc_pre.PixelIdxList))%oh no we have a meetup
        orginized_pre_cc=seeds_cc_pre.PixelIdxList;
        %% orginizing seeds
        for i3=1:length(seeds_cc_pre.PixelIdxList)
        
            memb_pre=ismember(valid_centroids,seeds_cc_pre.PixelIdxList{i3});
            if(sum(memb_pre)~=1)% oh no somehow we have a fusion
                pri='fused or lost seed when checkig for pre orginized'
                return
            end
            orginized_pre_cc{memb_pre>0}=seeds_cc_pre.PixelIdxList{i3};
            
        end
        %% finiding problematic seeds
        centoids_to_seperate=zeros(size(valid_centroids));
        for i4=1:length(seeds_cc_post.PixelIdxList)
            memb=ismember(valid_centroids,seeds_cc_post.PixelIdxList{i4});
            if(sum(memb)>1)
                centoids_to_seperate(memb>0)=1;
            end
        end
        
        indexes=find(centoids_to_seperate);
        %%
        %% seperation by finding borders
        for i5=1:length(indexes)
            
            counter=counter+1;
            growth_matrix_for_borders(growth_matrix_for_borders>0)=0;
            growth_matrix_for_borders(orginized_pre_cc{indexes(i5)})=1;
            growth_matrix_for_borders=imdilate(growth_matrix_for_borders,se2);
            matrix_for_borders=matrix_for_borders+cast(growth_matrix_for_borders,'uint8');
           
        end
        
        matrix_for_borders(seeds_mat_out>0)=0;%borders arent inside already defined seeds
        matrix_for_borders(seeds_mat_post<1)=0;%dont check borders outside of current growth
        matrix_for_borders(matrix_for_borders<2)=0;%borders will have more then one seed point in them
        growth_ch(matrix_for_borders>0)=0;%turn border into zero so no growth will be done there
        seeds_mat_post(matrix_for_borders>0)=0;%seperate seeds with border
        
    end
    %%
    %timestamp2=toc;
    
    %% check for validity of assumptions
    seeds_cc_post=bwconncomp(seeds_mat_post);
    if(length(seeds_cc_post.PixelIdxList)~=length(seeds_cc_pre.PixelIdxList))%oh no we have a meetup
            pri='method didnt seperate the seeds'%our method didnt seperate the guys
            return
    end
    %tic;
    %% orginizing seeds for comparison
    orginized_pre_cc=seeds_cc_pre.PixelIdxList;
    orginized_post_cc=seeds_cc_post.PixelIdxList;
    for i6=1:length(seeds_cc_post.PixelIdxList)%length must be equal to pre
        memb_post=ismember(valid_centroids,seeds_cc_post.PixelIdxList{i6});
        memb_pre=ismember(valid_centroids,seeds_cc_pre.PixelIdxList{i6});
        if(sum(memb_pre)~=1 ||sum(memb_post)~=1)% oh no somehow we have a fusion
            pri='fused or lost seed when checkig for removal'
            return
        end
        orginized_pre_cc{memb_pre>0}=seeds_cc_pre.PixelIdxList{i6};
        orginized_post_cc{memb_post>0}=seeds_cc_post.PixelIdxList{i6};
    end
    %%
    %% removing seeds that have completed growth
    for i7=1:length(valid_centroids)
        if(isequal(orginized_pre_cc{i7},orginized_post_cc{i7})) %need to remove seed
            valid_centroids(i7)=0;
            seeds_mat_post(orginized_post_cc{i7})=0;
        end     
    end
    valid_centroids(valid_centroids==0)=[];
    %%
    %% preparing next step
    seeds_mat_pre=seeds_mat_post;
    seeds_mat_out(seeds_mat_pre>0)=1;
    seeds_cc_pre=bwconncomp(seeds_mat_pre);
    step=step+1;
    timestamp=toc
    str=sprintf('total impcats: %d. step: %d. time for step %d'...
        ,counter,step,timestamp)
end
%% last orginizing before outputting
seeds_cc_out=bwconncomp(seeds_mat_out);
orginized_out_cc=seeds_cc_out;
for i8=1:length(seeds_cc_out.PixelIdxList)
        
    memb_out=ismember(begin_centroids,seeds_cc_out.PixelIdxList{i8});
    if(sum(memb_out)~=1)% oh no somehow we have a fusion
        pri='fused or lost seed when checkig for pre orginized'
        return
    end
    orginized_out_cc.PixelIdxList{memb_out>0}=seeds_cc_out.PixelIdxList{i8};

end
timestamp=toc
%% saving for backup
%%save ('seeds_cc_org.mat' ,'orginized_out_cc');
%%save('begin_centroids.mat','begin_centroids');
end