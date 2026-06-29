#import "../template/preamble.typ": *

// 维特比算法示例中标记逐行最大值（红色加粗）
#let viterbi-max(body) = text(fill: emphcolor, weight: "bold", body)

= 概率图模型：HMM、最大熵与CRF

#knowtitle[本章是算法大题核心。HMM三问题、前向算法、Viterbi算法、最大熵思想、CRF与HMM对比必须能默写。]

== 隐马尔可夫模型 HMM\*

隐马尔可夫模型 (Hidden Markov Model, HMM) 是自然语言处理中最经典的概率图模型之一，常用于词性标注、分词、语音识别等序列建模任务。

HMM 的核心思想是：序列中的状态是不可直接观察的，但每个隐藏状态会以一定概率生成一个可观测符号。因此，我们能够通过观测序列去反推最可能的隐藏状态序列。

/ 隐马尔可夫模型 (Hidden Markov Model, HMM): 描述隐藏状态序列按照马尔可夫链转移，并由每个隐藏状态生成观测序列的生成式概率模型。

=== 三个盒子的直观例子

假设有 $3$ 个盒子，每个盒子里分别装有红球和白球：

#figure(
  grid(
    columns: (auto, auto, auto),
    gutter: 1em,
    table(
      columns: (auto, auto, auto, auto),
      [], [盒子1], [盒子2], [盒子3],
      [红球], [5], [4], [7],
      [白球], [5], [6], [3]
    ),
    table(
      columns: (auto, auto, auto, auto),
      [], [盒子1], [盒子2], [盒子3],
      [抽到红球的概率], [0.5], [0.4], [0.7],
      [抽到白球的概率], [0.5], [0.6], [0.3]
    ),
    table(
      columns: (auto, auto, auto, auto),
      [], [盒子1], [盒子2], [盒子3],
      [初始选择概率], [0.2], [0.4], [0.4]
    )
  )
)

再假设每次抽完球之后，下一时刻会按照固定概率切换到另一个盒子，状态转移矩阵为：

#formula[$
  A = mat(
    0.5, 0.2, 0.3;
    0.3, 0.5, 0.2;
    0.2, 0.3, 0.5
  , delim: "[")
$]

在这个例子中：

- 隐状态 (hidden state) 是“当前选择的是哪个盒子”。
- 观测 (observation) 是“当前抽到的球的颜色”。
- 盒子是看不见的，球的颜色是看得见的。

因此它正好构成一个 HMM：状态集合 $Q = {q_1, q_2, q_3}$，观测集合 $V = {v_1, v_2}$（$v_1$ 表示红球，$v_2$ 表示白球），初始概率向量 $pi = (0.2, 0.4, 0.4)$，发射概率矩阵

#formula[$
  B = mat(
    0.5, 0.5;
    0.4, 0.6;
    0.7, 0.3
  , delim: "[")
$]

$B$ 的第 $i$ 行表示状态 $q_i$ 下生成不同观测的概率。例如处于盒子 $3$ 时，抽到红球的概率为 $0.7$、白球为 $0.3$。这个例子将贯穿后续的前向、后向与维特比算法。

=== 隐马尔可夫模型的形式化定义

完整而言，HMM 由五元组 $(Q, V, A, B, pi)$ 确定：

#key[五元组定义]（作业重点）：

- $Q = {q_1, q_2, dots, q_N}$：所有可能的状态集合，$N$ 为状态数。
- $V = {v_1, v_2, dots, v_M}$：所有可能的观测集合，$M$ 为观测符号数。
- $A = [a_(i j)]_(N times N)$：状态转移概率矩阵，$a_(i j) = P(i_(t+1)=q_j | i_t=q_i)$，每行和为 $1$。
- $B = [b_j(k)]_(N times M)$：观测概率矩阵（发射概率），$b_j(k) = P(o_t=v_k | i_t=q_j)$，每行和为 $1$。
- $pi = (pi_1, pi_2, dots, pi_N)$：初始状态概率向量，$pi_i = P(i_1=q_i)$，$sum_(i=1)^N pi_i = 1$。

常简记为 $lambda = (A, B, pi)$。设状态序列 $I = (i_1, i_2, dots, i_T)$，观测序列 $O = (o_1, o_2, dots, o_T)$，在两个基本假设下，状态序列与观测序列的联合概率为：

#formula[$
  P(I, O | lambda) = pi_(i_1) b_(i_1)(o_1) product_(t=2)^T a_(i_(t-1) i_t) b_(i_t)(o_t)
$]

观测序列的概率则是对所有可能状态序列求和：

#formula[$
  P(O | lambda) = sum_I P(I, O | lambda)
$]

这是 HMM 三个基本问题的出发点。直接枚举所有状态序列的复杂度为指数级 $O(N^T)$，因此需要动态规划求解。

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

