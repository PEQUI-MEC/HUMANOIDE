%-----------------------------------------------------------
%método para cálcular os melhores parâmetros para a variável de controle U
%minimizando uma função objetivo.
%Otimizações implementadas:
%metodo : 0 estocástico  gradiente descendente SGD
%metodo : 1 SGD com momento
%metodo : 2 Nesterov accelerated gradient
%metodo : 3 Adagrad
%Parâmetros:
%tipo: 1 para executar a otimização e plotar a trajetoria dos dos valores obtidos pela otimização
%tipo:0 apenas plotar a trajetoria dos valores de U ja estipulados
%U - variavel de controle inicial
%X - condição inicial constante
%Retorno:
%mostrado no console o melhor resultado e mostrado graficamente a
%trajetória obtida
%-----------------------------------------------------------
function otimizacao(U,X,tipo,metodo)
if tipo ==1
    %-----------------------------------------------------------
    %variaveis globais
    %-----------------------------------------------------------
    global maxNGrad ganhoAlpha gamma 
    %-----------------------------------------------------------
    %iniciar variáveis de controle inicial
    %-----------------------------------------------------------
    u1 = U(1,1);
    u2 = U(2,1);
    u3 = U(3,1);
    u4 = U(4,1);
    u5 = U(5,1);
    %-----------------------------------------------------------
    %inicio do metodo
    %----------------------------------------------------------
    fo = 1;%condição de parada
    %-----------------------------------------------------------
    %melhor valores
    %----------------------------------------------------------
    fm = fo;
    UM = U(:,1);
    %-----------------------------------------------------------
    %vetores axiliares para os métodos de otimização
    %----------------------------------------------------------
    vt = zeros(4,1); %usado como auxiliar NAG
    Grad = zeros(4,1);%usado como auxiliar adagrad
    
    for j = 1:1:maxNGrad
    %-----------------------------------------------------------
    %metodo do gradiente decendente implementados
    %----------------------------------------------------------   
    
    %-----------------------------------------------------------
    %estocástico  gradiente descendente SGD
    %---------------------------------------------------------- 
    if metodo == 0      
        U = SGD(U,X);
    end
    %-----------------------------------------------------------
    %SGD com momento
    %---------------------------------------------------------- 
    if metodo == 1      
        [U,vt] = SGDMomento(U,X,vt);
    end
    %-----------------------------------------------------------
    %Nesterov accelerated gradient
    %---------------------------------------------------------- 
    if metodo == 2      
        [U,vt] = NAG(U,X,vt);
    end
    %-----------------------------------------------------------
    %Adagrad
    %---------------------------------------------------------- 
    if metodo == 3      
        [U,Grad] = adagrad(U,X,Grad);
    end 
    
    %-----------------------------------------------------------
    %Setar os limites inferiores e superiores em U
    %----------------------------------------------------------  
        U0 = setLimites(U);
        u1 = U0(1,1);
        u2 = U0(2,1);
        u3 = U0(3,1);
        u4 = U0(4,1);
        u5 = U0(5,1);
    %-----------------------------------------------------------
    %atualizar o vetor U com os valores 
    %mais atuais (variaveis de controle)
    %----------------------------------------------------------
        U  = [u1;u2;u3;u4;u5];
    %-----------------------------------------------------------
    %Cálculo do valor da função objetivo
    %----------------------------------------------------------              
       [pa,pb,pc] = trajetoria(U,X);     
       fo = funcaoObjetivo(pa,pb,pc);
    %-----------------------------------------------------------
    %verificar melhor resultado
    %----------------------------------------------------------      
        if fo<fm
            fm = fo;
            UM = U;
        end
    %-----------------------------------------------------------
    %verificar condição de parada
    %----------------------------------------------------------  
        if fo < 1*10^-10 
            break
        end
    %-----------------------------------------------------------
    %imprimir resultado no console
    %----------------------------------------------------------     
        imprimirConsole(j,[U;fo]);               
    end
    %-----------------------------------------------------------
    %imprimir resultado final no console
    %---------------------------------------------------------- 
    disp('************************************************************')
    disp('Melhor Solução: ')
    imprimirConsole(0,[UM;fm]);
    disp('************************************************************')
    %-----------------------------------------------------------
    %mostrar a trajetória no gráfico
    %----------------------------------------------------------
    plotarTrajetoria(UM,X)
else
    %-----------------------------------------------------------
    %mostrar a trajetória no gráfico
    %----------------------------------------------------------
    plotarTrajetoria(U,X)
end

end
 