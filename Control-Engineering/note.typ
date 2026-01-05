#import "../template/conf.typ": conf
#import "../template/components.typ": *
#import "@preview/cetz:0.3.4"

#show: conf.with(
  title: [
    控制工程
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

= 线性系统的数学描述

p.s. 线性时不变系统即为线性定常系统, 线性时变系统即为线性非定常系统.

== 时域数学模型 - 微分方程

=== 微分方程描述

$
c^((n))(t) + a_1 c^((n - 1))(t) + dots + a_(n - 1) c'(t) + a_n c(t) \
= b_0 r^((m))(t) + b_1 r^((m - 1))(t) + dots + b_(m - 1) r'(t) + b_m r(t)
$

式中, $r(t)$和$c(t)$分别是系统的输入信号和输出信号; 

/ 系统阶数: 方程中最高导数项的阶数，即: 微分方程的阶数。

=== 单位脉冲响应描述

适用条件: 线性定常, 零初始条件.

$ H: r(t) arrow c(t), c(t) = H[r(t)] $

/ 单位脉冲函数: 即信号与系统中的单位冲激信号$delta(t)$, 其定义为:

$ delta(t) = cases(
  0 "if" t != 0,
  infinity "if" t = 0
), "且" integral_(-infinity)^(infinity) delta(t) d t = 1 $

/ 单位脉冲响应: 即系统对单位脉冲函数的响应, 记为$g(t) = H[delta(t)]$

LTI(线性时不变)系统的性质: 
#align(
  center, 
  table(
    fill: (x, y) => if y == 0 {luma(80%)},
    align: center,
    columns: 2,
    [*输入信号*], [*输出信号*],
    $delta(t)$, $g(t)$,
    $A delta(t)$, $A g(t)$,
    $delta(t - tau)$, $g(t - tau)$,
))

/ 卷积: $c(t) = g(t) * r(t) = integral_0^(infinity) g(t - tau) r(t) d tau$

== 频域数学模型 - 传递函数

传递函数不但可以反映系统的输入、输出动态特性，而且可以间接反映结构和参数变化对系统输出的影响。
经典控制理论中广泛采用的频域法和根轨迹法，就是以传递函数为基础建立起来的。传递函数是经典控制理论中最基本和最重要的概念。

/ 传递函数: LTI系统的零初始条件下, 系统输出拉氏变换与输入拉氏变换之比定义为: 
$ G(s) = C(s) / R(s) = integral_0^(infinity) g(t) e^(-s t) d t $

=== Laplace变换

/ Laplace变换: 将时域信号转换为复频域信号的数学工具, 定义为:
$ F(s) = cal(L)[f(t)] = integral_0^(infinity) f(t) e^(-s t) d t $
其中, $s = sigma + j omega$ 是复频域变量, $sigma$是衰减率, $omega$是角频率, $f(t)$称为原函数, $F(s)$称为象函数. 

Laplace变换的性质:
#align(
  center, 
  table(
    fill: (x, y) => if y == 0 {luma(80%)},
    align: center,
    columns: 2,
    [*性质*], [*公式*],
    "线性", $cal(L)[a f(t) + b g(t)] = a F(s) + b G(s)$,
    "时移", $cal(L)[f(t - t_0)] = e^(-s t_0) F(s)$,
    "频移", $cal(L)[e^(a t) f(t)] = F(s - a)$,
    "微分", $cal(L)[f'(t)] = s F(s) - f(0)$,
    "积分", $cal(L)[integral_0^t f(tau) d tau] = 1/s F(s)$,
    "初值定理", $lim_(t arrow 0) f(t) = lim_(s arrow infinity) s F(s)$,
    "终值定理", $lim_(t arrow infinity) f(t) = lim_(s arrow 0) s F(s)$,
))

=== 特征方程, 特征根, 零极点

$ G(s) = C(s) / R(s) = dots = M(s) / N(s) $

/ 特征方程: 传递函数的分母多项式为0的方程, 即$N(s) = 0$, 其中$M(s)$是分子多项式.
/ 特征根: 特征方程的根, 即$N(s) = 0$的解, 记为$s_i$.
/ 零极点: 传递函数的零点和极点, 即$M(s) = 0$的解为零点, $N(s) = 0$的解为极点.

=== 传递函数的三种形式

- 分子分母多项式
- 零极点增益形式: $G(s) = K (s - z_1)(s - z_2) dots / ((s - p_1)(s - p_2) dots)$, 其中$z_i$是零点, $p_i$是极点, $K$是增益.
- 时间常数形式: $G(s) = K / (T_1 s + 1)(T_2 s + 1) dots$, 其中$T_i$是时间常数, $K$是增益.

=== 几种典型环节

+ 比例环节/放大环节
+ 惯性环节/非周期环节 $T c'(t) + c(t) = K r(t)$
+ 纯微分环节
+ 积分环节
+ 二阶震荡环节 $T^2 c''(t) + 2 zeta T c'(t) + c(t) = r(t), 0 <= zeta < 1$
+ 纯时延环节 $c(t) = r(t - tau)$

== 结构图

/ 结构图: 用于描述系统的输入、输出、环节和连接关系的图形表示方法.

如图所示: 

#align(
  center, 
cetz.canvas({
  import cetz.draw: *
  set-style(mark: (end: ">", fill: black))
  line((), (rel: (2, 0)), name: "input")
  rect((rel: (0, -0.5)), ((rel: (2, 1))), name: "system")
  line((rel: (0, -0.5)), (rel: (2, 0)), name: "output")
  content("system", $G(s)$)
  content("input", $R(s)$, anchor: "south")
  content("output", $C(s)$, anchor: "south")
}))

/ 相加点, 分支点: 分别如下图(a), (b)所示: 

