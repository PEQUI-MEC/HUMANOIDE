%-----------------------------------------------------------
%C�lcula da derivada da fun��o objetivo dado a varia��o de 
%1 par�metro
%derivada c�lculada pelo m�todo das diferencas centradas
%utilizando 5 pontos , este m�todo tem uma incerteza
%da O(h^4)
%Par�metros :
%X0 - Vetor com a condi��o inicial do sistema (Constante)
%U0 - Vetor com a condi��o inicial das variaveis de controle u
%Retorno:
%d1 -  derivada
%----------------------------------------------------------
function d1 = primeiraDerivadaGradiente(X0,U0,ind)
%-----------------------------------------------------------
%variaveis globais
%----------------------------------------------------------
    global h
%-----------------------------------------------------------
%c�lculo do primeiro ponto para 2h
%----------------------------------------------------------
    y = U0(ind,1)+2*h;%adicionando a varia��o na vari�vel
    Y = U0(:,1);%copiando o vetor de controle original
    Y(ind,1) = y;%substituindo o valor com a varia��o na posi��o desejada
    [pa,pb,pc] = trajetoria(Y,X0);%c�lculo dos pontos da trajet�ria
    a = funcaoObjetivo(pa,pb,pc);%calculo da fun��o objetivo
%-----------------------------------------------------------
%c�lculo do primeiro ponto para h
%----------------------------------------------------------
    y = U0(ind,1)+h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    b = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%c�lculo do primeiro ponto para -h
%----------------------------------------------------------
    y = U0(ind,1)-h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    c = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%c�lculo do primeiro ponto para -2h
%----------------------------------------------------------
    y = U0(ind,1)-2*h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    d = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%c�lculo da derivada
%----------------------------------------------------------
    d1 = (-a + 8*b  -8*c + d) / (12 * h)  + h^4;  
end