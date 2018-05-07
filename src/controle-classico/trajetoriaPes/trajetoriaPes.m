function trajPes = trajetoriaPes(posP,passo,altura)
    
    p0 = [posP(1,1);posP(3,1)] + [-2*passo;0];
    p1 = [posP(1,1);posP(3,1)] + [-passo;altura];
    p2 = [posP(1,1);posP(3,1)];

    t = 0:0.01:1;
    ind = size(t,2);

    for i = 1:1:ind
        B(i,1) = (1 - t(1,i))^2 * p0(1,1) + 2*t(1,i)*(1 - t(1,i))*p1(1,1) + t(1,i)*t(1,i)*p2(1,1);
        B(i,2) = (1 - t(1,i))^2 * p0(2,1) + 2*t(1,i)*(1 - t(1,i))*p1(2,1) + t(1,i)*t(1,i)*p2(2,1);
    end

     trajPes = [B(:,1),posP(2,1)*ones(ind,1),B(:,2)];
end