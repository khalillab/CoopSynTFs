function [ unknown_rate ] = scaling( known_rate, known_n, unknown_n )
% Scaling:
%   Predicts transcriptional rate of promoters of variable n
%   Given a fit parameter of a promoter whose rate is known
%   Function guesses rate of promoter of different n (that wasn't fit)

    % Fit Values
    Qinf = 2.3604;
    alpha = 1.0578;
    thalf = 2.34;
    
    n = 1:8;
    rates = Qinf./(1 + exp(-alpha*(n-thalf)));

    unknown_rate = known_rate*(rates(unknown_n)/rates(known_n));

end
