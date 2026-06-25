#import "../template/preamble.typ": *

= 概率图模型：HMM、最大熵与CRF

#knowtitle[本章是算法大题核心。HMM三问题、前向算法、Viterbi算法、最大熵思想、CRF与HMM对比必须能默写。]

== 隐马尔可夫模型 HMM\*

/ 隐马尔可夫模型 (Hidden Markov Model, HMM): 描述隐藏状态序列按照马尔可夫链转移，并由每个隐藏状态生成观测序列的生成式概率模型。

#formula[$ lambda = (A, B, pi) $]

#key[五元组定义]（作业重点）：

*Q*：所有可能的状态集合
- $Q = {q_1, q_2, dots, q_N}$
- 例如：天气状态 {晴天, 雨天, 多云}
- $N$ 是状态数量

*V*：所有可能的观测集合
- $V = {v_1, v_2, dots, v_M}$
- 例如：球的颜色 {红, 白}
- $M$ 是观测符号数量

*A*：状态转移概率矩阵
- $A = [a_(i j)]_(N times N)$
- $a_(i j) = P(i_(t+1)=q_j | i_t=q_i)$
- 表示从状态 $q_i$ 转移到状态 $q_j$ 的概率
- 每行和为 1：$sum_(j=1)^N a_(i j) = 1$

*B*：观测概率矩阵（发射概率）
- $B = [b_j(k)]_(N times M)$
- $b_j(k) = P(o_t=v_k | i_t=q_j)$
- 表示在状态 $q_j$ 下观测到 $v_k$ 的概率
- 每行和为 1：$sum_(k=1)^M b_j(k) = 1$

*π*：初始状态概率分布
- $pi = (pi_1, pi_2, dots, pi_N)$
- $pi_i = P(i_1=q_i)$
- 表示初始时刻处于状态 $q_i$ 的概率
- $sum_(i=1)^N pi_i = 1$

== HMM 两个基本假设\*

#warnbox[
  1. #key[齐次的一阶马尔可夫假设]：
     - 当前状态只依赖前一状态，与更早状态无关
     - 状态转移概率不随时间变化
     - $P(i_t | i_(t-1), i_(t-2), dots, i_1) = P(i_t | i_(t-1))$

  2. #key[观测独立性假设]：
     - 当前观测只依赖当前状态，与其他状态和观测无关
     - $P(o_t | i_t, i_(t-1), dots, i_1, o_(t-1), dots, o_1) = P(o_t | i_t)$
]

#intuition[
  马尔可夫假设是"无记忆性"：状态转移只看前一步。观测独立性是"只看当前"：观测由当前状态决定。这两个假设大幅简化了模型，但也限制了表达能力。
]

== HMM 三个基本问题\*

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*问题*], [*目标*], [*算法*]),
  [概率计算（评估）], [给定 $lambda$ 和 $O$，计算 $P(O|lambda)$], [前向算法 / 后向算法],
  [学习（训练）], [给定观测序列估计 $lambda=(A,B,pi)$], [监督MLE / Baum-Welch (EM)],
  [预测（解码）], [给定 $lambda,O$ 求最可能状态序列], [Viterbi算法],
)

#intuition[
  三个问题对应三个任务：评估（这个模型对观测的解释力如何）、学习（从数据估计模型参数）、解码（推断最可能的隐藏状态）。
]

== 前向算法\*

#key[前向变量定义]（作业重点）：

#formula[$ alpha_t(i) = P(o_1, o_2, dots, o_t, i_t=q_i | lambda) $]

表示：到时刻 $t$ 为止的观测序列为 $o_1, o_2, dots, o_t$ 且时刻 $t$ 处于状态 $q_i$ 的概率。

