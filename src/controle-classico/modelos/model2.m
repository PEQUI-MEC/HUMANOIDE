%-----------------------------------------------------------
%Calcula o valor das derivadas do modelo dinamico 2
%Parâmetros
%t   - tempo
%Y0  - Vetor com a condição inicial do sistema
%params: parametros do sistema
%m   - massa
%L   - comprimento da perna do modelo
%g   - gravidade
%k   - constante da mola
%Bss - coeficiente angular do modelo
%TD  - valor do tempo de touchdown
%bx  - valor de x do pé B
%by  - valor de y do pé B
%bz  - valor de z do pé B
%expK- valor do ganho da constante da mola (ordem de grandeza)
%Retorno:
%dydt - vetor com primeira e segunda derivada do sistema
%-----------------------------------------------------------
function dydt = model2(t,Y0,params)  
%-----------------------------------------------------------
%constantes
%-----------------------------------------------------------
    m   = params(1,1);
    L   = params(2,1);
    g   = params(3,1);
    k   = params(4,1);
    Bss = params(5,1);
    TD  = params(6,1);
    bx  = params(7,1);
    by  = params(8,1);
    bz  = params(9,1);
    expK = params(10,1);
%-----------------------------------------------------------
%condição inicial
%-----------------------------------------------------------       
    x  = Y0(1,1);
    dx = Y0(2,1);
    y  = Y0(3,1);
    dy = Y0(4,1);
    z  = Y0(5,1);
    dz = Y0(6,1);
%-----------------------------------------------------------
%norma de L
%-----------------------------------------------------------    
    norma1 = (x*x + y*y + z*z )^0.5;
    norma2 = ((x - bx)^2 + (y - by)^2  + (z - bz)^2  )^0.5;
%-----------------------------------------------------------
%derivadas de y
%-----------------------------------------------------------        
    f1 = dx;
    f2 = (k*expK/m)*( ( L + Bss*TD - norma1)*(x/norma1) + ( L + Bss*TD - norma2)*( (x - bx)/norma2) );
    f3 = dy;
    f4 = (k*expK/m)*( ( L + Bss*TD - norma1)*(y/norma1) + ( L + Bss*TD - norma2)*( (y - by)/norma2) );
    f5 = dz;
    f6 = (k*expK/m)*( ( L + Bss*TD - norma1)*(z/norma1) + ( L + Bss*TD - norma2)*( (z - bz)/norma2) ) + g;
%-----------------------------------------------------------
%sistema de equações
%-----------------------------------------------------------    
    dydt = [f1;f2;f3;f4;f5;f6];   
end