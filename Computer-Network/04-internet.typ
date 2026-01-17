#import "../template/components.typ": card
#import "@preview/cetz:0.3.4": canvas, draw

= 网络层

== 路由

如图,有这样一个网络.
#figure(
  canvas({
    import draw: *

    // --- 样式配置 ---
    let stroke-style = (thickness: 1.2pt, paint: black) // 线条样式
    let text-style = (size: 14pt)      // 字体样式
    
    // 尺寸定义
    let r-half = 0.5 // 路由器矩形半宽
    let c-rad = 0.4  // 主机圆形半径
    
    // 颜色定义
    let c-white = white

    // --- 辅助函数 ---

    // 绘制方形路由器
    let router(pos, label, bg: c-white, name: none) = {
      rect(
        (rel: (-r-half, -r-half), to: pos), 
        (rel: (r-half, r-half), to: pos), 
        fill: bg, 
        stroke: stroke-style,
        name: name
      )
      content(pos, text(..text-style)[#label])
    }

    // 绘制圆形主机
    let host(pos, label, name: none) = {
      circle(
        pos, 
        radius: c-rad, 
        fill: white, 
        stroke: stroke-style,
        name: name
      )
      content(pos, text(..text-style)[#label])
    }

    // --- 1. 绘制节点 (按布局坐标) ---
    
    // 左侧链路
    host((0, 0), "A", name: "A")
    router((3, 0), "R1", name: "R1")
    router((6, 0), "R2", name: "R2")

    // 分支 R3 (上)
    router((9, 1.5), "R3", name: "R3")
    host((12, 2.5), "B", name: "B")
    host((12, 0.5), "C", name: "C")

    // 分支 R4 (下)
    router((9, -1.5), "R4", name: "R4")
    host((12, -1.5), "D", name: "D")

    // --- 2. 绘制连线 ---
    
    // 主干
    line("A", "R1", stroke: stroke-style)
    line("R1", "R2", stroke: stroke-style)
    
    // R2 分流
    line("R2", "R3", stroke: stroke-style)
    line("R2", "R4", stroke: stroke-style)
    
    // R3 分流
    line("R3", "B", stroke: stroke-style)
    line("R3", "C", stroke: stroke-style)
    
    // R4 链路
    line("R4", "D", stroke: stroke-style)
  })
)

显然,假如主机A想给B发送信息,就需要经过R1,R2,R3三个路由器.

现在我们考虑R2,它会接到一个包,头部信息写着*"From A To B"*,对于R2,它需要知道B在哪.
显然,R2没有办法直接把包发给B,它需要把包发给R3,也就是说,R2*需要*知道*"如果要把包发给B,就要发给R3"*.

如果我们把问题扩展一下(比如C要给A发包,D要给C发包...),那么显然R2*需要*知道4件事:
  - 如果要把包发给A,就要发给R1
  - 如果要把包发给B,就要发给R3
  - 如果要把包发给C,就要发给R3
  - 如果要把包发给D,就要发给R4

于是R2就会在自己的设备里建立下面这样一个表:
#figure(
  table(
    columns: (auto, auto),
    [目的主机],[下一跳],
    [A],[R1],
    [B],[R3],
    [C],[R3],
    [D],[R4]
  )
)
这个表被称为*转发表*.路由器建立这个表的行为被称为*路由*.

以上是路由的核心思路,有很多细节没有涉及.

#strike[NH5:不考路由.只是我本人的思路要求先有路由再有IP]

== IP

A给B发数据,A的设备在打包时需要给包头写上"From A To B",就需要标识符来标识A以及B.

在网络层,使用IP地址来标识设备(相应的,链路层有MAC地址).

IP地址是一段长度32位的二进制代码,出于人类可读性考虑,会每8位写成对应10进制数,4个数之间用小数点连接.

IP地址被定义为前n位的网络号,后(32-n)位的主机号.

在早期,IP地址采用分类的方式:网络号位数n是固定的几个取值,如下图:
#figure(
  canvas({
    import draw: *

    // --- 颜色定义 ---
    let c-green = rgb("#38761d") // 前导位颜色
    let c-red   = rgb("#c03508") // 网络号颜色
    let c-blue  = rgb("#0b5394") // 主机号颜色
    let c-border = gray.lighten(20%)

    // --- 辅助函数: 绘制单行 ---
    // y: 纵坐标
    // label: 左侧标签 (如 "Class A:")
    // segments: 数组，包含每个方块的数据 (宽度, 颜色, 中间文字, 下方文字)
    let draw-row(y, label, segments) = {
      let h = 1.2 // 方块高度
      
      // 1. 绘制左侧标签
      content((-0.5, y + h/2), text(size: 11pt)[#label], anchor: "east")

      // 2. 循环绘制方块
      let x = 0
      for seg in segments {
        // 绘制矩形边框
        rect((x, y), (x + seg.w, y + h), stroke: c-border)
        
        // 绘制中间文字 (居中)
        content(
          (x + seg.w/2, y + h/2), 
          text(fill: seg.col, size: 11pt)[#seg.top]
        )
        
        // 绘制下方文字 (如果存在)
        if seg.at("sub", default: none) != none {
          content(
            (x + seg.w/2, y - 0.3), 
            text(fill: seg.col, size: 10pt)[#seg.sub],
            anchor: "north"
          )
        }
        
        // 更新 x 坐标，为下一个方块做准备
        x = x + seg.w
      }
    }

    // --- 数据定义与绘制 ---
    // 为了视觉效果，宽度(w)是近似比例，不是严格的位宽数学比例

    // Class A
    draw-row(4, "Class A:", (
      (w: 0.8, col: c-green, top: "0"),
      (w: 3.2, col: c-red,   top: "Network (7 bits)", sub: "~128 networks"),
      (w: 8.0, col: c-blue,  top: "Host (24 bits)",    sub: "~16m hosts per network"),
    ))

    // Class B
    draw-row(2, "Class B:", (
      (w: 1.2, col: c-green, top: "10"),
      (w: 5.4, col: c-red,   top: "Network (14 bits)", sub: "~16k networks"),
      (w: 5.4, col: c-blue,  top: "Host (16 bits)",    sub: "~65k hosts per network"),
    ))

    // Class C
    draw-row(0, "Class C:", (
      (w: 1.6, col: c-green, top: "110"),
      (w: 7.4, col: c-red,   top: "Network (21 bits)", sub: "~2m networks"),
      (w: 3.0, col: c-blue,  top: "Host (8 bits)",     sub: "~256 hosts \n per network"),
    ))
  }),
  caption: "分类的IP地址"
)
这种分类会造成极大的浪费,比如一个企业有400个IP的需求,但是C类只有256个,所以只能使用B类,这就会造成6万多个IP的浪费.

上述这种分类依旧成为历史.

=== CIDR

新的方法仍然沿用分类法的这种前后区分的思路:前n位的网络前缀,后(32-n)位的主机号,区别在于n的取值不是固定的.

这种方法称为*分类域间路由选择CIDR(Classless Inter-Domain Routing, CIDR 的读音是"sider")*.

CIDR使用一种斜线记法,或称CIDR记法.在一个IP地址最后加上一个"/",斜线后面是网络前缀的位数(n的取值).

所有连续的前缀相同的地址的集合称为*CIDR地址块*.

=== 掩码

人可以通过CIDR记法区分一个IP中的网络前缀和主机号.计算机通过子网掩码(地址掩码)来区分.

掩码通过n个1和(32-n)个0组成,如/20地址块的掩码为$11111111" "11111111" "11110000" "00000000$.这个掩码的CIDR记法是255.255.240.0/20

#table(
  columns: (auto, auto),
  
  // 表头
  table.header(
    [*网络类别*], [*掩码*]
  ),

  // 表格数据
  [A 类网络], [255.0.0.0 或 255.0.0.0/8],
  [B 类网络], [255.255.0.0 或 255.255.0.0/16],
  [C 类网络], [255.255.255.0 或 255.255.255.0/24]
)

计算机得到网络地址的方式是IP与掩码按位与运算.

一个大的CIDR地址块中往往包含很多小地址块,所以在路由器的转发表中就利用较大的一个CIDR地址块来代替许多较小的地址块.这种方法称为路由聚合(route aggregation).

=== IP特点

- IP地址是一种分等级的地址结构.
- IP地址是标志一台主机(或路由器)和一条链路的*接口*.
  - 当一台主机同时连接到两个网络上时,该主机就必须同时具有两个相应的IP地址,其网络前缀必须是不同的.这种主机称为多归属主机(multihomed host).
  - 由于一个路由器至少应当连接到两个网络,因此一个路由器至少应当有两个不同的IP地址.
  - 可以类比理解为一个建筑正好处在北京路和上海路的交叉口上,那么这个建筑就可以拥有两个门牌号码.例如,北京路4号和上海路37号.
- ,一个网络(或子网)是指具有*相同网络前缀*的主机的集合,因此,用转发器或交换机连接起来的若干个局域网仍为一个网络.具有*不同*网络前缀的局域网必须使用路由器进行互连.

== ARP

回到开头的例子,A向B发数据,有个问题还没考虑:A的网络层用IP地址来写"From A To B",那A的链路层该如何写上正确的MAC地址.

这个问题由*地址解析协议ARP*来处理.

设备上有ARP缓存用于存放IP-MAC的映射表,类似路由的转发表.需要发包时设备会通过映射表确定目的MAC,如果表中没有,会在LAN内广播获取,广播内容大体上类似:"我的IP是xxx,MAC是xxx,我想知道IP为xxx的设备的MAC",相应的设备收到广播后会单播回复.

如果目标设备在其他的网络中,那么就得不到回复.就会使用自己的LAN的路由器的MAC地址,路由器的行为和主机类似.

== 包的格式
一个IP的包的结构如下
#figure(
  scale(85%)[
    #canvas({
      import draw: *

      // --- 配置 ---
      let scale = 0.6      // 宽度缩放比例 (1 bit = 0.4 units)
      let row-h = 1.0      // 行高
      let stroke-style = (paint: black, thickness: 0.8pt)

      // --- 辅助函数: 绘制一行 ---
      // y: 当前行的起始 y 坐标
      // fields: 数组，包含 (名称, 比特宽度)
      let draw-row(y, fields) = {
        let x = 0
        for item in fields {
          let name = item.at(0)
          let bits = item.at(1)
          let w = bits * scale
          
          // 绘制矩形框
          rect((x, y), (x + w, y - row-h), stroke: stroke-style)
          
          // 绘制文字 (居中)
          content((x + w/2, y - row-h/2), name)
          
          // 更新 x 坐标
          x = x + w
        }
      }

      // --- 开始绘制 ---
      // 按照 IP Header 的结构定义数据
      // 总宽度通常视为 32 bits
      
      let y = 0
      
      // 第 1 行
      draw-row(y, (
        ("版本 (4)", 4), 
        ("首部长度 (4)", 4), 
        ("区分服务 (8)", 8), 
        ("总长度 (16)", 16)
      ))
      y = y - row-h

      // 第 2 行
      draw-row(y, (
        ("标识(Identification) (16)", 16), 
        ("标志 (3)", 3), 
        ("片偏移 (13)", 13)
      ))
      y = y - row-h

      // 第 3 行
      draw-row(y, (
        ("生存时间 (8)", 8), 
        ("协议 (8)", 8), 
        ("首部检验和 (16)", 16)
      ))
      y = y - row-h

      // 第 4 行
      draw-row(y, (("源地址 (32)", 32),))
      y = y - row-h

      // 第 5 行
      draw-row(y, (("目的地址 (32)", 32),))
      y = y - row-h

      // 第 6 行
      draw-row(y, (
        ("可选字段(长度可变)", 24),
        ("填充",8)
      ))
      y = y - row-h
      
      // 第 7 行 (Payload)
      // Payload 在逻辑上不定长，但图中通常画成满宽
      draw-row(y, (("数据部分", 32),))
    })
  ]
)

包的首部的可变部分就是一个选项字段.选项字段用来支持排错、测量以及安全等措施.此字段的长度可变,从1字节到40字节不等,取决于所选择的项目.某些选项项目只需要1字节,它只包括1字节的选项代码.而有些选项需要多个字节, 这些选项一个个拼接起来,中间不需要有分隔符,最后用全0的填充字段补齐为4字节的整数倍.

== 分组转发的过程

分组在互联网上传送和转发是基于分组首部中的目的地址的,因此这种转发方式称为基于终点的转发.

当路由器收到一个待转发的包,在从转发表得出下一跳路由器的IP地址后,把下一跳路由器的IP地址转换成MAC 地址(必须使用ARP),并将此MAC地址放在链路层的MAC帧的首部,
然后利用这个MAC地址传送到下一跳路由器的链路层,再取出MAC帧的数据部分,交给网络层.

路由器查转发表的过程是逐行寻找前缀匹配的过程.具体而言,则是最长前缀匹配.

=== 使用二叉线索查找转发表

#figure(
  // 居中显示整个图表
  align(center)[
    #grid(
      columns: (auto, auto),
      gutter: 1cm, // 左右两部分之间的间距
      align: (left + horizon, center + horizon), // 垂直居中对齐

      // --- 左侧：表格部分 ---
      table(
        columns: (auto, auto),
        
        // 表头
        table.header(
          [32 位的 IP 地址], [唯一前缀]
        ),
        table.hline(y: 1, stroke: 0.5pt),

        // 数据行 (使用 raw 保持等宽字体)
        [`01000110 00000000 00000000 00000000`], [`0100`],
        [`01010110 00000000 00000000 00000000`], [`0101`],
        [`01100001 00000000 00000000 00000000`], [`011`],
        [`10110000 00000010 00000000 00000000`], [`10110`],
        [`10111011 00001010 00000000 00000000`], [`10111`],
      ),

      // --- 右侧：二叉树部分 ---
      canvas(length: 1cm, {
        import draw: *

        // --- 样式定义 ---
        let node-rad = 0.15 // 圆形节点半径
        let leaf-size = 0.25 // 方形叶子大小
        let norm-stroke = 0.5pt + black // 普通线条
        let bold-stroke = 2.5pt + black // 加粗线条

        // --- 节点坐标定义 ---
        // 使用字典存储坐标，方便连线引用
        let n = (
          root: (0, 0),
          // 左子树路径
          l1:   (-1.5, -1),   // 0
          l2:   (-0.5, -2),   // 0->1
          l3:   (-1.0, -3),   // 0->1->0
          leaf_l_1: (-1.5, -3.8), // 0->1->0->0 (方块)
          leaf_l_2: (-0.5, -3.8), // 0->1->0->1 (方块)
          leaf_l_3: (0.0, -2.8),  // 0->1->1 (方块)

          // 右子树路径
          r1:   (2.5, -1),    // 1
          r2:   (1.5, -2),    // 1->0
          r3:   (2.0, -3),    // 1->0->1
          r4:   (2.5, -4),    // 1->0->1->1
          leaf_r_1: (2.0, -4.8),  // ...->0 (方块)
          leaf_r_2: (3.0, -4.8),  // ...->1 (方块)
        )

        // --- 绘制连线函数 ---
        // from: 起点key, to: 终点key, label: 边上的数字, style: 线条样式
        let edge(from, to, label, style: norm-stroke) = {
          line(n.at(from), n.at(to), stroke: style)
          // 计算中点放置文字
          let mid-x = (n.at(from).at(0) + n.at(to).at(0)) / 2
          let mid-y = (n.at(from).at(1) + n.at(to).at(1)) / 2
          // 文字稍微偏离线条一点
          let offset-x = if n.at(to).at(0) < n.at(from).at(0) { -0.15 } else { 0.15 }
          content((mid-x + offset-x, mid-y + 0.15), text(size: 9pt)[#label])
        }

        // --- 绘制所有连线 ---
        
        // 左侧普通线
        edge("root", "l1", "0", style: bold-stroke) // 加粗
        edge("l1", "l2", "1", style: bold-stroke)   // 加粗
        edge("l2", "l3", "0", style: bold-stroke)   // 加粗
        edge("l3", "leaf_l_2", "1", style: bold-stroke) // 加粗 (终点)
        
        edge("l3", "leaf_l_1", "0")
        edge("l2", "leaf_l_3", "1")

        // 右侧普通线
        edge("root", "r1", "1")
        edge("r1", "r2", "0") // 图上这里好像是折过来的，简化为直连
        edge("r2", "r3", "1")
        edge("r3", "r4", "1")
        edge("r4", "leaf_r_1", "0")
        edge("r4", "leaf_r_2", "1")

        // --- 绘制节点 ---
        
        // 内部节点 (圆形)
        let circles = ("root", "l1", "l2", "l3", "r1", "r2", "r3", "r4")
        for k in circles {
          circle(n.at(k), radius: node-rad, fill: white, stroke: black)
        }

        // 叶子节点 (方形)
        let squares = ("leaf_l_1", "leaf_l_2", "leaf_l_3", "leaf_r_1", "leaf_r_2")
        for k in squares {
          let pos = n.at(k)
          rect(
            (pos.at(0) - leaf-size/2, pos.at(1) - leaf-size/2),
            (pos.at(0) + leaf-size/2, pos.at(1) + leaf-size/2),
            fill: white, stroke: black
          )
        }
      })
    )
  ],
  caption:"用5个前缀构成的二叉线索"
)

我们以上图这个例子来说明.
这里有5个IP.为了简化二叉线索的结构,可以先找出对应于每一个IP地址的唯一前缀(unique prefix).
所谓唯一前缀就是在*表中所有*的IP地址中,该前缀是唯一的.
在进行查找时,只要能够和唯一前缀相匹配就行了.

假定有一个IP地址是10011011 01111010 00000000 00000000,需要查找该地址是否在此二叉线索中.
我们从最左边查起.很容易发现,查到第三个字符(即前缀10后面的0)时,在二叉线索中就找不到匹配的,说明这个地址不在这个二叉线索中.

显然,要将二叉线索用于转发表中,还必须使二叉线索中的每一个叶节点包含所对应的网络前缀和子网掩码.
当搜索到一个叶节点时,就必须将寻找匹配的目的地址和该叶节点的子网掩码进行按位AND运算,看结果是否与对应的网络前缀相匹配.

为了提高二叉线索的查找速度,广泛使用了各种压缩技术.

== IMCP

为了更有效地转发IP数据报和提高交付成功的机会,在网络层使用了*网络控制报文协议ICMP(Internet Control Message Protocol)*.
ICMP允许主机或路由器报告差错情况和提供有关异常情况的报告.ICMP是互联网的标准协议,但ICMP不是高层协议(看起来好像是高层协议,因为ICMP报文装在IP数据报中,作为其中的数据部分),而是IP层的协议.
ICMP报文作为IP层数据报的数据,加上数据报的首部,组成IP数据报发送出去.
#figure(
  canvas({
    import draw: *

    // --- 尺寸定义 ---
    let w = 10 // 总宽度 (代表 32 位)
    let h = 0.8 // 单行高度
    
    // 计算比特位对应的 x 坐标
    let x-0 = 0
    let x-8 = w * (8/32)
    let x-16 = w * (16/32)
    let x-31 = w

    // --- 1. 绘制主体表格 ---

    // 第一行: 类型(8), 代码(8), 检验和(16)
    rect((x-0, 0), (x-8, -h), name: "r1-1")
    content("r1-1", [类型])
    
    rect((x-8, 0), (x-16, -h), name: "r1-2")
    content("r1-2", [代码])
    
    rect((x-16, 0), (x-31, -h), name: "r1-3")
    content("r1-3", [检验和])

    // 第二行
    rect((x-0, -h), (x-31, -2*h), name: "r2")
    content("r2", [(这 4 个字节取决于 ICMP 报文的类型)])

    // 第三行 (数据部分，稍高一点)
    rect((x-0, -2*h), (x-31, -3*h), name: "r3")
    content("r3", [ICMP 的数据部分 (长度取决于类型)])

    // --- 2. 绘制顶部刻度 ---
    
    content((x-0 - 0.25, 0.4), [位 0])
    content((x-8, 0.4), [8])
    content((x-16, 0.4), [16])
    content((x-31, 0.4), [31])

    // --- 3. 绘制左侧标注 ---
    
    // 文本
    let anno-pos = (-4, -h/2) // 定义文本中心位置
    content(anno-pos, [前 4 个字节\ 是统一的格式])
    
    // 箭头
    line(
      (-2.5, -h/2), 
      (x-0, -h/2), 
      stroke: 0.8pt,
      mark: (end: ">", fill: black)
    )
  }),
  caption: "ICMP报文的格式"
)

