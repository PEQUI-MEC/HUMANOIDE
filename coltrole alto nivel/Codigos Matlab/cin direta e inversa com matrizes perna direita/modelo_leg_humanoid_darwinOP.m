addpath('functions')
close all; clear; clc;figure('units','normalized','outerposition',[0 0 1 1]);
% 3 motores no quadril, perpendiculares entre si e interceptando mesmo pto;
% 1 motor no joelho, paralelo ao eixo do quadril;
% 2 motores no pe, perpendiculares e ambos paralelos ao quadril e ao joelho;

% m1: frame0/junta 1/link0, eixo: zcima/xfrente
% m2: frame1/junta 2/link1, eixo: zfrente/xesquerda
% m3: frame2/junta 3/link2, eixo: zdireita/xcima
% m4: frame3/junta 4/link3, joelho eixo: zdireita/xbaixo
% m5: frame4/junta 5/link4, calcanhar eixo: zdireita/xbaixo
% m6: frame5/junta 6/link5, calcanhar eixo: zfrente/xbaixo


    
x = -5:0.5:5;
z = gaussmf(x,[2 0])*3-7;
y = 3:-0.3:-3;
trajeto = [x+1; y+1; z+1];

% configura o video
video = VideoWriter('perna_teste.mp4', 'MPEG-4');
video.FrameRate = 7;
video.Quality = 100;
open(video);

for i = 1:1:length(x);
    clf;
    
% 1) qual o ponto do meu pe?
    %pe = trajeto(:,t);
    %pe = [x(i); y(i); z(i)];
    pe = [trajeto(1,i); trajeto(2, i); trajeto(3,i)]; % ponto do meu pe direito
    
 % 2) quais os 2 vetores que descrevem a direcao do meu pe?
    dedao = [1; 0; 0]; % vetor que aponta pra diretao que o "dedao" aponta (equivale ao eixo de rotacao do motor 6)
    fibula = [0; -1; 0]; % inclinacao do plano do pe com a lateral (pe direito)
    
    
    % calcula a cinematica inversa, retorna os angulos e plota
    [m1,m2,m3,m4,m5,m6] = legCineInv(pe, dedao, fibula, true, trajeto);
    

    legCineDir(m1,m2,m3,m4,m5,m6, true); % calcula a cinematica direta e plota
    
    writeVideo(video, getframe(gcf));
end
close(video)
