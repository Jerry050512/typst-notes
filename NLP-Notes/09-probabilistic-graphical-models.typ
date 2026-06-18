= 第9章：概率梅型

== 第一部分：隐马尔可夫模型 (HMM)

=== HMM 定义

*隐马尔可夫模型 (Hidden Markov Model, HMM)* 是描述由一个隐藏的马尔可夫链随机生成不可观测的状态序列，再由各个状态生成一个观测序列，从而产生可观测随机序列的过程的统计学习模型。

- 状态序列 (state sequence)：隐藏的、不可观测的随机状态序列
- 观测序列 (observation sequence)：每个状态生成的可观测随机序列

=== HMM 三要素

HMM 由以下三个要素确定，记为 lambda = (A, B, pi)：

/ 状态转移矩阵 A：$A = (a_(i j))_(N times N)$，其中 $a_(i j) = P(i_(t+1) = q_j | i_t = q_i)$，$i,j = 1,2,...,N$

/ 观测概率矩阵 B：$B = (b_j(k))_(N times M)$，其中 $b_j(k) = P(o_t = v_k | i_t = q_j)$

/ 初始状态概率向量 pi：$pi = (pi_i)$，其中 $pi_i = P(i_1 = q_i)$

其中 N 是状态数，M 是可能的观测数。

=== HMM 两个基本假设

1. *齐次马尔可夫性假设*：t+1 时刻的状态只依赖于 t 时刻的状态：
$
P(i_(t+1) | i_t, i_(t-1), ..., i_1, o_t, ..., o_1) = P(i_(t+1) | i_t)
$

2. *观测独立性假设*：t 时刻的观测只依赖于 t 时刻的状态：
$
P(o_t | i_t, i_(t-1), ..., i_1, o_(t-1), ..., o_1) = P(o_t | i_t)
$

=== HMM 三个基本问题

1. *概率计算*：在给定模型 lambda 和观测序列 O 的条件下，计算 P(O|lambda)
 - 解法：前向-后向算法

2. *学习*：在给定观测序列 O 的条件下，估计模型参数 lambda = (A,B,pi)
 - 监督学习：已知状态序列，极大似然估计
 - 无监督学习：Baum-Welch 算法（EM 算法的特殊情况）

3. *预测（解码）*：在给定模型 lambda 和观测序列 O 的条件下，求最可能的状态序列 I
 - 解法：维特比算法 (Viterbi Algorithm)

=== 前向算法

*目标*：高效计算 $P(O | lambda) = sum_(i=1)^N alpha_T(i)$

定义前向概率：$alpha_t(i) = P(o_1, o_2, ..., o_t, i_t = q_i | lambda)$

*算法步骤*：

1. 初始化：$alpha_1(i) = pi_i b_i(o_1)$，$i = 1,2,...,N$

2. 递推：对 $t = 1,2,...,T-1$：
$
alpha_(t+1)(j) = [sum_(i=1)^N alpha_t(i) a_(i j)] b_j(o_(t+1))
$，$j = 1,2,...,N$

3. 终止：$P(O | lambda) = sum_(i=1)^N alpha_T(i)$

*时间复杂度*：$O(N^2 T)$

=== 后向算法

定义后向概率：$beta_t(i) = P(o_(t+1), o_(t+2), ..., o_T | i_t = q_i, lambda)$

*算法步骤*：

1. 初始化：$beta_T(i) = 1$，$i = 1,2,...,N$

2. 递推：对 $t = T-1, T-2, ..., 1$：
$
beta_t(i) = sum_(j=1)^N a_(i j) b_j(o_(t+1)) beta_(t+1)(j)
$，$i = 1,2,...,N$

3. 终止：$P(O | lambda) = sum_(i=1)^N pi_i b_i(o_1) beta_1(i)$

=== 维特比算法

*目标*：求最优状态序列 $I^* = op("arg max")_I P(I | O, lambda)$

定义：$delta_t(i) = op("max")_(i_1,...,i_(t-1)) P(i_1,...,i_(t-1), i_t = q_i, o_1,...,o_t | lambda)$

