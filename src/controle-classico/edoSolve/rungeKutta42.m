%-----------------------------------------------------------
%método de Runge–Kutta de 4ª ordem
%para a resolução numérica (aproximação) 
%de soluções de equações diferenciais ordinárias.
%Parâmetros:
%var - vetor com parâmetros para o método
%t - tempo do método para cada iteração
%h - passo para cada iteração
%fun - tipo da função implementados dois modelos
%params - vetor com os parâmetros passados para o modelo dinâmico
%Retorno:
%yk - nova condição inicial , solução para a EDO para a iteração
%sh - novo passo ótimo - (nesse caso esta passando o passo fixo, sempre h)
%-----------------------------------------------------------
function [yk sh] = rungeKutta42(var,y,params)
%-----------------------------------------------------------
%parâmetros para o método de rungeKutta
%-----------------------------------------------------------
    t   = var(1,1);
    h   = var(2,1);
    fun = var(3,1);
%-----------------------------------------------------------
%verifica qual o modelo será resolvido
% 1 - modelo 1
% ~= 1 - modelo 2
%-----------------------------------------------------------   
    if fun
%-----------------------------------------------------------
%cálculo dos parâmetros do método de rungeKutta
%-----------------------------------------------------------
        K1 = model1(t,y,params);
        K2 = model1(t + h/2,y + (h/2)*K1,params);
        K3 = model1(t + h/2,y + (h/2)*K2,params);
        K4 = model1(t + h,y + h*K3,params);
%-----------------------------------------------------------
%novo valor de yk e o novo passo
%-----------------------------------------------------------
        yk = y + (h/6)*(K1 + 2*K2 + 2*K3 + K4);
        sh = h;
    else
%-----------------------------------------------------------
%cálculo dos parâmetros do método de rungeKutta
%-----------------------------------------------------------
        K1 = model2(t,y,params);
        K2 = model2(t + h/2,y + (h/2)*K1,params);
        K3 = model2(t + h/2,y + (h/2)*K2,params);
        K4 = model2(t + h,y + h*K3,params);
%-----------------------------------------------------------
%novo valor de yk e o novo passo
%-----------------------------------------------------------
        yk = y + (h/6)*(K1 + 2*K2 + 2*K3 + K4);
        sh = h;
    end
end