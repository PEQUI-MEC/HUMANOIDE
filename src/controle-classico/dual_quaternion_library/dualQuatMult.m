function r = dualQuatMult(p,q)
     
     pp = [p(1,1) p(2,1) p(3,1) p(4,1)]';
     pd = [p(5,1) p(6,1) p(7,1) p(8,1)]';

     qp = [q(1,1) q(2,1) q(3,1) q(4,1)]';
     qd = [q(5,1) q(6,1) q(7,1) q(8,1)]';

     aux1 = quatMult(pp,qp);
     aux2 = quatAdd(quatMult(pp,qd),quatMult(pd,qp));
     r = [aux1;aux2];
end