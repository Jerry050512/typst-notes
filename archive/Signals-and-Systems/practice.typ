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

#set image(
  height: 15%
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
  已知$f(t)$的波形如图所示, 试画出$f(6-2t)$的波形. 
]

#rect[
  已知某线性时不变系统的动态方程式为: 
  $ y''(t) + 2y'(t) + y(t) = x'(t) $
  系统的初始状态为$y(0)=1$, $y'(0)= -12$, 求系统的零输入响应$y_x(t)$. 
]

#rect[
  已知某LTI系统的动态方程式为$y'(t)+3y(t)=2f(t)$, 系统的冲激响应$h(t)=2e^(-3t) u(t)$, $f(t)=3u(t)$, 试求系统的零状态响应$y_"zs" (t)$. 
  - $y_"zs"(t) = f(t) * h(t) = 2(1-e^(-3t)) u(t)$
]

= 连续时间信号的频域分析

#rect[
  已知周期信号$f(t) = 2 + 4cos pi / 4 t + 8 cos(3 / 4 pi t + pi / 2)$, 试求出其复指数形式的傅里叶表达式, 并画出其频谱
  - $f(t) = 2 + 2e^(j pi / 4 t) + 2e^(-j pi / 4 t) + 4e^(j (3 / 4 pi t + pi / 2)) + 4e^(-j(3 / 4 pi t + pi / 2))$
]

#rect[
  求周期矩形脉冲信号f(t)的傅里叶变换
  - $F(j omega) = E tau omega_0 sum_(-infinity)^(infinity) S a((n omega_0 pi) / 2) delta(omega - n omega_0)$
]

#rect[
  已知LTI系统的微分方程为$y''(t)+4y'(t)+3y(t) = f(t)$ \
  i. 求系统的频率响应$H(j omega)$和冲激响应$h(t)$ \
  ii. 若激励$f(t)=e^(-2t)U(t)$,求系统的零状态响应$y_f (t)$. 
  - $H(j omega) = 1 / 2 (1 / (j omega + 1) -  1 / (j omega + 3))$, $h(t) = 1 / 2 (e^(-t) - e^(-3t)) u(t)$
  - $y_"zs"(t) = (1/2 e^(-t) + 1/2 e^(-3t) - e^(-2t)) u(t)$
]

#rect[
  如图所示系统, 已知$f_1(t) = (sin 2t) / t, f_2(t) = cos 3t, H(j omega) = cases(1 "if" |omega| < 3 "rad/s", 0 "if" |omega| > 3 "rad/s")$, $Y(j omega) = (1 / (2pi) F_1(j omega) * F_2(j omega)) dot H(j omega) $
  - $y(t) = (sin t cos 2t) / t$
]

#rect[
  #figure(image("assets/practice/001.png"))
  已知$H_1(j omega) = e^(-j 2omega), h_2(t) = e^(-t)U(t)$, 求系统的阶跃响应. 
  - $g(t) = (1 - e^(-t))U(t) - (1 - e^(-(t - 2))) U(t - 2)$
]

#rect[
  #grid(
    columns: (auto, 1fr), 
    align: horizon,
    figure(image("assets/practice/002.png")), 
    [
      已知有一个信号处理系统, 输入信号$f(t)$的最高频率为$f_m = (2π) / omega_m$, 抽样信号$s(t)$为幅值为1, 脉宽为$tau$, 周期为$T_S (T_S >tau) $的矩形脉冲序列, 经过抽样后的信号为$f_S (t)$, 抽样信号经过一个理想低通滤波器后的输出信号为$y(t)$. $f(t)$和$s(t)$的波形分别如图所示.  \
      i. 试画出采样信号$f_S (t)$的波形；\
      ii. 若要使系统的输出$y(t)$不失真地还原输入信号$f(t)$, 问该理想滤波器的截止频率$omega_c$.和抽样信号$s(t)$的频率$f_S$, 分别应该满足什么条件？
      - 保留采样序列对应位置的图像; 
      - $f_S >= 2 f_m = (4pi) / omega_m$, $omega_"最高频率" <= omega_c <= omega_S - omega_"最高频率"$, 其中$omega_"最高频率" = 2pi f_m, omega_S = 2pi f_S$
    ]
  )
]

= 连续时间信号与系统的复频域分析

#rect[
  求下列$F(s)$的反变换 \
  i. $F(s) = (s^2 + 8) / (s + 4)^2$ \
  ii. $F(s) = 1 / (3s^2(s^2 + 4))$ \
  iii. $(1 - e^(-2s)) / (s (s^2 + 4))$
  - $f(t) = delta(t) - 8t e^(-4t) u(t) + 24 e^(-4t) u(t)$
  - $f(t) = 1 / 12 (t - 1 / 2 sin 2t) u(t)$
  - $f(t) = 1 / 4 (1 - cos 2t) u(t) - 1 / 4 (1 - cos 2(t - 2)) u(t - 2)$
]

#rect[
  已知一线性系统: $r''(t) + 3 r'(t) + 2 r(t) = e'(t) + 2e(t)$, 若$r(0_-) = 1, r'(0_-) = 2, e(t) = u(t)$, 求$r(t)$
  - $r(t) = (1 + 3e^(-t) - 3e^(-2t)) u(t)$
]

#rect[
  已知某连续时间LTI因果系统的微分方程为$y''(t) + 3y'(t) + 2y(t) = f(t)$.  \
  i. 确定该系统的系统函数$H(s)$; \
  ii. 判断系统的稳定性, 若系统是稳定的, 求出系统的频率响应, 讨论其幅频和相频特性; \
  iii. 求系统的单位冲激响应$h(t)$及单位阶跃响应$g(t)$; \
  iv. 若系统输人$f(t) = e^(-t) U(t)$,求输出响应$y_f (t)$; \
  v. 当系统输出的拉氏变换为$Y(s) = (s + 1) / (s + 2)^2$时, 求系统的输入$f(t)$. 
  - $H(s) = 1 / (s^2 + 3s + 2)$
  - 极点-1, -2均在左半平面, 故稳定; \ 幅频$|H(omega)| = (4 + 5omega^2 + omega^4) / (8 omega^2 + 2)$; \ 相频$phi(omega) = -arctan (3 omega) / (2 omega^2)$
  - $h(t) = (e^(-t) + e^(-2t)) u(t)$; $g(t) = (1 / 2 - e^(-t) + 1 / 2 e^(-2t)) u(t)$
  - $y_f (t) = (t e^(-t) - e^(-t) + e^(-2t)) u(t)$
  - $f(t) = delta'(t) + e^(-2t) u(t)$
]