## Visão

## ImageTagger

ImageTagger Original: https://imagetagger.bit-bots.de/
Projeto GitHub: https://github.com/bit-bots/imagetagger
Servidor do pequi: http://pequi.dynu.net:8000/

### Tutorial

**Como instanciar um servidor local**

```bash
git clone https://github.com/bit-bots/imagetagger.git
cd imagetagger
```

Install Python Dependencies:

```
pip3 install -r requirements.txt
```

Copy settings.py.example to settings.py in the imagetagger folder:

```
cp imagetagger/settings.py.example imagetagger/settings.py
```

and customize the settings.py.

The following settings should probably be changed:

```python
# Allowed Host headers this site can server
ALLOWED_HOSTS = ['127.0.0.1','192.168.0.201','localhost','0.0.0.0','pequi.tplinkdns.com','pequi.dynu.net']
```

Para desabilitar a confirmação de cadastro por email, customize o arquivo imagetagger/urls.py mudando as referencias de
```python
from registration.backends.hmac.views import RegistrationView
#...
url(r'^accounts/', include('registration.backends.hmac.urls'))
```
para
```python
from registration.backends.simple.views import RegistrationView
#...
url(r'^accounts/', include('registration.backends.simple.urls'))
```

For the database, postgresql is used. Install it by running `sudo apt install postgresql`

Initialize the database cluster with `sudo -iu postgres initdb --locale en_US.UTF-8 -D '/var/lib/postgres/data'`

To start the postgresql server, run `sudo systemctl start postgresql.service`. If the server should always be started on boot, run `sudo systemctl enable postgresql.service`.

Then, create the user and the database by running

`sudo -iu postgres psql`

and then, in the postgres environment

```
CREATE USER imagetagger PASSWORD 'imagetagger';
CREATE DATABASE imagetagger WITH OWNER imagetagger ENCODING UTF8;
```

where of course the password and the user should be adapted to the ones specified in the database settings in the settings.py.

To initialize the database, run `./manage.py migrate`

To create an administrator user, run `./manage.py createsuperuser`.

`./manage.py runserver 0.0.0.0:8000` starts the server with the configuration given in the settings.py file.


### Tipos de anotações

Para criar uma anotação crie um time e entre na pagina de perfil do time, no canto inferior direito clique em 'Create Format'

**Base**
Esse é o formato padrão do sistema, ele é aceito para importar anotações no próprio sistema
Base Format
```
%%content
```
Annotation format
```
%%imagename|%%type|{%%vector}|%%ifblurredb%%endif%%ifconcealedc%%endif
```
Vector format
```
"x%%count1": "%%x","y%%count1": "%%y",
```
Not in image format
```
%%imagename|%%type|not in image
```

**CSV**
Esse é o formato para exportar pra treinamento no Tensorflow Object Dection API
Base Format
```
filename,width,height,class,xmin,ymin,xmax,ymax%%content
```
Annotation format
```
%%imagename,%%imagewidth,%%imageheight,%%type%%vector
```
Vector format
```
,%%x,%%y
```
Not in image format
```
 
```
