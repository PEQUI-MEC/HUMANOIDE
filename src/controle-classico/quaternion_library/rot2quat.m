%--------------------------------------
%M�todo para calcular o quat�rnio equivalente
%dado uma matriz de rota��o 
%Par�metros: 
%T: Matriz de Rota��o
%Retorno:
%q: quat�rnio resultante
%--------------------------------------
function q = rot2quat(T)
    
    %iniciar o quartenio
    q = [0 0 0 0]';

    %Elementos da matriz de Rota��o
    D1 = T(1,1);
    D2 = T(2,2);
    D3 = T(3,3);

    Au = T(1,2);
    Bu = T(1,3);
    Cu = T(2,3);

    Ad = T(2,1);
    Bd = T(3,1);
    Cd = T(3,2);

    %solu��o baseada em w
    bw = 1 + D1 + D2 + D3;
    if bw > 0
        w = sqrt(bw)/2;
        x = (Cd - Cu)/(4*w);
        y = (Bu - Bd)/(4*w);
        z = (Ad - Au)/(4*w);

        q = [ x y z w]';
        return
    end

    %solu��o baseada em x
    if D1 > D2 & D1 > D3
        bx = 1 + D1 - D2 -D3;
        x = sqrt(bx)/2;
        y = (Au+Ad)/(4*x);
        z = (Bu+Bd)/(4*x);
        w = (Cd - Cu)/(4*x);

        q = [x y z w]';
        return
    end

    %solu��o baseada em y
    if D2 > D1 & D2 > D3
        by = 1 - D1 + D2 -D3;
        y = sqrt(by)/2;
        x = (Au+Ad)/(4*y);
        z = (Cd+Cu)/(4*y);
        w = (Bu - Bd)/(4*y);

        q = [x y z w]';
        return
    end

    %solu��o baseada em z
    if D3 > D1 & D3 > D2
        bz = 1 - D1 - D2 +D3;
        z = sqrt(bz)/2;
        x = (Bu+Bd)/(4*z);
        y = (Cd+Cu)/(4*z);
        w = (Ad - Au)/(4*z);

        q = [x y z w]';
        return
    end
end