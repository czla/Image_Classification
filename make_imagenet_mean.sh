#!/usr/bin/env sh
# Compute the mean image from the imagenet training lmdb
# N.B. this is available in data/ilsvrc12

EXAMPLE=/home/tjcv/zlchen/Project/caffe/examples/imgsnet
DATA=/home/tjcv/zlchen/Project/AlexNet/disease-dataset
TOOLS=/home/tjcv/zlchen/Project/caffe/build/tools

$TOOLS/compute_image_mean $EXAMPLE/ilsvrc12_train_lmdb \
  $DATA/imagenet_mean.binaryproto

echo "Done."
