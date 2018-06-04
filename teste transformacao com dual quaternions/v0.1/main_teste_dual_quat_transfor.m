% quiver3(x,y,z,u,v,w) onde x,y,z é a posicao do vetor e u,v,w é a
% orientacao (direcao)

clc; clear; close all;
figure();
hold on;
grid on;
view(-45,45); % ajusta o view do grafico para ficar bom de ver
axis equal;
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera'); % da zoom na camera, nao na escala

% ----------------------------------------------------------------------
% EXEMPLO DE USO DA TRANSFORMACAO COM DUAL QUATERION (CTRL + T OU R)
% ----------------------------------------------------------------------
% scatter3(0,0,0, 180, [0.3 0.5 0.2], 'filled')
% %DADOS DA MINHA TRANSFORMACAO (ROTACAO MAIS TRANSLACAO)
% theta = pi/4; % angulo da rotacao
% v = [0, 0, 1]; % eixo da rotacao
% 
% x = -6:0.1:6;
% z = gaussmf(x, [2 0])*5;
% %y = sqrt(9 - x.^2);
% %x = [x(1:length(x)-1) -x];
% %y = [y(1:length(y)-1) -y];
% y = zeros(length(x));
% %z = 0: 0.1/2: 6;
% plot3(x, y, z);
% 
% for i = 1:length(x)
%     transform_plot(theta*2, v, [6 6 0], [x(i) y(i) z(i)]);
% end


% ----------------------------------------------------------------------
% TRANSFORMACOES SEGUIDAS ( da forma que esta a translacao nao acumula, a
% sensação é de estar errado, mas esta certo, é como se cada transformacao
% fosse sobre cada novo ponto)
% ----------------------------------------------------------------------
% pt1i = [0 0 0];
% pt1f = [1 0 0];
% r1 = [0 0 4];
% t1 = [2 0 0];
% theta1 = pi/2;
% dq2i = transform_plot(theta1, r1, t1, pt1i);
% dq2f = transform_plot(theta1, r1, t1, pt1f);
% pt2i = 2*quat_mult(dq2i(5:8), [dq2i(1) -dq2i(2:4)]);
% pt2f = 2*quat_mult(dq2f(5:8), [dq2f(1) -dq2f(2:4)]);
% vt2f = [pt2f - pt2i];
% 
% quiver3(pt2i(2), pt2i(3), pt2i(4), vt2f(2), vt2f(3), vt2f(4), 0, 'color', [0 0 0])
% 
% t1 = [0 2 0];
% theta1 = pi/2;
% dq3i = transform_plot(theta1, r1, t1, pt2i(2:4));
% dq3f = transform_plot(theta1, r1, t1, pt2f(2:4));
% pt3i = 2*quat_mult(dq3i(5:8), [dq3i(1) -dq3i(2:4)]);
% pt3f = 2*quat_mult(dq3f(5:8), [dq3f(1) -dq3f(2:4)]);
% vt3f = [pt3f - pt3i];
% 
% quiver3(pt3i(2), pt3i(3), pt3i(4), vt3f(2), vt3f(3), vt3f(4), 0, 'color', 'blue')
% 
% t1 = [0 0 2];
% theta1 = 0;
% dq4i = transform_plot(theta1, r1, t1, pt3i(2:4));
% dq4f = transform_plot(theta1, r1, t1, pt3f(2:4));
% pt4i = 2*quat_mult(dq4i(5:8), [dq4i(1) -dq4i(2:4)]);
% pt4f = 2*quat_mult(dq4f(5:8), [dq4f(1) -dq4f(2:4)]);
% vt4f = [pt4f - pt4i];
% 
% quiver3(pt4i(2), pt4i(3), pt4i(4), vt4f(2), vt4f(3), vt4f(4), 0, 'color', 'red')

% ----------------------------------------------------------------------
% TRANSFORMACOES SEGUIDAS CONCATENADAS
% ----------------------------------------------------------------------
% pt0ic = [0 0 0];
% pt0fc = [1 0 0];
% vt0c = pt0fc - pt0ic;
% quiver3(pt0ic(1), pt0ic(2), pt0ic(3), vt0c(1), vt0c(2), vt0c(3), 0);

r1 = [0 0 4];
t1 = [3 0 0];
theta1 = pi/2;
T0d1 = dq_transform(theta1, r1, t1); % transformacao 1
plot_frame(T0d1);

% pt0ic1 = transform_plot2(pt0ic, T0d1);
% pt0fc1 = transform_plot2(pt0fc, T0d1);
% vt0c1 = pt0fc1 - pt0ic1;
% quiver3(pt0ic1(1), pt0ic1(2), pt0ic1(3), vt0c1(1), vt0c1(2), vt0c1(3), 0, 'color', [0 0 0]);

r2 = r1;
t2 = [5 0 0];
theta2 = pi/2;
T1d2 = dq_transform(theta2, r2, t2); % transformacao 2

T0d2 = dual_quat_mult(T0d1, T1d2); % concatena as transformacoes
plot_frame(T0d2);

% pt0ic2 = transform_plot2(pt0ic, T0d2); % transforma o pto com a tranformacao total
% pt0fc2 = transform_plot2(pt0fc, T0d2);
% vt0c2 = pt0fc2 - pt0ic2;
% quiver3( pt0ic2(1),  pt0ic2(2),  pt0ic2(3), vt0c2(1), vt0c2(2), vt0c2(3), 0, 'color','blue')

r3 = r2;
t3 = [7 0 0];
theta3 = pi/2;
T2d3 = dq_transform(theta3, r3, t3); % transformacao 3

T0d3 = dual_quat_mult(T0d2, T2d3); % concatena as transformacoes
plot_frame(T0d3);

% pt0ic3 = transform_plot2(pt0ic, T0d3); % transforma o pto com a tranformacao total
% pt0fc3 = transform_plot2(pt0fc, T0d3);
% vt0c3 = pt0fc3 - pt0ic3;
% quiver3( pt0ic3(1),  pt0ic3(2),  pt0ic3(3), vt0c3(1), vt0c3(2), vt0c3(3), 0, 'color','blue')

