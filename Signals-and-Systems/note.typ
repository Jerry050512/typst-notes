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

/ 系统的全响应: 
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
  ], 
  [斜坡信号], $ r(t) = t dot u(t) = cases(t "if" t >= 0, 0 "if" t < 0) $
)

*四种奇异信号的关系*
#grid(
  columns: (1fr, 1fr), 
  $ delta'(t) = (d delta(t)) / (d t) $, $ delta(t) = integral_(-infinity)^t delta'(tau) d tau $, 
  $ delta(t) = (d u(t)) / (d t) $, $ u(t) = integral_(-infinity)^t delta(tau) d tau $, 
  $ u(t) = (d r(t)) / (d t) $, $ r(t) = integral_(-infinity)^t u(tau) d tau $
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
  [尺度变换], $f(t) -> f(a t)$, [0-1压缩,$1-infinity$延展, 小于0反折]
)

== 零输入响应

/ 零输入响应: 系统在没有外部激励($f(t) = 0$)的情况下, 仅由初始条件引起的响应($y_(z i)(t)$).

求解方法: 
- 根据微分方程的特征根确定零输入响应的形式
- 再由初始条件确定待定系数. 

=== 求解零输入响应的步骤

给定一个线性时不变系统, 其微分方程为:
$ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m f^((m))(t) + b_(m - 1) f^((m - 1))(t) + dots.c + b_0 f(t) $
求解零输入响应$y_(z i)(t)$

+ 设定初始条件, 例如$y(0) = y_0, y'(0) = y_1$等
+ 设定输入信号$f(t) = 0$,得到一个齐次线性微分方程 $ y^((n))(t) + a_(n - 1) y^((n - 1))(t) + dots.c + a_0 y(t) = 0 $
+ 求解特征方程 $ s^n + a_(n - 1)s^(n - 1) + dots.c + a_0 = 0 $ 得到特征根$s_1, s_2, dots.c, s_n$
  - 设定特征根为不相等实数根, 则齐次线性微分方程的通解为:$ y(t) = C_1 e^(s_1 t) + C_2 e^(s_2 t) + dots.c + C_n e^(s_n t) $ 其中$C_i$为常数
  - 设定特征根为$k$重相等实数根, 则齐次线性微分方程的通解为:$ y(t) = (C_1 + C_2 t + dots.c + C_k t^(k - 1)) e^(s_1 t) + dots.c $ 其中$C_i$为常数
  - 设定特征根为若干对共轭复数根, 则齐次线性微分方程的通解为:$ y(t) = e^(sigma_1 t) [C_1 cos(omega_1 t) + D_1 sin(omega_1 t)] + dots.c $ 其中$C_i$为常数
  - 设定特征根为$k$重共轭复数根, 则齐次线性微分方程的通解为:$ y(t) = e^(sigma_1 t) {[C_(11) + C_(12)t + dots.c + C_(1k)t^(k-1)] cos(omega_1 t) + [(D_(11) + D_(12)t + dots.c + D_(1k)t^(k-1)) sin(omega_1 t)]} + dots.c $ 其中$C_i$为常数
+ 代入初始条件, 求解常数$C_i$的值

== 零状态响应

/ 零状态响应: 系统在初始条件为0的情况下, 仅由外部激励引起的响应($y_(z s)(t)$).
/ 冲激响应: 系统对单位冲激信号的响应($h(t)$).
/ 阶跃响应: 系统对单位阶跃信号的响应($g(t)$).

求解系统的零状态响应方法: 
- 直接求解初始状态为零的微分方程. 
- 卷积法: 利用*信号分解*和线性时不变*系统的特性*求解

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
- 微分与积分 
$ [f_1(t) * f_2(t)]^((i)) = f_1^((j))(t) * f_2^((i - j))(t) $ 其中负数导数表示积分
- 位移
$ f_1(t) * f_2(t) = y(t) => f_1(t - t_1) * f_2(t - t_2) = y(t - t_1 - t_2) $
- 展缩
$ f_1(a t) * f_2(a t) = 1 / abs(a) y(a t) $
- $f(t) * delta(t - t_0) = f(t - t_0)$
- $f(t) * u(t) = integral^t_(-infinity)f(tau)d tau$

=== 求解冲激响应

利用*冲激平衡法*, 求解下列方程的冲激响应:
$ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m f^((m))(t) + b_(m - 1) f^((m - 1))(t) + dots.c + b_0 f(t) $

