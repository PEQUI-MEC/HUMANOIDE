function H = frame_z_fixo( vetorAxisMovel, zAxisFixo, vetorXY)
% FRAME_Z_FIXO Retorna uma matriz 3x3 que cada coluna sao os vetores de um
% sistema de coordenadas dados pelo vetor Z fixo e o vetor "axis movel", ele
% é movel por que podemos escolher se ele sera o eixo X ou eixo Y do novo
% frame, com os 2 eixos "z e o x OU o z e o y" especificados, o terceiro
% eixo é calculado com produto vetorial entre os ja especificados.

% Essa matriz tambem é uma rotacao do frame fixo para esse novo frame, ou
% seja, ela pode ser usada para representar um vetor do frame fixo no novo
% frame

    if vetorXY == 'y'
        y = vetorAxisMovel./norm(vetorAxisMovel);
        z = zAxisFixo./norm(zAxisFixo);

        x = cross(y, z);
        y = cross(z,x);
    elseif vetorXY == 'x'
        x = vetorAxisMovel./norm(vetorAxisMovel);
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