表示：在时刻 $t$ 处于状态 $q_i$，且前 $t$ 个观测已经出现的联合概率。记前向概率向量 $alpha_t = vec(alpha_t(1), alpha_t(2), dots.v, alpha_t(N), delim: "[")$。

前向算法用矩阵形式表示，分三步：

#methodblock[
  *前向算法（矩阵形式）*：

  1. *初始化* ($t=1$)：
     $ alpha_1 = "diag"(pi) b(o_1) $
     - 初始状态概率对角矩阵乘以首观测的发射概率向量

  2. *递推* ($t=1,2,dots,T-1$)：
     $ alpha_(t+1) = "diag"[b(o_(t+1))] A^T alpha_t $
     - 先用 $A^T$ 把上一时刻各状态的前向概率按转移概率汇聚，再用当前观测的发射概率逐项加权

  3. *终止*：
     $ P(O | lambda) = sum_i alpha_T (i) $

  时间复杂度 $O(N^2 T)$，相比暴力枚举 $O(N^T)$ 大幅降低。
]

#intuition[
  矩阵形式把“对所有前一状态求和”压缩成一次矩阵-向量乘法 $A^T alpha_t$，再用对角矩阵 $"diag"[b(o_(t+1))]$ 完成发射概率的逐项相乘，可读性与可实现性都更好。
]

#example(title: [前向算法计算示例])[
  沿用三个盒子的例子，$b("红") = vec(0.5, 0.4, 0.7, delim: "[")$，$b("白") = vec(0.5, 0.6, 0.3, delim: "[")$，观测序列 $O = ("红", "白", "红")$，$T=3$。

  1. *初始化* ($t=1$，观测“红”)
  $ alpha_1 = "diag"(pi) b("红") = mat(0.2, 0, 0; 0, 0.4, 0; 0, 0, 0.4, delim: "[") vec(0.5, 0.4, 0.7, delim: "[") = vec(0.10, 0.16, 0.28, delim: "[") $

  2. *递推到 $t=2$* (观测“白”)
  $ A^T alpha_1 = mat(0.5, 0.3, 0.2; 0.2, 0.5, 0.3; 0.3, 0.2, 0.5, delim: "[") vec(0.10, 0.16, 0.28, delim: "[") = vec(0.154, 0.184, 0.202, delim: "[") $
  $ alpha_2 = "diag"[b("白")] vec(0.154, 0.184, 0.202, delim: "[") = mat(0.5, 0, 0; 0, 0.6, 0; 0, 0, 0.3, delim: "[") vec(0.154, 0.184, 0.202, delim: "[") = vec(0.077, 0.1104, 0.0606, delim: "[") $

  3. *递推到 $t=3$* (观测“红”)
  $ A^T alpha_2 = mat(0.5, 0.3, 0.2; 0.2, 0.5, 0.3; 0.3, 0.2, 0.5, delim: "[") vec(0.077, 0.1104, 0.0606, delim: "[") = vec(0.08374, 0.08878, 0.07548, delim: "[") $
  $ alpha_3 = "diag"[b("红")] vec(0.08374, 0.08878, 0.07548, delim: "[") = mat(0.5, 0, 0; 0, 0.4, 0; 0, 0, 0.7, delim: "[") vec(0.08374, 0.08878, 0.07548, delim: "[") = vec(0.04187, 0.035512, 0.052836, delim: "[") $

  4. *终止*
  $ P(O | lambda) = 0.04187 + 0.035512 + 0.052836 = 0.130218 $
]


== 后向算法\*

#key[后向变量定义]（作业重点）：

#formula[$ beta_t(i) = P(o_(t+1), o_(t+2), dots, o_T | i_t=q_i, lambda) $]

表示：已知时刻 $t$ 处于状态 $q_i$，从 $t+1$ 到 $T$ 的剩余观测序列出现的概率。记后向概率向量 $beta_t = vec(beta_t(1), dots.v, beta_t(N), delim: "[")$。

#methodblock[
  *后向算法（矩阵形式）*：

  1. *初始化* ($t=T$)：
     $ beta_T = vec(1, 1, dots.v, 1, delim: "[") $
     - 终止时刻的后向概率规定为 $1$

  2. *递推* ($t=T-1, T-2, dots, 1$)：
     $ beta_t = A "diag"[b(o_(t+1))] beta_(t+1) $
     - 先用发射概率对角矩阵加权下一观测，再用 $A$ 按“从 $t$ 转移到 $t+1$”汇聚后向概率

  3. *终止*：
     $ P(O | lambda) = pi^T "diag"[b(o_1)] beta_1 $

  时间复杂度同为 $O(N^2 T)$。
]

