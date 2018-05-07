function xe = KinematicModel(MDH,N,foward)
    
    xe = [1 0 0 0 0 0 0 0]';
    
    if foward
        for i = 1:1:N

         o = MDH(i,1);
         d = MDH(i,2);
         a = MDH(i,3);
         s = MDH(i,4); 
         
         x = dualQuatDH(o,d,a,s,0);  
         xe = dualQuatMult(xe,x);
        end
    else
        for i = N:-1:1

         o = MDH(i,1);
         d = MDH(i,2);
         a = MDH(i,3);
         s = MDH(i,4);  

         x = dualQuatDH(o,d,a,s,1);  
         xe = dualQuatMult(xe,dualQuatConj(x));
        end
    end
end