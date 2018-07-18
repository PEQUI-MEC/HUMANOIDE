import numpy as np
"""
Funcoes minimas necessarias para a cinematica direta com dual quaternion.

"testado no matlab" significa que a saida da funcao aqui no python foi comparada com a saida da mesma no matlab.
"""


def quat_mult(q1, q2):
    """
    Docstring da funcao: *ctrl + q no nome da funcao.*

    Testado no matlab, multiplica dois quaternions.

    Args:
        q1: quaternion 1: np.array([1,2,3,4]).
        q2: quaternion 2: np.array([1,2,3,4]).

    Return:
        q1*q2: um novo quaternion: np.array([1,2,3,4]).

    """
    v1 = np.array([q1[1], q1[2], q1[3]])
    v2 = np.array([q2[1], q2[2], q2[3]])
    s1 = q1[0]
    s2 = q2[0]

    v3 = s1 * v2 + s2 * v1 + np.cross(v1, v2)
    q3 = np.array([s1 * s2 - np.dot(v1, v2)])
    return np.concatenate((q3, v3))


def dual_quat_mult(h1, h2):
    """
    Docstring da funcao: *ctrl + q no nome da funcao.*

    Testado no matlab, multiplica dois duais quaternions.

    Args:
        h1: dual quaternion 1: np.array([1,2,3,4,5,6,7,8]).
        h2: dual quaternion 2: np.array([1,2,3,4,5,6,7,8]).

    Return:
        q1*q2: um novo dual quaternion: np.array([1,2,3,4,5,6,7,8]).

    """
    q_primario1 = np.array(h1[0:4])
    q_primario2 = np.array(h2[0:4])
    q_dual1 = np.array(h1[4:8])
    q_dual2 = np.array(h2[4:8])

    q_primario = quat_mult(q_primario1, q_primario2)
    q_dual = quat_mult(q_primario1, q_dual2) + quat_mult(q_dual1, q_primario2)

    h = np.concatenate((q_primario, q_dual))
    return h


def dh_parameters(np_array_12_angulos):
    """
    Docstring da funcao: *ctrl + q no nome da funcao.*

    Testado no matlab, retorna a tabela dos parametros Denavit Hatenberg.

    Args:
        np_array_12_angulos: array de angulos em radianos: np.array([1,2,3,4,5,6,7,8,9,10,11,12]).

    Return:
        np.array()[16][4]: uma matriz 16 linhas por 4 colunas

    """
    df = 2
    af = 3.7
    a3 = 9.3
    a4 = a3
    a9 = a3
    a10 = a4
    de = 3.35
    dd = de
    t1 = np_array_12_angulos[0]
    t2 = np_array_12_angulos[1]
    t3 = np_array_12_angulos[2]
    t4 = np_array_12_angulos[3]
    t5 = np_array_12_angulos[4]
    t6 = np_array_12_angulos[5]
    t7 = np_array_12_angulos[6]
    t8 = np_array_12_angulos[7]
    t9 = np_array_12_angulos[8]
    t10 = np_array_12_angulos[9]
    t11 = np_array_12_angulos[10]
    t12 = np_array_12_angulos[11]

    pi = np.pi
    dh = np.array([[pi / 2,      -df,  af,      pi],  # do fixo pro 0           (sobre o motor 1)
                   [t1,            0,   0, -pi / 2],  # motor 1 do frame 0 pro 1(sobre o motor 2)
                   [pi / 2 + t2,   0,   0,  pi / 2],  # motor 2 do frame 1 pro 2(sobre o motor 3)
                   [t3,            0, -a3,       0],  # motor 3 do frame 2 pro 3(sobre o motor 4)
                   [t4,            0, -a4,       0],  # motor 4 do frame 3 pro 4(sobre o motor 5)
                   [t5,            0,   0, -pi / 2],  # motor 5 do frame 4 pro 5(sobre o motor 6)
                   [-pi / 2 + t6,  0,   0,  pi / 2],  # motor 6 do frame 5 pro 6(eixo z np.linalg.normal ao pe, mas esta acima do pe)
                   [0,            de,   0,       0],  # do frame 6 para o pe esquerdo(sobre o pe com eixo z np.linalg.normal ao pe)

                   # PERNA DIREITA
                   [pi / 2,      -df, -af,      pi],  # do fixo pro 7           (sobre o motor 7)
                   [t7,            0,   0, -pi / 2],  # motor 7 do frame 7 pro 8(sobre o motor 8)
                   [-pi / 2 + t8,  0,   0,  pi / 2],  # motor 8 do frame 8 pro 9(sobre o motor 9)
                   [t9,            0,  a9,       0],  # motor 9 do frame 9 pro 10(sobre o motor 10)
                   [t10,           0, a10,       0],  # motor 10 do frame 10 pro 11(sobre o motor 11)
                   [pi + t11,      0,   0,  pi / 2],  # motor 11 do frame 11 pro 12(sobre o motor 12)
                   [-pi / 2 + t12, 0,   0,  pi / 2],  # motor 12 do frame 12 pro 13(eixo z np.linalg.normal ao pe, mas esta acima do pe)
                   [0,            dd,   0,       0]])  # do frame 13 para o pe direito(sobre o pe com eixo z np.linalg.normal ao pe)
    return dh

