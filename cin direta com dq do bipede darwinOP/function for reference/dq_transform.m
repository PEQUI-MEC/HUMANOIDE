function dq_transform = dq_transform( theta, array_eixo_rotacao, array_translacao)
    %DQ_TRANSFORM Retorna um dq que representa uma transformacao
    %   Detailed explanation goes here
    
    %DADOS DA MINHA ROTACAO
    c = cos(theta/2);
    s = sin(theta/2);
    v = array_eixo_rotacao/norm(array_eixo_rotacao);
    %quiver3(0,0,0,v(1), v(2), v(3), 0, 'color', 'red');
    Rotacao = [c v*s];

    %DADOS DA MINHA TRANSLACAO
    Translacao = [0 array_translacao];
    dual = (1/2)*quat_mult(Translacao,Rotacao);
    %DUAL QUATERNION TRANSFORMACAO
    dq_transform = [Rotacao dual];
end

