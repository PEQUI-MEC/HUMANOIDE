function q = quat_mult(q1, q2)
% multiplica dois quaternions
    v1 = [q1(2) q1(3) q1(4)];
    v2 = [q2(2) q2(3) q2(4)];
    s1 = q1(1);
    s2 = q2(1);
    q = [s1*s2 - dot(v1,v2), s1*v2 + s2*v1 + cross(v1, v2)];
end