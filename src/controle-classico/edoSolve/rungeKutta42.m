%-----------------------------------------------------------
%m�todo de Runge�Kutta de 4� ordem
%para a resolu��o num�rica (aproxima��o) 
%de solu��es de equa��es diferenciais ordin�rias.
%Par�metros:
%var - vetor com par�metros para o m�todo
%t - tempo do m�todo para cada itera��o
%h - passo para cada itera��o
%fun - tipo da fun��o implementados dois modelos
%params - vetor com os par�metros passados para o modelo din�mico
%Retorno:
%yk - nova condi��o inicial , solu��o para a EDO para a itera��o
%sh - novo passo �timo - (nesse caso esta passando o passo fixo, sempre h)
%-----------------------------------------------------------
function [yk sh] = rungeKutta42(var,y,params)
%-----------------------------------------------------------
%par�metros para o m�todo de rungeKutta
%-----------------------------------------------------------
    t   = var(1,1);
    h   = var(2,1);
    fun = var(3,1);
%-----------------------------------------------------------
%verifica qual o modelo ser� resolvido
% 1 - modelo 1
% ~= 1 - modelo 2
%-----------------------------------------------------------   
    if fun
%-----------------------------------------------------------
%c�lculo dos par�metros do m�todo de rungeKutta
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
%c�lculo dos par�metros do m�todo de rungeKutta
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