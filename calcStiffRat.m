% calcStiffRat

function ratio = calcStiffRat(D1,t1,D2,t2)
    ratio = D1^3*t1 / (D2^3*t2);
end