#warnbox[
  *前向 vs 后向*：
  - *前向算法*：从前往后，$alpha_t(i)$ 是“到 $t$ 为止”的概率，递推用 $A^T alpha_t$。
  - *后向算法*：从后往前，$beta_t(i)$ 是“从 $t+1$ 开始”的概率，递推用 $A "diag"[b(o_(t+1))] beta_(t+1)$。
  - 两者结果相同：$P(O|lambda) = sum_i alpha_T(i) = pi^T "diag"[b(o_1)] beta_1$。
  - 结合使用：$P(O, i_t=q_i | lambda) = alpha_t(i) beta_t(i)$。
]

#example(title: [后向算法计算示例])[
  沿用前向算法的参数，$O = ("红", "白", "红")$，$T=3$。

  1. *初始化* ($t=3$)
  $ beta_3 = vec(1, 1, 1, delim: "[") $

  2. *递推到 $t=2$* (下一观测“红”)
  $ "diag"[b("红")] beta_3 = mat(0.5, 0, 0; 0, 0.4, 0; 0, 0, 0.7, delim: "[") vec(1, 1, 1, delim: "[") = vec(0.5, 0.4, 0.7, delim: "[") $
  $ beta_2 = A vec(0.5, 0.4, 0.7, delim: "[") = mat(0.5, 0.2, 0.3; 0.3, 0.5, 0.2; 0.2, 0.3, 0.5, delim: "[") vec(0.5, 0.4, 0.7, delim: "[") = vec(0.54, 0.49, 0.57, delim: "[") $

  3. *递推到 $t=1$* (下一观测“白”)
  $ "diag"[b("白")] beta_2 = mat(0.5, 0, 0; 0, 0.6, 0; 0, 0, 0.3, delim: "[") vec(0.54, 0.49, 0.57, delim: "[") = vec(0.27, 0.294, 0.171, delim: "[") $
  $ beta_1 = A vec(0.27, 0.294, 0.171, delim: "[") = mat(0.5, 0.2, 0.3; 0.3, 0.5, 0.2; 0.2, 0.3, 0.5, delim: "[") vec(0.27, 0.294, 0.171, delim: "[") = vec(0.2451, 0.2622, 0.2277, delim: "[") $

  4. *终止*
  $ "diag"[b("红")] beta_1 = mat(0.5, 0, 0; 0, 0.4, 0; 0, 0, 0.7, delim: "[") vec(0.2451, 0.2622, 0.2277, delim: "[") = vec(0.12255, 0.10488, 0.15939, delim: "[") $
  $ P(O | lambda) = pi^T vec(0.12255, 0.10488, 0.15939, delim: "[") = 0.2 times 0.12255 + 0.4 times 0.10488 + 0.4 times 0.15939 = 0.130218 $

  前向与后向算法得到一致的结果 $P(O|lambda) = 0.130218$。
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

*$δ_t(i)$*：在时刻 $t$ 到达状态 $q_i$ 的所有路径中，概率最大的那条路径的概率。

#formula[$ delta_t(i) = max_(i_1, i_2, dots, i_(t-1)) P(i_t=q_i, i_(t-1), dots, i_1, o_t, dots, o_1 | lambda) $]

*$Ψ_t(i)$*：在时刻 $t$ 状态为 $q_i$ 时，使其取得最大值的前一时刻状态，用于回溯最优路径。

#formula[$ psi_t(i) = arg max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] $]

记 $delta_t = vec(delta_t(1), dots.v, delta_t(N), delim: "[")$，维特比算法的矩阵形式如下：

#methodblock[
  *Viterbi 算法（矩阵形式）*：

  1. *初始化* ($t=1$)：
     $ delta_1 = "diag"(pi) b(o_1), quad psi_1 = vec(0, 0, dots.v, 0, delim: "[") $

  2. *递推* ($t=1,2,dots,T-1$)：
     $ delta_(t+1) = "diag"[b(o_(t+1))] "rowmax"[A^T "diag"(delta_t)] $
     $ psi_(t+1) = arg "rowmax"[A^T "diag"(delta_t)] $
     - $A^T "diag"(delta_t)$ 的第 $i$ 行列出“从各前一状态 $j$ 经 $a_(j i)$ 转移到 $i$”的候选值；对每行取最大即得 $delta$，取 argmax 即得 $psi$。

  3. *终止*：
     $ P^* = max_(1 <= i <= N) delta_T (i), quad i_T^* = arg max_(1 <= i <= N) delta_T (i) $

  4. *回溯* ($t=T-1, T-2, dots, 1$)：
     $ i_t^* = psi_(t+1)(i_(t+1)^*) $

  最优路径：$I^* = (i_1^*, i_2^*, dots, i_T^*)$。
]

