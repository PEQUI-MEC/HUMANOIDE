%-----------------------------------------------------------
%M�todo para calcular o melhor passo (h) que deve ser escolhido
%Para o m�todo implementado para resolver equa��es diferencias
%m�todo -  rungeKutta42
%Esta compara��o � realizada com o m�todo do pr�prio matlab,
%o qual, � definido como o mais correto.
%-----------------------------------------------------------
%-----------------------------------------------------------
%iniciar, limpar mem�ria, fechar todas as janelas
%-----------------------------------------------------------
clc
close all
clear all
%-----------------------------------------------------------
%adicionar as libs necess�rias
%-----------------------------------------------------------
addpath('../debug')
addpath('../derivadas')  
addpath('../edoSolve')  
addpath('../graphics')  
addpath('../modelos')  
addpath('../otimizacaoTrajetoria')  
addpath('../trajetoriaCoM')  
%-----------------------------------------------------------
%vari�veis globais
%-----------------------------------------------------------
global  m L g lstep pfa thetaM phiM KM expK BSSM 
m = 80;%massa do corpo dado em Kg
L = 1;%tamanho da perna do modelo dado em metros
g = 9.8;%gravidade m/s
pfa = [0;0;0];%posi��o do p� de suporte em MS
%-----------------------------------------------------------
%N�mero m�ximo de itera��es para o m�todo do gradiente
%-----------------------------------------------------------
global   hEdo %calculado (comparado com a fun��o do matlab)
hEdo       = 10^-3.6;%passo para o c�lculo das derivadas
%-----------------------------------------------------------
%condi��o inicial para MS
%-----------------------------------------------------------
xod  = 0.00;%x inicial (d - desejado)
yod  = 0.05;%y inicial
zod  = 0.96;%z inicial (muito pequeno apenas alguns cent�metros)
dxod = 1.00;%velocidade desejada no MS
dyod = 0.00;%condi��o de balan�o
dzod = 0.00;%velocidade em z (igual a zero condi��o necess�ria)
%-----------------------------------------------------------
%valores m�ximos das vari�veis de controle
%reduzir o espa�o de busca
%-----------------------------------------------------------
thetaM = 0.5;
phiM   = 0.5;
KM     = 2;
expK   = 10000;%ordem de grandeza da constante massa-mola
BSSM   = 0.2;               
%-----------------------------------------------------------
%vari�vel de controle inicial
%deve ser editado para os valores desejados
%-----------------------------------------------------------
%para uma velocidade de 1m/s 
%os valores para a variavel de controle
phi = 0.2277654528;
theta = 0.3082396318;
k = 18555.8839584785;
Bss = 0.1104930465;
k = k/expK;%tratar o valor (tirando a ordem de grandeza)
%-----------------------------------------------------------
%vari�vel de controle inicial
%-----------------------------------------------------------
U(1,1) = theta;
U(2,1) = phi;
U(3,1) = k;
U(4,1) = Bss;
U(5,1) = expK;
%-----------------------------------------------------------
%vetor com a condi��o inicial constante
%-----------------------------------------------------------
X  = [xod;yod;zod;dxod;dyod;dzod];
%-----------------------------------------------------------
%Calcular pontos com m�todo do matlab para resolver 
%as equa��es diferencias da trajet�ria
%-----------------------------------------------------------
[pa2 pb2 pc2 M2] = trajetoriaMatlab(U,X);
%-----------------------------------------------------------
%Verificar com o m�todo implementado
%passo do m�todo : h = 10e-n
%-----------------------------------------------------------
nh = 1:0.01:16;%valores para n
%-----------------------------------------------------------
%tamanho do vetor nh
%-----------------------------------------------------------
tam = size(nh);
tam = tam(1,2);
%-----------------------------------------------------------
%criar um vetor para o c�lculo do erro
%-----------------------------------------------------------
erro = zeros(1,tam);
%-----------------------------------------------------------
%percorrer o vetor nh para o c�lculo do erro
%-----------------------------------------------------------
for i = 1:1:tam
%-----------------------------------------------------------
%andamento do loop
%-----------------------------------------------------------
 msg = sprintf('%d de %d',i,tam);
 disp(msg);
%-----------------------------------------------------------
%atualizar o valor de h  utilizado no 
%m�todo rungeKutta42
%-----------------------------------------------------------
 hEdo = 10^-nh(1,i);
%-----------------------------------------------------------
%pontos dados pela trajet�ria
%utilizando o m�todo implementado
%para solu��o das equa��es diferencias 
%-----------------------------------------------------------
 [pa1 pb1 pc1 M1] = trajetoria(U,X);   
%-----------------------------------------------------------
%erro dado pela norma quadr�tica dos pontos
%-----------------------------------------------------------
 erro(1,i) = (pb1(1,1) - pb2(1,1))^2 + (pb1(2,1) - pb2(2,1))^2 + (pc1(1,1) - pc2(1,1))^2 + (pc1(2,1) - pc2(2,1))^2;
 erro(1,i) = (1/4)*erro(1,i)^0.5;
end
%-----------------------------------------------------------
%plotar Grafico escala Logar�tmica
%-----------------------------------------------------------
loglog(nh,erro)
grid on
%-----------------------------------------------------------
%Dados do gr�fico
%-----------------------------------------------------------
title('log(erro) para h = 10e-n')
xlabel('n')
ylabel('log(erro)')
%-----------------------------------------------------------
%C�lculos para obter o melhor valor de n
%-----------------------------------------------------------
ValorOtimoPasso(:,1) = erro';
ValorOtimoPasso(:,2) = nh';
%-----------------------------------------------------------
%ordenar a matriz pela coluna de erro
%em ordem crescente
%o melhor valor de n � dado pela primeiro elemento
%da segunda coluna do ValorOtimoPasso
%-----------------------------------------------------------
ValorOtimoPasso = sortrows(ValorOtimoPasso,1);
%-----------------------------------------------------------
%Imprimir o melhor valor no console
%-----------------------------------------------------------
disp('******************************************************')
msg = sprintf('Valor de n (h = 10e-n) :%d',ValorOtimoPasso(1,2));
disp(msg);
msg = sprintf('Valor do log(erro) :%d',ValorOtimoPasso(1,1));
disp(msg);