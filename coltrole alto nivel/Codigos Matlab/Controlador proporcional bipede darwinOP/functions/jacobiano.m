function [Je, Jd] = jacobiano(thetas_pto_da_derivada_1x12)
	% calcula o jacobiano das tranfoesmacoes em dual quaternions da perna 
    % direita e esquerda via derivadas numericas em um dado ponto,
    % representado pelo vetor de 12 angulos, ou seja, as variaveis,
    % sendo 6 angulos da perna esquerda e 6 da perna direita;
    
    % Os vetores duais quaternions sao as funcoes, ou seja, cada dual
    % quaternion tem 8 funcoes, cada uma em funcao das 6 respectivas
    % variaveis da sua perna:
    % F(X) = [ F1(X), F2(X), ..., F8(X) ]
    % X = [ x1, x2, ..., x6 ]
    % eh calculado 2 jacobianos, 1 para cada perna, sendo matrizes 8x6
    
	delta_theta = 10e-6;
	thetai = thetas_pto_da_derivada_1x12;
    
    % vetor pto inicial para a derivada
	DHi = DH_parameters(thetai); 
    TDQi = DH_to_dqTransforms(DHi);
    [dq_esq_i, dq_dir_i] = dq_transf_resultante(TDQi);
    
    Je = zeros(8,6);
    Jd = zeros(8,6);
    
    % calcula as 16 derivadas (8 da perna esquerda e 8 da direita) em
    % funcao de cada um dos 12 thetas (6 da perna esquerda e 6 da perna
    % direita
    for i = 1:6
        thetaf = thetai;
        thetaf(i) = thetaf(i) + delta_theta; % 1 a 6 perna esquerda
        thetaf(i+6) = thetaf(i+6) + delta_theta; % 7 a 12 perna direita
        
        DHf = DH_parameters(thetaf);
        TDQf = DH_to_dqTransforms(DHf);
        [dq_esq_f, dq_dir_f] = dq_transf_resultante(TDQf);
        delta_dq_esq = dq_esq_f - dq_esq_i;
        delta_dq_dir = dq_dir_f - dq_dir_i;
        
        Je(:,i) = delta_dq_esq./delta_theta;
        Jd(:,i) = delta_dq_dir./delta_theta;
    end
end
