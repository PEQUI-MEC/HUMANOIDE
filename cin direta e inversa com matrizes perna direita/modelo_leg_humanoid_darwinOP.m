addpath('functions')
close all; clear; clc;figure();
% 3 motores no quadril, perpendiculares entre si e interceptando mesmo pto;
% 1 motor no joelho, paralelo ao eixo do quadril;
% 2 motores no pe, perpendiculares e ambos paralelos ao quadril e ao joelho;

% m1: frame0/junta 1/link0, eixo: zcima/xfrente
% m2: frame1/junta 2/link1, eixo: zfrente/xesquerda
% m3: frame2/junta 3/link2, eixo: zdireita/xcima
% m4: frame3/junta 4/link3, joelho eixo: zdireita/xbaixo
% m5: frame4/junta 5/link4, calcanhar eixo: zdireita/xbaixo
% m6: frame5/junta 6/link5, calcanhar eixo: zfrente/xbaixo


%--------------------------------------------------------------------------
%-----------------------calculo angulos v0.4-------------------------------
%--------------------------------------------------------------------------
x = -5:0.5:5;
z = gaussmf(x,[2 0])*3-7;
y = 3:-0.3:-3;
trajeto = [x+1; y+1; z+1];



[m, n] = size(x);
for t = 1:3
%     pause(0.01);
    clf;
    hold on;grid on;axis equal;view(-45,45);

    % 1) qual o ponto do meu pe?
    pe = trajeto(:,t);
    %pe = [trajeto(1,t); trajeto(2, t); trajeto(3,t)]; % ponto do meu pe direito
    % 2) quais os 2 vetores que descrevem a direcao do meu pe?
    dedao = [1; 0; 0]; % vetor que aponta pra diretao que o "dedao" aponta
    fibula = [0; -1; 0]; % inclinacao do plano do pe com a lateral (pe direito)
    dedao = dedao/norm(dedao)*2;
    fibula = fibula/norm(fibula)*2;

    % eixo de rotacao do m5 (onde fica o frame 4 do link da canela)
    % garanto que a lateral extena do meu pe esteja sempre pro lado externo (direito)
    m5axis = cross(pe,dedao);
    m5axis = m5axis/norm(m5axis)*2;
    if m5axis(2) > 0
    m5axis = -m5axis;
    end

    % calculo um frame de orientacao que equivale ao frame 5 (m6) e
    % orienta o eixo m5 de forma a apontar sempre para direita do robo
    % utilizando o x e y da fibula nesse frame calcula o m6
    H = frvZ(m5axis, dedao, 'x');
    Ht = transpose(H);
    fibulat = Ht*fibula;
    if fibulat(1) < 0
    error('fibula alem do limite de angulo');
    end
    m6 = atan2(fibulat(2), fibulat(1))*180/pi % <<<<<<<<<<<<<<<<<<<<<< calculo m6
    fibulat(3) = 0;
    fibula = H*fibulat;

    % ponto do joelho (coxa) para fazer a translacao da analise, considerando o angulo
    % do joelho sempre negativo de forma que o movimento se asemelhe de um
    % humano e resolva a redundancia da solucao, pois o eixo de rotacao do m5,
    % m4 e m3 sao paralelos
    H = frvZ(-pe, m5axis, 'y');
    y = norm(pe)/2;
    x = 5*sin(acos(y/5));
    coxa = H*[x; y; 0] + pe;
    canela = pe - coxa;

    % utilizando o x e y do dedao nesse frame calcula o m5
    H = frvZ(-canela, m5axis, 'y');
    Ht = transpose(H);
    dedaot = Ht*dedao;
    m5 = atan2(dedaot(2), dedaot(1))*180/pi % <<<<<<<<<<<<<<<<<<<<<< calculo m5

    % frame de orientacao que equivale ao frame 3 (m4)
    % o angulo eh negativo
    H = frvZ(coxa, m5axis, 'x');
    Ht = transpose(H);
    canelat = Ht*canela;
    m4 = atan2(canelat(2), canelat(1))*180/pi % <<<<<<<<<<<<<<<<<<<<<< calculo m4

    % frame de orientacao que equivale ao frame 2 (m3), o eixo y equivale ao
    % eixo de rotacao do m2
    H = frvZ([-m5axis(2); m5axis(1); 0], m5axis, 'y'); % muita atencao aqui
    Ht = transpose(H);
    coxat = Ht*coxa;
    m3 = atan2(coxat(2), coxat(1))*180/pi % <<<<<<<<<<<<<<<<<<<<<< calculo m3

    % frame de orientacao que equivale ao frame 1 (m2)
    % eixo de rotacao do m2
    H = frvZ([m5axis(1); m5axis(2); 0], H(:,2), 'x'); % muita atencao aqui
    Ht = transpose(H);
    m5axist = Ht*m5axis;
    m2 = atan2(m5axist(2), m5axist(1))*180/pi % <<<<<<<<<<<<<<<<<<<<<< calculo m3

    m1 = atan2(m5axis(1), -m5axis(2))*180/pi

    quiver3(0,0,0, H(1,1), H(2,1), H(3,1), 0,  'linewidth', 1, 'color', 'r');
    quiver3(0,0,0, H(1,2), H(2,2), H(3,2), 0,  'linewidth', 1, 'color', 'g');
    quiver3(0,0,0, H(1,3), H(2,3), H(3,3), 0,  'linewidth', 1, 'color', 'b');


    quiver3(0, 0, 0, coxa(1), coxa(2), coxa(3), 0,'linewidth', 3, 'color', 'b');
    quiver3(coxa(1), coxa(2), coxa(3), canela(1), canela(2), canela(3),0 ,'linewidth', 3, 'color', 'm');

    quiver3(0, 0, 0, pe(1), pe(2), pe(3), 0,'linewidth', 1, 'color', 'b');
    quiver3(pe(1), pe(2), pe(3), dedao(1), dedao(2), dedao(3), 0,'linewidth', 1, 'color', [0.7 0.7 0]);
    quiver3(pe(1), pe(2), pe(3), fibula(1), fibula(2), fibula(3), 0,'linewidth', 1, 'color', [0 0.5 0]);
    quiver3(pe(1), pe(2), pe(3), m5axis(1), m5axis(2), m5axis(3), 0,'linewidth', 1, 'color', [0 0 0]); % axis


    legCineDir(m1,m2,m3,m4,m5,m6, false);
    pe+[0; -2; -1]
    line(trajeto(1,:), trajeto(2,:), trajeto(3,:));
    frames(t) = getframe(gcf);