def dq_transform(theta, array_eixo_rotacao, array_translacao):
    """
        Docstring da funcao: *ctrl + q no nome da funcao.*

        Testado no matlab, retorna um dual quaternion que representa a transformacao dada pelos argumentos
        observe que o giro em torno do vetor eixeo de rotação eh no sentido dado pela regra da mao direita

        Args:
            theta: angulo da rotacao
            array_eixo_rotacao: vetor np.array()[1][3]
            array_translacao: vetor np.array()[1][3]

        Return:
            np.array()[1][8]: um vetor 1 linha por 8 colunas

        """
    c = np.cos(theta/2)
    s = np.sin(theta/2)
    v = array_eixo_rotacao/np.linalg.norm(array_eixo_rotacao)
    tmp = np.multiply(v, s)
    Rotacao = np.append(c, tmp)

    Translacao = np.append(0, array_translacao)
    dual = (1/2)*quat_mult(Translacao, Rotacao)
    dq_transform = np.append(Rotacao, dual)

    return dq_transform


def dh_to_dq_transforms(denavit_haterberg_table):
    """
    Docstring da funcao: *ctrl + q no nome da funcao.*

    Testado no matlab, retorna uma tabela contendo as transformacoes de um frame pra outro em forma de dual quaternion,
    observe que da linha 1 a linha 8 as transformacoes sao da perna esquerda, da linha 9 a 16 sao da perna direita

    Args:
        denavit_haterberg_table: tabela np.array()[16][4]

    Return:
        np.array()[16][8]: uma matriz 16 linhas por 8 colunas

    """
    dh = denavit_haterberg_table

    tdq = np.zeros((16, 8))
    for i in range(0, 16):
        theta = dh[i][0]
        d = dh[i][1]
        a = dh[i][2]
        alpha = dh[i][3]

        h1 = np.cos(theta / 2) * np.cos(alpha / 2)
        h2 = np.cos(theta / 2) * np.sin(alpha / 2)
        h3 = np.sin(theta / 2) * np.sin(alpha / 2)
        h4 = np.sin(theta / 2) * np.cos(alpha / 2)
        p = np.array([h1, h2, h3, h4])
        d = np.array([-(d * h4 + a * h2) / 2, (-d * h3 + a * h1) / 2, (d * h2 + a * h4) / 2, (d * h1 - a * h3) / 2])
        tdq[i] = np.concatenate((p, d))

    return tdq


def dq_transf_resultante(Tabela_dual_quat_transform):
    """
    Docstring da funcao: *ctrl + q no nome da funcao.*

    Testado no matlab, retorna uma tabela de dimensao 2x8 que a primeira linha eh um dual quaternion que representa
    a transformacao resultante do frame fixo para o pe esquerdo e a segunda linha eh a transformacao do pe direito

    Args:
        Tabela_dual_quat_transform: tabela np.array()[16][8]

    Return:
        np.array()[2][8]: uma matriz 2 linhas por 8 colunas

    """
    TDQ = Tabela_dual_quat_transform

    dq_esq = dq_transform(0, np.array([0, 0, 1]), np.array([0, 0, 0]))
    for i in range(0, 8):
        dq_esq = dual_quat_mult(dq_esq, TDQ[i])

    dq_dir = dq_transform(0, np.array([0, 0, 1]), np.array([0, 0, 0]))
    for i in range(8, 16):
        dq_dir = dual_quat_mult(dq_dir, TDQ[i])

    dq_transform_esq_dir = np.array([dq_esq, dq_dir])
    return dq_transform_esq_dir


