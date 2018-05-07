%-----------------------------------------------------------
%Método principal para a otimização do modelo
%retornando no console os valores para as variáveis de controle
%Modelo implementado: 
%3D Dual-SLIP
%Otimizações implementadas: 
%metodo : 0 estocástico  gradiente descendente SGD
%metodo : 1 Nesterov accelerated gradient
%metodo : 2 momento
%metodo : 3 Adagrad
%Variável de Controle:
%U = [theta,phi,k,BSS];
%theta - ângulo de abertura frontal da perna
%phi   - ângulo de abertura lateral da perna
%k     - constante da massa mola do modelo
%BSS   - taxa de crescimento linear da perna durante o passo
%-----------------------------------------------------------

%-----------------------------------------------------------
%iniciar, limpar memória, fechar todas as janelas
%-----------------------------------------------------------
clc
close all
clear all
%-----------------------------------------------------------
%adicionar as libs necessárias
%-----------------------------------------------------------
addpath('debug')
addpath('derivadas')  
addpath('edoSolve')  
addpath('graphics')  
addpath('modelos')  
addpath('otimizacaoTrajetoria')  
addpath('trajetoriaCoM')  
%-----------------------------------------------------------
%variáveis globais
%-----------------------------------------------------------
global  m L g lstep pfa thetaM phiM KM expK BSSM 
%massa do corpo
m = 80;
%tamanho da perna
L = 1;
%gravidade
g = 9.8;
%posição do pé de suporte em MS
pfa = [0;0;0];
%-----------------------------------------------------------
%Numero maximo de iterações para o metodo do gradiente
%-----------------------------------------------------------
global maxNGrad ganhoAlpha  gamma h hEdo
maxNGrad   = 10^6;%número máximo de iterações método
ganhoAlpha = 10^-2;%ganho do fator de ganho para cada passo
gamma      = 0.4 ;%ganho para os método gradiente(momento)
h          = 10^-4;%passo para o calculo das derivadas
%calculado (comparado com a função do matlab)
hEdo       = 10^-3.85;%passo para o calculo das derivadas
%-----------------------------------------------------------
%condição inicial para MS
%-----------------------------------------------------------
xod  = 0.00;%x inicial (d - desejado)
yod  = 0.05;%y inicial
zod  = 0.96;%z inicial (muito pequeno apens alguns centimetros)
dxod = 0.40;%velocidade desejada no MS
dyod = 0.00;%condição de balanço
dzod = 0.00;%velocidade em z (igual a zero condição necessaria)
%-----------------------------------------------------------
%Tamanho do passo (não sendo usado ainda estudar como incorporar 
%esse dado)
%-----------------------------------------------------------
lstep = 0.5 + 0.1*(dxod - 1);
%-----------------------------------------------------------
%valores máximos das variáveis de controle
%reduzir o espaço de busca
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
%Geralmente na literatura são usados x para variável de estado
%e u para a variável de controle sendo usados essas letras
%em maiusculo para representação
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
%condição inicial constante
%-----------------------------------------------------------
X  = [xod;yod;zod;dxod;dyod;dzod];
%-----------------------------------------------------------
%Executa o metodo de otimização
%passando o vetor de controle U
%e o vetor da condição inicial X
%tipo: 1 para executar a otimização e plotar a trajetoria dos 
%dos valores obtidos pela otimização
%tipo:0 apenas plotar a trajetoria dos valores de U ja estipulados
%-----------------------------------------------------------
tipo = 1;%recebe 0 ou 1 (alterar para executar a otimização ou não)
%metodo : 0 estocástico  gradiente descendente SGD
%metodo : 1 SGD com momento
%metodo : 2 Nesterov accelerated gradient
%metodo : 3 Adagrad
metodo = 3;
otimizacao(U,X,tipo,metodo);
