%-----------------------------------------------------------
%Método para cálcular a trajetória do modelo dinâmico
%retornando os pontos dos pés, CoM e a trajetoria
%Parâmetros:
%U - variáveis de controle
%X - vetor com as condições iniciais
%Retorno:
%pa - ponto do pé A
%pb - ponto do pé B
%pc - ponto do centro de massa
%M  - trajetória completa vetores x,y e z
%-----------------------------------------------------------
function [pa pb pc M] = trajetoria(U,X)
%-----------------------------------------------------------
%variaveis globais
%-----------------------------------------------------------
    global m L g pfa expK

%-----------------------------------------------------------
%condições iniciais para MS
%----------------------------------------------------------- 
        xod  = X(1,1);
        yod  = X(2,1);
        zod  = X(3,1);
        dxod = X(4,1);
        dyod = X(5,1);
        dzod = X(6,1);
%-----------------------------------------------------------
%valores para a otimização valores de u
%-----------------------------------------------------------
        theta = U(1,1);
        phi   = U(2,1);
        k     = U(3,1);
        Bss   = U(4,1);
        expK  = U(5,1);
%-----------------------------------------------------------
%iniciar valores para o método ode45
%-----------------------------------------------------------
    %opções para ode45
    options = odeset('MaxStep',0.001);
    %tempo de solução
    tspan = [0 2];
%-----------------------------------------------------------
%vetor com as condições iniciais MS
%-----------------------------------------------------------  
        y0 = [xod;dxod;yod;dyod;zod;dzod];
%-----------------------------------------------------------
%vetor com os parâmetros constantes passado no método
%----------------------------------------------------------- 
        params = [m;L;g;k;Bss;expK];
%-----------------------------------------------------------
%resolver a EDO
%-----------------------------------------------------------  
    [t1,y] = ode45(@(t,y) model1(t,y,params),tspan,y0,options);
%-----------------------------------------------------------
%encontrar o valor de Touchdown do centro de massa
%------------------------------------------------------------   
    n = size(y(:,1));
    n = n(1,1);%tamanho do vetor y
    ind = 1;%iniciar contador
%-----------------------------------------------------------
%verificando a condição de parada posição Z < que Z de touchdown
%Z de touchdown = L*cos(theta)
%----------------------------------------------------------- 
    for i =1:1:n
        if y(i,5) >= L*cos(theta)
         ind = i;
        else
            break
        end
    end
%-----------------------------------------------------------
%Posição do centro de massa
%-----------------------------------------------------------      
    pc = [y(ind,1);y(ind,3);y(ind,5)];%centro de massa
%-----------------------------------------------------------
%Posição de Touchdown
%posição do pé de balaço quando toca o chão
%----------------------------------------------------------- 
    pfb = pc + L*[sin(theta)*cos(phi);sin(theta)*sin(phi);-cos(theta)];
%-----------------------------------------------------------
%codição inicial para TD
%-----------------------------------------------------------    
    y0 = y(ind,:);%condição inicial 
    TD = t1(ind);%tempo de TD
%-----------------------------------------------------------
%parâmetros constantes
%----------------------------------------------------------- 
    params = [m;L;g;k;Bss;TD;pfb(1,1);pfb(2,1);pfb(3,1);expK];
%-----------------------------------------------------------
%%resolver a EDO
%-----------------------------------------------------------     
    [t2,y2] = ode45(@(t,y) model2(t,y,params),tspan,y0,options);
%-----------------------------------------------------------
%encontrar o valor de LowestHeigth do centro de massa
%-----------------------------------------------------------    
    n2 = size(y2(:,1));
    n2 = n(1,1);%tamanho do vetor y
    ind2 = 1;%iniciar contador
%-----------------------------------------------------------
%verificando a condição de parada para o LowestHeigth velocidade dZ > 0
%----------------------------------------------------------- 
    for i =1:1:n2
        if y2(i,6) <= 0
         ind2 = i;
        else
            break
        end
    end
%-----------------------------------------------------------
%trajetória do centro de massa CoM M = [x y z]
%-----------------------------------------------------------        
    M = [y(1:ind,1) y(1:ind,3) y(1:ind,5);y2(1:ind2,1) y2(1:ind2,3) y2(1:ind2,5)];
%-----------------------------------------------------------
%atualizando a posição do centro de massa
%-----------------------------------------------------------
    pc = [y2(ind2,1);y2(ind2,3);y2(ind2,5)];
%-----------------------------------------------------------
%atualizando a posição dos pés e do centro de massa 
%para o retorno da função
%-----------------------------------------------------------
    pa  = [0;0;0];
    pb  = [pfb(1,1);pfb(2,1);0];
    pc  = [pc(1,1);pc(2,1);pc(3,1)] ;
end
