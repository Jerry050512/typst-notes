#import "../template/components.typ": card
#import "@preview/cetz:0.3.4": canvas, draw

#let blockquote(body) = {
  block(
    fill: luma(245), // 极淡的灰色背景
    stroke: (left: 4pt + luma(180)),
    inset: 1em, // 四周都有内边距
    width: 100%,
    body
  )
}

= 链路层

链路层使用的信道主要有以下两种类型:
  - 点对点信道.这种信道使用一对一的点对点通信方式
  - 广播信道.这种信道使用一对多的广播通信方式

#strike("NH5:划重点时说点对点不考,这里就不写相关内容啦!欸嘿")

课本有下面这么一段话来解释链路的概念.
#blockquote[
  我们在这里要明确一下,“链路”和“数据链路”并不是一回事.

  所谓链路(link)就是从一个节点到相邻节点的一段物理线路(有线或无线),而中间没有任何其他的交换节点.
  在进行数据通信时,两台计算机之间的通信路径往往要经过许多段这样的链路.可见链路只是一条路径的组成部分.

  数据链路(data link)则是另一个概念.这是因为当需要在一条线路上传送数据时,除了必须有一条物理线路外,还必须有一些必要的通信协议来控制这些数据的传输.若把实现这些协议的硬件和软件加到链路上,就构成了数据链路.

  ......

  也有人采用另外的术语.这就是把链路分为*物理链路*和*逻辑链路*.物理链路就是上面所说的链路,而逻辑链路就是上面的数据链路,是物理链路加上必要的通信协议.
]

所谓"Data Link"是OSI的称呼,而TCP/IP直接使用"Link"的称呼.

我主张抛弃所谓"数据链路".用TCP/IP的称呼.

后文均采用TCP/IP这种称呼.

== 链路层的几个共同问题

=== 帧

对点信道的数据链路层的协议数据单元------帧.链路层把网络层交下来的数据构成帧发送到物理层上,以及把接收到的帧中的数据取出并上交给网络层.在互联网中,网络层协议数据单元就是IP数据报(或简称为数据报、分组或包).

链路层在进行通信时的主要步骤如下:
  - 发送端的链路层把网络层交下来的包添加首部和尾部封装成帧
  - 发送端把封装好的帧发送给接收端的链路层
  - 若接收端的链路层收到的帧无差错,则从收到的帧中提取出包交给上面的网络层;否则丢弃这个帧

=== 三个基本问题

链路层协议有许多种,但有三个基本问题则是共同的.这三个基本问题是:*封装成帧*、*透明传输*和*差错检测*.

==== 封装成帧

封装成帧(framing)就是在一段数据的前后分别添加首部和尾部,这样就构成了一个帧.
接收端在收到物理层上交的比特流后,就能根据首部和尾部的标记,从收到的比特流中识别帧的开始和结束.

网络层的IP 数据报传送到数据链路层就成为帧的数据部分.
在帧的数据部分的前面和后面分别添加上首部和尾部,构成了一个完整的帧.这样的帧就是数据链路层的数据传送单元.一个帧的帧长等于帧的数据部分长度加上帧首部和帧尾部的长度.

每一种链路层协议都规定了所能传送的帧的数据部分长度上限—————*最大传送单元 MTU (Maximum Transfer Unit)*.

当数据是由可打印的ASCII码组成的文本文件时,帧定界可以使用特殊的帧定界符:
  - 控制字符SOH(Start Of Header)放在一帧的最前面,表示帧的首部开始
  - 另一个控制字符EOT(End of Transmission)表示帧的结束

// 定义样式
#let box-stroke = 1pt + black
#let dim-stroke = 0.5pt + black
#let data-fill = tiling(size: (5pt, 5pt))[
  #place(dx: 1pt, dy: 1pt, circle(radius: 0.5pt, fill: black.lighten(60%)))
]

