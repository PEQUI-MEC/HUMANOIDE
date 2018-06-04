function H = frvZ( vAxisMovel, zAxisFixo, vXY)
%FRAMEFROMVECTOR retorna uma matriz de rotacao que rotaciona o frame padrao
%para o frame definido pelos 2 vetores, caso nao sejam perpendicular o vetor y eh reajustado
if vXY == 'y'
    y = vAxisMovel./norm(vAxisMovel);
    z = zAxisFixo./norm(zAxisFixo);

    x = cross(y, z);
    y = cross(z,x);
elseif vXY == 'x'
    x = vAxisMovel./norm(vAxisMovel);
    z = zAxisFixo./norm(zAxisFixo);

    y = cross(z, x);
    x = cross(y,z);
else
    error('argumento vXY deve ser x ''x'' ou ''y''');
    exit
end

H = [x(1) y(1) z(1);
     x(2) y(2) z(2);
     x(3) y(3) z(3)];
end

