%-----------------------------------------------------------
%M�todo principal para o controle LQR
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
addpath('outros') 
addpath('trajetoriaPes')
addpath('quaternion_library');
addpath('dual_quaternion_library');
addpath('kinematic_dualquartenion_library');
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
dxod = 1;%velocidade desejada no MS
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
%condi��o inicial constante
%-----------------------------------------------------------
X  = [xod;yod;zod;dxod;dyod;dzod];
%-----------------------------------------------------------
%Obter trajet�rias iniciais para o CoM
%e para o p� de contato B
%-----------------------------------------------------------
[PA,PB,trajCoM] = trajetoria2MS(U,X);%trajet�ria para o CoM
passo = PB(1,1);%tamanho do passo
altura = 0.2;%altura de cada passo
trajPB = trajetoriaPes(PB,passo,altura);%trajet�ria do p� B

%-----------------------------------------------------------
%obter pontos do p� B para a condi��o inicial de MS
%-----------------------------------------------------------
tam = size(trajPB,1);
ind = 0;

  for i = 1:1:tam
     if trajPB(i,1) == 0
         ind = i;
         break
     end
  end
  aux(:,1) = trajPB(ind:tam,1);
  aux(:,2) = trajPB(ind:tam,2);     
  aux(:,3) = trajPB(ind:tam,3);
%-----------------------------------------------------------
%Trajet�ria do p� B para a primeira condi��o de MS
%-----------------------------------------------------------
  trajPB = aux;

%-----------------------------------------------------------
%Modelo do rob� 
%primeiros testes 
%implementa��o come�a aquiiii
%----------------------------------------------------------- 

hpi = pi/2;
N = 6;%Numero de Juntas

%Comprimento das Juntas
%syms L1 L2 L3 L4 L5
L1 = 1;
L2 = 1;
L3 = 1;
L4 = 1;
L5 = 1;

%Parametros de D.H.
oi = [ 0 -hpi 0 0 0 0]';
di = [ 0 0 0 0 0 0]';
ai = [ 0 0 L3 L4 0 L5]';
si = [ hpi -hpi 0 0 hpi 0]';

%matriz dos parametros de D.H
MDH = [oi di ai si];
%define se a cinematica sera 
%foward     (base para ponta) 
%backward   (ponta para base)
kinematic = 0; 
x = KinematicModel(MDH,N,kinematic);

re = getRotationDualQuat(x);
pe = getPositionDualQuat(x);   

q1 = [cos(hpi/2) sin(hpi/2)*[0 1 0]]'
q2 = [cos(hpi/2) sin(hpi/2)*[1 0 0]]'
quatMult(q2,q1)

     

