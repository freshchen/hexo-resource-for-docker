---
title: 数字图像处理习题
date: 2019-03-29
categories: others
top: 
---

### 考试习题

可能的考试习题，做个记录

##### 习题1 什么是图形的几何变换？举例怎么解决实际问题

图形的几何变换是指对图形的几何信息经过平移、比例、旋转等变换后产生新的图形，是图形在方向、尺寸和形
状方面的变换。

可以利用图形的几何变换，解决最值问题，创建动画，图形去噪等等

##### 习题2 已知一个像素A的坐标为（70，95），写出四个邻域中像素的坐标，如果还有另外一个像素B（78，90），分别计算像素A,B之间的D4距离和D8距离

领域坐标：(71, 95) (70, 96)(69,95)(70,94)

D4:13	D8:8

##### 习题3 写出实现下列功能的openGL函数

###### 1.当前3D图形向x轴平移10，向y轴平移-26，向z轴平移-4

```
glTranslatef(10.0f,-26.0f,-4.0f)
```

###### 2.当前3D图形沿x，y，z轴分别缩放0.5倍，3倍，4.5倍

```
glScaled(0.5f,3.0f,4.5f)
```

##### 习题4 二维空间的点坐标为（20，10），将其绕原点逆时针旋转30°，再继续绕原点顺时针旋转45°，最后该点的坐标是多少，写出变换的计算过程和结果

![](https://github.com/freshchen/freshchen.github.io/blob/master/images/post/image-homework.PNG?raw=true)

##### 习题5 一幅有噪声的图像，说明从频域空间，利用傅里叶变换对图像去噪，说明具体方法，说明截止半径大小对去噪结果的影响

[图像噪声](https://www.baidu.com/s?wd=%E5%9B%BE%E5%83%8F%E5%99%AA%E5%A3%B0&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)包含[高频信号](https://www.baidu.com/s?wd=%E9%AB%98%E9%A2%91%E4%BF%A1%E5%8F%B7&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)分量。通过傅里叶变换，将图像变换到频域上。在频域上通过[低通滤波](https://www.baidu.com/s?wd=%E4%BD%8E%E9%80%9A%E6%BB%A4%E6%B3%A2&tn=SE_PcZhidaonwhc_ngpagmjz&rsv_dl=gh_pc_zhidao)，可以滤到高频噪声。

截至半径太大或者太小都会使得去噪效果不好，要反复调参。