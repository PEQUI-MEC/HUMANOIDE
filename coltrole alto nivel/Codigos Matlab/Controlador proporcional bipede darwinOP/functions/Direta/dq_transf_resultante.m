function [dq_esq, dq_dir] = dq_transf_resultante(Tabela_dual_quat_transform)
% DQ_TRANSF_RESULTANTE retorna 2 duais quaternions 1x8 referente a transformacao total de cada perna 
    TDQ = Tabela_dual_quat_transform;
	%----------
    %---- resultante dos frames da perna esquerda
    %----------
    dq_esq = dq_transform(0, [0 0 1], [0 0 0]);
    for i = 1:1:8
        dq_esq = dual_quat_mult(dq_esq, TDQ(i, :));
    end

    %----------
    %---- resultante dos frames da perna direita
    %----------
    dq_dir = dq_transform(0, [0 0 1], [0 0 0]);
    for i = 9:1:16
        dq_dir = dual_quat_mult(dq_dir, TDQ(i, :));
    end	 

end