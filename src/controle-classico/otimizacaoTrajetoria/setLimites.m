%-----------------------------------------------------------
%M�todo para verificar  se a vari�vel de controle
%est� dentro de determinados limites
%caso n�o esteja atualiza o valor desta colocando 
%o valor m�nimo ou m�ximo
%Par�metro:
%U0 - vari�veis de controle
%Retorno:
%U - vari�vel de controle corrigida
%----------------------------------------------------------
function U = setLimites(U0)
%-----------------------------------------------------------
%vari�veis globais
%----------------------------------------------------------
global thetaM phiM KM BSSM
%-----------------------------------------------------------
%Separar as variaveis de controle
%----------------------------------------------------------
    u1 = U0(1,1);
    u2 = U0(2,1);
    u3 = U0(3,1);
    u4 = U0(4,1);
    u5 = U0(5,1);
%-----------------------------------------------------------
%tratar os dados da vari�vel de controle - theta
%-----------------------------------------------------------          
        if u1 < 0 
           u1 = 0;
        end  
        
        if u1 > thetaM
           u1 = thetaM;
        end
%-----------------------------------------------------------
%tratar os dados da vari�vel de controle - phi
%-----------------------------------------------------------               
        if u2 < 0
           u2 = 0;
        end
        
        if u2 > phiM
           u2 = phiM;
        end
%-----------------------------------------------------------
%tratar os dados da vari�vel de controle - K
%-----------------------------------------------------------         
        if u3 < 0
           u3 = 0;
        end
        
        if u3 > KM
           u3 = KM;
        end
%-----------------------------------------------------------
%tratar os dados da vari�vel de controle - BSS
%-----------------------------------------------------------         
        if u4 < 0
           u4 = 0;
        end
        
        if u4 > BSSM
           u4 = BSSM;
        end
%-----------------------------------------------------------
%retorno da fun��o
%vetor corrigido
%-----------------------------------------------------------           
        U = [u1;u2;u3;u4;u5];
end