## Visão

**Projeto**

A ROBOCUP HUMANOID LEAGUE é uma competição de robôs autônomos com um formato humano, de tamanho entre 40~90cm, que jogam futebol.

O objetivo do projeto é desenvolver a parte responsável pela visão do Robô Humanoide, isso inclui toda a parte de detecção de objeto e mapeamento do campo.

Nesse projeto o objetivo é desenvolver um software capaz de detectar um grupo objetos qualquer e sua posição na tela.

**Objetivos**

* Elaboração do software responsável pela visão, que consiste na detecção e localização de objetos;

* Integração com a camera e dispositivo computacional a serem utilizados no projeto;

* Teste da eficiência e precisão da detecção dos objetos necessários;

* Teste do consumo de recursos computacionais e viabilidade no sistema embarcado;

**Recursos**

O hardware é composto por uma placa de desenvolvimento Raspberry Pi 3 Model B v1.2 e uma Raspberry Pi Camera Rev1.3

<img src="https://i.imgur.com/rQYCpGt.jpg" width="300"/><img src="https://i.imgur.com/dcqhKiT.jpg" width="255"/> 


	Figura 1. Raspberry Pi 3 B v1.2	  	Figura 2. Raspberry Pi Camera Rev1.3

**Projeto**

Para podermos detectar uma objeto a intenção é usar redes neurais convolucionais (Convolutional Neural Networks / CNN) profundas que são usadas principalmente para classificação de imagens, possuem caso bem treinadas possuem uma eficácia muito alta.

Uma CNN é capaz de pegar uma imagem e dizer se existe um objeto dentro dela, mas para a nossa aplicação isso não é o suficiente pois é necessária achar a posição do objeto dentro da imagem caso ele exista, para isso uma das técnicas é usar algum algoritmo de visão clássica para segmentar a imagem em objetos e com isso podemos rodar uma CNN em cada uma dessas seções da imagem e com isso detectar a posição.

