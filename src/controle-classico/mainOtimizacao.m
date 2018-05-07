%-----------------------------------------------------------
%M�todo principal para a otimiza��o do modelo
%retornando no console os valores para as vari�veis de controle
%Modelo implementado: 
%3D Dual-SLIP
%Otimiza��es implementadas: 
%metodo : 0 estoc�stico  gradiente descendente SGD
%metodo : 1 Nesterov accelerated gradient
%metodo : 2 momento
%metodo : 3 Adagrad
%Vari�vel de Controle:
%U = [theta,phi,k,BSS];
%theta - �ngulo de abertura frontal da perna
%phi   - �ngulo de abertura lateral da perna
%k     - constante da massa mola do modelo
%BSS   - taxa de crescimento linear da perna durante o passo
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
addpath('debug')
addpath('derivadas')  
addpath('edoSolve')  
addpath('graphics')  
addpath('modelos')  
addpath('otimizacaoTrajetoria')  
addpath('trajetoriaCoM')  
%-----------------------------------------------------------
%vari�veis globais
%-----------------------------------------------------------
global  m L g lstep pfa thetaM phiM KM expK BSSM 
%massa do corpo
m = 80;
%tamanho da perna
L = 1;
%gravidade
g = 9.8;
%posi��o do p� de suporte em MS
pfa = [0;0;0];
%-----------------------------------------------------------
%Numero maximo de itera��es para o metodo do gradiente
%-----------------------------------------------------------
global maxNGrad ganhoAlpha  gamma h hEdo
maxNGrad   = 10^6;%n�mero m�ximo de itera��es m�todo
ganhoAlpha = 10^-2;%ganho do fator de ganho para cada passo
gamma      = 0.4 ;%ganho para os m�todo gradiente(momento)
h          = 10^-4;%passo para o calculo das derivadas
%calculado (comparado com a fun��o do matlab)
hEdo       = 10^-3.85;%passo para o calculo das derivadas
%-----------------------------------------------------------
%condi��o inicial para MS
%-----------------------------------------------------------
xod  = 0.00;%x inicial (d - desejado)
yod  = 0.05;%y inicial
zod  = 0.96;%z inicial (muito pequeno apens alguns centimetros)
dxod = 0.40;%velocidade desejada no MS
dyod = 0.00;%condi��o de balan�o
dzod = 0.00;%velocidade em z (igual a zero condi��o necessaria)
%-----------------------------------------------------------
%Tamanho do passo (n�o sendo usado ainda estudar como incorporar 
%esse dado)
%-----------------------------------------------------------
lstep = 0.5 + 0.1*(dxod - 1);
%-----------------------------------------------------------
%valores m�ximos das vari�veis de controle
%reduzir o espa�o de busca
%-----------------------------------------------------------
thetaM = 0.5;
phiM   = 0.5;
KM     = 2;
expK   = 10000;%ordem de grandeza da constante massa-mola
BSSM   = 0.2;
%params = [thetaM;phiM;KM;expK;BSSM];                  
%-----------------------------------------------------------
%variavel de controle inicial
%modificar os valores obtidos aqui
%Geralmente na literatura s�o usados x para vari�vel de estado
%e u para a vari�vel de controle sendo usados essas letras
%em maiusculo para representa��o
%-----------------------------------------------------------

phi = 0.2117046755;
theta = 0.3994995317;
k = 19210.7487666154;
Bss = 0.0318055780;

k = k/expK;%tratar o valor 
U(1,1) = theta;
U(2,1) = phi;
U(3,1) = k;
U(4,1) = Bss;
U(5,1) = expK;
%-----------------------------------------------------------
%condi��o inicial constante
%-----------------------------------------------------------
X  = [xod;yod;zod;dxod;dyod;dzod];
%-----------------------------------------------------------
%Executa o metodo de otimiza��o
%passando o vetor de controle U
%e o vetor da condi��o inicial X
%tipo: 1 para executar a otimiza��o e plotar a trajetoria dos 
%dos valores obtidos pela otimiza��o
%tipo:0 apenas plotar a trajetoria dos valores de U ja estipulados
%-----------------------------------------------------------
tipo = 1;%recebe 0 ou 1 (alterar para executar a otimiza��o ou n�o)
%metodo : 0 estoc�stico  gradiente descendente SGD
%metodo : 1 SGD com momento
%metodo : 2 Nesterov accelerated gradient
%metodo : 3 Adagrad
metodo = 3;
otimizacao(U,X,tipo,metodo);
