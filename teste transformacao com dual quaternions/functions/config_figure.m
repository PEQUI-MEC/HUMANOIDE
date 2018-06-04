function config_figure()
    %CONFIG_FIGURE Funcao que cria uma janela para plotagem e a configura

    clc; clear; close all;
    figure();
    hold on;
    grid on;
    view(-45,45); % ajusta o view do grafico para ficar bom de ver
    axis equal;
    setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera'); % da zoom na camera, nao na escala
    
    scatter3(0 ,0 ,0, 160, 'black', 'filled');
    quiver3(0, 0, 0, 1, 0, 0, 0,  'color', 'red', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
    quiver3(0, 0, 0, 0, 1, 0, 0,  'color', 'green', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
    quiver3(0, 0, 0, 0, 0, 1, 0,  'color', 'blue', 'lineWidth', 3, 'lineStyle', '-', 'maxHeadSize', 1);
end

