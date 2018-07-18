function [pto, theta, n] = dual_quat_to_xyz( dual_quaternion)
%DUAL_QUAT_TO_XYZ extrai a posicao xyz do dual quaternion dado
Td = dual_quaternion;

theta = 2*acos(Td(1));
nx = Td(2)/abs(sin(theta/2));
ny = Td(3)/abs(sin(theta/2));
nz = Td(4)/abs(sin(theta/2));
n = [nx ny nz];

quat_unit = [1 0 0 0];
o1 = [quat_unit (1/2)*quat_mult(quat_unit, [0 0 0 0])];
o = dual_quat_mult(Td, o1);
o = 2*quat_mult(o(5:8), [o(1) -o(2:4)]);
pto = o(2:4);
end

