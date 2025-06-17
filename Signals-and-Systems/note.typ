#import "../template/conf.typ": conf
#import "../template/components.typ": *

#show: conf.with(
  title: [
    信号与系统
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

== 信号的分类

+ 确定与随机
  - 确定: 对于指定时刻t, 信号值是唯一的
  - 随机: 对于指定时刻t, 信号值是随机的
+ 连续与离散
  - 连续: 信号在时间上是连续的, 定义在实数集上
  - 离散: 信号在时间上是离散的, 定义在整数集上
+ 周期与非周期
  - 周期: 信号在时间上是周期性的, 存在一个正数T, 使得$f(t+T)=f(t)$
  - 非周期: 信号在时间上不是周期性的
+ 能量与功率
  - 能量信号: 信号的能量有限, 功率为0
  - 功率信号: 信号的功率有限, 能量为无穷大
+ 一维与多维
  - 一维: 信号在一个维度上变化, 通常是时间
  - 多维: 信号在多个维度上变化, 通常是空间

=== 能量与功率的计算

信号$f(t)$在$1 Omega$的电阻上瞬时功率为$|f(t)|^2$, 信号的总能量为: 
$ W = lim_(T -> infinity) integral_(-T)^T |f(t)|^2 d t $

信号的平均功率为: 
$ P = lim_(T -> infinity) 1/(2T) integral_(-T)^T |f(t)|^2 d t $

== 系统的分类

/ 系统: 对输入信号进行处理, 产生输出信号的设备或算法
- / 激励: 输入信号, Excitation, $e(t)$
- / 响应: 输出信号, Response, $r(t), y(t)$

+ 连续与离散
+ 因果与非因果
+ 稳定与非稳定
+ 线性与非线性
+ 时不变与时变

我们主要讨论的就是*线性时不变系统*(Linear Time Invariant System, LTI系统).

= 连续时间信号与时域分析

#{
  set text(
    size: 15pt,
    weight: "bold",
  )
  $ y(t) = y_(z i)(t) + y_(z s)(t) $
}

== 常用信号

#table(
  columns: (1fr, auto, 2fr),
  align: horizon,
  inset: 10pt,
  table.header(
    [*信号名称*], [*信号表达式*], [*备注*],
  ),
  [实指数信号], $ f(t) = K e^(a t) $, [单边指数信号$f(t) = e^(a t) u(t)$],
  [正弦信号], $ f(t) = A sin(omega t + phi) $, [],
  [复指数信号], $ f(t) = K e^(s t) $, [其中$s = sigma + j omega$ \ 借助欧拉公式可以展开为 \ $K e^(sigma t) cos(omega t) + j K e^(sigma t) sin(omega t)$],
  [采样信号], $ S a(t) = (sin t) / t $, $integral^(infinity)_(-infinity) S a(t) d t = pi$, 
  [单位阶跃信号], $ U(t) = cases(0 "if" t < 0, 1 "if" t > 0) $, [],
  [矩形脉冲信号], $ g_tau(t) = U(t + tau / 2) - U(t - tau / 2) $, [],
  [单位冲激信号], $ delta(t) = cases(0 "if" t != 0, infinity "if" t = 0) \ "且" integral^infinity_(-infinity)delta(t)d t = 1 $, [
    + 筛选性质 $ f(t) delta(t - t_0) = f(t_0) delta(t - t_0) $
    + 积分筛选性质 $ integral^infinity_(-infinity) f(t) delta(t - t_0)d t = f(t_0) $
    + 尺度变换 $ delta(a t + b) = 1 / abs(a) delta(t + b / a) $
    + 偶函数 $ delta(-t) = delta(t) $
    + 阶跃信号导数 $ (d u(t)) / (d t) = delta(t) $
  ], 
  [冲激偶], $ delta'(t) $, [
    + 奇函数 $ integral^infinity_(-infinity) delta'(t) d t = 0 $
    + 相乘性质 $ f(t) delta'(t) = f(0) delta'(t) - f'(0) delta(t) $
  ]
)

== 信号的变换

#table(
  columns: (1fr, auto, 3fr),
  align: horizon,
  inset: 10pt,
  table.header(
    [*变换名称*], [*变换公式*], [*说明*],
  ),
  [平移(延时)], $f(t) -> f(t plus.minus t_0)$, [左加右减],
  [尺度变换], $f(t) -> f(a t)$, [0-1压缩, 1-inf延展, 小于0反折]
)