#figure(
  canvas({
    import draw: *

    // --- 1. IP 数据报 (顶部盒子) ---
    // 阴影效果
    rect((2.2, 3.8), (8.2, 4.8), fill: black, stroke: none)
    // 主体
    rect((2, 4), (8, 5), fill: white, stroke: box-stroke, name: "ip-box")
    content("ip-box", [*IP 数据报*])

    // --- 2. 向下的箭头 (封装过程) ---
    // 绘制一个宽箭头
    line((5, 4), (5, 2.8), mark: (end: "stealth", size: .3), stroke: 2pt)

    // --- 3. 帧结构 (中间长条) ---
    // 帧首部
    rect((0, 1.5), (2, 2.5), stroke: box-stroke, name: "header")
    content("header", [帧首部])
    
    // 帧的数据部分 (带纹理/灰色)
    rect((2, 1.5), (8, 2.5), fill: white.darken(5%), stroke: box-stroke, name: "data")
    content("data", [帧的数据部分])
    
    // 帧尾部
    rect((8, 1.5), (10, 2.5), stroke: box-stroke, name: "trailer")
    content("trailer", [帧尾部])

    // --- 4. 发送箭头 (左侧) ---
    line((0, 2), (-1.5, 2), mark: (end: "stealth", size: .25), stroke: 2pt)
    content((-1.5, 2.3), [发送], anchor: "south-west")

    // --- 5. 顶部标注 (帧开始/结束) ---
    // 帧开始
    content((0, 3.5), [帧开始])
    line((0, 3.3), (0, 2.6), mark: (end: "stealth", size: .15))
    
    // 帧结束
    content((10, 3.5), [帧结束])
    line((10, 3.3), (10, 2.6), mark: (end: "stealth", size: .15))

    // --- 6. 底部标注 (MTU) ---
    // 辅助线
    line((2, 1.4), (2, 0.8), stroke: (dash: "dotted"))
    line((8, 1.4), (8, 0.8), stroke: (dash: "dotted"))
    
    // MTU 尺寸线
    line((2, 1), (4.3, 1), mark: (start: "|"), stroke: dim-stroke)
    content((5, 1), [$space <= "MTU" space$], anchor: "center")
    line((5.7, 1), (8, 1), mark: (end: "|"), stroke: dim-stroke)

    // --- 7. 底部标注 (帧长 & 开始发送) ---
    // 帧长尺寸线
    line((0, 1.4), (0, -0.5), stroke: dim-stroke) // 左延伸线
    line((10, 1.4), (10, -0.5), stroke: dim-stroke) // 右延伸线
    
    // 横向双箭头线
    line((0, 0), (10, 0), mark: (start: "|", end: "|"), stroke: dim-stroke, name: "frame-len")
    // 填补中间文字背景以遮挡线条
    rect((3.5, -0.3), (6.5, 0.3), fill: white, stroke: none)
    content((5, 0), [数据链路层的帧长])

    // 从这里开始发送 (左下角上指箭头)
    line((0, -1.2), (0, -0.6), mark: (end: "stealth"), stroke: dim-stroke)
    content((0, -1.3), [从这里开始发送], anchor: "north-west")

  }),
  caption: [用帧首部和帧尾部封装成帧]
)

==== 透明传输

如果帧的数据部分的某一段比特流和帧首部或尾部一样会导致接收端误判.

例如下图:
#let guide-stroke = (paint: black, thickness: 0.5pt, dash: "dotted") // 辅助引线样式

// 模拟原图的灰色点状纹理
#let gray-fill = tiling(size: (4pt, 4pt))[
  #place(dx: 1pt, dy: 1pt, circle(radius: 0.5pt, fill: black.lighten(70%)))
]

