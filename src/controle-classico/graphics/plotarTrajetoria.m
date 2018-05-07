%-----------------------------------------------------------
%M�todo para mostrar gr�ficamente a trajet�ria do modelo din�mico
%Par�metros:
%U - vari�veis de controle
%X - vetor com as condi��es iniciais
%Retorno:
%gr�fico do modelo din�mico
%-----------------------------------------------------------
function plotarTrajetoria(U,X)
%-----------------------------------------------------------
%variaveis globais
%-----------------------------------------------------------
global m L g pfa expK hEdo
%-----------------------------------------------------------
%condi��es iniciais para MS
%----------------------------------------------------------- 
    xod  = X(1,1);
    yod  = X(2,1);
    zod  = X(3,1);
    dxod = X(4,1);
    dyod = X(5,1);
    dzod = X(6,1);
%-----------------------------------------------------------
%valores para a otimiza��o valores de u
%-----------------------------------------------------------  
    %u = [phi theta k Bss]
    theta = U(1,1);
    phi   = U(2,1);
    k     = U(3,1);
    Bss   = U(4,1);
    expK  = U(5,1);
%-----------------------------------------------------------
%vetor com as condi��es iniciais MS
%----------------------------------------------------------- 
    y0 = [xod;dxod;yod;dyod;zod;dzod];
%-----------------------------------------------------------
%vetor com os par�metros constantes
%-----------------------------------------------------------         
    params = [m;L;g;k;Bss;expK];
%-----------------------------------------------------------
%Parametros para os m�todos 
%-----------------------------------------------------------   
    t = 0;%inicio do tempo no tempo t = 0
    h = hEdo;%passo do m�todo rungeKutta42 inicial
    N = 10000;%n�mero m�ximo de itera��es

    %primeiro metodo
    sh = h;%tamanho do passo para o m�todo rungeKutta42 atualizando durante a execu��o do m�todo
    ind = 1;%contador
%-----------------------------------------------------------
%vetores auxiliares para guardar a trajet�ria
%-----------------------------------------------------------    
    px(1,1) = y0(1,1);
    py(1,1) = y0(3,1);
    pz(1,1) = y0(5,1);
%-----------------------------------------------------------
%inicio do m�todo 1 MS para TD
%----------------------------------------------------------- 
    for x = 0:h:N*h
%-----------------------------------------------------------
%vetor de par�metros
%-----------------------------------------------------------  
        var = [t;h;1];
%-----------------------------------------------------------
%m�todo num�rico para solucionar as equa��es diferenciais
%passo a passo
%----------------------------------------------------------- 
        [y sh] = rungeKutta42(var,y0,params);
%-----------------------------------------------------------
%atualizando a condi��o inicial
%----------------------------------------------------------- 
        y0  = y;
%-----------------------------------------------------------
%atualizando o instante t
%----------------------------------------------------------- 
        t = t+sh;
%-----------------------------------------------------------
%verificando a condi��o de parada posi��o Z < que Z de touchdown
%Z de touchdown = L*cos(theta)
%-----------------------------------------------------------  
        if y0(5,1) < L*cos(theta)
         break  
        end 
%-----------------------------------------------------------
%colocando os valores nos vetores auxiliares
%-----------------------------------------------------------  
        px(1,ind) = y0(1,1);
        py(1,ind) = y0(3,1);
        pz(1,ind) = y0(5,1);
%-----------------------------------------------------------
%atualizando o contador
%-----------------------------------------------------------  
        ind = ind + 1;
    end
%-----------------------------------------------------------
%atualizando o contador - tratando o valor
%-----------------------------------------------------------    
    if ind > 1
        ind = ind -1;
    end
%-----------------------------------------------------------
%Posi��o do centro de massa no momento de  Touchdown (TD)
%-----------------------------------------------------------
    pc = [px(1,ind);py(1,ind);pz(1,ind)];%centro de massa
%-----------------------------------------------------------
%posi��o do p� de bala�o quando toca o ch�o
%-----------------------------------------------------------    
    pfb = pc + L*[sin(theta)*cos(phi);sin(theta)*sin(phi);-cos(theta)]
%-----------------------------------------------------------
%tempo em que acontece a codi��o de touchdown
%----------------------------------------------------------- 
    TD = t;%tempo de TD
%-----------------------------------------------------------
%parametros constante para o segundo m�todo
%-----------------------------------------------------------
    params = [m;L;g;k;Bss;t;pfb(1,1);pfb(2,1);pfb(3,1);expK];
%-----------------------------------------------------------
%iniciando o segundo contador
%-----------------------------------------------------------
    ind2 = 1;
    sh = h;%tamanho do passo para o m�todo rungeKutta42 atualizando durante a execu��o do m�todo
