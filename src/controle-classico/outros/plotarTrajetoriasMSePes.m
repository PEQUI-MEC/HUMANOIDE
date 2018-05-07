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
addpath('../trajetoriaPes') 

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
dxod = 1.00;%velocidade desejada no MS
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
%1m/s
phi = 0.1980076302;
theta = 0.3968673092;
k = 19931.1753572129;
Bss = 0.0204905395;

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
%trajetória 4 - MS
%-----------------------------------------------------------
[pa pb pc M] = trajetoria(U,X);
ind = size(M,1);
offsetx = M(ind,1);
offsety = M(ind,2);
M2(:,1) = -M(ind:-1:1,1) + 2*offsetx;
M2(:,2) = -M(ind:-1:1,2) + 2*offsety;
M2(:,3) =  M(ind:-1:1,3);

trajCoM1 = [M;M2];
plot3(trajCoM1(:,1),trajCoM1(:,2),trajCoM1(:,3),'b')
hold on
plot3(trajCoM1(:,1),trajCoM1(:,2),0*trajCoM1(:,3),'b')


ind = size(trajCoM1,1);
offsetx2 = trajCoM1(ind/2,1);
offsety2 = trajCoM1(ind/2,2);
trajCoM2(:,1)  = trajCoM1(ind:-1:1,1) + trajCoM1(ind,1);
trajCoM2(:,2)  = -trajCoM1(ind:-1:1,2) + offsety + trajCoM1(ind/2,2);
trajCoM2(:,3)  =  trajCoM1(ind:-1:1,3);
hold on
plot3(trajCoM2(:,1),trajCoM2(:,2),trajCoM2(:,3),'r')
hold on
plot3(trajCoM2(:,1),trajCoM2(:,2),0*trajCoM2(:,3),'r')
hold on
ind = size(trajCoM2,1);
offsetx = trajCoM2(ind,1);
plot3(trajCoM1(:,1)+2*offsetx,trajCoM1(:,2),trajCoM1(:,3),'b')
hold on
plot3(trajCoM1(:,1)+2*offsetx,trajCoM1(:,2),0*trajCoM1(:,3),'b')
hold on
ind = size(trajCoM2,1);
offsetx = trajCoM2(ind,1) +offsetx;
plot3(trajCoM2(:,1)+offsetx,trajCoM2(:,2),trajCoM2(:,3),'r')
hold on
plot3(trajCoM2(:,1)+offsetx,trajCoM2(:,2),0*trajCoM2(:,3),'r')
hold on
plot3([pa(1,1) pb(1,1)],[pa(2,1) pb(2,1)],[0 0],'k:')
hold on
plot3(pc(1,1),pc(2,1), pc(3,1),'o')
hold on
plot3([pc(1,1) pc(1,1)],[pc(2,1) pc(2,1)], [pc(3,1) 0],'k:')
hold on
plot3([pc(1,1)],[pc(2,1)], [0],'+')
hold on
plot3([pa(1,1) pc(1,1)],[pa(2,1) pc(2,1)],[0 pc(3,1)],'b')
hold on
plot3([pb(1,1) pc(1,1)],[pb(2,1) pc(2,1)],[0 pc(3,1)],'r')
hold on
grid on
passo = pb(1,1);
trajPes = trajetoriaPes(pb,passo,0.2);
plot3(trajPes(:,1),trajPes(:,2),trajPes(:,3))
hold on
plot3(trajPes(:,1)+ 2*passo,trajPes(:,2),trajPes(:,3))
hold on
plot3(trajPes(:,1)+ 4*passo,trajPes(:,2),trajPes(:,3))
hold on
%pé A
trajPes = trajetoriaPes(pa,passo,0.2);
hold on
plot3(trajPes(:,1),trajPes(:,2),trajPes(:,3))
hold on
plot3(trajPes(:,1)+2*passo,trajPes(:,2),trajPes(:,3))
hold on
hold on
plot3(trajPes(:,1)+4*passo,trajPes(:,2),trajPes(:,3))






