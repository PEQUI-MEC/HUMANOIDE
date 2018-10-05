## Visão

## Treinamento

Para treinar a rede foi usado o [Tensorflow Object Detection API](https://github.com/tensorflow/models/tree/master/research/object_detection])
E para acelerar o tempo treinamento foi usado a [API de Machine Learning](https://cloud.google.com/products/ai/) do Google Cloud

* Tensorflow 1.11.0
* Python 3

### Tutorial:

**Tensorflow Object Detection API**  
Para instalatar a Tensorflow Object Detection API siga este tutorial: https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/installation.md
Instale também as metricas da COCO API (incluido no tutorial)
Adicione também o caminho da pasta no seu PYTHONPATH (incluido no tutorial)

**Google Cloud**  
Se cadastre no google cloud
https://cloud.google.com/
Dentro do [console](https://console.cloud.google.com) crie um projeto, nesse tutorial supor o nome 'humanoid_project'

Ainda no console habilite as APIs [Storage](https://console.cloud.google.com/storage/) e [Machine Learning](https://console.cloud.google.com/apis/api/ml.googleapis.com/)

No console do [Storage](https://console.cloud.google.com/storage/) crie um bucket(intervalo), nesse tutorial vamos supor o nome 'humanoid_bucket'.
```
#Crie uma variável no bash para facilitar a execução dos comandos abaixo
export YOUR_GCS_BUCKET=humanoid_bucket
```
Dentro dele vamos criar uma pasta para guardar o dataset e as configurações da rede, nesse tutorial vamos supor o nome 'data'.

Instale o gcloud sdk no seu computador https://cloud.google.com/sdk/install

Configure o gcloud sdk para usar seu projeto como padrão, use seu project ID (visto nas configurações do projeto no console)
```bash
# This command needs to be run once to allow your local machine to access your
# GCS bucket.
gcloud auth application-default login
```
```bash
gcloud config set project humanoid-210523
```

**Preparação do dataset**  
As fotos classificadas devem estar nesta pasta da seguinte forma:
```bash
├── training
│   ├── images
│   │   ├── train
│   │   │    ├── image1.jpg
│   │   │    ├── image2.jpg
│   │   │    ├── ...
│   │   ├── test
│   │   │    ├── image101.jpg
│   │   │    ├── image201.jpg
│   │   │    ├── ...
│   ├── test_labels.csv
│   ├── train_labels.csv
```
As labels/tags devem estar em csv no seguinte formato:
```csv
filename,width,height,class,xmin,ymin,xmax,ymax
cam_image2.jpg,960,540,ball,312,30,485,249
cam_image2.jpg,960,540,ball,514,24,694,245
cam_image2.jpg,960,540,robot,305,263,489,519
cam_image3.jpg,960,540,goal,515,267,704,523
...
```
Para criar os arquivos .record que a API do rentsorflow requer basta rodar os seguintes comandos:
Edite a função *class_text_to_int()* no arquivo *training/generate_tfrecord.py* com as labels do dataset:
```python
#...
# TO-DO replace this with label map
def class_text_to_int(row_label):
    if row_label == 'ball':
        return 1
    elif row_label == 'robot':
        return 2
    elif row_label == 'goal':
        return 3
    elif row_label == 'goalpost':
        return 4
    else:
        None
#...
```
Gerar dados de treinamento:
```bash
 python generate_tfrecord.py --csv_input=images/train_labels.csv --image_dir=images/train --output_path=train.record
```
Gerar dados de teste:
```bash
python generate_tfrecord.py --csv_input=images/test_labels.csv  --image_dir=images/test --output_path=test.record
```
Copie os dados para a google cloud
```
gsutil cp train.record gs://${YOUR_GCS_BUCKET}/data/
gsutil cp test.record gs://${YOUR_GCS_BUCKET}/data/
```

**Configuração do modelo**  
O tensorflow disponibiliza um conjunto de modelos já pretreinados no COCO dataset para treinamento.
https://github.com/tensorflow/models/blob/master/research/object_detection/g3doc/detection_model_zoo.md
Baixe o modelo adequado para o seu embarcado, para maior velocidade:
[ssdlite_mobilenet_v2_coco](http://download.tensorflow.org/models/object_detection/ssdlite_mobilenet_v2_coco_2018_05_09.tar.gz)
E extraia a root dentro da pasta *images/ssdlite_mobilenet_v2/*
Dentro da pasta crie um arquivo chamado label_map.pbtxt, com as labels do dataset:
```json
item {
  id: 1
  name: 'ball'
}

item {
  id: 2
  name: 'robot'
}

item {
  id: 3
  name: 'goal'
}

item {
  id: 4
  name: 'goalpost'
}
```
Baixe um [arquivo de configuração](https://github.com/tensorflow/models/blob/master/research/object_detection/samples/configs/) de acordo com a rede baixada, altere de acordo com as configurações e numero de imagens do dataset:
```json
model {
  ssd {
    num_classes: 4
    ...
    }
    ...
}

train_config: {
  batch_size: 24
  optimizer {
    rms_prop_optimizer: {
      learning_rate: {
        exponential_decay_learning_rate {
          initial_learning_rate: 0.004
          decay_steps: 10000
          decay_factor: 0.95
        }
      }
      momentum_optimizer_value: 0.9
      decay: 0.9
      epsilon: 1.0
    }
  }
  fine_tune_checkpoint: "gs://humanoid_bucket/data/model.ckpt"
  fine_tune_checkpoint_type:  "detection"
  # Note: The below line limits the training process to 200K steps, which we
  # empirically found to be sufficient enough to train the pets dataset. This
  # effectively bypasses the learning rate schedule (the learning rate will
  # never decay). Remove the below line to train indefinitely.
  num_steps: 80000
  data_augmentation_options {
    random_horizontal_flip {
    }
  }
  data_augmentation_options {
    ssd_random_crop {
    }
  }
}

train_input_reader: {
  tf_record_input_reader {
    input_path: "gs://humanoid_bucket/data/train.record"
  }
  label_map_path: "gs://humanoid_bucket/data/label_map.pbtxt"
}

eval_config: {
  num_examples: 1000
  # Note: The below line limits the evaluation process to 10 evaluations.
  # Remove the below line to evaluate indefinitely.
  max_evals: 25
}

eval_input_reader: {
  tf_record_input_reader {
    input_path: "gs://humanoid_bucket/data/test.record"
  }
  label_map_path: "gs://humanoid_bucket/data/label_map.pbtxt"
  shuffle: true
  num_readers: 1
}
```
Copie os arquivos para o gcloud storage
```bash
#from visao/traning/ssdlite_mobilenet_v2
gsutil cp * gs://${YOUR_GCS_BUCKET}/data/
```

**Invocando a Machine Learning API**  
No bucket crie uma pasta chamada model_dir, que será onde será salvo o modelo treianado
Seu bucket a esse ponte deve estar dessa forma:
```lang-none
+ ${YOUR_GCS_BUCKET}/
  + data/
    - faster_rcnn_resnet101_pets.config
    - model.ckpt.index
    - model.ckpt.meta
    - model.ckpt.data-00000-of-00001
    - pet_label_map.pbtxt
    - pet_faces_train.record-*
    - pet_faces_val.record-*
  + model_dir/
```
Vá para sua pasta do Tensorflow Object Detection API e entre em models/research no bash e execute o seguinte comando para compactar a api em uma forma compativel com o GCLOUD MACHINE LEARNING API
```bash
# From tensorflow/models/research/
bash object_detection/dataset_tools/create_pycocotools_package.sh /tmp/pycocotools
python setup.py sdist
(cd slim && python setup.py sdist)
```
Isso vai criar os seguinte pacotes python dist/object_detection-0.1.tar.gz, slim/dist/slim-0.1.tar.gz, and /tmp/pycocotools/pycocotools-2.0.tar.gz.

Copie o arquivo de configuração visao/training/gcloud_config/cloud.yml para models/research/gcloud_config/cloud.yml

Volte para pasta training e execute o seguinte comando para iniciar o treinamento
```bash
# From tensorflow/models/research/
gcloud ml-engine jobs submit training object_detection_`date +%m_%d_%Y_%H_%M_%S` \
    --runtime-version 1.10 \
    --job-dir=gs://${YOUR_GCS_BUCKET}/model_dir \
    --packages dist/object_detection-0.1.tar.gz,slim/dist/slim-0.1.tar.gz,/tmp/pycocotools/pycocotools-2.0.tar.gz \
    --module-name object_detection.model_main \
    --region us-east1 \
    --config gcloud_config/cloud.yml \
    -- \
    --model_dir=gs://${YOUR_GCS_BUCKET}/model_dir \
    --pipeline_config_path=gs://${YOUR_GCS_BUCKET}/data/ssdlite_mobilenet_v2_coco.config
```
Para acompanhar o treinamento no tensorboard execute:
```bash
tensorboard --logdir=gs://${YOUR_GCS_BUCKET}/model_dir
```
Para monitorar o status de cada job: https://console.cloud.google.com/mlengine/jobs
Para o live logging
```bash
gcloud ml-engine jobs list
#JOB id do comando acima
gcloud ml-engine jobs stream-logs ${JOB_ID}
```
