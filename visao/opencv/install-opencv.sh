##########################################
# INSTALL OPENCV ON RASPBERRY PI - PEQUI #
##########################################

# |         THIS SCRIPT IS TESTED CORRECTLY ON       		                     |
# |-----------------------------------------------=----------------------------------|        
# | OS             		  | Model         |OpenCV       | Test | Last test   |
# |-------------------------------|---------------|-------------|------|-------------|
# | Raspbian-Scratch-2018-03-03   | RPi 3 B v1.2  |OpenCV 3.4.0 | OK   | 12 Apr 2018 |
# | Raspbian-Scratch-2018-03-03   | RPi 1 B+ v1.2 |OpenCV 3.4.0 | OK   | 13 Apr 2018 |

# VERSION TO BE INSTALLED

OPENCV_VERSION='3.4.0'

# 1. KEEP RASP UP TO DATE

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade
sudo apt-get -y autoremove
sudo apt-get -y clean


# 2. INSTALL THE DEPENDENCIES

sudo apt-get install -y build-essential cmake pkg-config
sudo apt-get install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
sudo apt-get install -y libxvidcore-dev libx264-dev
sudo apt-get install -y libgtk2.0-dev libgtk-3-dev
sudo apt-get install -y libcanberra-gtk*
sudo apt-get install -y libatlas-base-dev gfortran
sudo apt-get install -y python2.7-dev python3-dev
sudo apt-get install -y unzip wget


# 3. INSTALL VIRTUALENV

wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo python3 get-pip.py
sudo pip install virtualenv virtualenvwrapper
sudo rm -rf ~/.cache/pip
export WORKON_HOME=$HOME/.virtualenvs
export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3.5
source /usr/local/bin/virtualenvwrapper.sh
source ~/.profile
mkvirtualenv cv -p python3
workon cv
pip install numpy

# 4. INSTALL THE LIBRARY
cd ~
wget -O opencv.zip https://github.com/opencv/opencv/archive/${OPENCV_VERSION}.zip
unzip opencv.zip
wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/${OPENCV_VERSION}.zip
unzip opencv_contrib.zip
rm opencv.zip
rm opencv_contrib.zip
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


# 5. LINKING LIBRARY ON ENVORIMENT

cd /usr/local/lib/python3.5/site-packages/
sudo mv cv2.cpython-35m-arm-linux-gnueabihf.so cv2.so
cd ~/.virtualenvs/cv/lib/python3.5/site-packages/
ln -s /usr/local/lib/python3.5/site-packages/cv2.so cv2.so

