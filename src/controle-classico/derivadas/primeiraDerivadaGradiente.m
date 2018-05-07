%-----------------------------------------------------------
%Cálcula da derivada da função objetivo dado a variação de 
%1 parâmetro
%derivada cálculada pelo método das diferencas centradas
%utilizando 5 pontos , este método tem uma incerteza
%da O(h^4)
%Parâmetros :
%X0 - Vetor com a condição inicial do sistema (Constante)
%U0 - Vetor com a condição inicial das variaveis de controle u
%Retorno:
%d1 -  derivada
%----------------------------------------------------------
function d1 = primeiraDerivadaGradiente(X0,U0,ind)
%-----------------------------------------------------------
%variaveis globais
%----------------------------------------------------------
    global h
%-----------------------------------------------------------
%cálculo do primeiro ponto para 2h
%----------------------------------------------------------
    y = U0(ind,1)+2*h;%adicionando a variação na variável
    Y = U0(:,1);%copiando o vetor de controle original
    Y(ind,1) = y;%substituindo o valor com a variação na posição desejada
    [pa,pb,pc] = trajetoria(Y,X0);%cálculo dos pontos da trajetória
    a = funcaoObjetivo(pa,pb,pc);%calculo da função objetivo
%-----------------------------------------------------------
%cálculo do primeiro ponto para h
%----------------------------------------------------------
    y = U0(ind,1)+h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    b = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%cálculo do primeiro ponto para -h
%----------------------------------------------------------
    y = U0(ind,1)-h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    c = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%cálculo do primeiro ponto para -2h
%----------------------------------------------------------
    y = U0(ind,1)-2*h;
    Y = U0(:,1);
    Y(ind,1) = y;
    [pa,pb,pc] = trajetoria(Y,X0);
    d = funcaoObjetivo(pa,pb,pc);
%-----------------------------------------------------------
%cálculo da derivada
%----------------------------------------------------------
    d1 = (-a + 8*b  -8*c + d) / (12 * h)  + h^4;  
end