ICMP报文有两种,即ICMP差错报告报文和ICMP询问报文.
#figure(
  table(
    columns: (auto, auto, auto), // 列宽：前两列自适应，最后一列占据剩余空间

    // --- 表头 ---
    table.header(
      [*ICMP 报文种类*], 
      [*类型的值*], 
      [*ICMP 报文的类型*]
    ),

    // --- 差错报告报文 (跨 4 行) ---
    table.cell(rowspan: 4)[差错报告报文],
    [3], [终点不可达],
    [11], [时间超过],
    [12], [参数问题],
    [5], [改变路由(Redirect)],

    // --- 询问报文 (跨 2 行) ---
    table.cell(rowspan: 2)[询问报文],
    [8 或 0], [回送(Echo)请求或回送回答],
    [13 或 14], [时间戳(Timestamp)请求或时间戳回答]
  ),
  caption: "几种常用的ICMP报文类型"
)

=== 应用举例

Ping: Ping是应用层直接用网络层,不经过运输层.

traceroute: traceroute用于跟踪一个包从源点到终点的路径.
  - traceroute从源主机向目的主机发送一连串的IP数据报,数据报中封装的是无法交付的UDP用户数据报(这是通过非法端口号实现无法交付).
  - traceroute的每个包的TTL经过设计,路由器会给用户返回ICMP超时报文;目的主机返回ICMP终点不可达报文.