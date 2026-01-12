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

==== 同轴电缆

同轴电缆由内导体铜质芯线(单股实心线或多股绞合线)、绝缘层、网状编织的外导体屏蔽层(也可以是单股的)以及绝缘保护套层所组成.

#strike("NH5:本来想用代码画图,但是跟Gemini,Typst吉列的豆蒸后选择直接使用课本原图截图")

#figure(
  image("assets/02-coaxial-cable.png"),
  caption: "同轴电缆的结构"
)

==== 光缆

光纤通信就是利用光导纤维(以下简称为光纤)传递光脉冲来进行通信的.光纤是光纤通信的传输媒体.
有光脉冲相当于1,而没有光脉冲相当于0.由于可见光的频率非常高,约为10MHz的量级,
因此一个光纤通信系统的传输带宽远远大于目前其他各种传输媒体的带宽.

光纤主要由纤芯(高折射率)和包层(低折射率)构成双层通信圆柱体.光波通过纤芯进行传导的.
光线在纤芯中传输的方式是不断地全反射.
#figure(
  grid(
    columns: (1fr, auto),
    align: horizon,
    figure(
      image("assets/02-optical-fiber.png"),
      caption: "光纤的结构",
      numbering: none
    ),
    figure(
      cetz.canvas({
        import cetz.draw: *

        // 定义画布尺寸和样式
        let width = 12
        let height = 2.5
        let boundary-y = 1
        let boundary-stroke = (thickness: 2pt, paint: luma(150))
        let center-stroke = (thickness: 0.5pt, paint: black, dash: "dash-dotted")
        let ray-stroke = (thickness: 1.2pt, paint: black)

        // 绘制上下边界（包层）
        line((-width/2, boundary-y*2), (width/2, boundary-y*2), stroke:boundary-stroke)
        line((-width/2, boundary-y), (width/2, boundary-y), stroke: boundary-stroke)
        line((-width/2, -boundary-y), (width/2, -boundary-y), stroke: boundary-stroke)
        line((-width/2, -boundary-y*2), (width/2, -boundary-y*2), stroke:boundary-stroke)

        // 绘制中心轴线
        line((-width/2, 0), (width/2, 0), stroke: center-stroke)

        // 绘制光线路径（Zigzag）
        // 定义反射点
        let p0 = (-width/2 + 0.5, 0)
        let p1 = (-3, boundary-y - 0.2)
        let p2 = (0, -boundary-y + 0.2)
        let p3 = (3, boundary-y - 0.2)
        let p4 = (width/2 - 0.5, -0.4)

        line(
          p0, p1, p2, p3, p4,
          stroke: ray-stroke,
          mark: (end: ">", fill: black) // 在末端添加箭头
        )
      }),
      caption: [光在光纤中传播],
      numbering: none
    )
  ),
  caption: "光纤结构及光的传播"
)

只要从纤芯中射到纤芯表面的光线的入射角大于某个临界角度,就可产生全反射.
因此,可以存在多条不同角度入射的光线在一条光纤中传输.这种光纤就称为*多模光纤*.
多模光纤只适合于近距离传输.

若光纤的直径减小到只有一个光的波长,则光纤可使光线一直向前传播,而不会产生多次反射.这样的光纤称为*单模光纤*.
在光纤通信中常用的三个波段的中心分别位于850nm,1300nm和1550nm.后两种情况的衰减都较小.850nm波段的衰减较大,但在此波段的其他特性均较好.

光纤不仅具有通信容量非常大的优点,而且还具有其他的一些特点:
  - 传输损耗小,中继距离长,对远距离传输特别经济
  - 抗雷电和电磁干扰性能好这在有大电流脉冲干扰的环境下尤为重要
  - 无串音干扰,保密性好,也不易被窃听或截取数据
  - 体积小,重量轻.这在现有电缆管道已拥塞不堪的情况下特别有利

=== 非导引型传输媒体

