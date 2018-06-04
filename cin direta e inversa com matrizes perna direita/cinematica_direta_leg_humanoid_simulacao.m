close all; clear; clc;
addpath('functions');
figure();
hold on;
grid on;
view(-45,45); % ajusta o view do grafico para ficar bom de ver
axis equal;

frame = 0;
for i = 0:10:70
    frame = frame + 1;
    pause(0.1);
theta = [i,  0,  0, 0]; % OS ANGULOS DE CADA MOTOR
DH_table = [
%alpha,  a,  d,  theta
90,    0,  -2,  theta(1)    ;
0,     4,  2,  theta(2)-90 ;
0,     4,  0,  theta(3)    ;
0,      2, 0, theta(4)];


H = H_calc(DH_table);
lines = [ 0, 0, 0;
          0, 0, -2;
          0, -2, -2;
          H(1,4,2), H(2,4,2), H(3,4,2);
          H(1,4,3), H(2,4,3), H(3,4,3);
          H(1,4,4), H(2,4,4), H(3,4,4)];
clf;
hold on;
grid on;
% if and(i < 45,i < 90)
    view(-45,45); % ajusta o view do grafico para ficar bom de ver
% else
%     if i < 75
%          view(i-30-45,45-i+30); % ajusta o view do grafico para ficar bom de ver
%     else 
%         view(3,3); % ajusta o view do grafico para ficar bom de ver
%     end
% end
axis equal;
plot3(lines(:,1), lines(:,2), lines(:,3), 'linewidth', 3, 'color', [0 0 0]);

plot_frames(H, 1);
F(frame) = getframe(gcf);

end

% video = VideoWriter('perna.mp4', 'MPEG-4');
% video.FrameRate = 20;
% video.Quality = 100;
% open(video)
% writeVideo(video, F)
% close(video)
