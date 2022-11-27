function ind = xy2ind(xy)
    poseRC = [50-xy(2)+1, xy(1)];
    indRC = floor((poseRC-2)/12 + 1);
    r = indRC(1);
    c = indRC(2);


    M=8;N=4; %grid dimensions
    simple_maze = reshape(1:M*N,M,N)' ;
    A = ones(M,N) ;
    A(5,1) = 0;
    A(7,1) = 0;
    A(3,2) = 0;
    A(2,3) = 0;
    A(4,3) = 0;
    A(5,3) = 0;
    A(7,3) = 0;
    A(7,4) = 0;
    
    Maze = A'.*simple_maze;
    ind = Maze(r,c);
end


