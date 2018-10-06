#Baseado no downloader original no imaggetagger
#Mas este cria threads para agilizar o processo e não baixa imagens já baixadas (mesmo convertida para .jpg)

import sys
import getpass
import shutil
import os
from lxml import html
try:
    import requests
except ImportError:
    print("Python3 requests is not installed. Please use e.g. pip3 install requests")
    sys.exit()

imageset = [160, 258, 196, 197, 168, 166, 2, 262, 261, 260, 20, 19, 21, 149, 233, 159, 81, 34, 155, 154, 156, 153, 35, 36, 33, 25, 5, 7, 12, 13, 14, 15, 16, 17, 18, 29, 30, 31, 32, 33]

print('N datasets: {}'.format(len(imageset)))

BaseUrl = "https://imagetagger.bit-bots.de" + "/"
user = "pequi"
password = "pequimecanico"
filename="data"
if not os.path.exists(os.getcwd() + '/' +filename):
    os.makedirs(os.getcwd()+'/'+filename)

loginpage = requests.get(BaseUrl)
csrftoken = loginpage.cookies['csrftoken']

cookies = {'csrftoken': csrftoken}
csrfmiddlewaretoken = csrftoken
data = {'username': user,
        'password': password,
        'csrfmiddlewaretoken': csrfmiddlewaretoken}
loggedinpage = requests.post(
    '{}user/login/'.format(BaseUrl),
    data=data,
    cookies=cookies,
    allow_redirects=False,
    headers={'referer': BaseUrl})

try:
	sessionid  = loggedinpage.cookies['sessionid']
except:
	print('Login failed')

cookies = {'sessionid' : sessionid}

import _thread
def _download_dataset(current_imageset):
  error = False
  current_imageset = str(current_imageset)
  if not os.path.exists(os.path.join(os.getcwd(), filename, current_imageset)):
    os.makedirs(os.path.join(os.getcwd(),filename,current_imageset))

  page = requests.get("{}images/imagelist/{}/".format(BaseUrl,
                                                      current_imageset),
                                                      cookies = cookies)
  if page.status_code == 404:
      print("In Imageset {} was an error. The server returned page not found.".format(current_imageset))
      errorlist.append(current_imageset)
      return
  images = page.text.replace('\n','')
  images = images.split(',')
  for index,image in enumerate(images):
      if image == '':
          continue
      if (os.path.isfile(os.path.join(filename, current_imageset, image.split('?')[1]))):
          continue
      #verifica se ja existe uma imagem convertida pra .jpg baixada
      imgname = (image.split('?')[1]).split('.')
      imgname[-1] = 'jpg'
      imgname = '.'.join(imgname)
      if (os.path.isfile(os.path.join(filename, current_imageset, imgname))):
          continue
      #print(imgname)
      r = requests.get(BaseUrl+image[1:],
                   data=data,
                   cookies=cookies,
                   allow_redirects=False,
                   headers={'referer': BaseUrl},
                   stream = True)
      if r.status_code == 404:
          print("In Imageset {} was an error. The server returned page not found.".format(current_imageset))
          errorlist.append(current_imageset)

          error = True
          continue
      image = image.split('?')[1]
      with open(os.path.join(filename, current_imageset, image), 'wb') as f:
          r.raw.decode_content = True
          shutil.copyfileobj(r.raw, f)
          sys.stdout.flush()
          print("{}Image {} / {} has been downloaded from imageset {}".format("\r",index+1,len(images)-1,current_imageset),end="")
  if not error:
      print('\nImageset {} has been downloaded.'.format(current_imageset))

for i in imageset:
  _thread.start_new_thread(_download_dataset, (i,))

while 1:
   pass
