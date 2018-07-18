function TDQ = DH_to_dqTransforms( Denavit_Haterberg_Table )
%DH_TO_DQTRANSFORMS Retorna uma matriz 16x8 com os duais quaternions referentes as transformacoes dos frames
%Consultar a funcao DH_parameters;

DH = Denavit_Haterberg_Table; % 16 linhas por 4 colunas

TDQ = zeros(16, 8);
for i = 1:1:16
    theta = DH(i, 1);
    d = DH(i, 2);
    a = DH(i, 3);
    alpha = DH(i, 4);
    
    h1 = cos(theta/2)*cos(alpha/2);
    h2 = cos(theta/2)*sin(alpha/2);
    h3 = sin(theta/2)*sin(alpha/2);
    h4 = sin(theta/2)*cos(alpha/2);
    p = [h1, h2, h3, h4];
    d = [ -(d*h4 + a*h2)/2 , (-d*h3 + a*h1)/2 , (d*h2 + a*h4)/2 , (d*h1 - a*h3)/2]; 
    TDQ(i,:) = [p d];
end

end

