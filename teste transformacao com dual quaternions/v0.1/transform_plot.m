function dq = transform_plot(theta, array_eixo_rotacao, array_translacao, array_pto)
    % transforma um pto com um angulo de rotacao, um eixo de rotacao e um vetor de translacao    

    %DADOS DA MINHA ROTACAO
    c = cos(theta/2);
    s = sin(theta/2);
    v = array_eixo_rotacao/norm(array_eixo_rotacao);
    quiver3(0,0,0,v(1), v(2), v(3), 0, 'color', 'red');
    Rotacao = [c v*s];

    %DADOS DA MINHA TRANSLACAO
    Translacao = [0 array_translacao];
    dual = (1/2)*quat_mult(Translacao,Rotacao);
    %DUAL QUATERNION TRANSFORMACAO
    transformacao = [Rotacao dual];
    quat_unit = [1, 0, 0, 0];

    %==========================================================================
    %# = 0, 1, 2 ... ;identifica o pto antes da rotacao
    %@ = 1, 2, 3 ... ;identifica o pto depois da rotacao
    %pto como quaternion:
    %pt#q@ = [0 x y z]
    
    %transformar quaterion em dual quaterion:
    %pt#d@ = [quat_unit (1/2)*quat_mult(quat_unit, pt#)]

    %transformar dual quaternion em quaterion: 
    %pt#q@ = 2*quat_mult(pt#d@(5:8), [pt#d@(1) -pt#d@(2:4)]);
    %==========================================================================
    pt0q = [0 array_pto];
    scatter3(pt0q(2), pt0q(3), pt0q(4), 'green', 'filled');
    pt0d = [quat_unit (1/2)*quat_mult(quat_unit, pt0q)];
    pt0d1 = dual_quat_mult(transformacao, pt0d);
    pt0q1 = 2*quat_mult(pt0d1(5:8), [pt0d1(1) -pt0d1(2:4)]);
    scatter3(pt0q1(2), pt0q1(3), pt0q1(4),'green');
    dq = pt0d1;
end