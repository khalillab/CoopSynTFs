function [ GFP_ON, params, GFP_raw ] = filterTCs( GFP_ON, params, GFP_ON_raw )
% Remove high basal
% Remove low fold change

ind = [];
for i=1:length(params)
    beg = mean(GFP_ON_raw(1:2,i));
    most = max(GFP_ON_raw(:,i));
    fold_change = most/beg;

    if ((fold_change>1.5)&&(most>1000))
        ind = [ind i];
    end
    
end

GFP_ON = GFP_ON(:,ind);
params = params(:,ind);
GFP_raw = GFP_ON_raw(:,ind);

end