#align(
  center,
  cetz.canvas(
    {
      import cetz.draw: *
      set-style(mark: (end: ">", fill: black))
      line((), (rel: (2, 0)), name: "input11")

      junction(obj_name: "junction1")

      line((rel: (.3, 0)), (rel: (2, 0)), name: "output1")
      line((rel: (-2.3, -2.3)), (rel: (0, 2)), name: "input12")

      line((8, 0), (rel: (4, 0)), name: "output21")
      line((rel: (-2, 0)), (rel: (0, -2)), name: "output22")

      content("input11", $u(t), U(s)$, anchor: "south", padding: .2)
      content("output1", $u(t) plus.minus r(t) \ U(s) plus.minus r(t)$, anchor: "south", padding: .2)
      content("input12", $r(t), R(s)$, anchor: "west", padding: .2)
      content((name: "input11", anchor: 80%), $+$, anchor: "north", padding: .2)
      content((name: "input12", anchor: 80%), $plus.minus$, anchor: "east", padding: .2)
      content("input12.start", [(a)], anchor: "north", padding: 1)

      content("output21", $u(t), U(s)$, anchor: "south", padding: .2)
      content("output22.end", [(b)], anchor: "north", padding: 1.3)
    }
  )
)

=== 闭环系统结构图

1. 无扰动的闭环系统结构图

#align(
  center,
  cetz.canvas({
    import cetz.draw: *
    set-style(mark: (end: ">", fill: black))
    line((), (rel: (2, 0)), name: "input")
    junction()
    line((rel: (.3, 0)), (rel: (2, 0)), name: "e")
    rect((rel: (0, -0.5)), ((rel: (2, 1))), name: "system")
    line((rel: (0, -0.5)), (rel: (2, 0)), name: "output")
    line((rel: (-1, 0)), (rel: (0, -2)), (rel: (-1, 0)))
    rect((rel: (0, -0.5)), ((rel: (-2, 1))), name: "feedback")
    line((rel: (0, -0.5)), (rel: (-2.3, 0)), (rel: (0, 1.7)), name: "b")

    content("system", $G(s)$)
    content("input", $R(s)$, anchor: "south")
    content("output", $C(s)$, anchor: "south")
    content((name: "input", anchor: 80%), $+$, anchor: "north", padding: .2)
    content("e", $E(s)$, anchor: "south")
    content("feedback", $H(s)$)
    content((name: "b", anchor: 70%), $B(s)$, anchor: "east", padding: .2)
    content((name: "b", anchor: 90%), $-$, anchor: "west", padding: .2)
  })
)

其中, $E(s)$为偏差信号, $B(s)$为反馈信号. $H(s)$为反馈传递函数. 

/ 开环传递函数: $ (B(s)) / (E(s)) = G(s) dot H(s) $
/ 前向传递函数: $ (C(s)) / (E(s)) = G(s) $
/ 单位反馈系统: 即$H(s) = 1$, 则开环传递函数和前向传递函数相同.
/ 闭环传递函数: $ (C(s)) / (R(s)) = G(s) / (1 + G(s) dot H(s)) $

2. 有扰动的闭环系统结构图

#align(
  center,
  cetz.canvas({
    import cetz.draw: *
    set-style(mark: (end: ">", fill: black))
    line((), (rel: (2, 0)), name: "input")
    junction()
    line((rel: (.3, 0)), (rel: (2, 0)), name: "e")
    rect((rel: (0, -0.5)), ((rel: (2, 1))), name: "g1")
    line((rel: (0, -0.5)), (rel: (1, 0)), name: "g1_output")
    junction()
    line((rel: (0, 2)), (rel: (0, -1.7)), name: "n")
    line((rel: (.3, -.3)), (rel: (1, 0)))
    rect((rel: (0, -.5)), ((rel: (2, 1))), name: "g2")
    line((rel: (0, -0.5)), (rel: (2, 0)), name: "output")
    line((rel: (-1, 0)), (rel: (0, -2)), (rel: (-1-2.3, 0)))
    rect((rel: (0, -0.5)), ((rel: (-2, 1))), name: "feedback")
    line((rel: (0, -0.5)), (rel: (-2.3-2.3, 0)), (rel: (0, 1.7)), name: "b")

    content("g1", $G_1(s)$)
    content("input", $R(s)$, anchor: "south")
    content("output", $C(s)$, anchor: "south")
    content((name: "input", anchor: 80%), $+$, anchor: "north", padding: .2)
    content("e", $E(s)$, anchor: "south")
    content("feedback", $H(s)$)
    content((name: "b", anchor: 80%), $B(s)$, anchor: "east", padding: .2)
    content((name: "b", anchor: 90%), $-$, anchor: "west", padding: .2)
    content("n", $"扰动" \ N(s)$, anchor: "west", padding: .2)
    content((name: "n", anchor: 80%), $+$, anchor: "east", padding: .2)
    content((name: "g1_output", anchor: 80%), $+$, anchor: "north", padding: .2)
    content("g2", $G_2(s)$)
  })
)

=== 结构图化简

1. 串联相乘, 并联相加
2. 反馈环节化简 $ C(s) / R(s) = G(s) / (1 plus.minus G(s) H(s)) $
3. 相加点分支点移动(结合律)
4. 相邻点移动(同类型)

== 信号流图

#figure(
  image("assets/signal-flow.png"), 
  caption: [信号流图],
)

信号流图是由节点和支路组成的一种信号传递网络。
/ 节点: 方程中的变量, 用“$circle$”表示. 
/ 支路: 连接两个节点的线段.
/ 输入节点(源): 仅具有输出支路的节点.
/ 输出节点(陷): 仅有输入支路的节点.
/ 混合节点: 既有输入又有输出支路. 
/ 通道: 沿支路箭头方向而穿过各相连支路的途径.
/ 开通道: 与任一节点相交不多于一次的通道.
/ 闭通道: 通道的终点就是起点，与任何其他节点相交不多于一次的通道. 
/ 前向通道: 从输入节点（源）到输出节点（阱）的通道上, 通过任何节点不多于一次的通道. 
/ 前向通道增益: 前向通道上各支路增益乘积, 称前向通道增益, 用$P_k$表示. 
/ 不接触回路: 回路之间没有公共节点. 

- 信号流图适用于线性系统。
- 支路表示一个信号对另一个信号的函数关系，信号只能沿支路上的箭头指向传递。
- 在节点上可以把所有输入支路的信号叠加，并把相加后的信号送到所有的输出支路。
- 混合节点增加一个具有单位增益的支路可以把它作为输出节点来处理。
- 对于一个给定的系统，信号流图不是唯一的。

