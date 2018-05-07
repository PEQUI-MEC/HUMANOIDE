function p = getPositionDualQuat(q)
     r = getRotationDualQuat(q);
     qd = [q(5,1) q(6,1) q(7,1) q(8,1)]';
     p = 2*quatMult(qd,quatConj(r)); 
     p = p(2:4,1);
end