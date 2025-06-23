#import "../template/conf.typ": conf
#import "../template/components.typ": *

#import "@preview/cetz:0.4.0"

#show: conf.with(
  title: [
    信号与系统 习题
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

= 信号与系统的概念与分类

#rect[
  判断下列信号类型(能量/功率/都不是) \
  i. $f(t) = 5 sin(2t - theta)$ \
  ii. $f(t) = 5e^(-2t)$ \
  iii. $f(t) = 10t, i >= 0$

  - 功率
  - 都不是
  - 都不是
]

= 连续时间信号与时域分析

#rect[
  #align(
    center,
    cetz.canvas({
      import cetz.draw: *
      scale(y: 2)
      grid((-2.5, -0.5), (3.5, 1.5), stroke: luma(80%), step: .5)
      line((-2.5, 0), (3.5, 0))
      content((), $t$, anchor: "south", padding: 5pt)
      line((0, -0.5), (0, 1.5))
      content((), $f(t)$, anchor: "west", padding: 5pt)
      line((-2, 0), (-2, 1), (0, 1), (3, 0))
      content((0, 1), $1$, anchor: "south-east", padding: 5pt)
      content((-2, 0), $-2$, anchor: "north", padding: 5pt)
      content((0, 0), $0$, anchor: "north-east", padding: 5pt) 
      content((3, 0), $3$, anchor: "north", padding: 5pt)
  }))
  已知$f(t)$的波形如图所示，试画出$f(6-2t)$的波形。
]

#rect[
  已知某线性时不变系统的动态方程式为：
  $ y''(t) + 2y'(t) + y(t) = x'(t) $
  系统的初始状态为$y(0)=1$，$y'(0)= -12$，求系统的零输入响应$y_x(t)$。
]

#rect[
  已知某LTI系统的动态方程式为$y'(t)+3y(t)=2f(t)$，系统的冲激响应$h(t)=2e^(-3t) u(t)$, $f(t)=3u(t)$, 试求系统的零状态响应$y_"zs" (t)$。
  - $y_"zs"(t) = f(t) * h(t) = 2(1-e^(-3t)) u(t)$
]