== 梅森公式

$ P = 1 / Delta sum_k P_k Delta_k $
/ $P$: 系统总增益. 
/ $k$: 向前通道数目.
/ $Delta$: 信号流图的特征式.
/ $Delta_k$: 第$k$条前向通道$P_k$的余因式

= 线性系统的时域分析

== 典型输入信号

- 阶跃函数
- 斜坡函数(ReLU激活函数)
- 抛物线(二次函数)
- 脉冲函数(冲激函数)
- 正弦函数

这些函数在*信号与系统*课程中基本已经提及, 此处不再赘述. 

== 动态和稳态

=== 动态指标

/ 动态性能: 一般由单位阶跃响应表征系统动态性能. 

#let func(t) = {
  return 1 - 1.07 * calc.pow(calc.e, -0.376 * t) * calc.sin(0.98 * t + 1.206)
}

#grid(
  align: center+horizon,
  columns: (1fr, 1fr),
[
- 最大超调量
- 峰值时间
- 上升时间
- 调整时间
- 延迟时间
- 振荡次数: $N$
], 
align(
  center, 
  cetz.canvas({
    import cetz.draw: *

    let x_lim = 6
    let y_lim = 4

    // let points = ()
    // let sample_num = 100
    // for x in range(sample_num) {
    //   x = x / sample_num * x_lim / .6
    //   points.push((x * 0.6, func(x) * 2.5))
    // }
    // line(..points)
    
    bezier((0, 0), (x_lim, 2), (2, 5), (3, 2))
    line((x_lim, 2), (0, 2), stroke: (dash: "dashed", paint: blue))

    hide(circle((3, 3.5), radius: 2pt, name: "formula"))
    

    line((1.04, 0), (rel: (0, 2)), stroke: (dash: "dashed"))
    line((x_lim - .8, 2.08), (rel: (0, -2.08)), stroke: (dash: "dashed"))

    set-style(mark: (symbol: ">", fill: black))
    line((2.4, 2), (rel: (0, .9)), stroke: red, mark: (fill: red), name: "a")
    line((rel: (0, -.9)), (2.4, 0), stroke: blue, mark: (fill: blue), name: "b")

    line((1.04, 1.5), (0, 1.5), stroke: (dash: "dashed"), name: "tr")
    line((2.4, 1), (0, 1), stroke: (dash: "dashed"), name: "tp")
    line((x_lim - .8, .5), (0, .5), stroke: (dash: "dashed"), name: "ts")

    set-style(mark: (symbol: none, end: ">", fill: black))
    line((0, 0), (0, y_lim))
    line((0, 0), (x_lim, 0))

    content("formula", $"超调量" sigma% = A / B times 100%$)
    content("tr", $"上升" \ "时间"t_r$, anchor: "south", padding: .5)
    content("tp.start", $"峰值" \ "时间"t_p$, anchor: "south-east", padding: .1)
    content((name: "ts", anchor: 25%), $"调节时间"t_s$, anchor: "south", padding: .1)
    content("a", {
      set text(red)
      $A$
      }, anchor: "west", padding: .1)
    content(
      "b", 
      {
        set text(blue)
        $B$
      },
      anchor: "west", 
      padding: .1
    )

  })
)
)

=== 稳态指标

只有当动态过程收敛时, 研究系统的稳态性能才有意义.稳态误差是描述系统稳态性能的一种性能指标, 通常在阶跃函数、斜坡函数或加速度函数作用下进行测定或计算. 若时间趋于无穷时, 系统输出不等于输入量或输入量的确定函数, 则系统存在稳态误差. 稳态误差是系统控制精度或抗扰动能力的一种度量. 

== 一阶系统的时域分析

#grid(
  align: center+horizon, 
  columns: (1fr, 1fr), 
  inset: 5pt,
  cetz.canvas({
    import cetz.draw: *
    set-style(mark: (end: ">", fill: black))
    line((), (rel: (2, 0)), name: "input")
    junction()
    line((rel: (.3, 0)), (rel: (2, 0)), name: "e")
    rect((rel: (0, -0.5)), ((rel: (2, 1))), name: "system")
    line((rel: (0, -0.5)), (rel: (2, 0)), name: "output")
    line((rel: (-1, 0)), (rel: (0, -2)), (rel: (-5.3, 0)), (rel: (0, 1.7)), name: "b")

    content("system", $1 / (T s)$)
    content("input", $R(s)$, anchor: "south")
    content("output", $C(s)$, anchor: "south")
    content((name: "input", anchor: 80%), $+$, anchor: "north", padding: .2)
    content("e", $E(s)$, anchor: "south")
    content((name: "b", anchor: 90%), $-$, anchor: "west", padding: .2)
  }), 
  cetz.canvas({
    import cetz.draw: *
    set-style(mark: (end: ">", fill: black))
    line((), (rel: (2, 0)), name: "input")
    rect((rel: (0, -.5)), (rel: (2, 1)), name: "system")
    line((rel: (0, -.5)), (rel: (2, 0)), name: "output")

    content("system", $1 / (T s + 1)$)
    content("input", $R(s)$, anchor: "south")
    content("output", $C(s)$, anchor: "south")
  }),
  [(a)], 
  [(b)]

)

=== 单位阶跃响应

$ r(t) = u(t), space R(s) = 1 / s $
从而, 
$ C(s) = 1 / (s (T s + 1)) = 1 / s - T / (T s + 1) $
$ c(t) = cal(L^(-1)) {C(s)} = 1 - e^(- t / T), (t >= 0) $

=== 单位脉冲响应

$ r(t) = delta(t), R(s) = 1 $
$ C(s) = 1 / (T s + 1), c(t) = 1 / T e^(- t / T) (t >= 0) $

=== 单位斜坡响应

$ r(t) = t(t >= 0), R(s) = 1 / s^2 $
$ C(s) = 1 / s^2 - T / s + T^2 / (T s + 1), c(t) = (t - T) + T e^(- t / T)(t >= 0) $

