FROM tensorflow/tensorflow:1.15.2-gpu-py3

RUN apt-get install -y git wget unzip libsm6 libxext6 libxrender-dev
RUN pip3 install tensorflow==1.15.2 cython pillow lxml jupyter matplotlib opencv-python pandas
RUN pip install tensorflow==1.15.2 pandas

RUN mkdir tensorflow && \
cd tensorflow && \
git clone https://github.com/tensorflow/models.git && \
cd models/research && \
python setup.py build && \
python setup.py install

RUN cd / && \
mkdir pre-trained-model && \
cd pre-trained-model && \
wget http://download.tensorflow.org/models/object_detection/ssd_inception_v2_coco_2018_01_28.tar.gz && \
tar -xzf ssd_inception_v2_coco_2018_01_28.tar.gz

RUN cd / && \
git clone https://github.com/cocodataset/cocoapi.git && \
cd cocoapi/PythonAPI && \
make && \
cp -r pycocotools /tensorflow/models/research/


RUN cd /tensorflow/models/research && \
wget -O protobuf.zip https://github.com/google/protobuf/releases/download/v3.0.0/protoc-3.0.0-linux-x86_64.zip && \
unzip protobuf.zip && \
cd /tensorflow/models/research/ && \
./bin/protoc object_detection/protos/*.proto --python_out=.


RUN cd /opt && \
git clone https://github.com/Paperspace/DataAugmentationForObjectDetection.git

ENV PYTHONPATH /tensorflow/models/research:/tensorflow/models/research/slim:/tensorflow/models/research/object_detection:/opt/DataAugmentationForObjectDetection
