import os
import sys
from PIL import Image, ImageFile
ImageFile.LOAD_TRUNCATED_IMAGES = True
import shutil
for root, dirs, files in os.walk("data", topdown=False):
  for fn in files:
    if(fn.split('.')[-1].lower() != 'jpg' and fn.split('.')[-1].lower() != 'jpeg'):
      name = fn.replace('.png', '')
      name = name.replace('.PNG', '')
      jpgpath = os.path.join(root,(name+'.jpg'))
      pngpath = os.path.join(root,fn)
      if(not os.path.isfile(jpgpath)):
        im = Image.open(pngpath)
        rgb_im = im.convert('RGB')
        rgb_im.save(jpgpath, 'JPEG')
      os.remove(pngpath)
  print(root)