+ 代入$y(t) = h(t)$, $f(t) = delta(t)$, 得到一个非齐次线性微分方程 $ y^((n))(t) + a_(n - 1)y^((n - 1))(t) + dots.c + a_0 y(t) = b_m delta^(m)(t) + b_(m - 1) delta^(m - 1)(t) + dots.c + b_0 delta(t) $
+ 设定初始条件, 例如$y(0) = y_0, y'(0) = y_1$等
+ 设定$h(t)$的形式
  - 若$n > m$, 则$h(t) = (sum_(i = 1)^n C_i e^(s_i t))u(t)$
  - 若$n <= m$, 则$h(t) = (sum_(i = 1)^n C_i e^(s_i t))u(t) + sum_(i=0)^(m - n) A_i delta^((i))(t)$
+ 代入方程, 利用两侧恒等, 求解常数$C_i$和$A_i$的值

= 连续时间信号的频域分析

/ 函数正交: 它们的内积为0
$ integral_(t_1)^(t_2) f_1(t) f_2(t) d t = 0 $

== 傅里叶级数

=== 三角形式

$ f(t) &= A_0 + sum_(n = 1)^(infinity) A_n cos(n omega_0 t + phi.alt_n)\ &= a_0 + sum_(n = 1)^infinity (a_n cos n omega_0 t + b_n sin omega_0 t) $
其中, $A_n = sqrt(a_n^2 + b_n^2)$, $phi.alt_n = arctan(- b_n / a_n)$ \
$A_0$称为信号的直流分量, $A_1$ 称为基波分量, $A_n$ 称为信号的$n$次谐波分量. 

/ 三角傅里叶级数: 周期信号在三角函数完备正交集的展开
/ 三角函数完备正交集: 
$ {1, cos n omega_0 t, sin n omega_0 t}_(n = 1, 2, 3, dots, +infinity) $

=== 指数形式

$ f(t) = sum_(n = -infinity)^infinity F_n e^(j n omega_0 t) $
其中, $ F_n = 1 / T integral^(T / 2)_(- T / 2) f(t) e^(- j n omega_0 t) d t $

=== 两者关系

$ F_0 = a_0 $
$ F_n = 1 / 2 (a_n - j b_n) = abs(F_n) e^(j phi_n) $
$ |F_n| = 1 / 2 A_n $

== 周期信号的傅里叶级数分析

/ Dirichlet条件: 周期信号展开为傅立叶级数条件
  + 绝对可积, 即$integral_(-T/2)^(T/2) abs(f(t)) d t < infinity$
  + 在一个周期内只有有限个不连续点； 
  + 在一个周期内只有有限个极大值和极小值. 

/ 频谱:$F_n$是频率的函数, 它反映了组成信号各正弦谐波的幅度和相位随频率变化的规律, 称频谱函数. 

== 非周期信号的傅里叶级数分析

/ 频谱密度函数: 简称频谱
$ F(j omega) = integral_(-infinity)^infinity f(t) e^(-j omega t) d t $

/ 傅里叶反变换: 
$ f(t) = 1 / (2pi) integral_(-infinity)^infinity F(j omega) e^(j omega t) d omega $

/ Dirichlet 条件:
  + 非周期信号在无限区间上绝对可积 $integral_(-infinity)^infinity abs(f(t)) d t < infinity$
  + 在任意有限区间内, 信号只有有限个最大值和最小值. 
  + 在任意有限区间内, 信号仅有有限个不连续点, 且这些点必须是有限值. 

=== 常见非周期信号的傅里叶变换

#table(
  columns: 3, 
  [*信号*], [*表达式*], [*变换*], 
  [矩形脉冲信号], $ f(t) = cases(A "if" abs(t) <= tau / 2, 0 "if" abs(t) > tau / 2) $, $ F(j omega) = A tau dot S a((omega tau) / 2) $,
  [单边指数信号], $ f(t) = e^(- alpha t) u(t), alpha > 0 $, $ F(j omega) = 1 / (a + j omega) $, 
  [双边指数信号], $ f(t) = e^(- alpha |t|), alpha > 0 $, $ F(j omega) = (2 alpha) / (alpha^2 + omega^2) $, 
  [单位冲激信号], $ delta(t) $, $ F(j omega) = 1 $, 
  [冲激偶信号], $ delta'(t) $, $ F(j omega) = j omega $, 
  [直流信号], $ 1 $, $ "极限方法求解" \ cal(F)[1] = 2pi delta(omega) $, 
  [符号函数信号], $ "sgn"(t) = cases(-1 "if" t < 0, 0 "if" t = 0, -1 "if" t > 1) $, $ F(j omega) = 2 / (j omega) $, 
  [单位阶跃信号], $ u(t) = 1 / 2 + 1 / 2 "sgn"(t) $, $ cal(F)[u(t)] = pi delta(omega) + 1 / (j omega) $
)

