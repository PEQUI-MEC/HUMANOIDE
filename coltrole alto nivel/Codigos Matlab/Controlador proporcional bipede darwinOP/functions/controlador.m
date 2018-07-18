function  thetas_corrigidos_1x12  = controlador(thetas_real_atual_1x12, h_desejado_esq_1x8, h_desejado_dir_1x8, h_futuro_esq_1x8, h_futuro_dir_1x8 )
% CONTROLADOR Controlador proporcional com feddforward
% Cada iteração deste controlador é executada em um ponto da trajetoria que
% é o próximo ponto que o atuador deve se posicionar e retorna os angulos
% necessários para esta posição;
% O robô está no ponto n, com a sua posição real theta n, o controlador vai
% calcular quais são os ângulos para o robô chegar a posição n+1, para isso
% ele recebe o ponto desejado n+1 e o ponto futuro n+2;
% --------------ARGUMENTOS
% thetas_real_atual_1x12: array dimensão 1x12 que recebe um vetor dos
% ângulos atuais reais do robô;
% hs_desejados_2x1x8: 2 arrays duais quaternions [h_esq, h dir] cada um com
% dimensão 1x8 que representa a próxima posição que o robô deverá assumir;
% hs__futuros_2x1x8: 2 arrays duais quaternions [h_esq, h dir] cada um com
% dimensão 1x8 que representa a posição seguinte a próxima posição que o
% robô deverá assumir;

% renomeando os argumentos:
thetas_real = thetas_real_atual_1x12;
h_desej_esq = h_desejado_esq_1x8;
h_desej_dir = h_desejado_dir_1x8;
h_futur_esq = h_futuro_esq_1x8;
h_futur_dir = h_futuro_dir_1x8;

DH = DH_parameters(thetas_real); % 16x4 tabela denavit
TDQ = DH_to_dqTransforms(DH); % 16x8 tabela dual quat denavit
[h_real_esq, h_real_dir] = dq_transf_resultante(TDQ); % 2(1x8) duais quat de cada perna

% parametros do controlador
g = 1000; % ganho proporcional
delta_t = 10e-6; % incremento no tempo para a derivada e integral

K = g*eye(8);% matriz diagonal de ganho
C8 = diag([1 -1 -1 -1 1 -1 -1 -1 ]); % matriz pra calcular o conjugado
[J_esq, J_dir] = jacobiano(thetas_real);

% calculos do controlador da perna esquerda
H_esq = dualHamiltonOp(h_desej_esq',0);% operador dual hamilton negativo
N_esq = H_esq*C8*J_esq;
erro_esq = [1 0 0 0 0 0 0 0]' - dual_quat_mult(dual_quat_conj(h_real_esq) , h_desej_esq)';
dh_desej_esq = (h_futur_esq - h_desej_esq)/delta_t;
vec = dual_quat_mult( dual_quat_conj(h_real_esq) , dh_desej_esq );
N_esqP = pinv(N_esq);
dtheta_esq = N_esqP*( K*erro_esq - vec');
theta_esq = (dtheta_esq*delta_t)/2; % regra do trapézio para integral

% calculos do controlador da perna direita
H_dir = dualHamiltonOp(h_desej_dir',0);% operador dual hamilton negativo
N_dir = H_dir*C8*J_dir;
erro_dir = [1 0 0 0 0 0 0 0]' - dual_quat_mult(dual_quat_conj(h_real_dir) , h_desej_dir)';
dh_desej_dir = (h_futur_dir - h_desej_dir)/delta_t;
vec = dual_quat_mult( dual_quat_conj(h_real_dir) , dh_desej_dir );
N_dirP = pinv(N_dir);
dtheta_dir = N_dirP*( K*erro_dir - vec');
theta_dir = (dtheta_dir*delta_t)/2;

thetas_corrigidos_1x12 = thetas_real + [theta_esq' theta_dir'];
end