== 零输入响应

/ 零输入响应: 系统在没有外部激励($f(t) = 0$)的情况下, 仅由初始条件引起的响应($y_(z i)(t)$).

=== 求解零输入响应的步骤

给定一个线性时不变系统, 其微分方程为:
$ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m f^((m))(t) + b_(m - 1) f^((m - 1))(t) + dots.c + b_0 f(t) $
求解零输入响应$y_(z i)(t)$

+ 设定初始条件, 例如$y(0) = y_0, y'(0) = y_1$等
+ 设定输入信号$f(t) = 0$,得到一个齐次线性微分方程 $ y^((n))(t) + a_(n - 1) y^((n - 1))(t) + dots.c + a_0 y(t) = 0 $
+ 求解特征方程 $ s^n + a_(n - 1)s^(n - 1) + dots.c + a_0 = 0 $ 得到特征根$s_1, s_2, dots.c, s_n$
  - 设定特征根为不相等实数根, 则齐次线性微分方程的通解为:$ y(t) = C_1 e^(s_1 t) + C_2 e^(s_2 t) + dots.c + C_n e^(s_n t) $ 其中$C_i$为常数
  - 设定特征根为$k$重相等实数根, 则齐次线性微分方程的通解为:$ y(t) = (C_1 + C_2 t + dots.c + C_k t^(k - 1)) e^(s_1 t) + dots.c $ 其中$C_i$为常数
  - 设定特征根为若干对共轭复数根, 则齐次线性微分方程的通解为:$ y(t) = e^(sigma_1 t) (C_1 cos(omega_1 t) + D_1 sin(omega_1 t)) + dots.c $ 其中$C_i$为常数
  - 设定特征根为$k$重共轭复数根, 则齐次线性微分方程的通解为:$ y(t) = e^(sigma_1 t) ((C_(11) + C_(12)t + dots.c + C_(1k)t^(k-1)) cos(omega_1 t) + ((D_(11) + D_(12)t + dots.c + D_(1k)t^(k-1)) sin(omega_1 t)) + dots.c $ 其中$C_i$为常数
+ 代入初始条件, 求解常数$C_i$的值

== 零状态响应

/ 零状态响应: 系统在初始条件为0的情况下, 仅由外部激励引起的响应($y_(z s)(t)$).
/ 冲激响应: 系统对单位冲激信号的响应($h(t)$).
/ 阶跃响应: 系统对单位阶跃信号的响应($g(t)$).

=== 卷积

/ 卷积: 信号$f(t)$与$h(t)$的卷积, 定义为:
$ y_(z s)(t) = f(t) * h(t) = integral^infinity_(-infinity) f(t - tau) h(tau) d tau $

==== 图解法求卷积

+ 反折$f(tau)$得到$f(-tau)$
+ 平移$f(-tau)$得到$f(t - tau)$
+ 乘以$h(tau)$得到$f(t - tau) h(tau)$
+ 积分$integral^infinity_(-infinity) f(t - tau) h(tau) d tau$得到卷积结果

note. 利用平移时遇到的分界点来进行分段积分.

==== 卷积的性质

- 交换律, 结合律, 分配律
- 微分与积分 $ f^((i))(t) = f_1^((j))(t) * f_2^((i - j))(t) $ 其中负数导数表示积分
- $f(t) * delta(t - t_0) = f(t - t_0)$
- $f(t) * u(t) = integral^t_(-infinity)f(tau)d tau$

=== 求解冲激响应

利用冲激平衡法, 求解下列方程的冲激响应:
$ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m f^((m))(t) + b_(m - 1) f^((m - 1))(t) + dots.c + b_0 f(t) $

+ 代入$y(t) = h(t)$, $f(t) = delta(t)$, 得到一个非齐次线性微分方程 $ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m delta^(m)(t) + b_(m - 1) delta^(m - 1)(t) + dots.c + b_0 delta(t) $
+ 设定初始条件, 例如$y(0) = y_0, y'(0) = y_1$等
+ 设定$h(t)$的形式
  - 若$n > m$, 则$h(t) = (sum_(i = 1)^n C_i e^(s_i t))u(t)$
  - 若$n <= m$, 则$h(t) = (sum_(i = 1)^n C_i e^(s_i t))u(t) + sum_(i=0)^(m - n) A_i delta^((i))(t)$
+ 代入方程, 利用两侧恒等, 求解常数$C_i$和$A_i$的值