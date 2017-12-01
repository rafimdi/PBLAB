function do_everything()
%%
% do_everything uses load_input to acess an ImageStack directory, it then reads channels 1 and 3
% and loads mergedcclist and vascenhanced mask for the use of the
% segmentation alghorithm.
%
% then do_everything uses essential_pre_proccessing and thresholding to prepare
% data for the alghorithm
% finally function preforms segmentation and saves the outputs
% begin_centroids and seeds cc allong with the raw chs in a .mat file called
% stack.mat for use of the gui.
%
% Matlab files Needed:
% essential_pre_processing
% thresholding_ch1
% extract_pericytes_for_gui
% load_input
% segmentation_p
% readTiff3D

output_dir=uigetdir();
[raw_ch1,raw_ch3,mergedcclist,vascEnhancedMask]=load_input();
[cleaned_seeds_mat,filtered_ch1,vasc_enh_mat]=essential_pre_processing(vascEnhancedMask,mergedcclist,raw_ch1);
thresholded_ch1=thresholding_ch1(raw_ch1,raw_ch3,vasc_enh_mat);
[orginized_out_cc,begin_centroids]=segmentation_p(cleaned_seeds_mat,thresholded_ch1);
output_filename=sprintf('%s/stack.mat',output_dir);
save(output_filename,'mergedcclist','vascEnhancedMask','raw_ch1','raw_ch3','begin_centroids','orginized_out_cc');
end