=== 常见周期信号的傅里叶变换

#table(
  columns: 3, 
  [*信号*], [*表达式*], [*变换*], 
  [虚指数信号], $ f(t) = e^(j omega_0 t) $, $ cal(F)[e^(j omega_0 t)] = 2pi delta(omega - omega_0) $, 
  table.cell([三角函数信号], rowspan: 2), 
  $ sin omega_0 t = 1 / (2 j) (e^(j omega_0 t) - e^(-j omega_0 t)) $, $ cal(F)[sin omega_0 t] = - j pi (delta(omega - omega_0) - delta(omega + omega_0)) $, 
  $ cos omega_0 t = 1 / 2 (e^(j omega_0 t) + e^(- j omega_0 t)) $, $ cal(F)[cos omega_0 t] = pi (delta(omega - omega_0) + delta(omega + omega_0)) $, 
  [单位冲激序列], $ delta_T (t) = sum_(n = - infinity)^(+infinity) delta(t - n T) $, $ cal(F)[delta_T (t)] = omega_0 sum_(n = - infinity)^(+infinity) delta(omega - n omega_0) $, 
  [一般周期函数], $ f_T (t) = sum_(-infinity)^(+infinity) F_n e^(j n omega_0 t) $, $ cal(F)[f_T (t)] = 2pi sum_(infinity)^(+infinity) F_n delta(omega - n omega_0) $, 
)

== 傅里叶变换的性质

#table(
  columns: (auto, 1fr), 
  [*特性*], [*公式*], 
  [线性特性], $ a f_1(t) + b f_2(t) <-> a F_1(omega) + b F_2(omega) $, 
  [对称互易特性], $ F(j t) <-> 2pi f(-omega) $, 
  [展缩特性], $ f(a t) <-> 1 / abs(a) F(j omega / a) $, 
  [时移特性], $ f(t - t_0) <-> F(j omega) dot e^(-j omega t_0) $, 
  [频移特性], $ f(t) dot e^(j omega_0 t) <-> F(j(omega - omega_0)) $, 
  [时域卷积特性], $ f_1(t) * f_2(t) <-> F_1(j omega) dot F_2(j omega) $, 
  [频域卷积特性], $ f_1(t) dot f_2(t) <-> 1 / (2pi) (F_1(j omega) * F_2(j omega)) $, 
  [时域微分特性], $ (d^n f) / (d t^n) <-> (j omega)^n dot F(j omega) $, 
  [积分特性], $ integral_(-infinity)^t f(tau) d tau <-> 1 / (j omega) F(j omega) + pi F(0) delta(omega) \ t^n f(t) <-> j^n dot (d F^n(j omega)) / (d omega^n) $, 
  [能量定理], $ integral_(-infinity)^(+infinity)abs(f(t))^2 d t = 1 / (2pi) integral_(-infinity)^(+infinity) abs(F(j omega))^2 d omega $
)

== 频域分析法

+ 输入信号傅里叶变换 $e(r) -> E(j omega)$
+ 系统分析 $H(j omega)$
+ $R(j omega) = E(j omega) dot H(j omega)$
+ 反变换 $r(t) = cal(F)^(-1)[R(j omega)]$

/ 系统频率响应特性$H(j ω)$: 系统输出信号和输入信号的傅里叶变换之比

== 滤波器

/ 滤波器: 能使信号的一部分频率通过, 而使另一部分频率通过很少的系统. 

#figure(
  image("assets/wave-filter.png"), 
  caption: [理想滤波器的幅频特性]
)

=== 理想低通滤波器

/ 理想低通滤波器: 具有如图所示矩形幅频特性、线性相频特性的系统称为理想低通滤波器. $omega_c$称为截止角频率. 

$ abs(H(j omega)) = cases(1 "if" abs(omega) < omega_c, 0 "if" abs(omega) > omega_c) \ phi(omega) = - omega t_d $

=== 物理可实现

