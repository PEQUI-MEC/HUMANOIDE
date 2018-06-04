function  legCineDir( m1, m2, m3, m4, m5, m6, clcfig)
if nargin == 6
    clcfig = true;
end
%LEGCINEDIR calcula a cinematica direta dos angulos passados e plota
% tem de haver uma figura ja pre configurada para melhor visualizacao 
pause(0.01);
if clcfig
    clf;
    hold on;grid on;view(-45,45);axis equal;
end
setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera'); % da zoom na camera, nao na escala
% CINEMATICA DIRETA
% frame[i] posicionado com eixo z no eixo de giro do motor[i+1]
% frame[i] fixo no link[i]
theta = [-90, 90, m1, m2, m3, m4, m5, m6]; % OS ANGULOS DE CADA MOTOR, os 2 primeiros sao fixos
DH_table = [
%alpha,  a,  d,  theta
0,    2,  -1,  theta(1); % fixo, transforma do frame do umbigo p o frame 0
0,    0,   0,  theta(2); % frame0/junta 1/link0, eixo: zcima/xfrente
90,   0,   0,  theta(3)+90 ; % frame1/junta 2/link1, eixo: zfrente/xesquerda
-90,  0,   0,  theta(4)+90 ; % frame2/junta 3/link2, eixo: zdireita/xcima
0,    5,   0,  theta(5)+180; % frame3/junta 4/link3, joelho eixo: zdireita/xbaixo
0,    5,   0,  theta(6)    ; % frame4/junta 5/link4, calcanhar eixo: zdireita/xbaixo
-90,  0,   0,  theta(7)    ; % frame5/junta 6/link5, calcanhar eixo: zfrente/xbaixo
0,    0.5, 0,  theta(8) ];% frame6/link6, ponta do pe

H = H_calc(DH_table);
plot_frames(H, 2);

motor = [ 0      0  0 0 0   0  0; % X cada coluna eh um vetor que representa a posicao de um motor no frame anterior?
       0      0  0 0 0   0  0; % Y
       1.5  -1.5 0 0 0 -0.5 0; % Z
       1      1  1 1 1   1  1]; % contante 1
for k = 1:7
    motor(:,k) = H(:,:,k+1)*motor(:,k);
    if(k<7)
        quiver3(motor(1,k),motor(2,k),motor(3,k), H(1,3,k+1)/2, H(2,3,k+1)/2, H(3,3,k+1)/2,0, 'linewidth', 3, 'color', [1 0.7 0.5]);%[0.8 0.8 0.2]
    end
end
lines = [ 0 motor(1,:) ; % X
          0 motor(2,:) ; % Y
          0 motor(3,:) ]; % Z

plot3(lines(1,:), lines(2,:), lines(3,:),'--o', 'linewidth', 0.1, 'color', [0 0 0], 'MarkerEdgeColor','k', 'MarkerFaceColor',[1 0.7 0.5], 'MarkerSize',7);



end

