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

通信的目的是传送*消息(message)*.语音、文字、图像、视频等都是消息.

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

来自信源的信号常称为*基带信号*(即*基本频带信号*).
像计算机输出的代表各种文字或图像文件的数据信号都属于基带信号.

基带信号往往包含较多的低频分量,甚至有直流分量,而许多信道并不能传输这种低频分量或直流分量.
为了解决这一问题,就必须对基带信号进行*调制(modulation)*.

调制可分为两大类.

一类是仅仅对基带信号的波形进行变换,使它能够与信道特性相适应.
变换后的信号仍然是基带信号.这类调制称为基带调制.由于这种基带调制是把数字
信号转换为另一种形式的数字信号,因此大家更愿意把这种过程称为*编码(coding)*.

另一类调制则需要使用*载波(carrier)*进行调制,把基带信号的频率范围搬移到较高的频段,
并转换为模拟信号,这样就能够更好地在模拟信道中传输.
经过载波调制后的信号称为*带通信号*(即仅在一段频率范围内能够通过信道),而使用载波的调制称为*带通调制*.

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

=== 基本的带通调制方法

有三种基本的带通调制方法:
  - 调幅(AM):载波的振幅随基带数字信号而变化.例如,0或1分别对应于无载波或有载波输出.
  - 调频(FM):载波的频率随基带数字信号而变化.例如,0或1分别对应于频率$f_1$或$f_2$.
  - 调相(PM):即载波的初始相位随基带数字信号而变化.例如,0或1分别对应于相位0度或180度.

#cetz.canvas({
  import cetz.draw: *
  scale(y:80%)

  // 数据：0 1 0 0 1 1 1 0 0
  let bits = (0, 1, 0, 0, 1, 1, 1, 0, 0)
  let n = bits.len()
  
  // 绘图参数
  let x_step = 1.2        // 每个比特的宽度
  let amp = 0.5           // 正弦波振幅的一半
  let samples_per_bit = 40 // 每个比特采样的点数（越高越平滑）
  let row_gap = 2.0       // 行间距

  // Y轴位置定义
  let y_base = 0
  let y_am = -row_gap
  let y_fm = -row_gap * 2
  let y_pm = -row_gap * 3

  // 样式
  let style_sig = (stroke: (thickness: 1pt, paint: black))
  let style_text = (anchor: "east")

  // ==========================================
  // 1. 绘制左侧标签
  // ==========================================
  let label_x = -0.5
  content((label_x, y_base + 0.5), "基带信号", ..style_text)
  content((label_x, y_am), "调幅", ..style_text)
  content((label_x, y_fm), "调频", ..style_text)
  content((label_x, y_pm), "调相", ..style_text)

  // ==========================================
  // 2. 绘制基带信号 (Baseband - Digital)
  // ==========================================
  let pts = ()
  for (i, b) in bits.enumerate() {
    let x = i * x_step
    let y = if b == 1 { 1 } else { 0 } // 0~1 的方波
    
    // 绘制比特上方的数字
    content((x + x_step/2, 1.3), str(b))
    
    pts.push((x, y_base + y))
    pts.push(((i + 1) * x_step, y_base + y))
  }
  line(..pts, ..style_sig)

  // ==========================================
  // 3. 模拟信号生成函数
  // ==========================================
  // 为了让代码整洁，我们通过循环生成采样点
  
  // --- 调幅 (AM / ASK) ---
  // 规则：0 -> 振幅为0 (直线); 1 -> 振幅为A (正弦波)
  pts = ()
  let carrier_freq = 3.0 // 载波频率 (每个bit周期内的波数)
  
  for i in range(n * samples_per_bit + 1) {
    let t = i / samples_per_bit // 当前时间 (以bit为单位)
    let bit_idx = calc.min(calc.floor(t), n - 1)
    let current_bit = bits.at(int(bit_idx))
    let x = t * x_step
    
    let val = 0
    if current_bit == 1 {
      val = amp * calc.sin(2 * calc.pi * carrier_freq * t)
    } else {
      val = 0
    }
    pts.push((x, y_am + val))
  }
  line(..pts, ..style_sig)

  // --- 调频 (FM / FSK) ---
  // 规则：0 -> 低频; 1 -> 高频
  // 难点：相位必须连续 (Continuous Phase)，不能直接切换频率公式，否则波形会断裂
  pts = ()
  let freq_low = 1.5 // 0 对应的频率
  let freq_high = 3.5 // 1 对应的频率
  let current_phase = 0.0 // 相位累加器
  let dt = 1.0 / samples_per_bit
  
  for i in range(n * samples_per_bit + 1) {
    let t_global = i / samples_per_bit
    let bit_idx = calc.min(calc.floor(t_global), n - 1)
    let current_bit = bits.at(int(bit_idx))
    let x = t_global * x_step
    
    // 确定当前频率
    let f = if current_bit == 1 { freq_high } else { freq_low }
    
    // 累加相位: d_phase = 2 * pi * f * dt
    // 这里的 -calc.pi/2 是为了调整起始相位让波形好看（可选）
    let val = amp * calc.sin(current_phase - calc.pi/2) 
    pts.push((x, y_fm + val))
    
    // 更新相位给下一点使用
    current_phase += 2 * calc.pi * f * dt
  }
  line(..pts, ..style_sig)

  // --- 调相 (PM / PSK) ---
  // 规则：0 -> 相位0; 1 -> 相位180度 (反相)
  pts = ()
  let psk_freq = 2
  
  for i in range(n * samples_per_bit + 1) {
    let t = i / samples_per_bit
    let bit_idx = calc.min(calc.floor(t), n - 1)
    let current_bit = bits.at(int(bit_idx))
    let x = t * x_step
    
    // 相位偏移：如果是1，加 pi (180度)
    let phase_shift = if current_bit == 1 { calc.pi } else { 0 }
    
    // 这里不需要相位累加，因为PSK是在特定时刻跳变相位的
    // 为了匹配图示（起始向下），加个初始相位修正
    let val = amp * calc.sin(2 * calc.pi * psk_freq * t + phase_shift)
    pts.push((x, y_pm + val))
  }
  line(..pts, ..style_sig)
})