=== 单位加速度响应

$ r(t) = 1 / 2 t^2, R(s) = 1 / s^3 $
$ C(s) = 1 / (T s + 1) dot 1 / s^3 $
$ c(t) = 1 / 2 t^2 - T t + T^2(1 - e^(- t / T)) $

== 二阶系统的时域分析

$ G_1(s) = K_1 / (tau s + 1), G_2(s) = K_2 / s $
$ G(s) = C(s) / R(s) = (K_1 K_2) / (tau s^2 + s + K_1 K_2) $

取$(K_1 K_2) / tau = omega_n^2, 1 / tau = 2 zeta omega_n$则可得二阶系统的标准形式: 
$ G(s) = C(s) / R(s) = omega_n^2 / (s^2 + 2 zeta omega_n s + omega_n^2) $
其中, $zeta$称为阻尼比, $tau$为时间常数, $omega_n$为系统的自然振荡角频率 (无阻尼自振角频率).

=== 特征根分布

特征方程: 
$ s^2 + 2 zeta omega_n s + omega_n^2 = 0 $
$ 
=> s_(1, 2) & = - zeta omega_n plus.minus sqrt(zeta^2 - 1) \
& = sigma plus.minus j omega
$

- 欠阻尼: $0 < zeta < 1$, 特征根为一对共轭复数 
$ s_(1, 2) = - zeta omega_n plus.minus j omega_n sqrt(1 - zeta^2) $
- 临界阻尼: $zeta = 1$, 特征根为两个相同负实数 
$ s_(1, 2) = - omega_n $
- 过阻尼: $zeta > 1$, 特征根为两个不同实数 
$ s_(1, 2) = - zeta omega_n plus.minus omega_n sqrt(zeta^2 - 1) $
- 无阻尼: $zeta = 0$, 特征根为一对共轭纯虚数 
$ s_(1, 2) = plus.minus j omega_n $

=== 单位阶跃响应

$ C(s) = omega_n^2 / (s (s^2 + 2 zeta omega_n s + omega_n^2)) $

在控制工程中, 除了不允许产生超调和震荡的情况外, 通常希望系统工作在$0.4 < zeta < 0.8$的欠阻尼状态. 

== 线性系统的稳定性分析

/ 稳定和不稳定: 一个原处于某一平衡状态的系统，受到某一扰动作用偏离了原平衡状态。当扰动消失后，如系统还能回到原平衡状态附近，则称该系统稳定。反之，系统不稳定。
/ 零状态响应的稳定性: 如果系统对于每一个有界输入的零状态响应仍保持有界，则称该系统的零状态响应是稳定的。又称为有界输入有界输出稳定(BIBO稳定). 

=== LTI 系统的稳定性充要条件

对于单输入, 输出的LTI系统微分方程一般形式通常为: 
$
  c^((n))(t) + a_1 c^((n - 1))(t) + dots.c + a_(n - 1) c'(t) + a_n c(t) \
  = b_0 r^((m))(t) + dots.c + b_m r_m(t)
$
其特征方程为: 
#align(
  center, 
  rect($ s^n + a_1 s^(n - 1) + dots.c + a_(n - 1) s + a_n = 0 $)
)

*线性定常系统零输入响应稳定的充要条件是其特征方程的根均具有负实部。*

=== 劳斯判据

对于这样的特征方程, 劳斯判据给出稳定的必要与充分条件分别为: 
/ 必要条件: 控制系统特征方程式的所有系数$a_i$均为正值，且特征方程式不缺项。
/ 充分条件: 劳斯表中第一列所有项均为正号. 

将多项式系数排列如下, 可以得到劳斯表: 

#align(
  center, 
  grid(
    align: center+horizon, 
    columns: 6, 
    stroke: (x, y) => {
      if x == 0 {
        (
          right: (
            paint: luma(180),
            thickness: 1.5pt,
            dash: "dotted"
          ), 
          left: (
            paint: black
          )
        )
      }
      if y == 0 {
        (
          top: (
            paint: black
          )
        )
      }
    },
    inset: 5pt,
    $s^n$, $a_0$, $a_2$, $a_4$, $a_6$, $dots.c$,
    $s^(n - 1)$, $a_1$, $a_3$, $a_5$, $a_7$, $dots.c$, 
    $s^(n - 2)$, $b_1$, $b_2$, $b_3$, $b_4$, $dots.c$,
    $s^(n - 3)$, $c_1$, $c_2$, $c_3$, $dots.c$, $dots.c$, 
    $dots.v$, $dots.v$, $dots.v$, $dots.v$, [], [], 
    $s^2$, $d_1$, $d_2$, $d_3$, [], [], 
    $s^1$, $e_1$, $e_2$, [], [], [], 
    $s^0$, $f_1$
  )
)

其中, 系数$b$, $c$等的求法采用上两行系数交叉相乘, 即: 
$ b_1 = (a_1 a_2 - a_0 a_3) / a_1; b_2 = (a_1 a_4 - a_0 a_5) / a_1; b_3 = (a_1 a_6 - a_0 a_7) / a_1 $
计算直到后续的值为0. 

*特殊情况处理*
- 在劳斯表的某一行中，出现第一个元为零，而其余各元均不为零，或部分不为零的情况；
- 在劳斯表的某一行中，出现所有元均为零的情况。
这两种情况*表明*: 系统在复平面内存在正根或存在两个大小相等符号相反的实根或存在两个共轭虚根（即存在关于原点对称的根），系统处在不稳定状态或临界稳定状态. 

== 控制系统的稳态误差

/ 稳态误差: $ e_(s s) = lim_(t -> infinity) e(t) $

=== 系统的类型

系统的类型由开环传递函数确定: 
$ G_O(s) = (K product_(i = 1)^m (tau_i s + 1)) / (s^gamma product _(j = 1)^m (T_j s + 1)) $

其中, $gamma = 0, 1, 2$的系统分别称为*0型系统, I型系统, II型系统*. 

/ 系统误差: 由系统设定输入信号引起的误差，反映了系统跟踪输入信号的能力. 
/ 扰动误差: 由扰动信号引起的误差，反映了系统抑制扰动的能力. 