def frame_z_fixo(vetorAxisMovel, zAxisFixo, vetorXY):
    """"
    Retorna uma matriz 3x3 que cada coluna sao os vetores de um
    sistema de coordenadas dados pelo vetor Z fixo e o vetor "axis movel", ele
    é movel por que podemos escolher se ele sera o eixo X ou eixo Y do novo
    frame, com os 2 eixos "z e o x OU o z e o y" especificados, o terceiro
    eixo é calculado com produto vetorial entre os ja especificados.
    
    Essa matriz tambem é uma rotacao do frame fixo para esse novo frame, ou
    seja, ela pode ser usada para representar um vetor do frame fixo no novo
    frame

    testado com o Matlab
"""
    if vetorXY == 'y':
        y = vetorAxisMovel/np.linalg.norm(vetorAxisMovel)
        z = zAxisFixo/np.linalg.norm(zAxisFixo)
        x = np.cross(y, z)
        y = np.cross(z, x)
    else:
        if vetorXY == 'x':
            x = vetorAxisMovel/np.linalg.norm(vetorAxisMovel)
            z = zAxisFixo/np.linalg.norm(zAxisFixo)
            y = np.cross(z, x)
            x = np.cross(y, z)

    H = np.array([[x[0], y[0], z[0]],
                  [x[1], y[1], z[1]],
                  [x[2], y[2], z[2]]])
    return H


def calcula_inversa(pe_esq, dedao_esq, fibula_esq, pe_dir, dedao_dir, fibula_dir):
    """
    Este metodo calcula os 12 angulos dos motores do bipede baseados na cinematica descrita no trabalho
    uma observacao importante eh que os vetores de posicao dos pes sao dados em referencia ao frame fixo modificado
    para cada perna, ou seja, ocada frame eh transladado para a posicao onde se inicia a perna, a junta da coxa com
    o quadril
    Args:
        pe_esq: vetor linha da posicao do pe esquerdo
        dedao_esq: vetor linha da direcao do dedao esquerdo
        fibula_esq: vetor linha da direcao da lateral externa do pe esquerdo
        pe_dir: vetor linha da posicao do pe direito
        dedao_dir: vetor linha da direcao do dedao direito
        fibula_dir: vetor linha da direcao da lateral externa do pe esquerdo

    Return:
        thetas: np.array() 1x12 os angulos dos motores
    """
    pi = np.pi
    modulo_coxa = 9.3

    dedao_dir = dedao_dir / np.linalg.norm(dedao_dir) * 2
    fibula_dir = fibula_dir / np.linalg.norm(fibula_dir) * 2

    m11axis = np.cross(pe_dir, dedao_dir)
    m11axis = m11axis / np.linalg.norm(m11axis) * 2
    if m11axis[1] > 0:
        m11axis = -m11axis

    H = frame_z_fixo(-pe_dir, m11axis, 'y')
    y = np.linalg.norm(pe_dir) / 2
    x = modulo_coxa * np.sin(np.arccos(y / modulo_coxa))

    canela_dir = np.matmul(-H, np.array([x, y, 0]))
    coxa_dir = -canela_dir + pe_dir

    m8axis = np.array([-m11axis[1], m11axis[0], 0])

    H = frame_z_fixo(m11axis, dedao_dir, 'x')
    Ht = np.transpose(H)
    fibula_dirt = np.matmul(Ht, fibula_dir)
    if fibula_dirt[0] < 0:
        raise ValueError('fibula direita alem do limite de angulo')

    m12 = np.arctan2(fibula_dirt[1], fibula_dirt[0]) * 180 / pi

    H = frame_z_fixo(-canela_dir, m11axis, 'y')
    Ht = np.transpose(H)
    dedao_dirt = np.matmul(Ht, dedao_dir)
    m11 = np.arctan2(dedao_dirt[1], dedao_dirt[0]) * 180 / pi

    H = frame_z_fixo(coxa_dir, m11axis, 'x')
    Ht = np.transpose(H)
    canela_dirt = np.matmul(Ht, canela_dir)
    m10 = np.arctan2(canela_dirt[1], canela_dirt[0]) * 180 / pi

    H = frame_z_fixo(m8axis, m11axis, 'y')
    Ht = np.transpose(H)
    coxa_dirt = np.matmul(Ht, coxa_dir)
    m9 = np.arctan2(coxa_dirt[1], coxa_dirt[0]) * 180 / pi

    H = frame_z_fixo(np.array([m11axis[0], m11axis[1], 0]), m8axis, 'x')
    Ht = np.transpose(H)
    m11axist = np.matmul(Ht, m11axis)
    m8 = np.arctan2(m11axist[1], m11axist[0]) * 180 / pi

    m7 = -np.arctan2(m8axis[1], m8axis[0])*180/pi

    dedao_esq = dedao_esq / np.linalg.norm(dedao_esq) * 2
    fibula_esq = fibula_esq / np.linalg.norm(fibula_esq) * 2

    m5axis = np.cross(dedao_esq, pe_esq)
    m5axis = m5axis / np.linalg.norm(m5axis) * 2
    if m5axis[1] < 0:
        m5axis = -m5axis

    H = frame_z_fixo(-pe_esq, m5axis, 'y')
    y = np.linalg.norm(pe_esq) / 2
    x = -modulo_coxa*np.sin(np.arccos(y/modulo_coxa))
    canela_esq = np.matmul(-H, np.array([x, y, 0]))
    coxa_esq = -canela_esq + pe_esq

    m2axis = np.array([m5axis[1], -m5axis[0], 0])

    H = frame_z_fixo(m5axis, dedao_esq, 'x')
    Ht = np.transpose(H)
    fibula_esqt = np.matmul(Ht, fibula_esq)
    if fibula_esqt[0] < 0:
        raise ValueError('fibula esquerda alem do limite de angulo')

    m6 = np.arctan2(fibula_esqt[1], fibula_esqt[0]) * 180 / pi

    H = frame_z_fixo(-canela_esq, m5axis, 'y')
    Ht = np.transpose(H)
    dedao_esqt = np.matmul(Ht, -dedao_esq)
    m5 = np.arctan2(dedao_esqt[1], dedao_esqt[0]) * 180 / pi

    H = frame_z_fixo(coxa_esq, m5axis, 'x')
    Ht = np.transpose(H)
    canela_esqt = np.matmul(Ht, canela_esq)
    m4 = np.arctan2(canela_esqt[1], canela_esqt[0]) * 180 / pi

    H = frame_z_fixo(-m2axis, m5axis, 'y')
    Ht = np.transpose(H)
    coxa_esqt = np.matmul(Ht, coxa_esq)
    m3 = np.arctan2(coxa_esqt[1], coxa_esqt[0]) * 180 / pi

    H = frame_z_fixo([m5axis[0], m5axis[1], 0], m2axis, 'x')
    Ht = np.transpose(H)
    m5axist = np.matmul(Ht, m5axis)
    m2 = np.arctan2(m5axist[1], m5axist[0]) * 180 / pi

    m1 = -np.arctan2(m2axis[1], m2axis[0]) * 180 / pi

    thetas = np.array([m1, m2, m3, m4, m5, m6, m7, m8, m9, m10, m11, m12])
    return thetas