=== 信道的极限容量

从概念上讲,限制码元在信道上的传输速率的因素有以下两个:
  - 信道能够通过的频率范围
  - 信噪比

==== 信道能够通过的频率范围

具体的信道所能通过的频率范围总是有限的.信号中的许多高频分量往往不能通过信道.

如果信号中的高频分量在传输时受到衰减,那么在接收端收到的波形前沿和后沿就变得不那么
峭了,每一个码元所占的时间界限也不再是很明确的,而是前后都拖了“尾巴”.这样,在
接收端收到的信号波形就失去了码元之间的清晰界限.这种现象叫作*码间串扰*.


*奈氏准则*可以帮助处理码间串扰问题.

*奈氏准则*:带宽为$W$(Hz)的低通信道中,若不考虑噪声影响,则码元传输的最高速率是$2W$(码元/秒).
传输速率超过此上限,就会出现严重的码间串扰的问题,使接收端对码元的判决(即识别)成为不可能.

==== 信噪比

信噪比就是信号的平均功率和噪声的平均功率之比,常记为$S/N$.通常大家使用分贝(dB)表示信噪比:
$ "信噪比(dB)"=10 * lg(S/N)("dB") $

*香农公式*:信道的极限信息传输速率$C$:
$ C=W log_2(1+S/N)("bit/s") $
式中,$W$为信道的带宽(以Hz为单位),$S$为信道内所传信号的平均功率,$N$为信道内部的高斯噪声功率.

香农公式表明,信道的带宽或信道中的信噪比越大,信息的极限传输速率就越高.香农公式指出了信息传输速率的上限.
香农公式的意义在于:只要信息传输速率低于信道的极限信息传输速率,就一定存在某种办法来实现无差错的传输.

