function flag = inBlockCenter(xy)
    remainder = mod(xy-1, 12);
    flag = remainder(1) >= 3.5 && remainder(1) <= 9.5 && remainder(2) >= 3.5 && remainder(2) <= 9.5;
end