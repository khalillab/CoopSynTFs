function [ gain_filter, ind ] = GainScreen( gain_stor )
% Find activateable circuits only

gain_filter = [];
ind = [];

j = 1;
for i=1:length(gain_stor)
    gain = gain_stor(:,i);
    
    if ((max(gain)/min(gain))>1.5)&(max(gain)>1000)
        gain_filter(:,j) = gain_stor(:,i);
        ind(j) = i;
        j = j+1;
    end
    
end

end