=== 稳态误差计算

#align(
  center, 
  table(
    columns: (1fr, 1fr, 1fr, 1fr, 1fr, 1fr, 1fr), 
    align: center+horizon, 
    inset: 10pt, 
    table.cell(rowspan: 2)[系统 \ 类型], table.cell(colspan: 3)[静态误差系数], table.cell(colspan: 3)[稳态误差], 
    [单位阶跃 $K_p$], [单位斜坡 $K_v$], [单位加速 $K_a$], $1(t)$, $t$, $ 1 / 2 t^2 $, 
    [0型], $K$, $0$, $0$, $ 1 / (1 + K) $, $infinity$, $infinity$,
    [I型], $infinity$, $K$, $0$, $0$, $ 1 / K $, $infinity$, 
    [II型], $infinity$, $infinity$, $K$, $0$, $0$, $ 1 / K $
  )
)

= 根轨迹法

/ 根轨迹: 当开环系统的某个参数（如开环增益K）由零连续变化到无穷大时，闭环特征根（闭环极点）在复平面上形成的若干条曲线

== 基本概念

+ 开环传递函数化为*零极点增益形式*: \
  #box(stroke: black, inset: 5pt, width: 100%)[$ G(s) = K / (s(0.5s + 1)) = k / s(s + 2), k = 2K $]
+ 用$times$将开环极点$p_1 = 0, p_2 = -2$绘制在复平面上. 
+ 求出闭环特征方程和闭环极点: \
  #box(width: 1fr)[
    $ D(s) = s^2 + 2s + k = 0 $
    $ s = -1 plus.minus sqrt(1 - k) $
  ]
+ 绘制根轨迹: 

#let cross_point(loc, size: 5pt) = {
  import cetz.draw: *
  for d in range(45, 360, step: 90) {
    d = d / 180 * calc.pi
    line(loc, (rel: (angle: d, radius: size)))
  }
  line(loc, loc)
}

#align(
  center, 
  cetz.canvas(
    length: 3cm, 
    {
      import cetz.draw: *

      scale(y: 0.5)

      set-style(
        mark: (fill: black),
        stroke: (thickness: 0.4pt, cap: "round"),
        angle: (
          radius: 0.3,
          label-radius: .22,
          fill: green.lighten(80%),
          stroke: (paint: green.darken(50%))
        ),
        content: (padding: 1pt)
      )
      
      line((-2.5, 0), (1, 0), mark: (end: "stealth"))
      content((), $ x $, anchor: "west")
      line((0, -4), (0, 4), mark: (end: "stealth"))
      content((), $ y $, anchor: "south")
      grid((-2.5, -4), (1, 4), step: 0.5, stroke: gray + 0.2pt)

      cross_point((0, 0))
      content((), $k = 0$, anchor: "south-west", padding: 5pt)
      cross_point((-2, 0))
      content((), $k = -2$, anchor: "south", padding: 5pt)
      line((), (-1, 0), mark: (end: ">", fill: green), stroke: green+1.5pt)
      line((0, 0), (-1, 0), mark: (end: ">", fill: green), stroke: green+1.5pt)
      content((), $k = 1$, anchor: "south-west", padding: 5pt)

      line((-1, -3.5), (-1, 3.5), stroke: red+2pt, mark: (symbol: ">"))
      content((-1, -3.5), $k = infinity$, anchor: "west", padding: 5pt)
      content((-1, 3.5), $k = infinity$, anchor: "west", padding: 5pt)

      for (k, label) in ((2, $k = 2$), (3, $k = 3$)) {
        circle((-1, k), radius: 3pt, fill: black)
        content((), label, anchor: "east", padding: 5pt)
        circle((-1, -k), radius: 3pt, fill: black)
        content((), label, anchor: "east", padding: 5pt)
      }
    }
  )
)

*分析*: 
- 稳定性: 无论$K$取何值，由图4-1表示的控制系统的闭环极点均位于复平面的左半平面，因此系统是闭环稳定的；
- 动态性能: $k=1$（$K=0.5$）是此二阶系统由过阻尼状态过渡到欠阻尼状态的分界点，不同的阻尼状态对应的系统动态特性有明显差别；
- 稳态性能: 系统属于I型系统，$K$即为静态速度误差速度系数。如果给定稳态误差要求，则由根轨迹图可以确定闭环极点位置的允许范围。

== 绘制根轨迹

设负反馈系统的开环传递函数为$G(s)H(s)$，其中$G(s)$和$H(s)$分别为控制系统的前向通道传递函数和反馈通道传递函数，则闭环系统的特征方程为$ 1+ G(s) H(s) = 0 $

在复数域上可写为: 
$ |G(s) H(s)| e^(j arg(G(s) H(s))) = e^(j(- pi + 2 k pi)), k = 0, 1, 2 dots $

从而得到: 
/ 幅值条件: $ |G(s) H(s)| = 1 $
/ 相角条件: $ arg(G(s)H(s)) = (2k - 1) pi, k = 0, 1, 2, dots $

/ 零极点增益形式: 根轨迹的标准形式 $ 1 + K M(s) / N(s) = 0 $

- 根轨迹连续, 且关于实轴对称; 
- 根轨迹起点为开环极点，终点为开环零点（或无穷远处）, 根轨迹的分支数等于闭环极点的个数，也等于开环极点的数目, 等于特征方程的阶数; 
- 实轴上根轨迹区段右侧的开环零极点数目之和为奇数;
- 如果开环零点的数目$m$小于开环极点数$n$，即$n > m$，则有( $n - m$ )条根轨迹沿着渐近线终止于无穷远处。渐近线的方位可由下面的方程决定
  - 渐近线与实轴的交点坐标 \
    #box(width: 1fr)[
      $ sigma_a = (sum_(i = 1)^n p_i - sum_(j = 1)^m z_j) / (n - m) $
    ]
  - 渐近线与实轴正方向的夹角 \
    #box(width: 1fr)[
      $ phi_a = (plus.minus(2k + 1) pi) / (n - m), k = 0, 1, 2, dots $
    ]
  - 当$k = 0$时，对应与实轴有最小夹角的渐近线。
  - 尽管这里假定k可以取无限大，但随着k值的增加，渐近线与实轴正方向的夹角会重复出现，并且独立的渐近线只有$(n-m)$条。
