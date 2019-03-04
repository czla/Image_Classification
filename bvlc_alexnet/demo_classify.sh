#!/usr/bin/env sh
# classify using alexnet

CAFFE_ROOT=/home/tjcv/zlchen/Project/caffe
EXAMPLE=/home/tjcv/zlchen/Project/caffe/examples/imgsnet
DATA=/home/tjcv/zlchen/Project/AlexNet/disease-dataset
IMAGE=$EXAMPLE/bvlc_alexnet/test/11.jpg

$CAFFE_ROOT/build/examples/cpp_classification/classification.bin $EXAMPLE/bvlc_alexnet/deploy.prototxt $EXAMPLE/bvlc_alexnet/caffe_alexnet_train_iter_20000.caffemodel $DATA/imagenet_mean.binaryproto $EXAMPLE/bvlc_alexnet/synset_words.txt $IMAGE