%-----------------------------------------------------------
%vetores auxiliares para guardar a trajet�ria
%----------------------------------------------------------- 
    px2(1,1) = y0(1,1);
    py2(1,1) = y0(3,1);
    pz2(1,1) = y0(5,1);
%-----------------------------------------------------------
%inicio do m�todo 2  TD para LH
%----------------------------------------------------------- 
    for x = 0:h:N*h
%-----------------------------------------------------------
%vetor de par�metros
%-----------------------------------------------------------    
        var = [t;h;0];
%-----------------------------------------------------------
%m�todo num�rico para solucionar as equa��es diferenciais
%passo a passo
%-----------------------------------------------------------
        [y sh] = rungeKutta42(var,y0,params);
%-----------------------------------------------------------
%atualizando nova condi��o inicial
%-----------------------------------------------------------     
        y0  = y;
%-----------------------------------------------------------
%atualizando o instante t
%-----------------------------------------------------------
        t = t+sh;        
%-----------------------------------------------------------
%verificando a condi��o de parada posi��o dZ > 0
%-----------------------------------------------------------
        if y0(6,1) > 0
            break
        end
%-----------------------------------------------------------
%atualizando os vetores auxiliares da trajet�ria
%-----------------------------------------------------------
        px2(1,ind2) = y0(1,1);
        py2(1,ind2) = y0(3,1);
        pz2(1,ind2) = y0(5,1); 
%-----------------------------------------------------------
%atualizando o contador
%-----------------------------------------------------------
        ind2 = ind2+1;
    end
%-----------------------------------------------------------
%atualizando o contador - tratando o valor
%-----------------------------------------------------------
    if ind2 > 1
        ind2 = ind2 -1;
    end
%-----------------------------------------------------------
%atualizando a posi��o do centro de massa
%-----------------------------------------------------------
    pc = [px2(1,ind2);py2(1,ind2);pz2(1,ind2)];%centro de massa
%-----------------------------------------------------------    % trajetoria 
% a trajetoria � simetrica ao ponto de middle suport
% desta forma fazemos um espelho da fun��o 
%deslocado ela para a origem
%posi��o do p� de suporte em MS  
%-----------------------------------------------------------    
    plot3(px(1,1:ind),py(1,1:ind),pz(1,1:ind),'b')
    hold on 
    plot3(px2(1,1:ind2),py2(1,1:ind2),pz2(1,1:ind2),'r')
    hold on
%-----------------------------------------------------------
%espelho da fun��o
%-----------------------------------------------------------  
    offsetx = px2(1,ind2);
    offsety = py2(1,ind2);
    plot3(-px2(1,ind2:-1:1) + 2*offsetx,-py2(1,ind2:-1:1)+2*offsety,pz2(1,ind2:-1:1),'r')
    hold on
    offsetx = -px2(1,ind2) + 2*offsetx;
    offsety = -py2(1,ind2) + 2*offsety;
    plot3(-px(1,ind:-1:1) + 2*offsetx,-py(1,ind:-1:1)+2*offsety,pz(1,ind:-1:1),'b')
    hold on
%-----------------------------------------------------------
%proje��o
%-----------------------------------------------------------   
    plot3(px(1,1:ind),py(1,1:ind),0*pz(1,1:ind),'g')
    hold on 
    plot3(px2(1,1:ind2),py2(1,1:ind2),0*pz2(1,1:ind2),'m')
    hold on
%-----------------------------------------------------------
%espelho da fun��o
%-----------------------------------------------------------    
    offsetx = px2(1,ind2);
    offsety = py2(1,ind2);
    plot3(-px2(1,ind2:-1:1) + 2*offsetx,-py2(1,ind2:-1:1)+2*offsety,0*pz2(1,ind2:-1:1),'m')
    hold on
    offsetx = -px2(1,ind2) + 2*offsetx;
    offsety = -py2(1,ind2) + 2*offsety;
    plot3(-px(1,ind:-1:1) + 2*offsetx,-py(1,ind:-1:1)+2*offsety,0*pz(1,ind:-1:1),'g')
    hold on 
%-----------------------------------------------------------
%plotar posi��o dos p�s
%----------------------------------------------------------- 
    plot3([pfa(1,1) pfb(1,1)],[pfa(2,1) pfb(2,1)],[0 0],'--k');
    hold on
%-----------------------------------------------------------
%proje��o centro de massa e proje��o centro de massa
%-----------------------------------------------------------     
    plot3(pc(1,1),pc(2,1),pc(3,1),'o')
    hold on
    plot3([pc(1,1) pc(1,1)],[pc(2,1) pc(2,1)],[pc(3,1) 0],':');
    hold on
    plot3(pc(1,1),pc(2,1),0,'x');
%-----------------------------------------------------------
%configura��o do grafico
%-----------------------------------------------------------     
    grid on
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end