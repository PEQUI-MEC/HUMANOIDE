%-----------------------------------------------------------
%Método para mostrar gráficamente a trajetória do modelo dinâmico
%Parâmetros:
%U - variáveis de controle
%X - vetor com as condições iniciais
%Retorno:
%gráfico do modelo dinâmico
%-----------------------------------------------------------
function plotarTrajetoria(U,X)
%-----------------------------------------------------------
%variaveis globais
%-----------------------------------------------------------
global m L g pfa expK hEdo
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
    %u = [phi theta k Bss]
    theta = U(1,1);
    phi   = U(2,1);
    k     = U(3,1);
    Bss   = U(4,1);
    expK  = U(5,1);
%-----------------------------------------------------------
%vetor com as condições iniciais MS
%----------------------------------------------------------- 
    y0 = [xod;dxod;yod;dyod;zod;dzod];
%-----------------------------------------------------------
%vetor com os parâmetros constantes
%-----------------------------------------------------------         
    params = [m;L;g;k;Bss;expK];
%-----------------------------------------------------------
%Parametros para os métodos 
%-----------------------------------------------------------   
    t = 0;%inicio do tempo no tempo t = 0
    h = hEdo;%passo do método rungeKutta42 inicial
    N = 10000;%número máximo de iterações

    %primeiro metodo
    sh = h;%tamanho do passo para o método rungeKutta42 atualizando durante a execução do método
    ind = 1;%contador
%-----------------------------------------------------------
%vetores auxiliares para guardar a trajetória
%-----------------------------------------------------------    
    px(1,1) = y0(1,1);
    py(1,1) = y0(3,1);
    pz(1,1) = y0(5,1);
%-----------------------------------------------------------
%inicio do método 1 MS para TD
%----------------------------------------------------------- 
    for x = 0:h:N*h
%-----------------------------------------------------------
%vetor de parâmetros
%-----------------------------------------------------------  
        var = [t;h;1];
%-----------------------------------------------------------
%método numérico para solucionar as equações diferenciais
%passo a passo
%----------------------------------------------------------- 
        [y sh] = rungeKutta42(var,y0,params);
%-----------------------------------------------------------
%atualizando a condição inicial
%----------------------------------------------------------- 
        y0  = y;
%-----------------------------------------------------------
%atualizando o instante t
%----------------------------------------------------------- 
        t = t+sh;
%-----------------------------------------------------------
%verificando a condição de parada posição Z < que Z de touchdown
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
%Posição do centro de massa no momento de  Touchdown (TD)
%-----------------------------------------------------------
    pc = [px(1,ind);py(1,ind);pz(1,ind)];%centro de massa
%-----------------------------------------------------------
%posição do pé de balaço quando toca o chão
%-----------------------------------------------------------    
    pfb = pc + L*[sin(theta)*cos(phi);sin(theta)*sin(phi);-cos(theta)]
%-----------------------------------------------------------
%tempo em que acontece a codição de touchdown
%----------------------------------------------------------- 
    TD = t;%tempo de TD
%-----------------------------------------------------------
%parametros constante para o segundo método
%-----------------------------------------------------------
    params = [m;L;g;k;Bss;t;pfb(1,1);pfb(2,1);pfb(3,1);expK];
%-----------------------------------------------------------
%iniciando o segundo contador
%-----------------------------------------------------------
    ind2 = 1;
    sh = h;%tamanho do passo para o método rungeKutta42 atualizando durante a execução do método
%-----------------------------------------------------------
%vetores auxiliares para guardar a trajetória
%----------------------------------------------------------- 
    px2(1,1) = y0(1,1);
    py2(1,1) = y0(3,1);
    pz2(1,1) = y0(5,1);
%-----------------------------------------------------------
%inicio do método 2  TD para LH
%----------------------------------------------------------- 
    for x = 0:h:N*h
%-----------------------------------------------------------
%vetor de parâmetros
%-----------------------------------------------------------    
        var = [t;h;0];
%-----------------------------------------------------------
%método numérico para solucionar as equações diferenciais
%passo a passo
%-----------------------------------------------------------
        [y sh] = rungeKutta42(var,y0,params);
%-----------------------------------------------------------
%atualizando nova condição inicial
%-----------------------------------------------------------     
        y0  = y;
%-----------------------------------------------------------
%atualizando o instante t
%-----------------------------------------------------------
        t = t+sh;        
%-----------------------------------------------------------
%verificando a condição de parada posição dZ > 0
%-----------------------------------------------------------
        if y0(6,1) > 0
            break
        end
%-----------------------------------------------------------
%atualizando os vetores auxiliares da trajetória
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
%atualizando a posição do centro de massa
%-----------------------------------------------------------
    pc = [px2(1,ind2);py2(1,ind2);pz2(1,ind2)];%centro de massa
%-----------------------------------------------------------    % trajetoria 
% a trajetoria é simetrica ao ponto de middle suport
% desta forma fazemos um espelho da função 
%deslocado ela para a origem
%posição do pé de suporte em MS  
%-----------------------------------------------------------    
    plot3(px(1,1:ind),py(1,1:ind),pz(1,1:ind),'b')
    hold on 
    plot3(px2(1,1:ind2),py2(1,1:ind2),pz2(1,1:ind2),'r')
    hold on
%-----------------------------------------------------------
%espelho da função
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
%projeção
%-----------------------------------------------------------   
    plot3(px(1,1:ind),py(1,1:ind),0*pz(1,1:ind),'g')
    hold on 
    plot3(px2(1,1:ind2),py2(1,1:ind2),0*pz2(1,1:ind2),'m')
    hold on
%-----------------------------------------------------------
%espelho da função
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
%plotar posição dos pés
%----------------------------------------------------------- 
    plot3([pfa(1,1) pfb(1,1)],[pfa(2,1) pfb(2,1)],[0 0],'--k');
    hold on
%-----------------------------------------------------------
%projeção centro de massa e projeção centro de massa
%-----------------------------------------------------------     
    plot3(pc(1,1),pc(2,1),pc(3,1),'o')
    hold on
    plot3([pc(1,1) pc(1,1)],[pc(2,1) pc(2,1)],[pc(3,1) 0],':');
    hold on
    plot3(pc(1,1),pc(2,1),0,'x');
%-----------------------------------------------------------
%configuração do grafico
%-----------------------------------------------------------     
    grid on
    xlabel('X')
    ylabel('Y')
    zlabel('Z')
end