function y = hillguess(cf,x)

    a = cf(1); % Activation
    c = cf(2); % Basal
	EC50 = cf(3); % EC50
    nh = cf(4); % Hill
    
    y = ((a*x.^nh) ./ (EC50^nh + x.^nh)) + c;

end