- 如果实轴上相邻两极点（或两零点）之间的线段属于根轨迹，则它们之间必存在分离点（或会合点）
  - 分离点是特征方程的重根
- 根轨迹与虚轴相交，说明控制系统有位于虚轴上的闭环极点，即特征方程含有纯虚数的根
- 根轨迹的出射角（或入射角）指的是根轨迹离开开环复数极点处（或进入开环复数零点处）的切线方向与实轴正方向的夹角
  - 根轨迹从复数极点$p_r$出发的出射角为 \
    #box(width: 1fr)[
      $ theta_(p_r) = plus.minus(2k + 1)pi + sum_(j = 1)^n arg(p_r - p_j) + sum_(i = 1)^m arg(p_r - z_i) $
    ]
  - 根轨迹到达复数零点$z_r$的入射角为 \
    #box(width: 1fr)[
      $ theta_(z_r) = plus.minus(2k + 1)pi + sum_(j = 1)^n arg(z_r - p_j) + sum_(i = 1, i != r)^m arg(z_r - z_i) $
    ]

== 广义根轨迹

=== 参数根轨迹

/ 参数根轨迹: 以非开环增益为可变参数绘制的根轨迹
+ 写出系统的闭环特征方程: $1+G(s)H(s)=0$
+ 变换该方程为: $1 + rho G_1(s)=0$, 其中$rho G_1(s)$称为等效开环传递函数
+ 按照常规根轨迹法则，再绘制以$K^*$为参变量的根轨迹。

*例如: *
给定, $ 1 + G(s) H(s) = 1 + (10(1 + K_s s)) / (s(s + 2)) = 0 $
变形得 $ 1 + (10 K_s s) / (s^2 + 2s + 10) = 0 $
从而得($rho = 10, K^* = rho K_s$) $ G_o '(s) = (K^* s) / (s^2 + 2s + 10) $

=== 零根度轨迹

/ 零根度轨迹: 正反馈系统的根轨迹, 其特征方程为 $ 1 - G(s) H(s) = 0 $
幅值条件不变, 而相角条件变为: $ arg(G(s) H(s)) = 2k pi, k = 0, 1, 2, dots $

= 线性系统的频域分析

== 频率特性

/ 幅频特性: LTI系统在正弦输入作用下，稳态输出振幅与输入振幅之比 $ A(omega) = A_c / A_r = | G(j omega) | $
/ 相频特性: LTI系统在正弦输入作用下，稳态输出相位与输入相位之差 $ phi(omega) = arg(G(j omega)) $
/ 频率特性: LTI系统正弦输入作用下，输出稳态分量和输入的复数比，也就是幅相频率特性，简称幅相特性 $ A(omega) e^(j phi(omega)) = |G(j omega)| e^(j arg(G(j omega))) $

/ 奈奎斯特图 (Nyquist Graph): 将频率$omega$作为参变量，将幅频与相频特性同时表示在复数平面上。图上实轴正方向为相角零度线，逆时针旋转为正. $ G(j omega) = X(omega) + j Y(omega) $

/ 博德图 (Bode Graph): 将频率特性画成对数坐标图形式，这种对数频率特性曲线由对数幅频特性和对数相频特性组成. 横坐标按$lg omega$分度（10为底的常用对数），即对数分度，单位为弧度/秒（rad/s）. 对数幅频曲线的纵坐标按$L(omega) = 20 lg |G(j omega)| = 20 lg A(omega)$线性分度，单位是分贝（dB）

== 典型环节的频率特性

#table(
  fill: (x, y) => if y == 0 {luma(80%)},
  columns: (auto, 1fr, 1fr, 1fr, 2fr), 
  align: center+horizon, 
  inset: 5pt,
  [*环节名称*], [*频率特性*], [*幅频相频*], [*对数幅频相频*], [*图像*], 
  [比例环节], $ G(j omega) = K $, $ cases(A(omega) = K, phi(omega) = 0) $, $ cases(L(omega) = 20 lg K, phi(omega) = 0) $, image("assets/c4/rate-part-f.png"), 
  [积分环节], $ G(j omega) = 1 / (j omega) \ = 1 / omega e^(-j pi / 2) $, $ cases(A(omega) = 1 / omega, phi(omega) = - pi / 2) $, $ cases(L(omega) = -20 lg omega, phi(omega) = - pi / 2) $, image("assets/c4/integral-part-f.png"), 
  [微分环节], $ G(j omega) = j omega \ = omega e^(j pi / 2) $, $ cases(A(omega) = omega, phi(omega) = pi / 2) $, $ cases(L(omega) = 20 lg omega, phi(omega) = pi / 2) $, image("assets/c4/drive-part-f.png"), 
  [惯性环节], $ G(j omega) = 1 / (1 + j omega T) $, table.cell(colspan: 2)[$ cases(A(omega) = 1 / sqrt(1 + omega^2 T^2), phi(omega) = -arctan omega T) $ $ cases(L(omega) = -20 lg sqrt(1 + omega^2 T^2), phi(omega) = - arctan omega T) $], image("assets/c4/inertia-part-f.png"), 
  [一阶微分], $ G(j omega) = 1 + j omega T $, table.cell(colspan: 2)[$ cases(A(omega) = sqrt(1 + omega^2 T^2), phi(omega) = arctan omega T) $ $ cases(L(omega) = 20 lg sqrt(1 + omega^2 T^2), phi(omega) = arctan omega T) $], image("assets/c4/1grade-drive-f.png")
)

== 系统开环频率特性的绘制

=== Nyquist Graph

+ 写出$A(omega)$和$phi(omega)$的表达式; 
+ 分别求出$omega = 0$和$omega = + infinity$时的$G(j omega)$; 
+ 求Nyquist图与实轴的交点; 
+ 如果有必要，可求Nyquist图与虚轴的交点，交点可利用$G(j omega)$的实部$R e[G(j omega)]=0$的关系式求出，也可利用$arg(G(j omega)) = n dot pi / 2$(其中$n$为正整数)求出; 
+ 必要时画出Nyquist图中间几点; 
+ 勾画出大致曲线; 