#methodblock[
  *前向算法步骤*：

  1. *初始化* ($t=1$)：
     $ alpha_1(i) = pi_i b_i(o_1), quad i=1,2,dots,N $
     - 初始状态概率 × 该状态下观测到 $o_1$ 的概率

  2. *递推* ($t=1,2,dots,T-1$)：
     $ alpha_(t+1)(j) = [sum_(i=1)^N alpha_t(i) a_(i j)] b_j(o_(t+1)), quad j=1,2,dots,N $
     - 对所有可能的前一状态 $i$：前向概率 × 转移概率，求和
     - 再乘以状态 $j$ 下观测到 $o_(t+1)$ 的概率

  3. *终止*：
     $ P(O|lambda) = sum_(i=1)^N alpha_T(i) $
     - 对所有可能的终止状态求和

  4. *时间复杂度*：$O(N^2 T)$
     - 相比暴力枚举 $O(N^T)$ 大幅降低
]

#example(title: [前向算法计算示例])[
  假设盒子球模型，$N=3$ 个状态（盒子），$M=2$ 个观测（红/白球）

  参数矩阵：
  $ A = mat(0.5, 0.3, 0.2; 0.2, 0.5, 0.3; 0.3, 0.2, 0.5), quad
    B = mat(0.3, 0.7; 0.6, 0.4; 0.5, 0.5), quad
    pi = (0.4, 0.4, 0.2) $

  观测序列：$O=("红", "白", "红")$，$T=3$

  *步骤1：初始化* ($t=1$，观测"红")
  - $alpha_1(1) = pi_1 b_1("红") = 0.4 times 0.3 = 0.12$
  - $alpha_1(2) = pi_2 b_2("红") = 0.4 times 0.6 = 0.24$
  - $alpha_1(3) = pi_3 b_3("红") = 0.2 times 0.5 = 0.10$

  *步骤2：递推* ($t=2$，观测"白")
  - $alpha_2(1) = [alpha_1(1) a_(1,1) + alpha_1(2) a_(2,1) + alpha_1(3) a_(3,1)] b_1("白")$
    $ = [0.12 times 0.5 + 0.24 times 0.2 + 0.10 times 0.3] times 0.7 = 0.0777 $

  类似计算 $alpha_2(2)$ 和 $alpha_2(3)$...

  *步骤3：终止*
  $ P(O|lambda) = alpha_3(1) + alpha_3(2) + alpha_3(3) $
]


== 后向算法\*

#key[后向变量定义]（作业重点）：

#formula[$ beta_t(i) = P(o_(t+1), o_(t+2), dots, o_T | i_t=q_i, lambda) $]

表示：在时刻 $t$ 状态为 $q_i$ 的条件下，从 $t+1$ 到 $T$ 的观测序列为 $o_(t+1), dots, o_T$ 的概率。

#methodblock[
  *后向算法步骤*：

  1. *初始化* ($t=T$)：
     $ beta_T(i) = 1, quad i=1,2,dots,N $
     - 终止时刻的后向概率规定为 1

  2. *递推* ($t=T-1, T-2, dots, 1$)：
     $ beta_t(i) = sum_(j=1)^N a_(i j) b_j(o_(t+1)) beta_(t+1)(j), quad i=1,2,dots,N $
     - 从状态 $i$ 转移到状态 $j$ 的概率 × 状态 $j$ 观测到 $o_(t+1)$ 的概率 × 后续的后向概率

  3. *终止*：
     $ P(O|lambda) = sum_(i=1)^N pi_i b_i(o_1) beta_1(i) $
     - 初始状态概率 × 观测概率 × 后向概率，对所有状态求和
]

#warnbox[
  
  *前向 vs 后向*：
  - *前向算法*：从前往后计算，$alpha_t(i)$ 是"到 $t$ 为止"的概率
  - *后向算法*：从后往前计算，$beta_t(i)$ 是"从 $t+1$ 开始"的概率
  - 两者结果相同：$P(O|lambda) = sum_i alpha_T(i) = sum_i pi_i b_i(o_1) beta_1(i)$
  - 结合使用：$P(O, i_t=q_i | lambda) = alpha_t(i) beta_t(i)$
]

