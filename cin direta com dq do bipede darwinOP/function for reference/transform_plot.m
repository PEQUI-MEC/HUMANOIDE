function pontoXYZ = transform_plot( array_pto, dq_transform, plot , reverse  )
    %TRANSFORM_PLOT2 transforma um pto [x y z] usando um dual quat de transformacao
    %   Detailed explanation goes here
    
    if nargin == 2
        plot = 1;
        reverse = 0;
    end
    
    transformacao = dq_transform;
    quat_unit = [1, 0, 0, 0];

    %==========================================================================
    %# = 0, 1, 2 ... ;identifica o pto antes da rotacao
    %@ = 1, 2, 3 ... ;identifica o pto depois da rotacao
    %pto cartesiano:
    %pt#c@ = [x y z];
    %pto como quaternion:
    %pt#q@ = [0 x y z]
    
    %transformar quaterion em dual quaterion:
    %pt#d@ = [quat_unit (1/2)*quat_mult(quat_unit, pt#)]

    %transformar dual quaternion em quaterion: 
    %pt#q@ = 2*quat_mult(pt#d@(5:8), [pt#d@(1) -pt#d@(2:4)]);
    %==========================================================================
    if reverse == 0
        pt0q = [0 array_pto];
        pt0d = [quat_unit (1/2)*quat_mult(quat_unit, pt0q)];
        pt0d1 = dual_quat_mult(transformacao, pt0d);
        pt0q1 = 2*quat_mult(pt0d1(5:8), [pt0d1(1) -pt0d1(2:4)]);
        pontoXYZ = pt0q1(2:4);
    
    else
        pt0q = [0 array_pto];
        pt0d = [quat_unit (1/2)*quat_mult(quat_unit, pt0q)];
        pt0d1 = dual_quat_mult(pt0d, transformacao);
        pt0q1 = 2*quat_mult(pt0d1(5:8), [pt0d1(1) -pt0d1(2:4)]);
        pontoXYZ = pt0q1(2:4);
    end
    
    if plot == 1
        scatter3(pt0q(2), pt0q(3), pt0q(4), 'green', 'filled');
        scatter3(pt0q1(2), pt0q1(3), pt0q1(4), 'green');      
    end
    
end

