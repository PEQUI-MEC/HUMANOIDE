function THETAS = calculaInversa( pe_esq, dedao_esq, fibula_esq, pe_dir, dedao_dir, fibula_dir )
    %CALCULAINVERSA calcula a cinematica inversa, retornando os 12 angulos,
    % recebendo 6 vetores, 3 do pe esquerdo e 3 do pe direito:
    % "pe_esq" "dedao_esq" "fibula_esq";
    % "pe_dir" "dedao_dir" "fibula_dir"
    modulo_coxa = 9.3;
    
%--------------------------------------------------------------------------
%---------------------------PERNA DIREITA----------------------------------
%--------------------------------------------------------------------------
    % Normaliza os vetores para ficarem com modulo 1
    dedao_dir = dedao_dir/norm(dedao_dir)*2;
    fibula_dir = fibula_dir/norm(fibula_dir)*2;
    
    
    % Calcula o eixo de rotacao do motor 11
    m11axis = cross(pe_dir,dedao_dir);
    m11axis = m11axis/norm(m11axis)*2;
    if m11axis(2) > 0
        m11axis = -m11axis;
    end
    
    
    % calcula os vetores da canela e da coxa
    H = frame_z_fixo(-pe_dir, m11axis, 'y');
    y = norm(pe_dir)/2; % calculo do vetor canela referente ao frame temporario
    x = modulo_coxa*sin(acos(y/modulo_coxa));
    %O vetor da canela é transformado de volta para o
    %frame base e invertido o sentido (apontar para baixo)
    canela_dir = -H*[x; y; 0];
    coxa_dir = -canela_dir + pe_dir;
    
    % calcula o vetor de rotacao do motor 8
    m8axis = [-m11axis(2); m11axis(1); 0];
    
    
    % calcula o angulo do motor 12
    H = frame_z_fixo(m11axis, dedao_dir, 'x'); %matriz de rotacao do frame de referencia temporario
    Ht = transpose(H);
    fibula_dirt = Ht*fibula_dir; % fibula com relação ao frame de referencia temporario
    if fibula_dirt(1) < 0
    error('fibula direita alem do limite de angulo');
    end
    m12 = atan2(fibula_dirt(2), fibula_dirt(1))*180/pi;
    
    
    % calcula o angulo do motor 11
    H = frame_z_fixo(-canela_dir, m11axis, 'y');
    Ht = transpose(H);
    dedao_dirt = Ht*dedao_dir;
    m11 = atan2(dedao_dirt(2), dedao_dirt(1))*180/pi;
    
    
    % calcula o angulo do motor 10
    H = frame_z_fixo(coxa_dir, m11axis, 'x');
    Ht = transpose(H);
    canela_dirt = Ht*canela_dir;
    m10 = atan2(canela_dirt(2), canela_dirt(1))*180/pi;
    
    
    % calcula o angulo do motor 9
    H = frame_z_fixo(m8axis, m11axis, 'y'); 
    Ht = transpose(H);
    coxa_dirt = Ht*coxa_dir;
    m9 = atan2(coxa_dirt(2), coxa_dirt(1))*180/pi;
    
    
    % calcula o angulo do motor 8
    H = frame_z_fixo([m11axis(1); m11axis(2); 0], m8axis, 'x');
    Ht = transpose(H);
    m11axist = Ht*m11axis;
    m8 = atan2(m11axist(2), m11axist(1))*180/pi;
    
    
    % calcula o angulo do motor 7
    m7 = -atan2(m8axis(2), m8axis(1))*180/pi;
    
    
%--------------------------------------------------------------------------
%---------------------------PERNA ESQUERDA---------------------------------
%--------------------------------------------------------------------------
    % Normaliza os vetores para ficarem com modulo 1
    dedao_esq = dedao_esq/norm(dedao_esq)*2;
    fibula_esq = fibula_esq/norm(fibula_esq)*2;
    
    
    % Calcula o eixo de rotacao do motor 5
    m5axis = cross(dedao_esq, pe_esq);
    m5axis = m5axis/norm(m5axis)*2;
    if m5axis(2) < 0
        m5axis = -m5axis;
    end
    
    
    % calcula os vetores da canela e da coxa
    H = frame_z_fixo(-pe_esq, m5axis, 'y');
    y = norm(pe_esq)/2; % calculo do vetor canela referente ao frame temporario
    x = -modulo_coxa*sin(acos(y/modulo_coxa));
    %O vetor da canela é transformado de volta para o
    %frame base (apontando para baixo)
    canela_esq = -H*[x; y; 0]; 
    coxa_esq = -canela_esq + pe_esq;
    
    
    % calcula o vetor de rotacao do motor 2
    m2axis = [m5axis(2); -m5axis(1); 0];
    
    
    % calcula o angulo do motor 6
    H = frame_z_fixo(m5axis, dedao_esq, 'x'); %matriz de rotacao do frame de referencia temporario
    Ht = transpose(H);
    fibula_esqt = Ht*fibula_esq; % fibula com relação ao frame de referencia temporario
    if fibula_esqt(1) < 0
    error('fibula esquerda alem do limite de angulo');
    end
    m6 = atan2(fibula_esqt(2), fibula_esqt(1))*180/pi;
    
    
    % calcula o angulo do motor 5
    H = frame_z_fixo(-canela_esq, m5axis, 'y');
    Ht = transpose(H);
    dedao_esqt = Ht*(-dedao_esq);
    m5 = atan2(dedao_esqt(2), dedao_esqt(1))*180/pi;
    
    
    % calcula o angulo do motor 4
    H = frame_z_fixo(coxa_esq, m5axis, 'x');
    Ht = transpose(H);
    canela_esqt = Ht*canela_esq;
    m4 = atan2(canela_esqt(2), canela_esqt(1))*180/pi;
    
    
    % calcula o angulo do motor 3
    H = frame_z_fixo(-m2axis, m5axis, 'y'); 
    Ht = transpose(H);
    coxa_esqt = Ht*coxa_esq;
    m3 = atan2(coxa_esqt(2), coxa_esqt(1))*180/pi;
    
    
    % calcula o angulo do motor 2
    H = frame_z_fixo([m5axis(1); m5axis(2); 0], m2axis, 'x');
    Ht = transpose(H);
    m5axist = Ht*m5axis;
    m2 = atan2(m5axist(2), m5axist(1))*180/pi;
    
    
    % calcula o angulo do motor 7
    m1 = -atan2(m2axis(2), m2axis(1))*180/pi;

    
    
    
    THETAS = [m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12];
    %THETAS = [0, 0, -45, 45, 0, 0, m7, m8, m9, m10, m11, m12];
end