对于频带宽度已确定的信道,如果信噪比也不能再提高了,并且码元传输速率也达到了上限值,
那只有用编码的方法让每一个码元携带更多比特的信息量的方法来提高信息的传输速率.

== 物理层下的传输媒体

*传输媒体*是数据传输中发送接收两端之间的物理通路.可以分为两大类:
  - 导引型传输媒体:电磁波被引导着沿着固体媒体(如铜线或光纤)传播
  - 非导引型传输媒体:自由空间,电磁波的传输常被称为无线传输.

=== 导引型传输媒体

==== 双绞线

把两根互相绝缘的铜导线并排放在一起,用规则的方式绞合起来构成双绞线.绞合可以减少电磁干扰.
几乎所有电话都用双绞线连接到电话交换机,这段从用户电话机到交换机的双绞线称为*用户线*或*用户环路*.
通常将一定数量的双绞线捆成电缆,包上护套.现在以太网也常用这种线缆连接.

考虑到长距离高速度传输数据的需求,人们采用了增加绞合度与电磁屏蔽的方法.

#figure(
  table(
    columns: (auto, auto),
    
    // 表头
    table.header(
      [*类型*], [*屏蔽结构 / 描述*]
    ),

    // 数据行
    [*UTP*], [无屏蔽双绞线 (Unshielded Twisted Pair)],
    [*STP*], [屏蔽双绞线 (Shielded Twisted Pair) - 这是一个统称],
    [*F/UTP*], [*总屏蔽：* 铝箔 (Foil)\n*线对屏蔽：* 无],
    [*S/UTP*], [*总屏蔽：* 金属编织层 (Braid)，常用铜\n*线对屏蔽：* 无],
    [*SF/UTP*], [*总屏蔽：* 铝箔 + 金属编织层 (双层)\n*线对屏蔽：* 无],
    [*FTP* 或 *U/FTP*], [*总屏蔽：* 无\n*线对屏蔽：* 每一对线单独包裹铝箔],
    [*F/FTP*], [*总屏蔽：* 铝箔\n*线对屏蔽：* 每一对线单独包裹铝箔],
    [*S/FTP*], [*总屏蔽：* 金属编织层\n*线对屏蔽：* 每一对线单独包裹铝箔],
  ),
  caption: [双绞线屏蔽类型对照表],
)

#figure(
  table(
    // 列宽设置：前两列自动宽度，第三列占 1 份，第四列占 1.5 份（因为应用描述较长）
    columns: (auto, auto, auto, auto),
    
    // --- 表头 ---
    table.header(
      [*绞合线类别*], [*带宽*], [*线缆特点*], [*典型应用*]
    ),

    // --- 数据行 ---
    [3], [16 MHz], 
    [2对4芯双绞线], 
    [模拟电话; 传统以太网 (10 Mbit/s)],

    [5], [100 MHz], 
    [与3类相比增加了绞合度], 
    [传输速率 100 Mbit/s (距离 100 m)],

    [5E (超5类)], [125 MHz], 
    [与5类相比衰减更小], 
    [传输速率 1 Gbit/s (距离 100 m)],

    [6], [250 MHz], 
    [改善了串扰等性能, 可使用屏蔽双绞线], 
    [传输速率 10 Gbit/s (距离 35 $~$ 55 m)],

    [6A], [500 MHz], 
    [改善了串扰等性能, 可使用屏蔽双绞线], 
    [传输速率 10 Gbit/s (距离 100 m)],

    [7], [600 MHz], 
    [必须使用屏蔽双绞线], 
    [传输速率超过 10 Gbit/s, 距离 100 m],

    [8], [2000 MHz], 
    [必须使用屏蔽双绞线], 
    [传输速率 25 Gbit/s 或 40 Gbit/s, 距离 30 m],
  ),
  caption: [常用的绞合线的类别、带宽和典型应用],
)