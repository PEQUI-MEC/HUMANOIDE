function h = dual_quat_mult(h1, h2)
% Multiplica 2 duais quaternions h1*h2
    q_primario1 = h1(1:4);
    q_primario2 = h2(1:4);
    q_dual1 = h1(5:8);
    q_dual2 = h2(5:8);
    
    q_primario = quat_mult(q_primario1, q_primario2);
    q_dual = quat_mult(q_primario1, q_dual2) + quat_mult(q_dual1, q_primario2);
    
    h = [q_primario q_dual];
    
end