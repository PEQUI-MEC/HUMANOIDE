%-----------------------------------------------------------
%Método para calcular o melhor passo (h) que deve ser escolhido
%Para o método implementado para resolver equações diferencias
%método -  rungeKutta42
%Esta comparação é realizada com o método do próprio matlab,
%o qual, é definido como o mais correto.
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
addpath('../debug')
addpath('../derivadas')  
addpath('../edoSolve')  
addpath('../graphics')  
addpath('../modelos')  
addpath('../otimizacaoTrajetoria')  
addpath('../trajetoriaCoM')  
%-----------------------------------------------------------
%variáveis globais
%-----------------------------------------------------------
global  m L g lstep pfa thetaM phiM KM expK BSSM 
m = 80;%massa do corpo dado em Kg
L = 1;%tamanho da perna do modelo dado em metros
g = 9.8;%gravidade m/s
pfa = [0;0;0];%posição do pé de suporte em MS
%-----------------------------------------------------------
%Número máximo de iterações para o método do gradiente
%-----------------------------------------------------------
global   hEdo %calculado (comparado com a função do matlab)
hEdo       = 10^-3.6;%passo para o cálculo das derivadas
%-----------------------------------------------------------
%condição inicial para MS
%-----------------------------------------------------------
xod  = 0.00;%x inicial (d - desejado)
yod  = 0.05;%y inicial
zod  = 0.96;%z inicial (muito pequeno apenas alguns centímetros)
dxod = 1.00;%velocidade desejada no MS
dyod = 0.00;%condição de balanço
dzod = 0.00;%velocidade em z (igual a zero condição necessária)
%-----------------------------------------------------------
%valores máximos das variáveis de controle
%reduzir o espaço de busca
%-----------------------------------------------------------
thetaM = 0.5;
phiM   = 0.5;
KM     = 2;
expK   = 10000;%ordem de grandeza da constante massa-mola
BSSM   = 0.2;               
%-----------------------------------------------------------
%variável de controle inicial
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
%variável de controle inicial
%-----------------------------------------------------------
U(1,1) = theta;
U(2,1) = phi;
U(3,1) = k;
U(4,1) = Bss;
U(5,1) = expK;
%-----------------------------------------------------------
%vetor com a condição inicial constante
%-----------------------------------------------------------
X  = [xod;yod;zod;dxod;dyod;dzod];
%-----------------------------------------------------------
%Calcular pontos com método do matlab para resolver 
%as equações diferencias da trajetória
%-----------------------------------------------------------
[pa2 pb2 pc2 M2] = trajetoriaMatlab(U,X);
%-----------------------------------------------------------
%Verificar com o método implementado
%passo do método : h = 10e-n
%-----------------------------------------------------------
nh = 1:0.01:16;%valores para n
%-----------------------------------------------------------
%tamanho do vetor nh
%-----------------------------------------------------------
tam = size(nh);
tam = tam(1,2);
%-----------------------------------------------------------
%criar um vetor para o cálculo do erro
%-----------------------------------------------------------
erro = zeros(1,tam);
%-----------------------------------------------------------
%percorrer o vetor nh para o cálculo do erro
%-----------------------------------------------------------
for i = 1:1:tam
%-----------------------------------------------------------
%andamento do loop
%-----------------------------------------------------------
 msg = sprintf('%d de %d',i,tam);
 disp(msg);
%-----------------------------------------------------------
%atualizar o valor de h  utilizado no 
%método rungeKutta42
%-----------------------------------------------------------
 hEdo = 10^-nh(1,i);
%-----------------------------------------------------------
%pontos dados pela trajetória
%utilizando o método implementado
%para solução das equações diferencias 
%-----------------------------------------------------------
 [pa1 pb1 pc1 M1] = trajetoria(U,X);   
%-----------------------------------------------------------
%erro dado pela norma quadrática dos pontos
%-----------------------------------------------------------
 erro(1,i) = (pb1(1,1) - pb2(1,1))^2 + (pb1(2,1) - pb2(2,1))^2 + (pc1(1,1) - pc2(1,1))^2 + (pc1(2,1) - pc2(2,1))^2;
 erro(1,i) = (1/4)*erro(1,i)^0.5;
end
%-----------------------------------------------------------
%plotar Grafico escala Logarítmica
%-----------------------------------------------------------
loglog(nh,erro)
grid on
%-----------------------------------------------------------
%Dados do gráfico
%-----------------------------------------------------------
title('log(erro) para h = 10e-n')
xlabel('n')
ylabel('log(erro)')
%-----------------------------------------------------------
%Cálculos para obter o melhor valor de n
%-----------------------------------------------------------
ValorOtimoPasso(:,1) = erro';
ValorOtimoPasso(:,2) = nh';
%-----------------------------------------------------------
%ordenar a matriz pela coluna de erro
%em ordem crescente
%o melhor valor de n é dado pela primeiro elemento
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