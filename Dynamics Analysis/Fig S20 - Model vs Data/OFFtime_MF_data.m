function [kd_half,td_half] = OFFtime_MF_data(GFP,time)

    kd_half = 0;
    td_half = 0;
    
    cutoff = find(max(GFP)==GFP);
    GFP(1:cutoff) = 1;

    ind = find(GFP<0.5);

    if isempty(ind)
        kd_half = 0;
        td_half = 3000;
    else
        ind1 = ind(1);

        if ind1==1
            ind1 = 2;
            ind2 = 1;
        else

            ind2 = ind1-1;

            kd_half = (GFP(ind1)-GFP(ind2))/(time(ind1)-time(ind2));
            td_half = ((0.5-GFP(ind2))/kd_half)+time(ind2);
            td_half = td_half - 960;
        end
    end
        
end