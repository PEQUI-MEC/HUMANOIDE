function dual_quat = xyz2dual_quat( pto )
%XYZ2DUAL_QUAT transforma um ponto em dual quaternion, fazendo a rotação do
%frame do pe, detalhe importante eh que o frame a ser transformado sempre
% tera o eixo y para frente, o x para a esquerda e o z para baixo, que eh
% o frame dos pes (frame "pe" e frame "pd")

dual_quat = dq_transform(0, [0 0 1], [pto]); % theta, rotacao, translacao
roty = dq_transform(pi, [0 1 0], [0 0 0]);
rotz = dq_transform(pi/2, [0 0 1], [0 0 0]);

dual_quat = dual_quat_mult(dual_quat, roty);
dual_quat = dual_quat_mult(dual_quat, rotz);
end