#example(title: [后向算法计算示例])[
  沿用前向算法例子的参数，$O=("红", "白", "红")$，$T=3$

  *步骤1：初始化* ($t=3$)
  - $beta_3(1) = beta_3(2) = beta_3(3) = 1$

  *步骤2：递推* ($t=2$，下一观测"红")
  - $beta_2(1) = a_(1,1) b_1("红") beta_3(1) + a_(1,2) b_2("红") beta_3(2) + a_(1,3) b_3("红") beta_3(3)$
    $ = 0.5 times 0.3 times 1 + 0.3 times 0.6 times 1 + 0.2 times 0.5 times 1 = 0.43 $

  类似计算 $beta_2(2)$ 和 $beta_2(3)$，再计算 $beta_1(i)$...

  *步骤3：终止*
  $ P(O|lambda) = pi_1 b_1("红") beta_1(1) + pi_2 b_2("红") beta_1(2) + pi_3 b_3("红") beta_1(3) $
]

== HMM 学习问题\*

#key[Baum-Welch 算法关键变量]（作业重点）：

*$γ_t(i)$*：给定模型 $lambda$ 和观测序列 $O$，在时刻 $t$ 处于状态 $q_i$ 的概率

#formula[$ gamma_t(i) = P(i_t=q_i | O, lambda) = (alpha_t(i) beta_t(i)) / P(O|lambda) $]

- 分子：前向概率 × 后向概率 = 在状态 $i$ 且观测到整个序列的概率
- 分母：观测序列总概率，用于归一化
- 物理意义：在 $t$ 时刻处于状态 $i$ 的"期望"

*$ξ_t(i,j)$*：给定模型和观测序列，在时刻 $t$ 处于状态 $q_i$ 且时刻 $t+1$ 处于状态 $q_j$ 的概率

#formula[$ xi_t(i,j) = P(i_t=q_i, i_(t+1)=q_j | O, lambda) = (alpha_t(i) a_(i j) b_j(o_(t+1)) beta_(t+1)(j)) / P(O|lambda) $]

- 分子：前向到 $t$ 状态 $i$ × 转移到 $j$ × 观测 $o_(t+1)$ × 后向从 $t+1$ 状态 $j$
- 物理意义：在 $t$ 时刻从状态 $i$ 转移到状态 $j$ 的"期望"

#methodblock[
  *Baum-Welch (EM) 参数更新*：

  - 有标注状态序列：用频率做监督 MLE
    - $a_(i j)$ = 从 $i$ 到 $j$ 的转移次数 / 从 $i$ 转出的总次数
    - $b_j(k)$ = 状态 $j$ 生成观测 $v_k$ 的次数 / 状态 $j$ 出现总次数

  - 只有观测序列：用 Baum-Welch（EM 算法的 HMM 版本）
    - E步：用当前参数计算 $gamma_t(i)$ 和 $xi_t(i,j)$
    - M步：用期望计数更新参数
      - $ overline(a)_(i j) = (sum_(t=1)^(T-1) xi_t(i,j)) / (sum_(t=1)^(T-1) gamma_t(i)) $
      - $ overline(b)_j(k) = (sum_(t=1, o_t=v_k)^T gamma_t(j)) / (sum_(t=1)^T gamma_t(j)) $
]

#intuition[
  Baum-Welch 本质是 EM：E步算期望（$gamma, xi$），M步用期望更新参数。$gamma_t(i)$ 是"软"状态分配，$xi_t(i,j)$ 是"软"转移计数。
]


== Viterbi 算法\*

#key[Viterbi 算法关键变量]（作业重点）：

*$δ_t(i)$*：在时刻 $t$ 状态为 $i$ 的所有路径中概率最大值

#formula[$ delta_t(i) = max_(i_1, i_2, dots, i_(t-1)) P(i_t=i, i_(t-1), dots, i_1, o_t, dots, o_1 | lambda) $]

- 表示：到时刻 $t$ 为止，以状态 $q_i$ 结尾的最优路径的概率

*$Ψ_t(i)$*：在时刻 $t$ 状态为 $i$ 时，前一时刻的最优状态

#formula[$ psi_t(i) = arg max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] $]

- 用于回溯最优路径

