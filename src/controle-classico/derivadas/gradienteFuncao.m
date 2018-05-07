%-----------------------------------------------------------
%Cálcula o gradiente da função objetivo
%Parâmetros :
%X0 - Vetor com a condição inicial do sistema (Constante)
%U0 - Vetor com a condição inicial das variaveis de controle u
%Retorno:
%grad -  vetor gradiente das variaveis de controle
%----------------------------------------------------------
function grad = gradienteFuncao(X0,U0)
%-----------------------------------------------------------
%cálculo do gradiente para cada variavel de controle
%----------------------------------------------------------    
    grad(1,1) = primeiraDerivadaGradiente(X0,U0,1);% linha referente a theta
    grad(2,1) = primeiraDerivadaGradiente(X0,U0,2);% linha referente a phi
    grad(3,1) = primeiraDerivadaGradiente(X0,U0,3);% linha referente a K
    grad(4,1) = primeiraDerivadaGradiente(X0,U0,4);% linha refetente a BSS   
end