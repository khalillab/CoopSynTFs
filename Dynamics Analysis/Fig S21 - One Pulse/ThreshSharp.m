function [ m_stor, thresh_stor ] = ThreshSharp( gain_norm, time_range )
% Find threshold and slope of persistence filtering

time_log = log10(time_range);
for i=1:length(gain_norm)
    
    if gain_norm(1,i)>=max(gain_norm(:,i))
        m_stor(i) = nan;
        thresh_stor(i) = nan;
        
    else
        
    % Gain
    high = max(gain_norm(:,i));
    low = gain_norm(1,i);
    mid = 0.5*(high-low)+low;
    
    range = [find(gain_norm(:,i)==low):find(gain_norm(:,i)==high)];
    
    diff = mid-gain_norm(range,i);
    ind = find(diff<0);

    x2 = range(ind(1));   % above
    x1 = range(ind(1)-1); % below
    
    y1 = gain_norm(x1,i);
    y2 = gain_norm(x2,i);
    
    x2 = time_log(x2);    % above
    x1 = time_log(x1);    % below
    
    dx = x2-x1;
    dy = y2-y1;
    
    m = dy/dx;
    m_stor(i) = m;
    
    thresh = (mid-y2)/m + x2;    
    thresh_stor(i) = 10^thresh;
    end
    
end

end

