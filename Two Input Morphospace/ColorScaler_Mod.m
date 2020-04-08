function [ mymap ] = ColorScaler_Mod( c1, c2, num )
% Creates color scale value
%   c1 = color vector 1
%   c2 = color vector 2
%   num = number of increments between vectors
    mymap = zeros(num,3);
    
    for i=1:3
        mymap(:,i) = linspace(c1(i),c2(i),num);
    end

end

