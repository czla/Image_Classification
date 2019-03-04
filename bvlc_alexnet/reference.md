## 1. 准备数据集 
* 路径：`$path/to/dataset/dataset_name`
* 结构：
|-train
    |-classname1
        |-filename1.jpg
        |-filename2.jpg
        ...
    |-classname1
        |-filename1.jpg
        |-filename2.jpg
        ...
    ...
|-val
    |-classname1
        |-filename1.jpg
        |-filename2.jpg
        ...
    |-classname1
        |-filename1.jpg
        |-filename2.jpg
        ...
    ...
|-train.txt(图片路径+空格+对应类别下标(从0开始)，见3)
|-val.txt
|-imagenet_mean.binaryproto(均值文件，见3)

## 2.数据转换成lmdb格式  
* `cd $CAFFE_ROOT`
* `mkdir examples/imgsnet`
* `cp examples/imagenet/create_imagenet.sh examples/imgsnet/`
* revise create_imagenet.sh
    >EXAMPLE=/home/blabla/caffe/examples/imgsnet/ //刚才新建的文件夹
    >DATA=/home/blabla/caffe/examples/imgs/data/ //存放图片数据的文件夹
    >TRAIN_DATA_ROOT=/home/blabla/dataset_name/train //训练图片文件夹
    >VAL_DATA_ROOT=/home/blabla/dataset_name//val //测试图片文件夹
    >RESIZE=true //让图片resize 为同样大小，下面大小自己修改就行。 
* `./examples/imgsnet/create_imagenet.sh`,会在$EXAMPLE里生成2个LMDB文件 

## 3.生成均值文件  
* `cd $CAFFE_ROOT`
* `cp examples/imagenet/make_imagenet_mean.sh examples/imgsnet/`
* revise make_imagenet_maen.sh
    >EXAMPLE=/home/blabla/caffe/examples/imgsnet/ //刚才新建的文件夹
    >DATA=/home/blabla/caffe/examples/imgs/data/ //存放图片数据的文件夹
* `./examples/imgsnet/make_imagenet_mean.sh`,会在$DATA里生成.binaryproto均值文件

## 4.配置网络
* `cd $CAFFE_ROOT`
* `cp -r models/bvlc_alexnet examples/imgsnet/`
* `cd examples/imgsnet/`revise`solver.prototxt` and `train_val.prototxt`

#### 4.1 revise `solver.prototxt`
    >net: "/home/balbla/caffe/examples/imgsnet/bvlc_alexnet/train_val.prototxt" 
    >test_iter : 160 //测试迭代次数 
    >test_interval : 5000 //多少次迭代测试一次 
    >base_lr : 0.001 //基础学习率 
    >lr_policy : "step" 
    >gamma: 0.1 
    >stepsize : 100000 
    >display: 20 //多少次迭代显示一次 
    >max_iter : 20000 //一共迭代多少次 
    >momentum : 0.9 
    >weight_decay : 0.0005 
    >snapshot : 20000 //多少次迭代保存一次快照 
    >snapshot_prefix : "/home/alps/caffe/examples/imgsnet/bvlc_alexnet/caffe_alexnet_train" //快照保存位置（也是结果的位置） 
    >solver_mode : GPU

#### 4.2 revise `train_val.prototxt`
    >mean_file : "/home/blabla/dataset_name/imagenet_mean.binaryproto //这个是上面生成的均值文件位置 
    >source : "/home/balbla/caffe/examples/imgsnet/ilsvrc12_train_lmdb" //这个是上面生成的 lmdb文件位置
    >name : "fc8"
    >num_output:12

## 5.训练网络
* `cd $CAFFE_ROOT`
* `./build/tools/caffe train --solver=/home/balbla/caffe/examples/imgsnet/bvlc_alexnet/solver.prototxt 2>&1 | tee logfile.log`,模型保存在`imgsnet/bvlc_alexnet`路径下

## 6.测试网络
* `cd imgsnet/bvlc_alexnet`,建立文件`labels.txt`,按类别下标排序写出类名
* 建立demo_classify.sh,测试命令：
    >/home/blabla/caffe/build/examples/cpp_classification/classification.bin /home/blabla/bvlc_alexnet/deploy.prototxt myiter_20000.caffemodle /home/blabla/dataset_name/imagenet_mean.binaryproto labels.txt test.jpg
