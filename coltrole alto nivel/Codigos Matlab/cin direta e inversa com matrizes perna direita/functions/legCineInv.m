function [ m1,m2,m3,m4,m5,m6 ] = legCineInv( pe, dedao, fibula, flag_plots_3d, trajeto)
% LEGCINEINV Calcula a cinematica inversa da perna direita;

% ARGUMENTOS:
% pe: vetor de dimensão 3x1 que indica a posição do calcanhar;
% dedao: vetor de dimensão 3x1 que indica a direção do dedão;
% fibula: vetor de dimensão 3x1 que indica a direção da lateral externa do
% pe;

% RETORNO:
% Vetor de 6 ângulos em graus sendo os ângulos dos motores da perna direita

    if nargin == 3
        flag_plots_3d = false;
        trajeto = [0;0;0];
    end
    
%--------------------------------------------------------------------------
%-----------------------calculo angulos v0.4-------------------------------
%--------------------------------------------------------------------------
    dedao = dedao/norm(dedao)*2;
    fibula = fibula/norm(fibula)*2;
    
    % Calcula um vetor que é equivalente ao eixo de rotacao do motor 5
    % garanto que a lateral extena do meu pe esteja sempre pro lado externo (direito)
    m5axis = cross(pe,dedao);
    m5axis = m5axis/norm(m5axis)*2;
    if m5axis(2) > 0
    m5axis = -m5axis;
    end
    
    % para calcular o angulo do motor m6 utilizando a funcao atan2 eu
    % preciso transformar o vetor "fibula" de modo que a coordenada z dele
    % seja 0, ou seja, o angulo de rotacao do motor 6 seja dado
    % inteiramente pelas coordenadas x e y do vetor "fibula", para isso eu
    % calculo um frame de referencia temporario que é similar ao frame 5, 
    % com a diferenca do eixo x;
    % O frame de referencia cujos eixos são:
    % z: o eixo de rotacao do motor 6 (equivale ao vetor "dedao")
    % x: equivale ao vetor de rotacao do motor 5 (normal ao triangulo da
    % perna)
    H = frvZ(m5axis, dedao, 'x'); %matriz de rotacao do frame de referencia temporario
    Ht = transpose(H);
    fibulat = Ht*fibula; % fibula com relação ao frame de referencia temporario
    if fibulat(1) < 0
    error('fibula alem do limite de angulo');
    end
    m6 = atan2(fibulat(2), fibulat(1))*180/pi; % <<<<<<<<<<<<<<<<<<<<<< calculo m6 (angulo do motor 6)

    % Para calcular o angulo do motor 5 eu preciso saber primeiro como esta
    % a canela do robo, pois a posicao da canela (que vem antes do motor 5
    % na cadeia cinematica) interfere na rotacao do motor 5, para encontrar
    % a canela primeiramente é calculado a posicao do joelho, para isso
    % sabemos o tamanho (modulo) da canela e da coxa e tambem que o joelho
    % é um ponto que esta no plano formado pelos vetores "pe" e "dedao",
    % logo para calcular o ponto do joelho (vetor coxa) e o vetor "canela"
    % utilizamos um frame de referencia temporario cujo eixo y equivale a
    % "-pe" e o eixo z equivale ao eixo "m5axis", dessa forma o vetor
    % "canela" com relacao a esse frame tera a componente z = 0;
    % uma observacao importante neste ponto é que a posicao do joelho é
    % calculada de forma que o triangulo da perna aponta sempre "para
    % frente", ou seja, o joelho sempre vai dobrar para frente
    H = frvZ(-pe, m5axis, 'y');
    y = norm(pe)/2; % calculo do vetor canela referente ao frame temporario
    x = 5*sin(acos(y/5));
    %O vetor da canela é transformado de volta para o
    %frame base e invertido o sentido (apontar para baixo)
    canela = -H*[x; y; 0];
    coxa = -canela + pe;

    
    % Para calcular o angulo do motor 5 eu preciso transformar o
    % vetor "dedao" de modo que a coordenada z dele seja 0, ou seja, o
    % angulo de rotacao do motor 5 seja dado inteiramente pelas coordenadas
    % x e y do vetor "dedao", para isso eu calculo um frame de referencia
    % temporario que é similar ao frame 4 e fica da seguinte forma:
    % z: o eixo de rotacao do motor 5 ( normal ao triangulo da perna)
    % y: equivale ao vetor inverso da canela, ou seja, "-canela"
    % utilizando o x e y do dedao nesse frame calcula o angulo do motor 5
    H = frvZ(-canela, m5axis, 'y');
    Ht = transpose(H);
    dedaot = Ht*dedao;
    m5 = atan2(dedaot(2), dedaot(1))*180/pi; % <<<<<<<<<<<<<<<<<<<<<< calculo m5 (angulo do motor 5)
    
    
    % Para calcular o angulo do motor 4 (do joelho) eu preciso do vetor
    % "canela" transformado de tal forma que o z = 0, assim o angulo sera
    % dado inteiramente pelas coordenadas x e y do vetor "canela", para
    % isso eu utilizo um frame de referencia temporario que equivaleria ao
    % frame 3 da seguinte forma:
    % eixo z: eixo de rotacao do motor 4 que equivale aos eixos do motor 5
    % e motor 3, todos perpendiculares ao triangulo da perna
    % eixo x: equivale ao vetor "coxa"
    % uma observacao importante nesse ponto é que o angulo deste motor é
    % sempre negativo, garantindo que o joelho sempre dobre para frente (o
    % eixo de giro do motor esta apontando para fora, lembre-se da regra da
    % mao direita)
    H = frvZ(coxa, m5axis, 'x');
    Ht = transpose(H);
    canelat = Ht*canela;
    m4 = atan2(canelat(2), canelat(1))*180/pi; % <<<<<<<<<<<<<<<<<<<<<< calculo m4

    
    % Para calcular o angulo do motor 3 é necessario transformar o vetor
    % "coxa" de forma que o angulo seja dado inteiramente pelos componentes
    % x e y dele, ou seja, que o z da "coxa" seja 0, para isso precisamos
    % pensar em um frame que o eixo z seja normal ao triangulo da perna, ou
    % seja, equivalha ao eixo "m5axis", e o eixo y seja equivalente ao eixo
    % de rotacao do motor 2, mas a essa altura nao temos o eixo de rotacao
    % do motor 2, porem notamos que esse eixo tambem é dado pela intersecao
    % do plano que contem o triangulo da perna e o plano xy base, ou ainda
    % a rotacao em 90 graus em relacao ao eixo z base da projecao do vetor 
    % "m5axis" no plano xy base;
    m2axis = [-m5axis(2); m5axis(1); 0];
    H = frvZ(m2axis, m5axis, 'y'); % muita atencao aqui
    Ht = transpose(H);
    coxat = Ht*coxa;
    m3 = atan2(coxat(2), coxat(1))*180/pi; % <<<<<<<<<<<<<<<<<<<<<< calculo m3

    
    % para calcular o angulo do motor 2 é utilizado o vetor "m5axis"
    % transformandoo de tal forma que zere sua coordenada z, para isso o
    % frame de referencia tempirario é escolhido da seguinte forma:
    % z: é o vetor "m2axis" calculado anteriormente
    % x: é a projecao do vetor "m5axis" no plano xy base
    H = frvZ([m5axis(1); m5axis(2); 0], m2axis, 'x'); % muita atencao aqui
    Ht = transpose(H);
    m5axist = Ht*m5axis;
    m2 = atan2(m5axist(2), m5axist(1))*180/pi; % <<<<<<<<<<<<<<<<<<<<<< calculo m2
    
    % se voce leu tudo ate aqui, dispensa explicacoes
    m1 = atan2(m2axis(2), m2axis(1))*180/pi;
    
    if flag_plots_3d == true
        subplot(1,2,1);
        hold on;grid on;axis equal;view(-45,45);
        % plota os vetores coxa (amarelo) e canela (rosa) calculados na cinematica inversa
        quiver3(0, 0, 0, coxa(1), coxa(2), coxa(3), 0,'linewidth', 3, 'color', [0.858, 0.858, 0.058]);
        quiver3(coxa(1), coxa(2), coxa(3), canela(1), canela(2), canela(3),0 ,'linewidth', 3, 'color', 'm');

        %plota o vetor pé (preto), o vetor dedão (vermelho), o vetor fibula
        %(verde) e vetor de rotação do motor 5 (azul claro);
        quiver3(0, 0, 0, pe(1), pe(2), pe(3), 0,'linewidth', 1, 'color', [0, 0, 0,]);
        quiver3(pe(1), pe(2), pe(3), dedao(1), dedao(2), dedao(3), 0,'linewidth', 1, 'color', 'r');
        quiver3(pe(1), pe(2), pe(3), fibula(1), fibula(2), fibula(3), 0,'linewidth', 1, 'color', 'g');
        quiver3(pe(1), pe(2), pe(3), m5axis(1), m5axis(2), m5axis(3), 0,'linewidth', 1, 'color', [0, 1, 0.992]); 
        l = legend('Coxa.', 'Canela.', 'Pe.', 'Dedao.', 'Fibula.', 'Eixo motor 5');
        l.Interpreter = 'Latex';
        title('Cinematica Inversa.', 'Interpreter', 'Latex');
        line(trajeto(1,:), trajeto(2,:), trajeto(3,:));
        setAxes3DPanAndZoomStyle(zoom(gca),gca,'camera');
        zoom(1.5);
        hold off;
    end
end

