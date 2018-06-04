addpath('functions')
config_figure(); %configura o grafico para plotagem


r1 = [0 0 4];
t1 = [3 0 0];
theta1 = pi/2;
T0d1 = dq_transform(theta1, r1, t1); % transformacao 1
plot_frame(T0d1);
pto = [0 3 4];
pto2 = transform_plot(pto, T0d1, 0, 0);
T1d0 = reverse_dq_transform(T0d1);
transform_plot(pto2, T1d0, 1, 1);
r2 = r1;
t2 = [5 0 0];
theta2 = pi/2;
T1d2 = dq_transform(theta2, r2, t2); % transformacao 2

T0d2 = dual_quat_mult(T0d1, T1d2); % concatena as transformacoes
plot_frame(T0d2);


r3 = r2;
t3 = [7 0 0];
theta3 = pi/2;
T2d3 = dq_transform(theta3, r3, t3); % transformacao 3

T0d3 = dual_quat_mult(T0d2, T2d3); % concatena as transformacoes
plot_frame(T0d3);

