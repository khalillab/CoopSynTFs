function [kd_half,td_half] = OFFtime_16(params,GFP_OFF_stor,time)
    
    [m,n] = size(params);
    
    kd_half = zeros(1,n);
    td_half = zeros(1,n);

    for i=1:n
        
        GFP = GFP_OFF_stor(:,i);
        cutoff = find(GFP==1);
        GFP(1:cutoff) = 1;
        
        ind = find(GFP<0.5);
        
        if isempty(ind)
            kd_half(i) = 0;
            td_half(i) = 3000;
        else
            ind1 = ind(1);
            
            if ind1==1
                ind1 = 2;
                ind2 = 1;
            else
                
                ind2 = ind1-1;

                kd_half(i) = (GFP(ind1)-GFP(ind2))/(time(ind1)-time(ind2));
                td_half(i) = ((0.5-GFP(ind2))/kd_half(i))+time(ind2);
                td_half(i) = td_half(i) - 960;
            end
        end
        
    end
end