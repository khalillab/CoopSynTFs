function [ka_half,ta_half] = ONtime_16(params,GFP_ON_stor,time)

    ka_half = zeros(1,length(params));
    ta_half = zeros(1,length(params));

    for i=1:length(params)

        GFP = GFP_ON_stor(:,i);

        ind = find(GFP>0.5);
        ind1 = ind(1);
        ind2 = ind1-1;

        ka_half(i) = (GFP(ind1)-GFP(ind2))/(time(ind1)-time(ind2));

        ta_half(i) = ((0.5-GFP(ind2))/ka_half(i))+time(ind2);    
    
    end
end