%-----------------------------------------------------------
%Imprime no console os valores - usado para debugar o codigo
%Parâmetros 
%iteração - número da iteração que deseja imprimir no console
%vec      - vetor com os valores a serem imprimidos
%theta - vec(1,1)
%phi   - vec(2,1)
%K     - vec(3,1)
%BSS   - vec(4,1)
%fo    - vec(5,1)
%----------------------------------------------------------
function imprimirConsole(iteracao,vec)
%-----------------------------------------------------------
%separar os valores do vetor
%-----------------------------------------------------------     
     theta = vec(1,1);
     phi   = vec(2,1);
     K     = vec(3,1);
     BSS   = vec(4,1);
     expK  = vec(5,1);
     fo    = vec(6,1);
%-----------------------------------------------------------
%imprimir no console
%-----------------------------------------------------------     
     disp('------------------------------------------------------------')
     msg = sprintf('iteracao : %d:',iteracao);
     disp(msg);
     msg = sprintf('phi = %0.10f;',phi);
     disp(msg);
     msg = sprintf('theta = %0.10f;',theta);
     disp(msg);
     msg = sprintf('k = %0.10f;',K*expK);
     disp(msg);
     msg = sprintf('Bss = %0.10f;',BSS);
     disp(msg);
     msg = sprintf('FO : %0.10f',fo);
     disp(msg);
end