end
frames = [frames fliplr(frames) frames fliplr(frames)];
video = VideoWriter('perna_teste.mp4', 'MPEG-4');
video.FrameRate = 7;
video.Quality = 100;
open(video)
writeVideo(video, frames)
close(video)

%--------------------------------------------------------------------------
%-----------------------teste funcao frvZ-------------------------------
%--------------------------------------------------------------------------

% for t = -2:1:2
%     pause(1);
%     clf;hold on;grid on;axis equal;view(-45,45);
%     y = [-2; 2; 2];
%     z = [t; 1; 2];
%     quiver3(0,0,0,y(1), y(2), y(3),0, 'linewidth', 1, 'color', 'r');
%     quiver3(0,0,0,z(1), z(2), z(3),0, 'linewidth', 1, 'color', 'b');
%     H = frvZ(y,z, 'x');
%     quiver3(0,0,0, H(1,1), H(2,1), H(3,1), 0,  'linewidth', 3, 'color', 'r');
%     quiver3(0,0,0, H(1,2), H(2,2), H(3,2), 0,  'linewidth', 3, 'color', 'g');
%     quiver3(0,0,0, H(1,3), H(2,3), H(3,3), 0,  'linewidth', 3, 'color', 'b');
% end


%--------------------------------------------------------------------------
%----------------------Cinematica Direta da perna--------------------------
%--------------------------------------------------------------------------
% for t = 0:10:60
%   legCineDir(0,0,t,-t,0,0);
% end;
% 
% for t = 0:10:60
%   legCineDir(0,t,60,-60,0,0);
% end;
% 
% for t = 0:10:60
%   legCineDir(t,60,80,-80,0,0);
% end;
