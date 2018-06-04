function TDQ = DH_to_dqTransforms( Denavit_Haterberg_Table )
%DH_TO_DQTRANSFORMS Retorna uma matriz 8x16 com os duais quaternions referentes as transformacoes dos frames
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


%{
os proximos passos sao:
- fazer essa funcao DH_to_dq que pega a tabela DH e me retorna uma tabela
com todos os duais quaternions de transformacao de todos os frames e
colocar uma opcao para plotar ou nao os frames;

- criar uma funcao que retorna uma tabela das transformacoes inversas em
dual quaternions

- criar uma funcao que retorna 2 transformacoes dual quaterions cada uma
referente a um pe e ao frame fixo

passar tudo isso pro pyton
%}
end

