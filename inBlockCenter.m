function flag = inBlockCenter(xy)
    remainder = mod(xy-1, 12) + 1;
    flag = remainder(1) >= 3.5 && remainder(1) <= 8.5 && remainder(2) >= 4.5 && remainder(2) <= 8.5;
end