记录：$psi_t(i) = op("arg max")_(1 <= i_t <= N) [delta_(t-1)(i_t) a_(i_t i)]$

*算法步骤*：

1. 初始化：$delta_1(i) = pi_i b_i(o_1)$，$psi_1(i) = 0$，$i = 1,2,...,N$

2. 递推：对 $t = 2,3,...,T$：
 - $delta_t(j) = op("max")_(1 <= i <= N) [delta_(t-1)(i) a_(i j)] b_j(o_t)$
 - $psi_t(j) = op("arg max")_(1 <= i <= N) [delta_(t-1)(i) a_(i j)]$

3. 终止：
 - $P^* = op("max")_(1 <= i <= N) [delta_T(i)]$
 - $i_T^* = op("arg max")_(1 <= i <= N) [delta_T(i)]$

4. 回退：对 $t = T-1, T-2, ..., 1$：
 - $i_t^* = psi_(t+1)(i_(t+1)^*)$

=== 前向后向概率的重要应用

*单个状态概率 (gamma)*：
$
gamma_t(i) = P(i_t = q_i | O, lambda) = (alpha_t(i) beta_t(i)) / P(O | lambda)
$

给定观测序列 O 的条件下，t 时刻处于状态 $q_i$ 的概率。

*转移概率 (xi)*：
$
xi_t(i,j) = P(i_t = q_i, i_(t+1) = q_j | O, lambda) = (alpha_t(i) a_(i j) b_j(o_(t+1)) beta_(t+1)(j)) / P(O | lambda)
$

给定观测序列 O 的条件下，t 时刻处于状态 $q_i$ 且 t+1 时刻处于状态 $q_j$ 的概率。

*重要关系*：
- $gamma_t(i) = sum_(j=1)^N xi_t(i,j)$
- $sum_(t=1)^(T-1) gamma_t(i)$：在观测序列 O 下经过状态 $q_i$ 的期望次数
- $sum_(t=1)^(T-1) xi_t(i,j)$：在观测序列 O 下从状态 $q_i$ 转移到 $q_j$ 的期望次数

== 第二部分：最大熵模型

=== 熵的定义

随机变量 X 的*熵* (entropy) 定义为：
$
H(X) = - sum_x p(x) log p(x)
$

熵衡量随机变量的不确定性。熵越大，不确定性越大。

=== 条件熵

在给定随机变量 X 的条件下，随机变量 Y 的*条件熵* (conditional entropy)：
$
H(Y|X) = sum_x p(x) H(Y | X = x) = - sum_x sum_y p(x,y) log p(y|x)
$

=== 最大熵原理

*核心思想*：在满足已知约束条件的所有模型（概率分布）中，选择熵最大的模型作为最优模型。

即：在已知部分知识（约束）的前提下，对未知部分不做任何主观假设，而是等可能地对待。

数学表述：在满足约束条件
$
sum_x sum_y tilde(p)(x) p(y|x) f_i(x,y) = tilde(p)(x,y) f_i quad (i = 1,2,...,n)
$
的所有条件分布 $p(y|x)$ 中，选择使条件熵 $H(p)$ 最大的分布：
$
p^* = op("arg max")_(p in C) H(p)
$

=== 最大熵模型形式

在满足上述约束条件下，使条件熵最大的条件概率分布具有如下形式：
$
p_*(y|x) = exp(sum_(i=1)^n lambda_i f_i(x,y)) / Z_lambda(x)
$

其中：
- $f_i(x,y)$：第 i 个特征函数（约束函数）
- $lambda_i$：第 i 个特征函数对应的权值（拉格朗日乘子）
- $Z_lambda(x)$：规范化因子，$Z_lambda(x) = sum_y exp(sum_(i=1)^n lambda_i f_i(x,y))$

*重要性质*：最大熵模型是对数线性模型 (log-linear model)。

=== 参数估计

最大熵模型的参数是特征函数的权值 $lambda = (lambda_1, lambda_2, ..., lambda_n)$。

*改进的迭代尺度法 (IIS, Improved Iterative Scaling)*：

