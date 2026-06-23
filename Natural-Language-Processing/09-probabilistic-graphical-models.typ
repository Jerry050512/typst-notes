#import "../template/preamble.typ": *

= 概率图模型：HMM、最大熵与CRF

#knowtitle[本章是算法大题核心。HMM三问题、前向算法、Viterbi算法、最大熵思想、CRF与HMM对比必须能默写。]

== 隐马尔可夫模型 HMM

/ 隐马尔可夫模型 (Hidden Markov Model, HMM): 描述隐藏状态序列按照马尔可夫链转移，并由每个隐藏状态生成观测序列的生成式概率模型。

#formula[$ lambda = (A, B, pi) $]

三要素：
- $A$：状态转移概率矩阵，$a_(i j) = P(i_(t+1)=q_j | i_t=q_i)$；
- $B$：观测概率矩阵，$b_j(k) = P(o_t=v_k | i_t=q_j)$；
- $pi$：初始状态概率，$pi_i = P(i_1=q_i)$。

== HMM 两个基本假设

#warnbox[
  1. #key[齐次的一阶马尔可夫假设]：给定前一状态后，当前状态与更早状态独立，且状态转移概率不随时间变化。\
  2. #key[观测独立性假设]：当前观测只依赖当前状态。
]

== HMM 三个基本问题

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*问题*], [*目标*], [*算法*]),
  [概率计算], [给定 $lambda$ 和 $O$，计算 $P(O|lambda)$], [前向算法 / 后向算法],
  [学习], [给定观测序列估计 $A,B,pi$], [监督MLE / Baum-Welch],
  [预测/解码], [给定 $lambda,O$ 求最可能状态序列], [Viterbi算法],
)

== 前向算法

#methodblock[
  *定义*：$alpha_t(i) = P(o_1, dots, o_t, i_t=q_i | lambda)$。

  1. 初始化：$alpha_1(i) = pi_i b_i(o_1)$。
  2. 递推：$alpha_(t+1)(j) = [sum_i alpha_t(i) a_(i j)] b_j(o_(t+1))$。
  3. 终止：$P(O|lambda) = sum_i alpha_T(i)$。
  4. 时间复杂度：$O(N^2 T)$。
]


== 后向算法

#methodblock[
  *定义*：$beta_t(i)=P(o_(t+1), dots, o_T | i_t=q_i, lambda)$。

  1. 初始化：$beta_T(i)=1$。
  2. 递推：$beta_t(i)=sum_j a_(i j) b_j(o_(t+1)) beta_(t+1)(j)$。
  3. 终止：$P(O|lambda)=sum_i pi_i b_i(o_1) beta_1(i)$。
]

== HMM 学习问题速记

#methodblock[
  - 有标注状态序列：用频率做监督 MLE，$a_(i j)$ 是从 $i$ 到 $j$ 的转移次数除以从 $i$ 转出的总次数；$b_j(k)$ 是状态 $j$ 生成观测 $v_k$ 的次数除以状态 $j$ 出现总次数。
  - 只有观测序列：用 Baum-Welch，也就是 EM 的 HMM 版本。
  - 直接计算 $P(O|lambda)=sum_I P(O,I|lambda)$ 需要枚举 $N^T$ 条状态序列，复杂度太高，因此用前向/后向动态规划。
]


== Viterbi 算法

#methodblock[
  *目标*：求最可能的隐藏状态序列。

  1. 定义 $delta_t(i)$：时刻 $t$ 以状态 $q_i$ 结尾的最大路径概率。
  2. 初始化：$delta_1(i)=pi_i b_i(o_1)$，$psi_1(i)=0$。
  3. 递推：$delta_t(j)=max_i [delta_(t-1)(i) a_(i j)] b_j(o_t)$。
  4. 记录：$psi_t(j)=arg max_i [delta_(t-1)(i) a_(i j)]$。
  5. 终止：选择 $max_i delta_T(i)$。
  6. 回溯：根据 $psi$ 从后往前找最优状态序列。
]

#warnbox[前向算法是“求和”计算观测概率；Viterbi 是“取最大”寻找最优路径。二者递推形式相似，但目标不同。]

== 最大熵模型

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


== 条件随机场 CRF

/ 条件随机场 (Conditional Random Field, CRF): 给定输入 $X$ 后，输出变量 $Y$ 在无向图上满足条件马尔可夫性质，并直接建模条件概率 $P(Y|X)$ 的判别式模型。

线性链 CRF 常用于分词、NER、POS 等序列标注任务。

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


== 本章高频题

#exercise(title: [概率图模型])[
  1. 写出 HMM 的三要素和两个基本假设。
  2. 说明 HMM 的三个基本问题及对应算法。
  3. 默写前向算法步骤。
  4. 默写 Viterbi 算法步骤，并说明与前向算法区别。
  5. 解释最大熵原理。
  6. 比较 HMM 和 CRF。
]
