function [ output_args ] = plot_frame_fix( input_args )
%PLOT_FRAME_FIX plota os vetores do sistema de coordenadas fixo

% plota o frame 000
    scatter3(0 ,0 ,0, 160, 'black', 'filled');
    quiver3(0, 0, 0, 1, 0, 0, 0,  'color', 'red', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1); % vetor x
    quiver3(0, 0, 0, 0, 1, 0, 0,  'color', 'green', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1); % vetor y
    quiver3(0, 0, 0, 0, 0, 1, 0,  'color', 'blue', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1); % vetor z


end