def hamilton_menos(h):
    """
    Calcula a matriz dual hamilton negativa do dual quaternion h
    Args:
        h: np.array() 1x8
    Return:
        hamilton_neg: np.array() 8x8
    """
    hamilton_neg = np.array(
        [[h[0], -h[1], -h[2], -h[3],    0,     0,     0,     0],
         [h[1],  h[0],  h[3], -h[2],    0,     0,     0,     0],
         [h[2], -h[3],  h[0],  h[1],    0,     0,     0,     0],
         [h[3],  h[2], -h[1],  h[0],    0,     0,     0,     0],
         [h[4], -h[5], -h[6], -h[7], h[0], -h[1], -h[2], -h[3]],
         [h[5],  h[4],  h[7], -h[6], h[1],  h[0],  h[3], -h[2]],
         [h[6], -h[7],  h[4],  h[5], h[2], -h[3],  h[0],  h[1]],
         [h[7],  h[6], -h[5],  h[4], h[3],  h[2], -h[1],  h[0]]])
    return hamilton_neg


def jacobiano(thetas_pto_da_derivada_1x12):
    """
    Calcula o jacobiano da cinematica direta no ponto dado pelo vetor thetas_pto_da_derivada_1x12
    Args:
        thetas_pto_da_derivada_1x12: np.array() 1x12
    Return:
        jacobiano: np.array() 2x(6x8)
    """
    delta_theta = 10e-6
    thetai = thetas_pto_da_derivada_1x12

    DHi = dh_parameters(thetai)
    TDQi = dh_to_dq_transforms(DHi)
    dq_i= dq_transf_resultante(TDQi)
    dq_esq_i = dq_i[0]
    dq_dir_i = dq_i[1]

    Je = np.zeros([8, 6])
    Jd = np.zeros([8, 6])

    for i in range(0,6):
        thetaf = np.array(thetai)
        thetaf[i] = thetaf[i] + delta_theta
        thetaf[i + 6] = thetaf[i + 6] + delta_theta

        DHf = dh_parameters(thetaf)
        TDQf = dh_to_dq_transforms(DHf)
        dq_f = dq_transf_resultante(TDQf)
        dq_esq_f = dq_f[0]
        dq_dir_f = dq_f[1]
        delta_dq_esq = dq_esq_f - dq_esq_i
        delta_dq_dir = dq_dir_f - dq_dir_i


        for j in range(0,8):
            Je[j][i] = delta_dq_esq[j] / delta_theta
            Jd[j][i] = delta_dq_dir[j] / delta_theta

    jacobiano = np.array([Je, Jd])
    return jacobiano


