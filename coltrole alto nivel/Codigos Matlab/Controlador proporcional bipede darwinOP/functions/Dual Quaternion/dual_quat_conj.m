function h_conj = dual_quat_conj( h )
%DUAL_QUAT_CONJ calcula o conjugado do dual quaternion
h_conj = [ h(1) -h(2) -h(3) -h(4) h(5) -h(6) -h(7) -h(8)];
end