#methodblock[
  *Viterbi 算法步骤*：

  1. *初始化* ($t=1$)：
     $ delta_1(i) = pi_i b_i(o_1), quad i=1,2,dots,N $
     $ psi_1(i) = 0 $

  2. *递推* ($t=2,3,dots,T$)：
     $ delta_t(i) = max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] b_i(o_t), quad i=1,2,dots,N $
     $ psi_t(i) = arg max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)], quad i=1,2,dots,N $
     - 对每个状态 $i$，找到使路径概率最大的前一状态 $j$

  3. *终止*：
     $ P^* = max_(1 <= i <= N) delta_T(i) $
     $ i_T^* = arg max_(1 <= i <= N) delta_T(i) $
     - 找到最后时刻概率最大的状态

  4. *回溯* ($t=T-1, T-2, dots, 1$)：
     $ i_t^* = psi_(t+1)(i_(t+1)^*) $
     - 根据 $psi$ 从后往前回溯最优路径

  最优路径：$I^* = (i_1^*, i_2^*, dots, i_T^*)$
]

#warnbox[

  *Viterbi vs 前向算法的关键区别*：

  - *前向算法*：递推用 #key[求和] $sum$
    - $ alpha_(t+1)(j) = [sum_i alpha_t(i) a_(i j)] b_j(o_(t+1)) $
    - 目标：计算观测序列概率（对所有可能路径求和）

  - *Viterbi 算法*：递推用 #key[取最大] $max$
    - $ delta_t(i) = max_j [delta_(t-1)(j) a_(j i)] b_i(o_t) $
    - 目标：找最优路径（只保留概率最大的路径）

  两者递推形式相似，但一个是求和（概率计算），一个是取最大（路径寻优）。
]

#example(title: [Viterbi 算法计算示例])[
  沿用前面的参数，$O=(“红”, “白”, “红”, “白”)$，$T=4$

  *步骤1：初始化* ($t=1$，观测”红”)
  - $delta_1(1) = pi_1 b_1(“红”) = 0.4 times 0.3 = 0.12$
  - $delta_1(2) = pi_2 b_2(“红”) = 0.4 times 0.6 = 0.24$
  - $delta_1(3) = pi_3 b_3(“红”) = 0.2 times 0.5 = 0.10$
  - $psi_1(1) = psi_1(2) = psi_1(3) = 0$

  *步骤2：递推* ($t=2$，观测”白”)
  - $ delta_2(1) &= max{0.12 times 0.5, 0.24 times 0.2, 0.10 times 0.3} times 0.7 \ &= max{0.06, 0.048, 0.03} times 0.7 = 0.06 times 0.7 = 0.042 $
  - $psi_2(1) = arg max = 1$ （最大值来自状态1）

  类似计算 $delta_2(2), delta_2(3)$ 和对应的 $psi$...

  继续递推到 $t=T=4$

  *步骤3：终止*
  - $P^* = max{delta_4(1), delta_4(2), delta_4(3)}$
  - $i_4^* = arg max$

  *步骤4：回溯*
  - $i_3^* = psi_4(i_4^*)$
  - $i_2^* = psi_3(i_3^*)$
  - $i_1^* = psi_2(i_2^*)$

  最优路径：$I^* = (i_1^*, i_2^*, i_3^*, i_4^*)$
]

== 马尔可夫随机场与团\*

/ 无向图模型 (Markov Random Field, MRF): 用无向图表示变量之间的依赖关系，节点表示随机变量，边表示变量间的概率依赖。

#key[团的定义]（作业重点）：

/ 团 (Clique): 无向图中任意两个节点都有边连接的节点子集。

/ 最大团 (Maximal Clique): 不能再加入任何节点的团（即加入任何其他节点都会破坏"全连接"性质）。

#example(title: [团与最大团的识别])[
  考虑4个节点的无向图：$Y_1-Y_2-Y_3-Y_4$，且 $Y_2-Y_4$、$Y_1-Y_3$ 有边

  ```
    Y1 --- Y2 --- Y4
     |      |      |
     +---- Y3 ----+
  ```

  *所有团*（两个节点的团）：
  - ${Y_1, Y_2}$、${Y_2, Y_3}$、${Y_3, Y_4}$、${Y_4, Y_2}$、${Y_1, Y_3}$

  *最大团*：
  - ${Y_1, Y_2, Y_3}$ （三个节点两两相连）
  - ${Y_2, Y_3, Y_4}$ （三个节点两两相连）

  *不是团*：
  - ${Y_1, Y_2, Y_3, Y_4}$ 不是团，因为 $Y_1$ 和 $Y_4$ 没有边连接
]

