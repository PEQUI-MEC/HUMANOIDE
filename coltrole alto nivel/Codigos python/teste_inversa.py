from cinematica_controle import *
# comentario crtl+/

# gera os pontos de trajetoria no espaco
trajetoria = gera_ptos_pes(50)
esq = trajetoria[0]
dir = trajetoria[1]

# dedao e fibula constantes
dedao_esq = np.array([1, 0, 0])
fibula_esq = np.array([0, 1, 0])
dedao_dir = np.array([1, 0, 0])
fibula_dir = np.array([0, -1, 0])

l = np.size(esq, 1)
for i in range(0, l):
    pe_esq = np.array([esq[0][i],esq[1][i] , esq[2][i]])
    pe_dir = np.array([dir[0][i],dir[1][i] , dir[2][i]])

    thetas = calcula_inversa(pe_esq, dedao_esq, fibula_esq, pe_dir, dedao_dir, fibula_dir) * np.pi / 180
    print("thetas: ", thetas)
