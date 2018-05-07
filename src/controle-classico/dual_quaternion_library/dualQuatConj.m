function qr = dualQuatConj(q)

    qp =  quatConj([q(1,1) q(2,1) q(3,1) q(4,1)]');
    qd =  quatConj([q(5,1) q(6,1) q(7,1) q(8,1)]');
    qr = [qp;qd];          
end