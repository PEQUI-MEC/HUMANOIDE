function DH = DH_parameters(array_12_angulos)
    %DH_PARAMETER retorna uma matriz com os parametros de Denavit Hatenberg
    %Rot(z,theta) Trans(z,d) Trans(x,a) Rot(z,alpha)
    %Os frames junto com a tabela estao no diagrama na pasta do codigo
    df = 4; % altura do umbigo ate a quadril
    af = 3; % distancia do meio da quadril ate a junta do quadril
    a3 = 6; % tamanho da coxa
    a4 = a3;
    a9 = a3;
    a10= a4;
    de = 2; % altura da sola do pe ao calcanhar
    dd = de;
    t1 = array_12_angulos(1);
    t2 = array_12_angulos(2);
    t3 = array_12_angulos(3);
    t4 = array_12_angulos(4);
    t5 = array_12_angulos(5);
    t6 = array_12_angulos(6);
    t7 = array_12_angulos(7);
    t8 = array_12_angulos(8);
    t9 = array_12_angulos(9);
    t10 = array_12_angulos(10);
    t11 = array_12_angulos(11);
    t12 = array_12_angulos(12);
    
    
    
    DH = [    % PERNA ESQUERDA
              pi/2, -df,  af, pi ; % do fixo pro 0           (sobre o motor 1)
              t1,   0,   0, -pi/2 ; % motor 1 do frame 0 pro 1(sobre o motor 2) 
           pi/2+t2,   0,   0,  pi/2 ; % motor 2 do frame 1 pro 2(sobre o motor 3)
              t3,   0,  -a3,   0 ; % motor 3 do frame 2 pro 3(sobre o motor 4)
              t4,   0,  -a4,   0 ; % motor 4 do frame 3 pro 4(sobre o motor 5)
              t5,   0,   0, -pi/2 ; % motor 5 do frame 4 pro 5(sobre o motor 6)
          -pi/2+t6,   0,   0,  pi/2 ; % motor 6 do frame 5 pro 6(eixo z normal ao pe, mas esta acima do pe)
               0,  de,   0,   0 ; % do frame 6 para o pe esquerdo(sobre o pe com eixo z normal ao pe)
               
               % PERNA DIREITA
              pi/2, -df, -af, pi ; % do fixo pro 7           (sobre o motor 7)
              t7,   0,   0, -pi/2 ; % motor 7 do frame 7 pro 8(sobre o motor 8)
          -pi/2+t8,   0,   0,  pi/2 ; % motor 8 do frame 8 pro 9(sobre o motor 9)
              t9,   0, a9,   0 ; % motor 9 do frame 9 pro 10(sobre o motor 10)
             t10,   0, a10,   0 ; % motor 10 do frame 10 pro 11(sobre o motor 11)
         pi+t11,   0,   0,  pi/2 ; % motor 11 do frame 11 pro 12(sobre o motor 12)
         -pi/2+t12,   0,   0,  pi/2 ; % motor 12 do frame 12 pro 13(eixo z normal ao pe, mas esta acima do pe)
               0,  dd,   0,   0 ];% do frame 13 para o pe direito(sobre o pe com eixo z normal ao pe)

           
           
%     DH = [    % PERNA ESQUERDA
%               90, -df,  af, 180 ; % do fixo pro 0           (sobre o motor 1)
%               t1,   0,   0, -90 ; % motor 1 do frame 0 pro 1(sobre o motor 2) 
%            90+t2,   0,   0,  90 ; % motor 2 do frame 1 pro 2(sobre o motor 3)
%               t3,   0,  a3,   0 ; % motor 3 do frame 2 pro 3(sobre o motor 4)
%               t4,   0,  a4,   0 ; % motor 4 do frame 3 pro 4(sobre o motor 5)
%               t5,   0,   0, -90 ; % motor 5 do frame 4 pro 5(sobre o motor 6)
%           -90+t6,   0,   0,  90 ; % motor 6 do frame 5 pro 6(eixo z normal ao pe, mas esta acima do pe)
%                0,  de,   0,   0 ; % do frame 6 para o pe esquerdo(sobre o pe com eixo z normal ao pe)
%                
%                % PERNA DIREITA
%               90, -df, -af, 180 ; % do fixo pro 7           (sobre o motor 7)
%               t7,   0,   0, -90 ; % motor 7 do frame 7 pro 8(sobre o motor 8)
%           -90+t8,   0,   0,  90 ; % motor 8 do frame 8 pro 9(sobre o motor 9)
%               t9,   0, a9,   0 ; % motor 9 do frame 9 pro 10(sobre o motor 10)
%              t10,   0, a10,   0 ; % motor 10 do frame 10 pro 11(sobre o motor 11)
%          180+t11,   0,   0,  90 ; % motor 11 do frame 11 pro 12(sobre o motor 12)
%          -90+t12,   0,   0,  90 ; % motor 12 do frame 12 pro 13(eixo z normal ao pe, mas esta acima do pe)
%                0,  dd,   0,   0 ];% do frame 13 para o pe direito(sobre o pe com eixo z normal ao pe)
end

