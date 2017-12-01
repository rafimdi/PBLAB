%thresholding ch1 returns a binary image of ch1 using filtering, cleaning
%and thersholding


function thresholded_ch1=thresholding_ch1(raw_ch1,raw_ch_fitc,vasc_enh_mat)
diff=raw_ch1-(raw_ch_fitc./2);
filtered=diff;
filtered=filtered.*cast(vasc_enh_mat,'uint16');
thresholded_ch1=filtered;
thresholded_ch1(thresholded_ch1<=70)=0;
thresholded_ch1(thresholded_ch1>70)=1;
thresholded_ch1=cast(thresholded_ch1,'uint8');
thresholded_ch1(thresholded_ch1==1)=255;

end