function  plot_frames( H ,inicio)
%PLOT_FRAMES plota os frames das matrizes de transformacao H(4,4,i), deve
%se criar a figura com o antes de executar essa funcao, comando:

% fig = figure();
% set(gcf, 'Units', 'Normalized', 'OuterPosition', [0 0 1 1]);
% hold on;
% grid on;
% view(-45,45); % ajusta o view do grafico para ficar bom de ver

% para capturar os frames e fazer um video crie um loop e coloque estes 
% comandos antes de chamar a funcao dentro do for:

% clf
% hold on;
% grid on;
% view(-45,45); % ajusta o view do grafico para ficar bom de ver

% este comando depois da funcao e dentro do for:
% F(frame) = getframe(gcf);

% estes comandos depois do loop:

% video = VideoWriter('animacao2.mp4', 'MPEG-4')
% video.FrameRate = 40
% video.Quality = 100
% open(video)
% writeVideo(video, F)
% close(video)

% para descomentar: seleciona e ctrl+T


frame0 = [  1,  0,  0   ;
            0,  1,  0   ;
            0,  0,  1   ;
            1,  1,  1   ];
        
quiver3(0, 0, 0, frame0(1,1), frame0(2,1), frame0(3,1), 0, 'linewidth', 3, 'color', 'r') % frame0 X
quiver3(0, 0, 0, frame0(1,2), frame0(2,2), frame0(3,2), 0, 'linewidth', 3, 'color', 'g') % frame0 Y
quiver3(0, 0, 0, frame0(1,3), frame0(2,3), frame0(3,3), 0, 'linewidth', 3, 'color', 'b') % frame0 Z

matriz_temporarira_para_pegar_a_terceira_dimensao = size(H);
for i = inicio:matriz_temporarira_para_pegar_a_terceira_dimensao(3)-1
    quiver3(H(1,4,i), H(2,4,i), H(3,4,i), H(1,1,i), H(2,1,i), H(3,1,i), 0, 'linewidth', 1, 'color', 'r') % frame1 X
    quiver3(H(1,4,i), H(2,4,i), H(3,4,i), H(1,2,i), H(2,2,i), H(3,2,i), 0, 'linewidth', 1, 'color', 'g') % frame1 X
    quiver3(H(1,4,i), H(2,4,i), H(3,4,i), H(1,3,i), H(2,3,i), H(3,3,i), 0, 'linewidth', 1, 'color', 'b') % frame1 X
end

% plotar o pe
i = matriz_temporarira_para_pegar_a_terceira_dimensao(3);
quiver3(H(1,4,i), H(2,4,i), H(3,4,i), -H(1,2,i), -H(2,2,i), -H(3,2,i), 0, 'linewidth', 4, 'color', [0 0.5 0]); %  fibula do pe
quiver3(H(1,4,i), H(2,4,i), H(3,4,i), H(1,3,i), H(2,3,i), H(3,3,i), 0, 'linewidth', 4, 'color', [0.7 0.7 0]); % dedao do pe

[H(1,4,7), H(2,4,7), H(3,4,7)]
end

