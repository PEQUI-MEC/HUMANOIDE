%-----------------------------------------------------------
%M�todo para retornar a trajet�ria do centro de massa
%completa para 2 MS
%Par�metros:
%Retorno:
%PA - posi��o do p� A referente ao segundo passo
%PB - posi��o do p� B referente ao primeiro passo
%trajCoM - trajet�ria para 2 MS
%-----------------------------------------------------------     
function [PA,PB,trajCoM] = trajetoria2MS(U,X)
%-----------------------------------------------------------
%Obter a trajet�ria dado a condi��o inicial e as vari�veis de controle
%-----------------------------------------------------------     
    [pa,pb,pc,CoM] = trajetoria(U,X);
%-----------------------------------------------------------
%Como a trajet�ria � simetrica fazer a simetria para 2 MS
%-----------------------------------------------------------    
    ind = size(CoM,1);%pegar a �ltima posi��o do vetor de pontos
    offsetx = CoM(ind,1);%c�lcular o offset em x
    offsety = CoM(ind,2);%calcular o offset em y
    M2(:,1) = -CoM(ind:-1:1,1) + 2*offsetx;%calcular a trajet�ria sim�trica para x
    M2(:,2) = -CoM(ind:-1:1,2) + 2*offsety;%calcular a trajet�ria sim�trica para y
    M2(:,3) =  CoM(ind:-1:1,3);%em z n�o muda
    %trajet�ria total para 2 MS dado pela uni�o das duas trajet�rias
    trajCoM = [CoM;M2];
%-----------------------------------------------------------
%posi��o do p� B
%-----------------------------------------------------------    
    PB =pb;
%-----------------------------------------------------------
%posi��o do p� A
%----------------------------------------------------------- 
    xa = M2(ind,1);
    ya = M2(ind,2);    
    PA = pa + [2*pb(1,1);0;0];    
end