#figure(
  canvas({
    import draw: *

    // --- 变量定义 ---
    let h = 1.2 
    let soh-w = 1.5
    let eot-w = 1.5
    let mid-eot-start = 4.5 
    let mid-eot-end = 6.0
    let total-len = 14
    let bottom-line-y = -1.0 // 底部标注线的 Y 轴位置

    // --- 1. 阴影 (Shadow) ---
    rect((0.2, -0.2), (total-len + 0.2, h - 0.2), fill: black, stroke: none)

    // --- 2. 主体方块 ---
    // SOH
    rect((0, 0), (soh-w, h), fill: white, stroke: box-stroke)
    content((soh-w/2, h/2), [*SOH*])

    // 数据段 1
    rect((soh-w, 0), (mid-eot-start, h), fill: white, stroke: box-stroke)

    // 伪 EOT
    rect((mid-eot-start, 0), (mid-eot-end, h), fill: white, stroke: box-stroke)
    content(((mid-eot-start + mid-eot-end)/2, h/2), [*EOT*])

    // 数据段 2
    rect((mid-eot-end, 0), (total-len - eot-w, h), fill: white, stroke: box-stroke)

    // 真 EOT
    rect((total-len - eot-w, 0), (total-len, h), fill: white, stroke: box-stroke)
    content((total-len - eot-w/2, h/2), [*EOT*])

    // --- 3. 顶部标注 (保持不变) ---
    // "出现了 EOT"
    content((mid-eot-start + 0.5, 3.5), [出现了 "EOT"])
    line((mid-eot-start + 0.5, 3.2), (mid-eot-start + 0.2, h), mark: (end: "stealth"))

    // "完整的帧"
    let top-dim-y = 2.8
    line((0, top-dim-y), (total-len, top-dim-y), mark: (start: "|", end: "|"), stroke: dim-stroke)
    // 遮挡线
    rect((total-len/2 - 1.2, top-dim-y - 0.2), (total-len/2 + 1.2, top-dim-y + 0.2), fill: white, stroke: none)
    content((total-len/2, top-dim-y), [完整的帧])
    
    // 引线
    line((0, h), (0, top-dim-y), stroke: guide-stroke)
    line((total-len, h), (total-len, top-dim-y), stroke: guide-stroke)

    // "数据部分"
    let sub-dim-y = 2.0
    line((soh-w, sub-dim-y), (total-len - eot-w, sub-dim-y), mark: (start: "|", end: "|"), stroke: dim-stroke)
    rect((total-len/2 - 1.2, sub-dim-y - 0.2), (total-len/2 + 1.2, sub-dim-y + 0.2), fill: white, stroke: none)
    content((total-len/2, sub-dim-y), [数据部分])
    
    // 引线
    line((soh-w, h), (soh-w, sub-dim-y), stroke: guide-stroke)
    line((total-len - eot-w, h), (total-len - eot-w, sub-dim-y), stroke: guide-stroke)

    // --- 4. 底部标注 ---

    // 垂直辅助引线 (从方块底部延伸下来)
    // 起点
    line((0, 0), (0, bottom-line-y), stroke: guide-stroke)
    // 中间截断点
    line((mid-eot-end, 0), (mid-eot-end, bottom-line-y), stroke: guide-stroke)
    // 终点
    line((total-len, 0), (total-len, bottom-line-y), stroke: guide-stroke)

    // 范围 1: 误认为是一个帧
    line((0, bottom-line-y), (mid-eot-end, bottom-line-y), mark: (start: "|", end: "|"), stroke: dim-stroke)
    content((mid-eot-end / 2, bottom-line-y - 0.3), [被接收端误认为是一个帧], anchor: "north")

    // 范围 2: 被丢弃部分
    line((mid-eot-end, bottom-line-y), (total-len, bottom-line-y), mark: (start: "|", end: "|"), stroke: dim-stroke)
    content(((mid-eot-end + total-len) / 2, bottom-line-y - 0.3), [被接收端当作无效帧而丢弃], anchor: "north")

    // 发送方向指示 (移到最左侧，不干扰范围)
    line((-0.5, -0.8), (-0.5, 0.5), mark: (end: "stealth"), stroke: 1.5pt)
    content((-0.6, -0.2), [发送\ 方向], anchor: "east")

  }),
  caption: [数据部分恰好出现与EOT一样的代码]
)

这里就引入*透明传输*的概念:接收端无视中间那个EOT继续接收数据,中间那个EOT就像"透明"一样.

实现方法是*字节填充*或*字符填充*:
发送端的链路层在数据中的控制字符前加一个转义字符ESC,而在接收端的链路层在把数据送往网络层之前删除这个插入的转义字符.如下图

#let shadow-offset = (x: 0.15, y: -0.15)
// 字节填充的空心箭头样式
#let stuffing-arrow = (
  mark: (end: "stealth", fill: white, scale: 1.5), 
  stroke: 1pt
)