![image alt text](https://i.imgur.com/GhQeawY.jpg)

O problema dessa técnica é que é preciso em rodar a rede neural em cada uma dessas múltiplas segmentações e isso é computacionalmente muito pesado o que a impede de rodar em tempo real em sistemas fracos, como estamos usando um sistema embarcado não dispomos de muito poder computacional.

Para isso usaremos algoritmos e arquiteturas que otimizam a velocidade da detecção em troca da precisão de detecção, como por exemplo a MobileNet e a SquezzyNet.

**Implementação**

No Raspberry Pi foram usados principalmente os seguintes programas:

	

* **Python 3.5** - Linguagem de programação base.

* **OpenCV 3.4.0**- Para adquirir e processar imagens da camera

* **Tensorflow 1.7.0** - Biblioteca para implementação de redes neurais

**	**

1. **Instalação de Depedencias**

No Raspberry Pi foi usada a imagem do Raspbian Strech (v2018-03-03) fornecida pelos desenvolvedores como sistema operacional. Primeiramente utilizaremos o sistema operacional para a ultima versão.

	

```shell
sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y clean
```


Com o Raspbian o Python 3.5 já vem instalado por padrão.

Instalando dependencias do sistema:

```shell
sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libcanberra-gtk*
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y python2.7-dev python3-dev
sudo apt-get install -y unzip wget
```


**Virtualenv**

Para fazer o gerenciamento de dependência do projeto é necessários instalar o virtualenv e criar um ‘environment’, dentro desse environment instalaremos os programas necessários
Instalação:

```shell
wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/.cache/pip
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.5
source /usr/local/bin/virtualenvwrapper.sh
source ~/.profile
```


Com o virtualenv instalado agora só falta criar o environment em que vamos instalar as dependências. Nesse exemplo usarei o nome ‘cv’:

	
```shell
mkvirtualenv cv -p python3
workon cv
```

**OpenCV**

O OpenCV (Open Source Computer Vision Library) é uma biblioteca de código aberto para visão computacional que será usada para obter a imagens da câmera e tratá-las para poder ser usada de forma adequada na rede neural.

Para compilar o OpenCV dentro do raspberry é necessário ter pelo menos um cartão SD de 16Gb e para acelerar o processo que geralmente demora ~6 horas vamos adicionar 1Gb de memoria swap para auxiliar na compilação:

No raspberry pi abra o arquivo ‘/etc/dphys-swapfile’ e editar a variável ‘CONF_SWAPSIZE’:

```shell
#set size to absolute value, leaving empty (default) then uses computed value
#you most likely don't want this, unless you have an special disk situation
#CONF_SWAPSIZE=100
CONF_SWAPSIZE=1024
```

Após isso é só resetar o serviço de swap, após o término da compilação é uma boa ideia voltar o valor ao normal (100)

```shell
sudo /etc/init.d/dphys-swapfile stop
sudo /etc/init.d/dphys-swapfile start
```


Para compilar o openCV para python é necessário a biblioteca NumPy

```shell
pip install numpy
```

Baixado o código fonte da última versão do OpenCV:


```shell
OPENCV_VERSION='3.4.0'
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
unzip opencv_contrib.zip
rm opencv.zip
rm opencv_contrib.zip
```
Agora temos que definir as configurações de compilação do OpenCV, como estamos trabalhando em sistema computacionalmente limitado o ideal é otimizar essas configurações o máximo possível, de acordo com esse [artigo [5]](https://www.theimpossiblecode.com/blog/build-faster-opencv-raspberry-pi3/) habilitando as FLAGS para suporte do ARM NEON e do VFPV3 conseguimos certa de ~30% a mais de performance em classificação de imagens usando a engine de redes neurais do Caffe disponíveis dentro do OpenCV.

```shell
cd ~/opencv-${OPENCV_VERSION}
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
	-D CMAKE_INSTALL_PREFIX=/usr/local \
	-D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-${OPENCV_VERSION}/modules \
	-D ENABLE_NEON=ON \
	-D ENABLE_VFPV3=ON \
	-D BUILD_TESTS=OFF \
	-D INSTALL_PYTHON_EXAMPLES=OFF \
	-D WITH_QT=OFF \
	-D WITH_GTK=ON \
	-D BUILD_EXAMPLES=OFF ..
sudo make -j4
sudo make install
sudo ldconfig
```


Após compilado com sucesso só precisamos linkar a biblioteca para dentro do nosso envoriment.

```shell
cd /usr/local/lib/python3.5/site-packages/
sudo mv cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/lib/python3.5/site-packages/cv2.so cv2.so
```

**Tensorflow**

Para instalar o tensorflow normalmente teriamos que compilar para armv7 no raspberry Pi, mas buscando na internet é possivel achar versões recentes já [pré-compiladas para Python 3.5 [6]](https://github.com/lhelontra/tensorflow-on-arm)

```shell
wget https://github.com/lhelontra/tensorflow-on-arm/releases/download/v1.7.0/tensorflow-1.7.0-cp35-none-linux_armv7l.whl
pip install tensorflow-1.7.0-cp35-none-linux_armv7l.whl
```

**imutils de pyimagesearch.com**

Um pacote que implementa algumas funções úteis e algumas otimizações para a obtenção e tratamento de imagens no OpenCV, leia mais [aqui [7]](https://www.pyimagesearch.com/2015/02/02/just-open-sourced-personal-imutils-package-series-opencv-convenience-functions/).

```shell
pip install imutils
```

**	**

**Referencias**

[1] [http://www.cbrobotica.org/wp-content/uploads/RulesLARC2017-SPL_HL.pdf](http://www.cbrobotica.org/wp-content/uploads/RulesLARC2017-SPL_HL.pdf)

[2] [https://pjreddie.com/darknet/yolov2/](https://pjreddie.com/darknet/yolov2/)

[3] [https://arxiv.org/abs/1602.07360](https://arxiv.org/abs/1602.07360) - SqueezyNet

[4] [https://arxiv.org/abs/1704.04861](https://arxiv.org/abs/1704.04861) - MobileNet

[5] [https://www.theimpossiblecode.com/blog/build-faster-opencv-raspberry-pi3/](https://www.theimpossiblecode.com/blog/build-faster-opencv-raspberry-pi3/)

[6] [https://github.com/lhelontra/tensorflow-on-arm/](https://github.com/lhelontra/tensorflow-on-arm/)

[7] [https://www.pyimagesearch.com/2015/02/02/just-open-sourced-personal-imutils-package-series-opencv-convenience-functions/](https://www.pyimagesearch.com/2015/02/02/just-open-sourced-personal-imutils-package-series-opencv-convenience-functions/)