1. 初始化 $lambda_i = 0$（对所有 i）
2. 对每个 $lambda_i$，更新为 $lambda_i + delta_i$，其中 $delta_i$ 是方程
$
sum_x sum_y tilde(p)(x) p(y|x) f_i(x,y) e^(delta_i f^(x,y)) = sum_x sum_y tilde(p)(x,y) f_i
$ 的解，$f^(x,y) = sum_(i=1)^n f_i(x,y)$
3. 重复步骤2直到收敛

*拟牛顿法 (Quasi-Newton Method)*：

使用 BFGS 等拟牛顿法直接优化对数似然函数，收敛速度通常比 IIS 更快。

== 第三部分：条件随机场 (CRF)

=== CRF 定义

*条件随机场 (Conditional Random Field, CRF)* 是给定输入随机变量 X 的条件下，输出随机变量 Y 的条件概率分布模型。

- CRF 是*判别模型* (discriminative model)，直接对条件概率 $P(Y|X)$ 建模
- 与 HMM 的生成式建模方式 $P(O,I) = P(i_1) prod_t P(o_t|i_t) P(i_(t+1)|i_t)$ 不同

=== 线性链条件随机场

*线性链条件随机场* (Linear-chain CRF) 是 CRF 在序列标注问题上的特化形式。

设 $X = (X_1, X_2, ..., X_n)$，$Y = (Y_1, Y_2, ..., Y_n)$ 均为线性链表示的随机变量序列，若在给定 X 的条件下，Y 满足马尔可夫性：
$
P(Y_i | X, Y_(j ne i)) = P(Y_i | X, Y_(i-1), Y_(i+1))
$

则称 P(Y|X) 为线性链条件随机场。

*线性链 CRF 的参数化形式*：
$
P(Y | X) = (1/Z(X)) exp(sum_(i=1)^n sum_(k=1)^K lambda_k t_k(y_(i-1), y_i, X, i))
$

其中：
- $t_k$：转移特征函数（边上的特征）
- $lambda_k$：对应的权值
- $Z(X)$：规范化因子

=== CRF 与 HMM 的关系

| 特性 | HMM | CRF |
|------|-----|-----|
| 模型类型 | 生成模型 | 判别模型 |
| 建模对象 | 联合概率 P(O,I) | 条件概率 P(Y|X) |
| 假设 | 观测独立性、齐次马尔可夫性 | 无严格独立性假设 |
| 特征 | 仅基于状态转移和观测 | 可使用丰富的特征函数 |
| 表达能力 | 较弱 | 更强 |

CRF 可以包含 HMM 所能表达的所有内容，同时还能表达更复杂的依赖关系。

=== CRF 三个基本问题

1. *概率计算*：给定模型参数和输入序列 X、输出序列 Y，计算 $P(Y|X)$
 - 解法：类似 HMM 的前向-后向算法

2. *学习*：给定训练数据，估计模型参数
 - 解法：最大似然估计 + 正则化，使用 L-BFGS 等优化算法

3. *预测*：给定模型和输入序列 X，求最可能的输出序列 Y
 - 解法：维特比算法

=== CRF 中的维特比算法

在 CRF 中进行解码（预测）时，使用维特比算法求最优标注序列：

*算法步骤*：

1. 初始化：$delta_1(j) = sum_(k=1)^K lambda_k e_k(y_0, y_j, X, 1)$

2. 递推：对 $i = 2, 3, ..., n$：
 - $delta_i(j) = op("max")_(y_(i-1)) [delta_(i-1)(y_(i-1)) + sum_(k=1)^K lambda_k t_k(y_(i-1), y_j, X, i)]$
 - $psi_i(j) = op("arg max")_(y_(i-1)) [delta_(i-1)(y_(i-1)) + sum_(k=1)^K lambda_k t_k(y_(i-1), y_j, X, i)]$

3. 终止：$y_n^* = op("arg max")_(y_n) delta_n(y_n)$

4. 回退：对 $i = n-1, ..., 1$：$y_i^* = psi_(i+1)(y_(i+1)^*)$

