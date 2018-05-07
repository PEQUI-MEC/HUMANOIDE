function xe = dualQuatDH(o,d,a,s,k)
    
     h1 = cos(o/2)*cos(s/2);
     h2 = cos(o/2)*sin(s/2);
     h3 = sin(o/2)*sin(s/2);
     h4 = sin(o/2)*cos(s/2);

     xe(1,1) = h1;
     xe(2,1) = h2;
     xe(3,1) = h3;
     xe(4,1) = h4;
     xe(5,1) = -0.5*(d*h4 + a*h2);
     xe(6,1) = 0.5*(-d*h3 + a*h1);
     xe(7,1) = 0.5*(d*h2 + a*h4);
     xe(8,1) = 0.5*(d*h1 - a*h3);

     if k
        xe = dualQuatConj(xe);
     end
     
end