def dual_quat_conj(h):
    """
    Calcula o dual quaternion conjugado de h
    Args:
        h: np.array() 1x8
    Return:
        h_conj: np.array() 1x8
    """
    h_conj = np.array([h[0], -h[1], -h[2], -h[3], h[4], -h[5], -h[6], -h[7]])
    return h_conj


def xyz2dual_quat(pto):
    """
    Transforma um ponto em dual quaternion, fazendo a rotação do
    frame do pe, detalhe importante eh que o frame a ser transformado sempre
    tera o eixo y para frente, o x para a esquerda e o z para baixo, que eh
    o frame dos pes (frame "pe" e frame "pd")

    :param pto:
    :return:
    """
    dual_quat = dq_transform(0, np.array([0, 0, 1]), pto)
    roty = dq_transform(np.pi, np.array([0, 1, 0]), np.array([0, 0, 0]))
    rotz = dq_transform(np.pi / 2, np.array([0, 0, 1]), np.array([0, 0, 0]))

    dual_quat = dual_quat_mult(dual_quat, roty)
    dual_quat = dual_quat_mult(dual_quat, rotz)
    return dual_quat


def controlador(thetas_real_atual_1x12, h_desejado_esq_1x8, h_desejado_dir_1x8, h_futuro_esq_1x8, h_futuro_dir_1x8):
    """
    Calcula os angulos da proxima posicao dos pes
    Args:
        thetas_real_atual_1x12:
        h_desejado_esq_1x8:
        h_desejado_dir_1x8:
        h_futuro_esq_1x8:
        h_futuro_dir_1x8:
    Return:
        thetas_corrigidos_1x12: np.array() 1x12
    """
    thetas_real = thetas_real_atual_1x12
    h_desej_esq = h_desejado_esq_1x8
    h_desej_dir = h_desejado_dir_1x8
    h_futur_esq = h_futuro_esq_1x8
    h_futur_dir = h_futuro_dir_1x8

    DH = dh_parameters(thetas_real)
    TDQ = dh_to_dq_transforms(DH)
    h_real = dq_transf_resultante(TDQ)

    h_real_esq = h_real[0]
    h_real_dir = h_real[1]

    g = 1000
    delta_t = 10e-6

    K = g * np.eye(8)
    C8 = np.diag([1, -1, -1, -1, 1, -1, -1, -1])
    jacob = jacobiano(thetas_real)
    J_esq = jacob[0]
    J_dir = jacob[1]

    #controlador da perna esquerda
    H_esq = hamilton_menos(h_desej_esq)
    N_esq = np.matmul(np.matmul(H_esq, C8), J_esq)
    erro_esq = np.array([1, 0, 0, 0, 0, 0, 0, 0]) - dual_quat_mult(dual_quat_conj(h_real_esq) , h_desej_esq)
    dh_desej_esq = (h_futur_esq - h_desej_esq) / delta_t
    vec = dual_quat_mult(dual_quat_conj(h_real_esq), dh_desej_esq)
    N_esqP = np.linalg.pinv(N_esq)
    dtheta_esq = np.matmul(N_esqP, np.matmul(K, erro_esq) - vec)
    theta_esq = (dtheta_esq * delta_t) / 2


    # controlador da perna direita
    H_dir = hamilton_menos(h_desej_dir)
    N_dir = np.matmul(np.matmul(H_dir, C8), J_dir)
    erro_dir = np.array([1, 0, 0, 0, 0, 0, 0, 0]) - dual_quat_mult(dual_quat_conj(h_real_dir) , h_desej_dir)
    dh_desej_dir = (h_futur_dir - h_desej_dir) / delta_t
    vec = dual_quat_mult(dual_quat_conj(h_real_dir), dh_desej_dir)
    N_dirP = np.linalg.pinv(N_dir)
    dtheta_dir = np.matmul(N_dirP, (np.matmul(K, erro_dir) - vec))
    theta_dir = (dtheta_dir * delta_t) / 2

    thetas_corrigidos_1x12 = thetas_real + np.append(theta_esq, theta_dir)
    return thetas_corrigidos_1x12

