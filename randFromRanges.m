function [rand_vec] = randFromRanges(ranges)
    %randFromRanges Outputs a vector of random number within given ranges
    %   The given range must be a n-by-2 matrix. The output will be given 
    %   as an array of doubles.
    
    n = length(ranges(:,1));
    rand_vec = zeros(1, n);
    for i = 1:n
        rand_vec(i) = ranges(i,1)+(ranges(i,2)-ranges(i,1))*rand;
    end
end