#figure(
  canvas({
    import draw: *

    scale(80%)

    // --- 1. 数据定义 ---
    // 定义每一块的属性：内容、宽度、类型(header/data/control)
    // Top Row: 原始数据
    let top-y = 6
    let top-h = 1.2
    let top-data = (
      (t: "SOH", w: 1.5, type: "head"),
      (t: "",    w: 1.5, type: "gap"),
      (t: "EOT", w: 1.5, type: "ctrl"),
      (t: "",    w: 1.5, type: "gap"),
      (t: "SOH", w: 1.5, type: "ctrl"),
      (t: "",    w: 1.5, type: "gap"),
      (t: "ESC", w: 1.5, type: "ctrl"),
      (t: "",    w: 1.5, type: "gap"),
      (t: "SOH", w: 1.5, type: "ctrl"),
      (t: "EOT", w: 1.5, type: "tail"),
    )

    // Bottom Row: 填充后的数据
    let bot-y = 0
    let bot-h = 1.2
    let bot-data = (
      (t: "SOH", w: 1.5, type: "head"),
      (t: "",    w: 2.0, type: "gap"), // 间隙稍微拉大以适应下方宽度
      (t: ("ESC", "EOT"), w: 2.4, type: "stuffed"),
      (t: "",    w: 2.0, type: "gap"),
      (t: ("ESC", "SOH"), w: 2.4, type: "stuffed"),
      (t: "",    w: 2.0, type: "gap"),
      (t: ("ESC", "ESC"), w: 2.4, type: "stuffed"),
      (t: "",    w: 2.0, type: "gap"),
      (t: ("ESC", "SOH"), w: 2.4, type: "stuffed"),
      (t: "EOT", w: 1.5, type: "tail"),
    )

    // --- 2. 绘制辅助函数 ---
    
    // 绘制一行的函数
    let draw-row(start-x, y, h, data, name-prefix) = {
      let cx = start-x
      let cmds = ()
      // 先画整体阴影
      let total-w = data.map(d => d.w).sum()
      cmds.push(rect((cx + shadow-offset.x, y + shadow-offset.y), 
           (cx + total-w + shadow-offset.x, y + h + shadow-offset.y), 
           fill: black, stroke: none))
      
      // 遍历绘制方块
      for (i, item) in data.enumerate() {
        let fill-color = white
        let label = name-prefix + str(i)
        
        // 绘制方块背景和边框
        cmds.push(rect((cx, y), (cx + item.w, y + h), fill: fill-color, stroke: box-stroke, name: label))
        
        // 绘制文字
        if item.type == "stuffed" {
           // 如果是填充对 (ESC + X)
           cmds.push(line((cx + item.w/2, y), (cx + item.w/2, y + h), stroke: box-stroke))
           cmds.push(content((cx + item.w/4, y + h/2), item.t.at(0)))
           cmds.push(content((cx + item.w*0.75, y + h/2), item.t.at(1)))
        } else {
           cmds.push(content((cx + item.w/2, y + h/2), item.t))
        }
        
        cx = cx + item.w
      }
      return (cx, cmds) // 返回 (总长度, 绘制指令列表)
    }

    let cmds = ()

    // --- 3. 执行绘制 ---

    // 绘制上面一行
    let (top-len, top-cmds) = draw-row(2, top-y, top-h, top-data, "top-")
    cmds += top-cmds
    
    // 绘制下面一行
    let (bot-len, bot-cmds) = draw-row(0, bot-y, bot-h, bot-data, "bot-")
    cmds += bot-cmds

    // --- 4. 连线与标注 (关键逻辑) ---

    // 定义对应关系索引 (Top索引 -> Bot索引)
    let mapping = (
      "2": 2, // EOT -> ESC EOT
      "4": 4, // SOH -> ESC SOH
      "6": 6, // ESC -> ESC ESC
      "8": 8  // SOH -> ESC SOH
    )

    for (t-idx, b-idx) in mapping {
      let t-name = "top-" + str(t-idx)
      let b-name = "bot-" + str(b-idx)
      
      // 虚线投影 (左上角连左上角，右上角连右上角)
      cmds.push(line((t-name + ".south-west"), (b-name + ".north-west"), stroke: (dash: "dotted")))
      cmds.push(line((t-name + ".south-east"), (b-name + ".north-east"), stroke: (dash: "dotted")))
      
      // 字节填充箭头
      let anchor = b-name + ".north-west"
      let y-base = bot-y + bot-h
      cmds.push(line(
        (rel: (0.6, (top-y - 1.5) - y-base), to: anchor),
        (rel: (0.6, 0.1), to: anchor),
        ..stuffing-arrow
      ))
      cmds.push(content(
        (rel: (0.6, (top-y - 1.2) - y-base), to: anchor),
        [字节填充],
        size: 8pt
      ))
    }

    // --- 5. 其他文本标注 ---

    // 顶部尺寸线 "原始数据"
    let dim-y = top-y + top-h + 0.5
    cmds.push(line((top-data.at(0).w + 0.5, dim-y), (1.5 + top-len - top-data.at(-1).w, dim-y), mark: (start: "stealth", end: "stealth")))
    cmds.push(rect((2 + top-len/2 - 1.5, dim-y - 0.3), (2 + top-len/2 + 1.5, dim-y + 0.3), fill: white, stroke: none))
    cmds.push(content((2 + top-len/2, dim-y), [原始数据]))

    // 帧开始/结束符 (顶部)
    cmds.push(line((2 + 0.75, dim-y + 0.8), (2 + 0.75, top-y + top-h), mark: (end: "stealth")))
    cmds.push(content((2 + 0.75, dim-y + 1), [帧开始符]))
    
    cmds.push(line((top-len - 0.75, dim-y + 0.8), (top-len - 0.75, top-y + top-h), mark: (end: "stealth")))
    cmds.push(content((top-len - 0.75, dim-y + 1), [帧结束符]))

    // 底部尺寸线 "经过字节填充后发送的数据"
    let bot-dim-y = bot-y + bot-h + 2.5 // 这里放到底部箭头的上方，或者放最下面
    // 原图是在下方
    let bot-label-y = -1.5
    cmds.push(line((0.5, bot-label-y), (bot-len - 0.5, bot-label-y), mark: (start: "stealth", end: "stealth")))
    cmds.push(rect((bot-len/2 - 4, bot-label-y - 0.3), (bot-len/2 + 4, bot-label-y + 0.3), fill: white, stroke: none))
    cmds.push(content((bot-len/2, bot-label-y), [经过字节填充后发送的数据]))

    // 发送在前 (左侧)
    cmds.push(line((0, -0.5), (0, 0.5), mark: (end: "stealth"), stroke: 1.5pt))
    cmds.push(content((-0.2, -0.8), [发送\ 在前], anchor: "north"))
    
    cmds.flatten()
  }),
  caption: [用字节填充法解决透明传输的问题]
)