=== Bode Graph

+ 将开环频率特性分解为典型环节相乘形式（时间常数形式）; 
+ 求出各典型环节的交接频率（各环节时间常数的倒数），将其从小到大排列为$omega_1, omega_2, omega_3, dots$，并标注在$omega$轴上; 
+ 绘制低频渐近线（$omega_1$左边的部分），这是一条斜率为$-20 nu "dB/dec"$的直线，它或它的延长线应通过$(1, 20lg K)$点和$(K_1/nu, 0)$点；(对于微分环节$nu$取负值); 
+ 随着$omega$的增加，每遇到一个典型环节的交接频率，就按上述方法改变一次斜率; 
+ 必要时可用渐近线和精确曲线的误差表，对交接频率附近的曲线进行修正，以求得更精确曲线; 
+ 对数相频特性可以由各个典型环节的相频特性相加而得，也可以利用相频特性函数$phi(omega)$直接计算; 

=== 最小相位系统

/ 最小相位对象: 复平面右半平面既无零点也无极点的传递函数所表示的对象

== 频域稳定判据和系统相对稳定性

=== Nyquist稳定性判据

给定开环传递函数 $ G(s) H(s) = (K sum_(i=1)^m (s - z_i)) / sum_(i = 1)^n (s - p_i), n >= m $
构造辅助函数$F(s)$ $ F(s) = 1 + G(s)H(s) = (sum_(i = 1)^n (s - s_i)) / (sum_(i = 1)^n (s - p_i)) $

- 闭环系统稳定的充分和必要条件是特征方程的根，即$F(s)$的零点，都位于$s$平面的左半部。

/ Nyquist回线: 一条包围整个s 平面右半部的按顺时针方向运动的封闭曲线

/ Nyquist稳定性判据: 如果在$s$平面上，$s$沿着奈氏回线顺时针方向移动一周时，在$F(s)$平面上的映射曲线$C_F$围绕坐标原点按逆时针方向旋转$N = P$周，则系统是稳定的（$P$为不稳定开环极点的数目） \ 闭环控制系统稳定的充分和必要条件是，当$omega$从$-infinity$变化到$+infinity$时，系统的开环频率特性$G(j omega)H(j omega)$按逆时针方向包围$(-1, j 0)$点$N = P$周，$P$为位于$s$平面右半部的开环极点数目

=== 对数频率稳定判据

/ 判据: 当$omega$由$0$变到$infinity$，在开环对数幅频特性$L(omega) >= 0$的频段内，相频特性$phi(omega)$穿越$-pi$线的次数(正穿越与负穿越次数之差)为$P/2$. $P$为$s$平面右半部开环极点数目. 

=== 系统相对稳定性和稳定裕度

/ 相对稳定性: 若系统开环传递函数没有右半平面的极点，且闭环系统是稳定的，那么乃氏曲线$G(j omega)H(j omega)$离$(-1, j 0)$点越远，则闭环系统的稳定程度越高；反之，$G(j omega)H(j omega)$离$(-1, j 0)$点越近，则闭环系统的稳定程度越低；如果$G(j omega)H(j omega)$穿过$(-1, j 0)$点，则闭环系统处于临界稳定状态

/ 稳定裕度: 衡量闭环稳定系统稳定程度的指标，常用的有相角裕度$gamma$和幅值裕度$K_g$

1. 相角裕度$gamma$

/ 剪切频率: 在频率特性上对应于幅值$A(omega) = 1$的角频率$omega_c$
/ 相角裕度: 在剪切频率处，相频特性距$-pi$线的相位差$gamma$, 即: $ gamma = pi + phi(omega_c) $

对于稳定的系统， $phi(omega_c)$必在伯德图$-pi$线以上，这时称系统有*正相角裕度*

2. 增益裕度$K_g$

/ 穿越频率: 相频特性等于$-pi$的频率$omega_g$
/ 增益裕度: 在穿越频率处, 开环幅频特性$A(omega_g)$的倒数, 即: $ K_g = 1 / A(omega_g) $ 

在Bode Graph上，增益裕度改以分贝(dB)表示 $ K_g = -20 lg A(omega_g) = -L(omega_g) $
对于稳定的系统，$L(omega_g)$必在Bode Graph0dB线以下，这时称为*正增益裕度*

=== 总结

- 工程实践中, 一般希望: 
#align(
  center, 
  rect()[$ gamma in [pi / 6, pi / 3], K_g >= 2, K_g >= 6 "dB" $]
)
- 对于一个稳定的最小相位系统，其相角裕度应为正值，增益裕度应大于1
- 对于最小相位系统，开环幅频特性和相频特性之间存在唯一的对应关系。上述相角裕度意味着，系统开环对数幅频特性在剪切频率处的斜率应大于-40dB/dec，且有一定宽度。在实际中常取-20dB/dec. 
- 在闭环稳定条件下，稳定裕度越大，反映系统稳定程度越高。稳定裕度也间接反映了系统动态过程的平稳性，裕度大意味着超调小、振荡弱，阻尼大。

== 闭环系统的频域性能指标

/ 截止频率(带宽频率$omega_b$): 对数幅频特性的幅值$|C(j omega) / R(j omega)|$下降到-3分贝时对应的频率
/ 带宽BW: 0到$omega_b$的频率范围
  - 带宽愈大，响应速度愈快。带宽小，只有较低频率信号才易通过
/ 谐振峰值$M_r$: 闭环幅频特性的最大值
  - 反映系统的相对稳定性。峰值愈大，系统阶跃响应的超调量愈大
/ 谐振频率$omega_r$: 产生谐振峰值对应的频率
  - 一定程度上反映了系统暂态响应的速度。 频率愈大，暂态响应愈快

= 线性系统校正方法

*校正的本质: *通过改变系统的零极点来改变系统性能。

== 几种校正方式 & 设计方法