无线传输可用的频段很广.

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: horizon,
    table.header(
      [英文缩写],
      [英文全称 / 前缀含义],
      [中文名称],
      [频率范围]
    ),
    [LF], [Low Frequency], [低频], [30kHz \~ 300kHz],
    [MF], [Medium Frequency], [中频], [300kHz \~ 3MHz],
    [HF], [High Frequency], [高频], [3MHz \~ 30MHz],
    [VHF], [Very High Frequency], [甚高频], [30MHz \~ 300MHz],
    [UHF], [Ultra High Frequency], [特高频], [300MHz \~ 3GHz],
    [SHF], [Super High Frequency], [超高频], [3GHz \~ 30GHz],
    [EHF], [Extremely High Frequency], [极高频], [30GHz \~ 300GHz],
    [THF], [Tremendously High Frequency], [*目前尚无标准译名*], [300GHz \~ 3000GHz],
  ),
  caption: "无线电频谱频段名称与范围"
)

无线电微波通信在当前的数据通信中占有特殊重要的地位.微波的频率范围为300MHz\~300 GHz(波长1m\~1mm),但主要使用2GHz\~40GHz的频率范围.

当利用无线信道传送数字信号时,必须使误码率(即比特错误率)不大于可容许的范围:
  - 对于给定的调制方式和数据率,信噪比越大,误码率就越低
  - 对于同样的信噪比,具有更高数据率的调制技术的误码率也更高
  - 如果移动用户在进行通信时还在不断改变自己的地理位置,就会引起无线信道特性的改变,因而信噪比和误码率都会发生变化
    - 因此,用户的移动设备的物理层应当有一定的自适应能力,可以根据所处的环境特性选择最合适的调制和编码技术

为实现远距离通信必须在一条微波通信信道的两个终端之间建立若干个中继站.中继站把前一站送来的信号经过放大后再发送到下一站,这种通信方式称为*"微波接力"*.大多数长途电话业务使用4GHz\~6GHz的频率范围.

要使用某一段无线电频谱进行通信,通常必须得到本国政府有关无线电频谱管理机构的许可证.
但是,也有一些无线电频段是可以自由使用的(只要不干扰他人在这个频段中的通信),这正好满足计算机无线局域网的需求.
现在的无线局域网就使用来自美国ISM频段中的2.4GHz和5.8GHz频段.各国的ISM标准有可能略有差别.

== 信道复用技术

*复用(multiplexing)*是通信技术中的基本概念.计算机网络中的信道广泛地使用各种复用技术.

在进行通信时,*复用器(multiplexer)*总是和*分用器(demultiplexer)*成对地使用.

=== 频分复用、时分复用和统计时分复用

最基本的复用就是*频分复用FDM(Frequency Division Multiplexing)*和*时分复用TDM(Time Division Multiplexing)*.

==== 频分复用和时分复用

频分复用的各路信号在同样的时间内占用不同的频率信道,使多路信号同时占用不同的带宽资源.

将时间划分为一段段等长的时分复用帧(即TDM帧).每一路信号在每一个TDM帧中占用固定序号的时隙.
一路信号所占用的时隙周期性地出现(其周期就是TDM帧的长度).因此TDM信号也称为等时(isochronous)信号.
可以看出,时分复用的所有用户是在不同的时间占用同样的频带宽度.

使用FDM或TDM的复用技术,可以让多个用户(可以处在不同地点)共享信道资源.
称为频分多址接入FDMA(Frequency Division Multiple Access),简称为频分多址,
或者称为时分多址接入TDMA(Time Division Multiple Access),简称为时分多址.

TDM的信道利用率不高.所以有一种改进:*统计时分复用STDM(Statistic TDM)*.

用户向集中器的输入缓存发送数据,集中器按需动态调整STDM帧,每一个STDM帧中的时隙数小于连接在集中器上的用户数.

统计时分复用又称为异步时分复用,而普通的时分复用称为同步时分复用.

由于STDM帧中的时隙并不是固定地分配给某个用户的,因此在每个时隙中还必须有用户的地址信息.

最后要强调一下,TDM帧和STDM帧都是在物理层传送的比特流中所划分的帧.这种“帧”和我们以后要讨论的链路层的“帧”是完全不同的概念,不可弄混.

=== 波分复用

*波分复用WDM(Wavelength Division Multiplexing)*就是光的频分复用.

最初,人们只能在一根光纤上复用两路光载波信号.这种复用方式称为波分复用WDM.随着技术的发展,在一根光纤上复用的光载波信号的路数越来越多.
现在已能做到在一根光纤上复用几十路或更多路数的光载波信号.于是就使用了密集波分复用DWDM(Dense Wavelength Division Multiplexing)这一名词.

