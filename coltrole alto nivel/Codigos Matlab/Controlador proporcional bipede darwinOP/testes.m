%% configuracao
addpath('functions', 'functions\Dual Quaternion', 'functions\Quaternion');
addpath('functions\Plots', 'functions\Inversa', 'functions\Direta');

close all; clear; clc;%figure('units','normalized','outerposition',[0 0 1 1]);
teste_controlador = true; % variável que controla o que será executado

%% Gerar trajeto dos pes
if( teste_controlador )
    [trajeto_pe_esq, trajeto_pe_dir ] = gera_ptos_pes(0);
else
    [trajeto_pe_esq, trajeto_pe_dir ] = gera_ptos_pes(1);
end

%% calculo do theta do primeiro ponto
dedao_dir = [1; 0; 0];
fibula_dir = [0; -1; 0];
dedao_esq = [1; 0; 0];
fibula_esq = [0; 1; 0];
pe_dir = trajeto_pe_dir(:,1);
pe_esq = trajeto_pe_esq(:,1);
THETAS = calculaInversa(pe_esq, dedao_esq, fibula_esq, pe_dir, dedao_dir, fibula_dir)*pi/180;

%% Configuracao de gravacao de video
if( ~teste_controlador )
video = VideoWriter('cin_direta_com_dq_do_bipede darwinOP.mp4', 'MPEG-4');
video.FrameRate = 7;
video.Quality = 100;
open(video)
end
%% Loop da execucao da caminhada
f = length(trajeto_pe_dir(1,:));

ptos_ref_esq = zeros([3 f-1]);
ptos_ref_dir = zeros([3 f-1]);

ptos_esq = zeros([3 f-1]);
ptos_dir = zeros([3 f-1]);
for i = 1:1:f-1
    if( ~teste_controlador )
        clf;
        hold on;grid on;axis equal;view(-45,45);
    end
    
    % ----------------------- CONTROLADOR
    dq_pe_esq = xyz2dual_quat(trajeto_pe_esq(:,i)' + [0 3.7 -5.35] );
    dq_pe_dir = xyz2dual_quat(trajeto_pe_dir(:,i)' + [0 -3.7 -5.35] ); % os ptos do pe sao vetores coluna [x; y; z]
    dq_pe_esq_futuro = xyz2dual_quat(trajeto_pe_esq(:,i+1)' + [0 3.7 -5.35]);
    dq_pe_dir_futuro = xyz2dual_quat(trajeto_pe_dir(:,i+1)' + [0 -3.7 -5.35]); % os ptos do pe sao vetores coluna [x; y; z]
    if ( teste_controlador )
        THETAS = controlador(THETAS, dq_pe_esq, dq_pe_dir, dq_pe_esq_futuro, dq_pe_dir_futuro);
    end
    
    
    % ----------------------- CIN INVERSA
    pe_dir = trajeto_pe_dir(:,i);
    pe_esq = trajeto_pe_esq(:,i);
    if ( ~teste_controlador )
        THETAS = calculaInversa(pe_esq, dedao_esq, fibula_esq, pe_dir, dedao_dir, fibula_dir)*pi/180;
    end
    
    % ----------------------- CIN DIRETA
    DH = DH_parameters(THETAS);    % tabela denavit hartenberg
    TDQ = DH_to_dqTransforms(DH);    % tabela transformacoes dual quaternions
    [h_real_esq, h_real_dir] = dq_transf_resultante(TDQ);
    
    % coleta dos pontos resultantes do pe
    ptos_esq(:,i) = dual_quat_to_xyz(h_real_esq);
    ptos_dir(:,i) = dual_quat_to_xyz(h_real_dir);
    ptos_ref_esq(:,i) = pe_esq' + [0 3.7 -5.35];
    ptos_ref_dir(:,i) = pe_dir' + [0 -3.7 -5.35];
    
    ptos_esq(2,i) = round(ptos_esq(2,i),3);
    ptos_dir(2,i) = round(ptos_dir(2,i),3);
    
    if ( ~teste_controlador )
         plot_frame_fix();    % plota o frame fixo (000) do grafico do matlab
        % plota os frames de toda a cadeia cinematica
         plot_frames_chain(TDQ);

        % plota as linhas das trajetorias de cada pe
        line(trajeto_pe_dir(1,:), trajeto_pe_dir(2,:)-3.7, trajeto_pe_dir(3,:)-5.35);
        line(trajeto_pe_esq(1,:), trajeto_pe_esq(2,:)+3.7, trajeto_pe_esq(3,:)-5.35, 'color', 'r');

        % salva o frame no video
        frame = getframe(gcf);
        writeVideo(video, frame);
    end
end
if ( ~teste_controlador )
    close(video)
else
    figure();
    subplot(2,3,1);
    plot((1:f-1), ptos_esq(1,:),(1:f-1),ptos_ref_esq(1,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('x (cm)', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');
    subplot(2,3,2);
    plot((1:f-1), ptos_esq(2,:),(1:f-1),ptos_ref_esq(2,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('y (cm)', 'Interpreter', 'latex');
    title('Vetor de translacao esquerda', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');
    subplot(2,3,3);
    plot((1:f-1), ptos_esq(3,:),(1:f-1),ptos_ref_esq(3,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('z (cm)', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');

    subplot(2,3,4);
    plot((1:f-1), ptos_dir(1,:),(1:f-1),ptos_ref_dir(1,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('x (cm)', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');
    subplot(2,3,5);
    plot((1:f-1), ptos_dir(2,:),(1:f-1),ptos_ref_dir(2,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('y (cm)', 'Interpreter', 'latex');
    title('Vetor de translacao direita', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');
    subplot(2,3,6);
    plot((1:f-1), ptos_dir(3,:),(1:f-1),ptos_ref_dir(3,:));
    grid on;
    xlabel('Iteracao', 'Interpreter', 'latex');
    ylabel('z (cm)', 'Interpreter', 'latex');
    l = legend('real', 'teorico');
    set(l, 'interpreter', 'latex');
end