#key[因子分解]：

无向图模型的联合概率可以分解为最大团上的势函数的乘积：

#formula[$ P(Y) = (1/Z) product_(C in cal(C)) psi_C(Y_C) $]

其中：
- $cal(C)$ 是所有最大团的集合
- $psi_C(Y_C)$ 是最大团 $C$ 上的势函数（非负函数）
- $Z = sum_Y product_C psi_C(Y_C)$ 是归一化因子

#example(title: [无向图的因子分解])[
  对上面的图，最大团是 ${Y_1, Y_2, Y_3}$ 和 ${Y_2, Y_3, Y_4}$

  因子分解式：
  $ P(Y_1, Y_2, Y_3, Y_4) = (1/Z) psi_(1,2,3)(Y_1, Y_2, Y_3) psi_(2,3,4)(Y_2, Y_3, Y_4) $
]

/ 熵 (Entropy): 衡量随机变量不确定性的量。

#formula[$ H(X) = - sum_x p(x) log p(x) $]

/ 最大熵原理: 在满足已知约束的所有概率分布中，选择熵最大的分布，即对未知信息不做额外假设。

最大熵模型是对数线性模型：
#formula[$ P(y|x) = (1 / Z(x)) exp(sum_i lambda_i f_i(x,y)) $]

其中 $f_i(x,y)$ 是特征函数，$lambda_i$ 是权重，$Z(x)$ 是归一化因子。


=== 最大熵答题要点

#methodblock[
  最大熵原则：在满足已知约束的所有分布中，选择熵最大的分布。它既满足事实，又对未知部分不额外偏置。最大熵模型中的 $Z(x)=sum_y exp(sum_i lambda_i f_i(x,y))$ 用于归一化。
]


== 条件随机场 CRF\*

/ 条件随机场 (Conditional Random Field, CRF): 给定输入 $X$ 后，输出变量 $Y$ 在无向图上满足条件马尔可夫性质，并直接建模条件概率 $P(Y|X)$ 的判别式模型。

线性链 CRF 常用于分词、NER、POS 等序列标注任务。

#key[线性链 CRF 的矩阵形式]（作业重点）：

对于线性链 CRF，可以用矩阵形式表示。定义 $m$ 个位置的随机矩阵 $M_1(x), M_2(x), dots, M_m(x)$，每个矩阵大小为 $(n times n)$，其中 $n$ 是标签数量。

矩阵元素：
#formula[$ M_i(y_(i-1), y_i | x) = exp(sum_k lambda_k f_k(y_(i-1), y_i, x, i)) $]

归一化因子（所有路径的非规范化概率之和）：
#formula[$ Z(x) = (M_1(x) M_2(x) dots M_m(x))_("start", "stop") $]

- 即矩阵连乘后，从 start 状态到 stop 状态的元素值

标注序列概率：
#formula[$ P(y|x) = (1/Z(x)) product_(i=1)^m M_i(y_(i-1), y_i | x) $]

