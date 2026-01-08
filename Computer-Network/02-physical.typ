#import "../template/components.typ": card
#import "@preview/cetz:0.3.4"

#set grid(
  inset: 2pt,
  align: center,
)

= 物理层

== 数据通信的基础知识

一个通信系统可以划分成三个部分:*源系统*,*传输系统*,*目的系统*.

源系统包含两部分:*源点*,*发送器*.
  - 源点产生数据.又称源站或信源.
  - 发送器将数据编码发送出去.

目的系统包含两部分:*接收器*,*终点*.
  - 接收器接收数据,将数据解码.
  - 终点接受解码后的数据.又称目的站或信宿.

通信的目的是传送*消息(message)*.话音、文字、图像、视频等都是消息.

*数据(data)*是运送消息的实体.

*信号(signal)*则是数据的电气或电磁的表现.信号分为两大类:
  - 模拟信号:连续的
  - 数字信号:离散的

=== 信道

*信道(channel)*一般都是用来表示向某一个方向传送信息的媒体.
一条通信电路往往包含一条发送信道和一条接收信道.
信道和电路并不等同.

通信有三种方式,这里举例解释:
  - *单工通信*:祝磊讲课单方面对我们输出
  - *半双工通信*:对讲机
  - *全双工通信*:打电话

=== 常用编码方式

常用4种编码方式:
  - 不归零制:正电平代表1,负电平代表0
  - 归零制:正脉冲代表1,负脉冲代表0
  - 曼彻斯特编码:位周期中心的向上跳变代表0,位周期中心的向下跳变代表1.但也可反过来定义
  - 差分曼彻斯特编码:在每一位的中心处始终都有跳变.位开始边界有跳变代表0,而位开始边界没有跳变代表1

#cetz.canvas({
  import cetz.draw: *
  scale(y:80%)

  let bits = (1, 0, 0, 0, 1, 0, 0, 1, 1, 1)
  let n = bits.len()
  
  let x_step = 1.2    // 水平宽度
  let y_high = 0.8    // 信号振幅 (High = +0.8, Low = -0.8)
  let row_gap = 2   // 【重要】增加行间距，防止正负脉冲重叠
  
  // 各行的基准线 (Base line)
  let y_nrz = 0
  let y_rz = -row_gap + 0.5 
  let y_man = -row_gap * 2
  let y_diff = -row_gap * 3

  let style_grid = (stroke: (paint: gray, dash: "dashed", thickness: 0.5pt))
  let style_sig = (stroke: (thickness: 1pt, paint: black))
  
  // ------------------------------------------------
  // 1. 绘制网格背景
  // ------------------------------------------------
  // 灰色背景块
  for i in range(n) {
    if calc.rem(i, 2) == 1 {
      rect(
        (i * x_step, y_diff - 0.8), 
        ((i + 1) * x_step, y_high + 0.8), 
        fill: rgb("f2f2f2"), 
        stroke: none
      )
    }
  }

  // 垂直虚线和顶部数字
  for i in range(n + 1) {
    line((i * x_step, y_diff - 0.8), (i * x_step, y_high + 0.8), ..style_grid)
    if i < n {
      content(
        ((i + 0.5) * x_step, y_high + 0.5), 
        strong(str(bits.at(i)))
      )
    }
  }

  // ------------------------------------------------
  // 2. 绘制左侧标签
  // ------------------------------------------------
  let label_x = -0.5
  content((label_x, y_high + 0.5), "比特流", anchor: "east")
  
  // NRZ 基准在 0~1 之间
  content((label_x, y_nrz + y_high/2), "不归零制", anchor: "east")
  
  // RZ 基准就是 Base 线
  content((label_x, y_rz), "归零制", anchor: "east")
  
  // 曼彻斯特等
  content((label_x, y_man + y_high/2), "曼彻斯特", anchor: "east")
  content((label_x, y_diff + y_high/2), "差分曼彻斯特", anchor: "east")

  // ------------------------------------------------
  // 3. 信号绘制
  // ------------------------------------------------

  // --- 不归零制 (NRZ) ---
  let pts = ()
  for (i, b) in bits.enumerate() {
    let y = if b == 1 { y_high } else { 0 }
    pts.push((i * x_step, y_nrz + y))
    pts.push(((i + 1) * x_step, y_nrz + y))
  }
  line(..pts, ..style_sig)

  // --- 归零制 (RZ) [修正：双极性] ---
  // 定义：Base -> High/Low -> Base
  pts = () 
  for (i, b) in bits.enumerate() {
    let base = y_rz
    let x_start = i * x_step
    let x_1 = (i + 0.25) * x_step
    let x_2 = (i + 0.75) * x_step
    let x_end = (i + 1) * x_step
    
    // 为了画出完美的方波，我们需要显式定义拐点
    
    // 1. 起点 (Base)
    pts.push((x_start, base)) 
    
    if b == 1 {
        // 正脉冲: Base -> High -> Base
        pts.push((x_1, base))
        pts.push((x_1, base + y_high)) // 垂直向上到 High
        pts.push((x_1, base + y_high))   // 保持 High
        pts.push((x_2, base + y_high))
        pts.push((x_2, base))            // 垂直向下回 Base
    } else {
        // 负脉冲: Base -> Low -> Base
        pts.push((x_1, base))
        pts.push((x_1, base - y_high)) // 垂直向下到 Low
        pts.push((x_1, base - y_high))   // 保持 Low
        pts.push((x_2, base - y_high))
        pts.push((x_2, base))            // 垂直向上回 Base
    }
    
    // 2. 后半周期保持 Base 直到结束
    pts.push((x_end, base))
  }
  line(..pts, ..style_sig)

  // --- 曼彻斯特 ---
  pts = ()
  for (i, b) in bits.enumerate() {
    let base = y_man
    if b == 1 {
      pts.push((i * x_step, base + y_high))
      pts.push(((i + 0.5) * x_step, base + y_high))
      pts.push(((i + 0.5) * x_step, base))
      pts.push(((i + 1) * x_step, base))
    } else {
      pts.push((i * x_step, base))
      pts.push(((i + 0.5) * x_step, base))
      pts.push(((i + 0.5) * x_step, base + y_high))
      pts.push(((i + 1) * x_step, base + y_high))
    }
  }
  line(..pts, ..style_sig)

  // --- 差分曼彻斯特 ---
  pts = ()
  let current_level = 1 
  let base = y_diff
  for (i, b) in bits.enumerate() {
    if b == 0 { current_level = 1 - current_level } 
    pts.push((i * x_step, base + current_level * y_high))
    pts.push(((i + 0.5) * x_step, base + current_level * y_high))
    current_level = 1 - current_level
    pts.push(((i + 0.5) * x_step, base + current_level * y_high))
    pts.push(((i + 1) * x_step, base + current_level * y_high))
  }
  line(..pts, ..style_sig)
})