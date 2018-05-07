function T = dualHamiltonOp(h,op)
 
    h1 = h(1,1);
    h2 = h(2,1);
    h3 = h(3,1);
    h4 = h(4,1);
    h5 = h(5,1);
    h6 = h(6,1);
    h7 = h(7,1);
    h8 = h(8,1);

   Hp = HamiltonOp([h1 h2 h3 h4]',op);
   Hd = HamiltonOp([h5 h6 h7 h8]',op);
   O = zeros(4,4);
   
   T = [Hp O;Hd Hp];

end