#example(title: [CRF 矩阵计算])[
  线性链 CRF，观测序列 $x$，标记 $y_i in {1, 2}$，$y_0="start"=1$，$y_4="stop"=1$

  给定随机矩阵：
  $ M_1(x) = mat(0, 0; 0.5, 0.5), quad
    M_2(x) = mat(0.3, 0.7; 0.7, 0.3) $
  $ M_3(x) = mat(0.5, 0.5; 0.6, 0.4), quad
    M_4(x) = mat(0, 1; 0, 1) $

  *计算所有路径的非规范化概率*：

  从 start=1 到 stop=1 的所有路径：
  - $y=(1,1,1)$：$0.5 times 0.3 times 0.5 times 1 = 0.075$
  - $y=(1,1,2)$：$0.5 times 0.3 times 0.4 times 1 = 0.06$
  - $y=(1,2,1)$：$0.5 times 0.7 times 0.6 times 1 = 0.21$
  - $y=(1,2,2)$：$0.5 times 0.7 times 0.4 times 1 = 0.14$
  - $y=(2,1,1)$：$0.5 times 0.7 times 0.5 times 1 = 0.175$
  - $y=(2,1,2)$：$0.5 times 0.7 times 0.4 times 1 = 0.14$
  - $y=(2,2,1)$：$0.5 times 0.3 times 0.6 times 1 = 0.09$
  - $y=(2,2,2)$：$0.5 times 0.3 times 0.4 times 1 = 0.06$

  *归一化因子*：
  $ Z(x) &= sum "所有路径概率" \ &= 0.075 + 0.06 + 0.21 + 0.14 + 0.175 + 0.14 + 0.09 + 0.06 \ &= 0.95 $

  或通过矩阵乘法：
  $ M_1 M_2 M_3 M_4 = dots "计算后第(1,1)元素" = 0.95 $

  *概率最大的路径*：
  $ P^* = max{"所有路径概率"} = 0.21 $
  对应状态序列 $y^* = (1, 2, 1)$
]

== HMM vs CRF

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header([*对比项*], [*HMM*], [*CRF*]),
  [模型类型], [生成式模型，建模联合概率 $P(X,Y)$], [判别式模型，建模条件概率 $P(Y|X)$],
  [独立性假设], [有马尔可夫假设和观测独立性假设], [放宽独立性限制],
  [特征能力], [特征简单，主要是转移和发射概率], [可使用丰富上下文特征],
  [训练], [相对简单], [较复杂，需优化条件似然],
  [效果], [基线模型，速度快], [序列标注中通常效果更好],
)


=== 线性链 CRF 公式与三问题

#formula[$ P(y|x) = (1 / Z(x)) exp(sum_i sum_k lambda_k t_k(y_(i-1), y_i, x, i) + sum_i sum_l mu_l s_l(y_i, x, i)) $]

其中 $t_k$ 是转移特征，依赖相邻标签；$s_l$ 是状态特征，依赖当前标签和观测；$Z(x)$ 对所有可能标签序列归一化。

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*问题*], [*目标*], [*常用方法*]),
  [概率计算], [计算给定输入下各种标注序列概率], [前向-后向],
  [学习], [估计特征权重参数], [极大似然/正则化极大似然],
  [预测], [求概率最大的标注序列], [Viterbi 类动态规划],
)


== 本章高频题\*

#exercise(title: [概率图模型])[
  *必考计算题*：
  1. #key[后向算法计算]：给定 HMM 参数 λ=(A,B,π) 和观测序列 O，用后向算法计算 P(O|λ)
  2. #key[Viterbi 算法]：给定 HMM 和观测序列，用维特比算法求最优状态路径
  3. #key[CRF 矩阵计算]：给定随机矩阵 M_i(x)，计算所有路径的非规范化概率、归一化因子 Z(x)、概率最大的状态序列

  *必考概念题*：
  4. #key[HMM 五元组]：Q、V、A、B、π 的含义
  5. #key[前向后向变量]：α_t(i)、β_t(i) 的符号及定义
  6. #key[Baum-Welch 变量]：γ_t(i)、ξ_t(i,j) 的含义
  7. #key[Viterbi 变量]：δ_t(i)、Ψ_t(i) 的含义
  8. #key[团与最大团]：给定无向图，识别所有团和最大团，写出因子分解式

  *重要理解题*：
  9. HMM 的两个基本假设
  10. HMM 三个基本问题及对应算法
  11. 前向算法与 Viterbi 算法的区别（求和 vs 取最大）
  12. 比较 HMM 和 CRF（生成式 vs 判别式）
]

#warnbox[
  *作业题型总结*：
  - 计算题1：后向算法计算 P(O|λ)（需要完整写出递推过程）
  - 计算题2：Viterbi 求最优路径（需要写出 δ 和 Ψ 的递推）
  - 概念题：Q、V、A、B、π、α、β、γ、ξ、δ、Ψ 的含义和定义
  - 图论题：识别团和最大团，写因子分解式
  - CRF 计算题：矩阵形式计算归一化因子和最优路径
]