/ 佩利维纳准则(频域条件): 
平方可积$ integral_(-infinity)^infinity abs(H(j omega))^2 d omega < infinity $
并且 $ integral_(-infinity)^(infinity) abs(ln abs(H(j omega))) / (1 + omega^2) d omega < infinity $

时域条件: $ h(t) = 0, t < 0 $

== 采样定理

/ 采样: 利用采样脉冲序列$s(t)$从连续信号$f(t)$中"抽取"一系列离散样本值的过程: 得到的离散信号称为取样信号. 

分类: 矩形脉冲采样(自然采样), 冲激脉冲采样(理想采样)

/ 时域取样定理: 一个频谱在区间$(-omega_m, omega_m)$以外为0的带限信号$f(t)$,可唯一地由其在均匀间隔$T_S [T_S < 1 / (2f_m)]]$上的样值点$f(n T_S)$确定. ($f_m$是被采样信号的最高频率)
  - $f(t)$必须是带限信号；即在$|omega| > omega_m$各处为零
  - 取样频率不能太低, 必须$f_S > 2 f _m, (omega_S > 2 omega_m)$, 或者说, 取样间隔不能太大, 必须$T_S < 1/(2f_m)$；否则将发生混叠. 

/ 奈奎斯特频率 (Nyquist Sampling Rate): 最低允许的取样频率$f_S = 2f_m$
/ 奈奎斯特间隔 (Nyquist Space): 把最大充许的取样间隔$T_S = 1 / (2f_m)$
/ 奈奎斯特角频率: 最低允许的取样角频率$omega_S = 2omega_m$

= 连续时间信号与系统的复频域分析

== 拉普拉斯(Laplace)变换

#table(
  columns: (1fr, 1fr), 
  [*正变换*], [*逆变换*],
  $ F(s) = integral_(-infinity)^infinity f(t) e^(-s t) d t $, $ f(t) = 1 / (2pi j) integral_(sigma - j infinity)^(sigma + j infinity) F(s) e^(s t) d s $
)

$F(s)$为单位带宽内各谐波的合成振幅, 是*密度函数*；其中, $s$是复数称为复频率, $F(s)$称复频谱. 

=== 收敛域

/ 收敛域(Region of Convergence, ROC): 使$F(s)$存在的$s$的区域 (即Laplace变换存在的条件)
  - $integral_(-infinity)^infinity abs(f(t)) e^(-sigma t) d t = C$ (绝对可积)

*常见信号的ROC*
#table(
  columns: 3, 
  [*信号名称*], [*表达式*], [*ROC*], 
  [指数信号], $ f(t) = e^(alpha t) u(t) $, $ "Re"[s] > alpha $, 
  [单位阶跃信号], $ f(t) = u(t) $, $ sigma > 0 $, 
  [单个脉冲信号], [-], $sigma > -infinity ("整个复平面")$
)

右边信号$f(t) u(t)$的ROC形式为$sigma > sigma_1$, 左边信号$f(t) u(-t)$的ROC形式为$sigma > sigma_2$, 其中$sigma_1, sigma_2$称为收敛轴. 

/ 单边Laplace变换: 
$ F(s) = integral_(0^-)^infinity f(t) e^(-s t) d t $
一般情况下, 所说的拉氏变换都是指*单边拉普拉斯变换*

=== 常用信号的Laplace变换

#let l_eq = math.attach(math.arrow.l.r.long, t: math.cal($L$))

