function dq_reverse = reverse_dq_transform( dq_transform )
    %REVERSE_DQ_TRANSFORM Retorna um dual quaternion que eh a transformacao reversa, ou seja, faz a transformacao do frame seguinte para o anterior

    dq_reverse = [dq_transform(1) -dq_transform(2:4) dq_transform(5) -dq_transform(6:8)]; 
    
end

