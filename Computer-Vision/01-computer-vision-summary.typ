#import "../template/preamble.typ": *

= 计算机视觉概述

#knowtitle[Computer Vision (CV) is a branch of Artificial Intelligence (AI) that helps computers to interpret and understand visual information much like humans.]

== 应用概述

想象一下：你走进一间房间，一眼就能看出椅子在哪里、有几个人、窗外是晴天还是雨天。这一切，你的大脑在毫秒内完成。#key[计算机视觉（Computer Vision）] 的目标，就是让计算机也能从图像/视频中做到同样的事, 自动提取、分析并理解视觉信息。

它处于三个学科的交叉点：
- #key[图像处理]（Image Processing）：变换/增强图像
- #key[模式识别]（Pattern Recognition）：从数据中识别规律
- #key[人工智能]（Artificial Intelligence）：让机器"理解"

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  table.header(
    [任务],
    [定义],
    [输出形式],
    [典型应用],
  ),
  [图像分类], [识别图像中物体类别], [类别标签], [猫狗识别、验证码],
  [目标检测], [定位+分类多个目标], [Bounding Box + 类别], [行人检测、车辆识别],
  [语义分割], [每像素分配类别], [像素级类别图], [自动驾驶道路解析],
  [实例分割], [区分同类不同实例], [像素级实例掩码], [机器人抓取],
  [深度估计], [估计各点到相机距离], [深度图], [AR/VR、自动驾驶],
  [光流估计], [相邻帧像素运动向量场], [运动向量场], [-],
  [三维重建], [从2D图像恢复3D结构], [点云/网格], [文物数字化、地图建立],
)

/ 事件相机 (Event-based camera) : 一种仿生视觉传感器，也称动态视觉传感器（DVS，Dynamic Vision Sensor）。

在事件相机的每个像素处都有一个独立的光电传感模块，当该像素处的亮度变化超过设定阈值时，就会生成、输出事件数据（有时也称脉冲数据）。所有的像素都是独立工作的，所以事件相机的数据输出是异步的，在空间上呈现稀疏的特点。不同于传统相机以固定速率捕获图像帧，而是异步输出有关亮度变化信息的事件流。