实际上,对于密集波分复用,光载波的间隔一般是0.8nm或1.6nm.

波分复用的复用器又称为合波器,分用器又称为分波器.

=== 码分复用

*码分复用CDM(Code Division Multiplexing)*是另一种共享信道的方法.
当码分复用信道为多个不同地址的用户所共享时,就称为*码分多址CDMA(Code Division Multiple Access)*.

由于各用户使用经过特殊挑选的不同码型,因此各用户之间不会造成干扰.码分复用最初用于军事通信,因为这种系统发送的信号有很强的抗干扰能力,其频谱类似于白噪声,不易被敌人发现.

==== 原理

当发送一连串比特流时,每一个比特发送的时间称为比特时间.每个比特时间再分为若干个短间隔,称为*码片(chip)*.

有若干个站发送接收数据,显然需要标识数据来源,CDM选择给每个站一个$m$ bit长的01序列来标识身份.
常用$m=64,128$,出于方便考虑,这里设$m=8$.

这里我们假设有一个站点$S$,它的序列是$00011011$,现在它要发送数据$110$.

现在,我们规定,当需要发送$1$时,发送站点序列本身;当需要发送$0$时,发送站点序列的二进制反码.

站点序列就被称为*码片序列*.

因此,$S$需要发送$00011011|00011011|11100100$.但是,直接这样发会有一个问题:如果有个站点$S'$的码片序列是$11100100$.这样接收方就没办法区分这条信息是来自$S$的$110$还是来自$S'$的$001$了.

所以CDM还有如下规定或惯例或假设:
  - 每一个站的码片序列中0记为-1,1记为1
  - 任意两个不同站点的码片向量*正交*
  - 所有的站所发送的码片序列都是同步的,即所有的码片序列都在同一个时刻开始

从上述规定或惯例或假设可以得到,站点的码片向量和自身的规格化内积是1,和二进制反码的规格化内积是-1.

现在我们从先前的案例继续

站点$S$的码片序列从$00011011$,相应的码片向量$mat(-1, -1, -1, 1, 1, -1, 1, 1)$.
现在我们引入新的站点$T$,它的序列是$00101110$,相应的码片向量$mat(-1, -1, 1, -1, 1, 1, 1, -1)$.容易验证这两个向量正交.

现在我们假设$S$和$T$分别发送$110$,$111$,有一个站点$X$接受到两条信息.

首先是这两个站点发送的向量
$
  R_1 = S_x = mat(-1, -1, -1, 1, 1, -1, 1, 1)mat( -1, -1, -1, 1, 1, -1, 1, 1)mat( 1, 1, 1, -1, -1, 1, -1, -1)\
  R_2 = T_x = mat(-1,-1,1,-1,1,1,1,-1)mat(-1,-1,1,-1,1,1,1,-1)mat(-1,-1,1,-1,1,1,1,-1)
$

$X$有$S$,$T$两个码片向量,只需要将码片向量与接收向量求规格化内积即可得到信息,不用在计算前区分接收向量来在何处.
$
  S dot R_1 &= mat(-1, -1, -1, 1, 1, -1, 1, 1)mat( -1, -1, -1, 1, 1, -1, 1, 1)mat( 1, 1, 1, -1, -1, 1, -1, -1) dot vec(-1, -1, -1, 1, 1, -1, 1, 1) \
  &= 1 1 0\
  S dot R_2 &= mat(-1,-1,1,-1,1,1,1,-1)mat(-1,-1,1,-1,1,1,1,-1)mat(-1,-1,1,-1,1,1,1,-1) dot vec(-1, -1, -1, 1, 1, -1, 1, 1)\
  &= 0 0 0
$

我个人认为这个规格化内积在接收方接收信息的计算的部分不够线性代数.
这里用$R_1$和$S$来举例.
$
  S &= vec(-1, -1, -1, 1, 1, -1, 1, 1,delim: "[")\
  R_1 &= mat(
    -1, -1, -1, 1, 1, -1, 1, 1;
    -1, -1, -1, 1, 1, -1, 1, 1;
    1, 1, 1, -1, -1, 1, -1, -1;
    delim:"["
  )\
  "message from S" &= 1/m R_1S = vec(1,1,0,delim:"[")
$