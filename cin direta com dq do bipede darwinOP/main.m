addpath('functions');
%config_figure();
close all; clear; clc;figure();
t1 = 0;
t2 = 0;
t3 = 0;
t4 = 0;
t5 = 0;
t6 = 0;
t7 = 0;
t8 = 0;
t9 = pi/4;
t10 = -pi/4;
t11 = 0;
t12 = 0;

% video = VideoWriter('cin_direta_com_dq_do_bipede darwinOP.mp4', 'MPEG-4');
% video.FrameRate = 7;
% video.Quality = 100;
% open(video)

for i = 1:3:1
    clf;
    hold on;grid on;axis equal;view(-45,45);
    
    % plota o frame 000
    scatter3(0 ,0 ,0, 160, 'black', 'filled');
    quiver3(0, 0, 0, 1, 0, 0, 0,  'color', 'red', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
    quiver3(0, 0, 0, 0, 1, 0, 0,  'color', 'green', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
    quiver3(0, 0, 0, 0, 0, 1, 0,  'color', 'blue', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
    
    t9 = i*pi/180; % angulo do motor 3 da perna direita
    t10 = -i*pi/180; % angulo do motor 4 (joelho) da perna esquerda

    DH = DH_parameters([t1 t2 t3 t4 t5 t6 t7 t8 t9 t10 t11 t12]);
    TDQ = DH_to_dqTransforms(DH);
%     plot_frames_chain(TDQ);
%     frame = getframe(gcf);
%     writeVideo(video, frame)
end
% close(video)

%{
%isso fica antes do loop
video = VideoWriter('cin_direta_com_dq_do_bipede darwinOP.mp4', 'MPEG-4');
video.FrameRate = 7;
video.Quality = 100;
open(video)
%}
%{
%isso fica na ultima linha dentro do loop
frame = getframe(gcf);
writeVideo(video, frame)
%}
%{
%isso fica fora do loop
close(video)
%}


%{
%testando a primeira transformacao
t1 = dq_transform(90, [0 0 1], [0 0 0]);
t2 = dq_transform(0, [0 0 1], [0 0 -4]);
t3 = dq_transform(0, [0 0 1], [3 0 0]);
t4 = dq_transform(180, [1 0 0], [0 0 0]);
t = dual_quat_mult(t1, t2);
t = dual_quat_mult(t, t3);
t = dual_quat_mult(t, t4)
%}

%{
%testando a segunda transformacao
t = dq_transform(-pi/2, [1 0 0], [0 0 0])
%}
