%-----------------------------------------------------------
%Método para retornar a trajetória do centro de massa
%completa para 2 MS
%Parâmetros:
%Retorno:
%PA - posição do pé A referente ao segundo passo
%PB - posição do pé B referente ao primeiro passo
%trajCoM - trajetória para 2 MS
%-----------------------------------------------------------     
function [PA,PB,trajCoM] = trajetoria2MS(U,X)
%-----------------------------------------------------------
%Obter a trajetória dado a condição inicial e as variáveis de controle
%-----------------------------------------------------------     
    [pa,pb,pc,CoM] = trajetoria(U,X);
%-----------------------------------------------------------
%Como a trajetória é simetrica fazer a simetria para 2 MS
%-----------------------------------------------------------    
    ind = size(CoM,1);%pegar a última posição do vetor de pontos
    offsetx = CoM(ind,1);%cálcular o offset em x
    offsety = CoM(ind,2);%calcular o offset em y
    M2(:,1) = -CoM(ind:-1:1,1) + 2*offsetx;%calcular a trajetória simétrica para x
    M2(:,2) = -CoM(ind:-1:1,2) + 2*offsety;%calcular a trajetória simétrica para y
    M2(:,3) =  CoM(ind:-1:1,3);%em z não muda
    %trajetória total para 2 MS dado pela união das duas trajetórias
    trajCoM = [CoM;M2];
%-----------------------------------------------------------
%posição do pé B
%-----------------------------------------------------------    
    PB =pb;
%-----------------------------------------------------------
%posição do pé A
%----------------------------------------------------------- 
    xa = M2(ind,1);
    ya = M2(ind,2);    
    PA = pa + [2*pb(1,1);0;0];    
end