==== 差错检验

比特在传输过程中可能会产生差错:1可能会变成0,而0也可能变成1.这就叫作比特差错.比特差错是传输差错中的一种.本小节所说的“差错”,如无特殊说明,就是指"比特差错".

在一段时间内,传输错误的比特占所传输比特总数的比率称为*误码率BER(Bit Error Rate)*.

目前在链路层广泛使用了*循环冗余检验CRC(Cyclic Redundancy Check)*的检错技术.

CRC的核心思路就是:在发送端,先把数据划分为组,假定每组$k$个比特.CRC运算就是在数据$M$的后面添加供差错检测用的$n$位冗余码,然后构成一个帧发送出去,一共发送$(k+n)$位.

从这个核心思路出发,有两个问题需要考虑:
  - 发送端如何计算冗余码
  - 接收端如何验证数据正确性

===== 计算冗余码

1. 二进制的模2运算进行$2^n$乘$M$的运算,这相当于在$M$后面添加$n$个0,我们姑且叫他$M'$
2. 双方事先商量一个长度为$(n+1)$的数$P$.
3. 用第一步得到的$(n+k)$位的$M'$除以$P$,得到余数$R$------计算$M' div P = Q dot dot dot dot dot dot R(n"位")$.
4. 把$R$拼接到$M$后,发送出去.

这种为了进行检错而添加的冗余码常称为*帧检验序列FCS(Frame Check Sequence)*.

循环冗余检验CRC和帧检验序列FCS并不是同一个概念.CRC是一种检错方法,而FCS是添加在数据后面的冗余码,在检错方法上可以选用CRC,但也可不选用CRC.


===== 接收端验证

对接收到的帧数据$A$,计算$A div P$的余数$R$,如果$R = 0$则保留帧,反之丢弃帧.

===== 举例说明

1. 首先,假设我们需要传输数据$M = 101001(k=6)$,发送接收两端约定$P = 1101(n=3)$;
2. 计算得到$Q = 110101$,$R = 001$;
3. 那么我们发送$101001001$;
4. 接收端收到$A=101001001$,计算$101001001 div 1101$,得到$R=0$,保留数据.

这里放个竖式说明一下第二步的除法如何计算的:
// 样式定义
#let math-font = "Times New Roman"
#let guide-stroke = (dash: "dotted", thickness: 0.5pt)
#let text-y-offset = 0.5