#table(
  columns: (auto, 3fr, 1fr), 
  fill: (x, y) => if y == 0 {luma(80%)},
  align: center+horizon, 
  [*校正名称*], [*结构图*], [*说明*], 
  [串联校正], image("assets/c5/series-correction.png"), [], 
  [反馈校正], image("assets/c5/feedback-correction.png"), [], 
  [串联反馈校正], image("assets/c5/series-feedback-correction.png"), [], 
  [前馈补偿], image("assets/c5/feedforward-compensation.png"), [相当于对给定值信号进行整形和滤波后再送入反馈系统], 
  [扰动补偿], image("assets/c5/disturbance-compensation.png"), [对扰动信号直接或间测量，形成附加扰动补偿通道
  ]
)
  
#table(
  columns: (auto, 1fr), 
  fill: (x, y) => if y == 0 {luma(80%)}, 
  align: center+horizon, 
  [*名称*], [*基本思想*], 
  [频率法], [利用适当校正装置的Bode Graph，配合开环增益调整来修改原来开环系统Bode Graph，使得开环系统经校正和增益调整后的Bode Graph符合性能指标要求。], 
  [根轨迹法], [在系统中加入校正装置，相当于增加了新的开环零极点，这些零极点将使校正后的闭环根轨迹，向有利于改善系统性能的方向改变，系统闭环零极点重新布置，从而满足闭环系统性能要求。], 
  [时域法], [在系统中加入校正装置，根据闭环系统传递函数和给定时域性能指标，反向求解校正装置参数。]
)

== 线性系统基本控制规律

#align(
  center, 
  figure(
    image("assets/c5/control-system.png"), 
    caption: [控制系统], 
  )
)

#table(
  columns: (auto, 2fr, 1fr), 
  fill: (x, y) => if y == 0 {luma(80%)}, 
  align: center+horizon, 
  [*控制器名称*], [*公式*], [*说明*], 
  [比例(P)], $ G_c(s) = K_p $, [], 
  [比例-微分(PD)], $ G_c(s) & = K_p(1 + T_d s) \ m(t) & = K_p e(t) + K_p T_d (d e(t)) / (d t) $, [$K_p$为比例系数，$T_d$为微分时间常数], 
  [积分(I)], $ G_c(s) & = 1 / (T_i s) \ m(t) & = 1 / T_i integral_0^t e(t) d t $, [$T_i$为可调比例系数。由于积分控制器的积分作用，当输入信号消失后，输出信号有可能是一个不为零的常量。], 
  [比例－积分(PI)], $ G_c(s) & = K_p(1 + 1 / (T_i s)) \ m(t) & = K_p e(t) + K_p / T_i integral_0^t e(t) d t $, [$K_p$为可调比例系数，$T_i$为可调积分时间常数], 
  [比例－积分－微分(PID)], 
)

== 串联校正

=== 相位超前校正

$ G_c(s) = 1 / a dot (1 + a T s) / (1 + T s), a > 1 $

#figure(
  image("assets/c5/phase-lead-correction.png", height: 30%), 
  caption: [超前校正的Bode Graph]
)

- 提供正相移，开环增益衰减$a$倍，需附加放大器补偿; 
- 相位超前主要发生在频段$(1/(a T), 1/T)$，且超前角最大值为
$ phi_m = arcsin (a - 1) / (a + 1) $
$ omega_m = 1 / (sqrt(a) T) $

*设计串联超前校正步骤* 
+ 确定系统的开环增益$K$; 
+ 绘制在确定的$K$值下系统的Bode Graph，并计算其相角裕度$gamma_0$; 
+ 计算所需要的相角超前量$phi_0$，考虑到校正装置影响剪切频率的位置而留出的裕量, 取$phi_0 = gamma - gamma_0 + epsilon, epsilon in [15degree, 20degree]$; 
+ 令超前校正装置的最大超前角$phi_m = phi_0$，并按下式计算校正网络的系数$a$值, $a = (1 + sin phi_m) / (1 - sin phi_m)$; 
+ 将校正网络在$omega_m$处的增益定为$10lg a$，同时确定未校正系统伯德曲线上增益为$-10lg a$处的频率即为校正后系统的剪切频率; 
+ 确定超前校正装置的交接频率$omega_1 = omega_m / sqrt(a), omega_2 = omega_m sqrt(a)$; 
+ 画出校正后系统的Bode Graph，验算系统的相角稳定裕度。如不符要求，可增大$epsilon$，并从第3步起重新计算; 

=== 相位滞后校正

$ G_c(s) = (1 + b T s) / (1 + T s), b < 1 $

#figure(
  image("assets/c5/phase-lag-correction.png", height: 30%), 
  caption: [滞后校正的Bode Graph]
)

=== 相位滞后-超前校正

$ G_c(s) = ((1 + b T_1 s)(1 + a T_2 s)) / ((1 + T_1 s)(1 + T_2 s)), a > 1, b < 1 "and" b T_1 > a T_2 $

#figure(
  image("assets/c5/phase-lag-lead-correction.png", height: 30%), 
  caption: [滞后-超前校正的Bode Graph]
)

== 反馈校正 & 复合校正

#figure(
  image("assets/c5/feedback-correction-single.png"), 
  caption: [反馈校正系统]
)

采用局部反馈包围系统前向通道中的一部分环节以实现校正。图中被局部反馈包围部分的传递函数是$ G_(2c)(s) = (G_2(s)) / (1 + G_2(s) G_c (s)) $
局部闭环的开环增益为 $ |G_2(s) G_c (s)| $
$ "If" |G_2(s) G_c (s)| -> 0, G_(2c)(s) approx G_2(s) $
$ "If" |G_2(s) G_c (s)| -> infinity, G_(2c)(s) approx 1 / (G_c (s)) $

在系统反馈控制回路中加入前馈通路，组成前馈控制和反馈控制相结合的系统，只要参数选择得当，不但可保持系统稳定，极大减小乃至消除稳态误差，而且可以抑制几乎所有的可量测扰动。
这样的系统就称之为*复合控制系统*，相应的控制方式称为*复合控制*。把复合控制的思想用于系统设计，就是所谓复合校正。