#warnbox[
  *Viterbi vs 前向算法的关键区别*：

  - *前向算法*：递推用 #key[求和] $sum$，$alpha_(t+1) = "diag"[b(o_(t+1))] A^T alpha_t$，目标是计算观测序列总概率。
  - *Viterbi 算法*：递推用 #key[取最大] $max$，$delta_(t+1) = "diag"[b(o_(t+1))] "rowmax"[A^T "diag"(delta_t)]$，目标是找最优路径。
  - 矩阵形式只差一个算子：前向是 $A^T alpha_t$（矩阵-向量乘，内含求和），Viterbi 是 $"rowmax"[A^T "diag"(delta_t)]$（逐行取最大）。
]

#example(title: [Viterbi 算法计算示例])[
  仍用三个盒子的模型，观测序列 $O = ("红", "白", "红", "白")$，$T=4$。由于 $P(O|lambda)$ 对所有候选路径相同，最大化 $P(I, O|lambda)$ 等价于最大化 $P(I | O, lambda)$。下面矩阵中 #viterbi-max[红色加粗]的数字为该行取到的最大值。

  1. *初始化* ($t=1$，观测“红”)
  $ delta_1 = "diag"(pi) b("红") = mat(0.2, 0, 0; 0, 0.4, 0; 0, 0, 0.4, delim: "[") vec(0.5, 0.4, 0.7, delim: "[") = vec(0.10, 0.16, 0.28, delim: "[") $
  $ psi_1 = vec(0, 0, 0, delim: "[") $

  2. *递推到 $t=2$* (观测“白”)
  $
    A^T "diag"(delta_1) = mat(
      0.050, 0.048, #viterbi-max[0.056] ;
      0.020, 0.080, #viterbi-max[0.084] ;
      0.030, 0.032, #viterbi-max[0.140], delim: "["
    )
  $
  $ "rowmax"[A^T "diag"(delta_1)] = vec(#viterbi-max[0.056], #viterbi-max[0.084], #viterbi-max[0.140], delim: "["), quad psi_2 = vec(3, 3, 3, delim: "[") $
  $ delta_2 = "diag"[b("白")] vec(0.056, 0.084, 0.140, delim: "[") = vec(0.0280, 0.0504, 0.0420, delim: "[") $

  3. *递推到 $t=3$* (观测“红”)
  $
    A^T "diag"(delta_2) = mat(
      0.01400, #viterbi-max[0.01512], 0.00840;
      0.00560, #viterbi-max[0.02520], 0.01260;
      0.00840, 0.01008, #viterbi-max[0.02100], delim: "["
    )
  $
  $ "rowmax"[A^T "diag"(delta_2)] = vec(#viterbi-max[0.01512], #viterbi-max[0.02520], #viterbi-max[0.02100], delim: "["), quad psi_3 = vec(2, 2, 3, delim: "[") $
  $ delta_3 = "diag"[b("红")] vec(0.01512, 0.02520, 0.02100, delim: "[") = vec(0.007560, 0.010080, 0.014700, delim: "[") $

  4. *递推到 $t=4$* (观测“白”)
  $
    A^T "diag"(delta_3) = mat(
      #viterbi-max[0.0037800], 0.0030240, 0.0029400;
      0.0015120, #viterbi-max[0.0050400], 0.0044100;
      0.0022680, 0.0020160, #viterbi-max[0.0073500], delim: "["
    )
  $
  $ "rowmax"[A^T "diag"(delta_3)] = vec(#viterbi-max[0.0037800], #viterbi-max[0.0050400], #viterbi-max[0.0073500], delim: "["), quad psi_4 = vec(1, 2, 3, delim: "[") $
  $ delta_4 = "diag"[b("白")] vec(0.0037800, 0.0050400, 0.0073500, delim: "[") = vec(0.00189000, 0.00302400, 0.00220500, delim: "[") $

  5. *终止与回溯*
  $ P^* = max_i delta_4(i) = 0.003024, quad i_4^* = 2 $
  $ i_3^* = psi_4(2) = 2, quad i_2^* = psi_3(2) = 2, quad i_1^* = psi_2(2) = 3 $

  最优路径 $I^* = (q_3, q_2, q_2, q_2)$，对应路径概率
  $ pi_3 b_3("红") a_(3 2) b_2("白") a_(2 2) b_2("红") a_(2 2) b_2("白") = 0.4 times 0.7 times 0.3 times 0.6 times 0.5 times 0.4 times 0.5 times 0.6 = 0.003024 $
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
  $ M_1(x) = mat(0.5, 0.5; 0, 0), quad
    M_2(x) = mat(0.3, 0.7; 0.7, 0.3) $
  $ M_3(x) = mat(0.5, 0.4; 0.6, 0.4), quad
    M_4(x) = mat(1, 0; 1, 0) $

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