def gera_ptos_pes(qnt_ptos):
    n = qnt_ptos

    #
    # trajetoria do pe direito
    #

    t1 = np.arange(4, 0, (-4) / n)# (final - inicial) / n
    t2 = np.zeros(n)
    t3 = np.arange(0, -4, (-4) / n)
    xdrepete = np.append(t1, np.append(t2, t3))

    t1 = np.arange(-3, 3, 6 / n)
    t2 = np.repeat(3, n)
    t3 = np.arange(3, -3, (-6) / n)
    ydrepete = np.append(t1, np.append(t2, t3))

    zdrepete = np.repeat(-10, n * 3)

    t1 = np.arange(-4, 4, 8 / n)
    xdrepete = np.append(xdrepete, t1)

    t1 = np.repeat(-3, n)
    ydrepete = np.append(ydrepete, t1)

    t1 = -np.power(np.arange(-2, 2, 4 / n), 2) / 2 - 8
    zdrepete = np.append(zdrepete, t1)

    t1 = np.zeros(2 * n)
    t2 = np.arange(0, 4, 4 / n)
    xd = np.append(t1, t2)
    for i in range(1,5):
        xd = np.append(xd, xdrepete)

    t1 = np.zeros(n)
    t2 = np.arange(0, -3, -3 / n)
    t3 = np.repeat(-3, n)
    yd = np.append(t1, np.append(t2, t3))
    for i in range(1,5):
        yd = np.append(yd, ydrepete)

    t1 = np.arange(-12, -10, 2 / n)
    t2 = np.repeat(-10, n)
    t3 = -np.power(np.arange(-2, 2, 4 / n), 2) / 2 - 8
    zd = np.append(t1, np.append(t2, t3))
    for i in range(1, 5):
        zd = np.append(zd, zdrepete)

    #
    # trajetoria do pe esquerda
    #

    t1 = np.arange(0, -4, -4 / n)
    t2 = np.arange(-4, 4, 8 / n)
    t3 = np.arange(4, 0, -4 / n)
    xerepete = np.append(t1, np.append(t2, t3))

    t1 = np.arange(-3, 3, 6 / n)
    t2 = np.repeat(3, n)
    t3 = np.arange(3, -3, -6 / n)
    yerepete = np.append(t1, np.append(t2, t3))

    t1 = np.repeat(-10, n)
    t2 = -np.power(np.arange(-2, 2, 4 / n), 2) / 2 - 8
    t3= np.repeat(-10, n)
    zerepete = np.append(t1, np.append(t2, t3))

    t1 = np.zeros(n)
    xerepete = np.append(xerepete, t1)

    t1 = np.repeat(-3, n)
    yerepete = np.append(yerepete, t1)

    t1 = np.repeat(-10, n)
    zerepete = np.append(zerepete, t1)

    xe = np.zeros(n * 3)
    for i in range(1, 5):
        xe = np.append(xe, xerepete)

    t1 = np.zeros(n)
    t2 = np.arange(0, -3, -3 / n)
    t3 = np.repeat(-3, n)
    ye = np.append(t1, np.append(t2, t3))
    for i in range(1, 5):
        ye = np.append(ye, yerepete)

    t1 = np.arange(-12, -10, 2 / n)
    t2 = np.repeat(-10, n * 2)
    ze = np.append(t1, t2)
    for i in range(1, 5):
        ze = np.append(ze, zerepete)

    trajetoria_pe_esq = np.array([xe, ye, ze])
    trajetoria_pe_dir = np.array([xd, yd, zd])
    return np.array([trajetoria_pe_esq, trajetoria_pe_dir])