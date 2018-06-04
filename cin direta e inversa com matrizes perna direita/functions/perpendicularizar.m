function Vp = perpendicularizar(vetFixo, vetAjustavel)
% DEPRECATED
% TODO esta invertendo o vetor em alguns casos, verificar
%PERPENDICULARIZAR gira o vetor ajustavel no plano formado com o vetor fixo ate o vetor ajustavel se tornar perpendicular
	
    if dot(vetFixo,vetAjustavel)~=0
		A = [vetFixo(1)	 vetAjustavel(1)    -1		    0            0     ;
			 vetFixo(2)	 vetAjustavel(2)     0		   -1            0     ;
			 vetFixo(3)  vetAjustavel(3)     0     	    0           -1     ;
			     0			   0         vetFixo(1)  vetFixo(2)  vetFixo(3);
			     1			   0             0          0            0    ];
		B = [0; 0; 0; 0; 1];
		linsolve(A,B);
		Vp = ans(3:5)/norm(ans(3:5));

	else 
		Vp = vetAjustavel/norm(vetAjustavel);
	end		
end