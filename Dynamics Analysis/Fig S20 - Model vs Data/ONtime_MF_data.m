function [ka_half,ta_half] = ONtime_MF_data(GFP,time)
    
    if GFP(1)<0.5

        ind = find(GFP>0.5);
        ind1 = ind(1);
        ind2 = ind1-1;

        % Slope
        ka_half = (GFP(ind1)-GFP(ind2))/(time(ind1)-time(ind2));

        % Approximate ON Time
        ta_half = ((0.5-GFP(ind2))/ka_half)+time(ind2);    
        
    else
        
        ka_half = 0;
        ta_half = 0;
        
    end
end