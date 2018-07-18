function pto = dual_quat2xyz( dual_quaternion )
%DUAL_QUAT2XYZ gera o ponto [x; y; z] dado um dual quaternion, detalhe que
%este ponto eh somente a translacao

quat_unit = [1 0 0 0];
o = [quat_unit (1/2)*quat_mult(quat_unit, [0 0 0 0])];
o = dual_quat_mult(dual_quaternion, o);
o = 2*quat_mult(o(5:8), [o(1) -o(2:4)]);
pto = o(1:4);
end

