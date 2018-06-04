function H = H_calc(DH_table)
%Funcao que calcula uma matriz (4, 4, i) onde cada matriz i eh a transformacao do frame i para o frame 0, cada coluna eh o versor x,y,z do frame i com respeito ao frame 0
alpha = DH_table(:,1).*(pi/180);
a = DH_table(:,2);
d = DH_table(:,3);
theta = DH_table(:,4)*(pi/180);

H = zeros(4, 4, numel(theta)); % index: H(row, column, i)
for i = 1:numel(theta)
    H(:,:,i) = [
    cos(theta(i)),  -sin(theta(i))*cos(alpha(i)), sin(theta(i))*sin(alpha(i)),  a(i)*cos(theta(i)) ;
    sin(theta(i)),  cos(theta(i))*cos(alpha(i)),  -cos(theta(i))*sin(alpha(i)), a(i)*sin(theta(i)) ;
    0,              sin(alpha(i)),                        cos(alpha(i)),        d(i)               ;
    0,              0,                            0,                            1                  ];
    if i > 1
        H(:,:,i) = H(:,:,i-1)*H(:,:,i); % H1*H2*...*Hi
    end
end

end