#figure(
  canvas({
    import draw: *

    // --- 基础配置 ---
    let dx = 0.4  // x轴间距 (字符宽度)
    let dy = -0.5 // y轴行高 (向下生长)
    
    // 绘制单个字符的辅助函数
    // x, y: 网格坐标
    // char: 字符
    let cell(x, y, char) = {
      content((x * dx, y * dy), text(font: math-font, char))
    }

    // 绘制一串二进制数的辅助函数
    // start-x: 起始 x 坐标
    // row-y: 行号 (0, 1, 2...)
    // bits: 字符串
    // underline: 是否画底线
    let draw-bits(start-x, row-y, bits, underline: false) = {
      for (i, char) in bits.clusters().enumerate() {
        cell(start-x + i, row-y, char)
      }
      if underline {
        let line-y = row-y * dy - 0.25
        line((start-x * dx - 0.1, line-y), ((start-x + bits.len()) * dx - 0.1, line-y), stroke: 0.5pt)
      }
    }

    // --- 1. 顶部标注 (商 Q) ---
    // Q = 110101
    // 稍微向上偏移
    draw-bits(3, -1.0, "110101") 
    content((11.5 * dx, -1.0 * dy), [$arrow Q$ (商)], anchor: "west")

    // --- 2. 除法结构主体 ---

    // 除数 P (左侧)
    content((-4.5 * dx, 0), [$P$ (除数) $arrow$], anchor: "east")
    draw-bits(-4, 0, "1101")
    
    // 除号 (左括号 + 顶部横线)
    // 竖线
    line((-0.2, 0.25), (-0.2, -0.25), stroke: 0.5pt) 
    // 横线 (除法顶盖)
    line((-0.2, 0.25), (10 * dx, 0.25), stroke: 0.5pt)

    // 被除数 (第0行)
    draw-bits(0, 0, "101001000")
    content((10 * dx, 0), [$arrow 2^n M$ (被除数)], anchor: "west")

    // --- 3. 计算过程 (按行绘制) ---
    
    // Step 1
    draw-bits(0, 1, "1101", underline: true)
    
    // Step 2 (余数 1110 -> 0 是落下的一位)
    draw-bits(1, 2, "111")
    cell(4, 2, "0") // 落下的位
    
    // Step 3
    draw-bits(1, 3, "1101", underline: true)

    // Step 4 (余数 0111 -> 1 是落下的一位)
    cell(2, 4, "0")
    draw-bits(3, 4, "11")
    cell(5, 4, "1") // 落下的位

    // Step 5
    draw-bits(2, 5, "0000", underline: true)

    // Step 6 (余数 1110 -> 0 是落下的一位)
    draw-bits(3, 6, "111")
    cell(6, 6, "0") // 落下的位

    // Step 7
    draw-bits(3, 7, "1101", underline: true)

    // Step 8 (余数 0110 -> 0 是落下的一位)
    cell(4, 8, "0")
    draw-bits(5, 8, "11")
    cell(7, 8, "0") // 落下的位

    // Step 9
    draw-bits(4, 9, "0000", underline: true)

    // Step 10 (余数 1100 -> 0 是落下的一位)
    draw-bits(5, 10, "110")
    cell(8, 10, "0") // 落下的位

    // Step 11
    draw-bits(5, 11, "1101", underline: true)

    // Step 12 (最终余数 R)
    draw-bits(6, 12, "001")
    content((9.5 * dx, 12 * dy), [$arrow R$ (余数)，作为 FCS], anchor: "west")

    // --- 4. 绘制竖向辅助虚线 ---
    // 逻辑：从被除数的某一位，垂直画到该位第一次被使用的行
    
    // 第5位 (index 4, '0') 落到第2行
    line((4 * dx, -0.3), (4 * dx, 2 * dy + 0.3), stroke: guide-stroke)
    
    // 第6位 (index 5, '1') 落到第4行
    line((5 * dx, -0.3), (5 * dx, 4 * dy + 0.3), stroke: guide-stroke)
    
    // 第7位 (index 6, '0') 落到第6行
    line((6 * dx, -0.3), (6 * dx, 6 * dy + 0.3), stroke: guide-stroke)

    // 第8位 (index 7, '0') 落到第8行
    line((7 * dx, -0.3), (7 * dx, 8 * dy + 0.3), stroke: guide-stroke)

    // 第9位 (index 8, '0') 落到第10行
    line((8 * dx, -0.3), (8 * dx, 10 * dy + 0.3), stroke: guide-stroke)

  }),
  caption: [说明循环冗余检验原理的例子]
)

===== 其他内容

在数据链路层若*仅仅*使用循环冗余检验CRC差错检测技术,则只能做到对帧的*无差错接受*.接收端丢弃的帧虽然曾*收到*了,但最终还是因为有差错被丢弃,即没有被*接受*.

传输差错可分为两大类:一类就是前面所说的最基本的比特差错,而另一类传输差错则更复杂些,这就是收到的帧并没有出现比特差错,但却出现了*帧丢失*、*帧重复*或*帧失序*.

“无比特差错”与“无传输差错”并不是同样的概念.
== 使用广播信道的数据链路层



== 扩展的以太网