== 习题要点

以下为期末考试中概率图模型部分的高频计算题型和重点：

=== 题型一：HMM 概率计算（前向/后向算法）

*核心考点*：给出模型 lambda = (A, B, pi) 和观测序列 O，用前向或后向算法计算 P(O|lambda)。

*解题步骤*：
1. 计算初始概率：$alpha_1(i) = pi_i b_i(o_1)$
2. 逐步递推计算所有 $alpha_t(i)$
3. 求和得到 $P(O|lambda) = sum_i alpha_T(i)$

*注意*：这是最基础的计算题，务必熟练手算 2-3 步递推。

=== 题型二：HMM 解码（维特比算法）

*核心考点*：给定模型和观测序列，用维特比算法求最优状态序列。

*解题步骤*：
1. 计算初始 delta 值
2. 递推计算每个时刻的 delta 和 psi
3. 终止得到最终最优概率和最后状态
4. 回退得到完整最优路径

*注意*：回退步骤不要漏掉！psi 记录的是"从哪个状态转移过来"。

=== 题型三：Baum-Welch 算法（参数学习）

*核心考点*：用前向后向概率更新模型参数。

*更新公式*：
- $pi_i^* = gamma_1(i)$
- $a_(i j)^* = (sum_(t=1)^(T-1) xi_t(i,j)) / (sum_(t=1)^(T-1) gamma_t(i))$
- $b_j^*(k) = (sum_(t=1, o_t = v_k)^T gamma_t(j)) / (sum_(t=1)^T gamma_t(j))$

*注意*：分母是"处于该状态的期望次数"，分子是"满足条件的期望次数"。

=== 题型四：最大熵模型的特征函数与模型形式

*核心考点*：给定特征函数，写出最大熵模型的具体形式。

*解题方法*：
1. 将特征函数代入 $p(y|x) = exp(sum_i lambda_i f_i(x,y)) / Z(x)$
2. 计算规范化因子 $Z(x) = sum_y exp(sum_i lambda_i f_i(x,y))$
3. 化简得到最终表达式

=== 题型五：CRF 概率计算与解码

*核心考点*：给定线性链 CRF 的特征函数和权值，计算条件概率或求最优标注。

*解题步骤*：
1. 计算每个位置的特征得分
2. 用前向-后向算法计算规范化因子 Z(X)
3. 用维特比算法求最优标注序列

=== 题型六：HMM 与 CRF 的对比分析

*核心考点*：说明 HMM 和 CRF 的区别与联系。

*答题要点*：
- HMM 是生成模型，建模联合概率；CRF 是判别模型，建模条件概率
- HMM 有观测独立性假设；CRF 没有
- CRF 可以使用任意丰富的特征函数
- 两者都可用维特比算法解码

=== 题型七：熵与条件熵的计算

*核心考点*：给定概率分布，计算熵 H(X)、条件熵 H(Y|X)、互信息 I(X;Y)。

*重要公式*：
- $H(X) = -sum_x p(x) log p(x)$
- $H(Y|X) = -sum_x sum_y p(x,y) log p(y|x)$
- $I(X;Y) = H(X) - H(X|Y) = H(Y) - H(Y|X)$

=== 题型八：IIS 参数更新

*核心考点*：用改进的迭代尺度法更新最大熵模型的参数。

*解题步骤*：
1. 计算经验期望：$E_(p tilde)[f_i] = sum_x sum_y tilde(p)(x,y) f_i(x,y)$
2. 计算模型期望：$E_p[f_i] = sum_x sum_y tilde(p)(x) p(y|x) f_i(x,y)$
3. 求解 delta_i 使得模型期望等于经验期望
4. 更新 $lambda_i <- lambda_i + delta_i$

*期末复习建议*：
- 重点练习前向算法和维特比算法的手算，考试常考 3-5 步递推
- 熟记 Baum-Welch 的三个更新公式，理解其统计意义
- 理解最大熵模型的推导过程：从约束优化到指数族形式
- 对比记忆 HMM 和 CRF 的异同
