function [maxp,minp]=find_crop_size(cordinate_length,p,min_size)
minp=round(0.8*min(p));maxp=round(1.2*max(p));
if(maxp >cordinate_length);maxp=cordinate_length;end
if(minp <1);minp=1;end
if(maxp-minp<min_size)
    expansion_length=min_size-(maxp-minp);
    half_expansion=round(expansion_length./2);
    if(maxp+half_expansion>cordinate_length)
        exapnsion_possible=cordinate_length-maxp;
        minp=minp-(expansion_length-exapnsion_possible);
        maxp=cordinate_length;
        return;
    end

    if(minp-half_expansion<1)
        exapnsion_possible=minp-1;
        maxp=maxp+(expansion_length-exapnsion_possible);
        minp=1;
        return;
    end
    if (maxp+half_expansion<=cordinate_length && minp-half_expansion>=1)
        maxp=maxp+half_expansion;
        minp=minp-half_expansion;
        return;
    end
end
return;
end