#table(
  columns: (auto, 1fr), 
  [*信号*], [*变换*], 
  [冲激信号], [$ delta(t) #l_eq 1, "Re"[s] > -infinity $ $ delta^((n))(t) #l_eq s^n, "Re"[s] > -infinity $], 
  [阶跃信号], $ u(t) #l_eq 1 / s, "Re"[s] > 0 $, 
  [指数类信号], $ e^(lambda t) u(t) #l_eq 1 / (s - lambda), "Re"[s] > "Re"[lambda], (lambda "可取任意复数") $, 
  [正弦信号], [$ cos (omega_0 t) u(t) #l_eq s / (s^2 + omega_0^2), "Re"[s] > 0 $ $ sin (omega_0 t) u(t) #l_eq omega_0 / (s^2 + omega_0^2), "Re"[s] > 0 $], 
  [斜坡信号], $ t dot u(t) #l_eq 1 / s^2, "Re"[s] > 0 $, 
  [t的正整幂], $ t^n dot u(t) #l_eq (n!) / s^(n + 1) $, 
)

/ Fourier变换与Laplace变换关系: 
  - 收敛轴包含虚轴: $F(s) |_(s = j omega) = F(j omega)$
  - 收敛轴不包含虚轴: $F(s)$存在, $F(j omega)$不存在.
  - 收敛轴为虚轴: $F(s)$与广义$F(j omega)$存在, 但$F(s) != F(j omega)$

=== Laplace变换基本性质

*注意变换后收敛域改变*
#table(
  columns: (auto, 1fr), 
  [*性质*], [*公式*], 
  [线性性质], $ cal(L)[a f(t) + b (t)] = a F(s) + b G(s) $, 
  [相似性质], $ cal(L)[f(a t)] = 1 / a F(s / a), a > 0 $, 
  [微分性质], [$ cal(L)[f'(t)] = s F(s) - f(0) $ $ cal(L)[f^((n))(t)] = s^n F(s) - s^(n - 1) f(0) - s^(n - 2) f'(0) - dots.c - f^((n - 1))(0) $], 
  [积分性质], $ cal(L) [integral_(-infinity)^t f(tau) d tau] = F(s) / s + (f^(-1)(0^-)) / s $, 
  [位移性质], $ cal(L) [e^(a t) f(t)] = F(s - a), "Re"[s] > a $, 
  [延迟性质], $ cal(L)[f(t - tau)] = e^(-s tau) F(s) $, 
  [初值定理], [$ f(0) = lim_(s -> infinity) s F(s) $ $f'(t), f(t)$存在, 且有Laplace变换], 
  [终值定理], [$ lim_(t -> +infinity) f(t) = lim_(s -> 0) s F(s) $ $s F(s)$所有奇点在左半平面]
)

== Laplace反变换

=== 留数定理

$ f(t) = sum_k "Res"[F(s) e^(s t), s_k] $

/ 奇点: 不解析的点. 

- 一阶极点
$ "Res"[F(s) e^(s t), s_0] = lim_(s -> s_0) F(s) e^(s t) $
- m阶极点
$ "Res"[F(s) e^(s t), s_0] = 1 / (m - 1)! lim_(s -> s_0) d^(m - 1) / (d s^(m - 1)) ((s - s_0)^m F(s) e^(s t)) $

=== 部分分式展开

=== 归纳

$ cal(F)^(-1)[1 / (s - a)^(n + 1)] = t^n / n! e^(a t) $
$ cal(F)^(-1)[s^n] = delta^((n))(t) $

- $F(s)$为有理真分式, 一阶极点

$ F(s) = sum k_n / (s - p_n) $
$ f(t) = sum k_n e^(p_n t) u(t) $

- $F(s)$为有理真分式, $r$重阶极点

$ F(s) = sum k_r / (s - p_1)^r + sum k_n / (s - p_n) $
$ f(t) = sum k_r e^(p_1 t) dot t^(r - 1) / (r - 1)! + sum k_n / (s - p_n) $

- $F(s)$为有理假分式

展开为$ F(s) = sum B_k s^k + (N_1(s)) / D(s) $
$ f(t) = sum B_k delta^((k))(t) + f_1(t) $
$f_1(t)$由前两种情况求出.

== 系统函数与系统特性

/ 传递函数: 系统输出的拉普拉斯变换与输入的拉普拉斯变换之比为系统的传递函数, 记为$H(s)$

求$H(s)$的方法: 
- 由系统的冲激响应求解$H(s)=cal(L)[h(t)]$
- 由定义式$H(s) = Y(s) / X(s)$
- 由系统的微分方程写出$H(s)$

/ 零极点图: s平面上用符号#sym.circle.small 表示零点的位置, 用符号#sym.times 表示极点的位置

/ 频响特性: 系统在输入信号激励之下稳态响应随信号频率的变化情况. 

/ 因果系统: 连续时间LTI系统为因果系统的充分必要条件是
  $ h(t)=0, t < 0 $
  即单位冲激响应是因果信号

/ 系统的稳定性: 

连续时间LTI系统有界输入有界输出(Boundary Input Boundary Output, BIBO)稳定的充分必要条件是: 
$ integral_(-infinity)^infinity |h(tau)| d tau = S < infinity $
等价于: $H(s)$的ROC包含$j omega$轴.

/ 因果连续LTI系统: BIBO稳定充要条件为$H(s)$全部极点位于左半s平面. 


