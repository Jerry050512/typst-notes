= 第9章：概率模型

== 第一部分：隐马尔可夫模型 《HMM》

=== HMM 定义

隐马尔可夫模型 《Hidden Markov Model, HMM》 是描述由一个隐藏的马尔可夫链随机生成不可观测的状态序列，再由各个状态生成一个观测序列，从而产生可观测随机序列的过程的统计学习模型。

- 状态序列 《state sequence》：隐藏的、不可观测的随机状态序列
- 观测序列 《observation sequence》：每个状态生成的可观测随机序列

=== HMM 三要素

HMM 由以下三个要素确定，记为 lambda = 《A, B, pi》：

· 状态转移矩阵 A：A = 《a《i j》》《N times N》，其中 a《i j》 = P《i《t+1》 = qj   it = qi》，i,j = 1,2,...,N

· 观测概率矩阵 B：B = 《bj《k》》《N times M》，其中 bj《k》 = P《ot = vk   it = qj》

· 初始状态概率向量 pi：pi = 《pii》，其中 pii = P《i1 = qi》

其中 N 是状态数，M 是可能的观测数。

=== HMM 两个基本假设

1. 齐次马尔可夫性假设：t+1 时刻的状态只依赖于 t 时刻的状态：

P《i《t+1》   it, i《t-1》, ..., i1, ot, ..., o1》 = P《i《t+1》   it》


2. 观测独立性假设：t 时刻的观测只依赖于 t 时刻的状态：

P《ot   it, i《t-1》, ..., i1, o《t-1》, ..., o1》 = P《ot   it》


=== HMM 三个基本问题

1. 概率计算：在给定模型 lambda 和观测序列 O 的条件下，计算 P《O lambda》
 - 解法：前向-后向算法

2. 学习：在给定观测序列 O 的条件下，估计模型参数 lambda = 《A,B,pi》
 - 监督学习：已知状态序列，极大似然估计
 - 无监督学习：Baum-Welch 算法《EM 算法的特殊情况》

3. 预测《解码》：在给定模型 lambda 和观测序列 O 的条件下，求最可能的状态序列 I
 - 解法：维特比算法 《Viterbi Algorithm》

=== 前向算法

目标：高效计算 P《O   lambda》 = sum《i=1》N alphaT《i》

定义前向概率：alphat《i》 = P《o1, o2, ..., ot, it = qi   lambda》

算法步骤：

1. 初始化：alpha1《i》 = pii bi《o1》，i = 1,2,...,N

2. 递推：对 t = 1,2,...,T-1：

alpha《t+1》《j》 = 《sum《i=1》N alphat《i》 a《i j》》 bj《o《t+1》》
，j = 1,2,...,N

3. 终止：P《O   lambda》 = sum《i=1》N alphaT《i》

时间复杂度：O《N2 T》

=== 后向算法

定义后向概率：betat《i》 = P《o《t+1》, o《t+2》, ..., oT   it = qi, lambda》

算法步骤：

1. 初始化：betaT《i》 = 1，i = 1,2,...,N

2. 递推：对 t = T-1, T-2, ..., 1：

betat《i》 = sum《j=1》N a《i j》 bj《o《t+1》》 beta《t+1》《j》
，i = 1,2,...,N

3. 终止：P《O   lambda》 = sum《i=1》N pii bi《o1》 beta1《i》

=== 维特比算法

目标：求最优状态序列 I = op《"arg max"》I P《I   O, lambda》

定义：deltat《i》 = op《"max"》《i1,...,i《t-1》》 P《i1,...,i《t-1》, it = qi, o1,...,ot   lambda》

记录：psit《i》 = op《"arg max"》《1 ‹= it ‹= N》 《delta《t-1》《it》 a《it i》》

算法步骤：

1. 初始化：delta1《i》 = pii bi《o1》，psi1《i》 = 0，i = 1,2,...,N

2. 递推：对 t = 2,3,...,T：
 - deltat《j》 = op《"max"》《1 ‹= i ‹= N》 《delta《t-1》《i》 a《i j》》 bj《ot》
 - psit《j》 = op《"arg max"》《1 ‹= i ‹= N》 《delta《t-1》《i》 a《i j》》

3. 终止：
 - P = op《"max"》《1 ‹= i ‹= N》 《deltaT《i》》
 - iT = op《"arg max"》《1 ‹= i ‹= N》 《deltaT《i》》

4. 回退：对 t = T-1, T-2, ..., 1：
 - it = psi《t+1》《i《t+1》》

=== 前向后向概率的重要应用

单个状态概率 《gamma》：

gammat《i》 = P《it = qi   O, lambda》 = 《alphat《i》 betat《i》》 / P《O   lambda》


给定观测序列 O 的条件下，t 时刻处于状态 qi 的概率。

转移概率 《xi》：

xit《i,j》 = P《it = qi, i《t+1》 = qj   O, lambda》 = 《alphat《i》 a《i j》 bj《o《t+1》》 beta《t+1》《j》》 / P《O   lambda》


给定观测序列 O 的条件下，t 时刻处于状态 qi 且 t+1 时刻处于状态 qj 的概率。

重要关系：
- gammat《i》 = sum《j=1》N xit《i,j》
- sum《t=1》《T-1》 gammat《i》：在观测序列 O 下经过状态 qi 的期望次数
- sum《t=1》《T-1》 xit《i,j》：在观测序列 O 下从状态 qi 转移到 qj 的期望次数

== 第二部分：最大熵模型

=== 熵的定义

随机变量 X 的熵 《entropy》 定义为：

H《X》 = - sumx p《x》 log p《x》


熵衡量随机变量的不确定性。熵越大，不确定性越大。

=== 条件熵

在给定随机变量 X 的条件下，随机变量 Y 的条件熵 《conditional entropy》：

H《Y X》 = sumx p《x》 H《Y   X = x》 = - sumx sumy p《x,y》 log p《y x》


=== 最大熵原理

核心思想：在满足已知约束条件的所有模型《概率分布》中，选择熵最大的模型作为最优模型。

即：在已知部分知识《约束》的前提下，对未知部分不做任何主观假设，而是等可能地对待。

数学表述：在满足约束条件

sumx sumy tilde《p》《x》 p《y x》 fi《x,y》 = tilde《p》《x,y》 fi quad 《i = 1,2,...,n》

的所有条件分布 p《y x》 中，选择使条件熵 H《p》 最大的分布：

p = op《"arg max"》《p in C》 H《p》


=== 最大熵模型形式

在满足上述约束条件下，使条件熵最大的条件概率分布具有如下形式：

p《y x》 = exp《sum《i=1》n lambdai fi《x,y》》 / Zlambda《x》


其中：
- fi《x,y》：第 i 个特征函数《约束函数》
- lambdai：第 i 个特征函数对应的权值《拉格朗日乘子》
- Zlambda《x》：规范化因子，Zlambda《x》 = sumy exp《sum《i=1》n lambdai fi《x,y》》

重要性质：最大熵模型是对数线性模型 《log-linear model》。

=== 参数估计

最大熵模型的参数是特征函数的权值 lambda = 《lambda1, lambda2, ..., lambdan》。

改进的迭代尺度法 《IIS, Improved Iterative Scaling》：

1. 初始化 lambdai = 0《对所有 i》
2. 对每个 lambdai，更新为 lambdai + deltai，其中 deltai 是方程

sumx sumy tilde《p》《x》 p《y x》 fi《x,y》 e《deltai f《x,y》》 = sumx sumy tilde《p》《x,y》 fi
 的解，f《x,y》 = sum《i=1》n fi《x,y》
3. 重复步骤2直到收敛

拟牛顿法 《Quasi-Newton Method》：

使用 BFGS 等拟牛顿法直接优化对数似然函数，收敛速度通常比 IIS 更快。

== 第三部分：条件随机场 《CRF》

=== CRF 定义

条件随机场 《Conditional Random Field, CRF》 是给定输入随机变量 X 的条件下，输出随机变量 Y 的条件概率分布模型。

- CRF 是判别模型 《discriminative model》，直接对条件概率 P《Y X》 建模
- 与 HMM 的生成式建模方式 P《O,I》 = P《i1》 prodt P《ot it》 P《i《t+1》 it》 不同

=== 线性链条件随机场

线性链条件随机场 《Linear-chain CRF》 是 CRF 在序列标注问题上的特化形式。

设 X = 《X1, X2, ..., Xn》，Y = 《Y1, Y2, ..., Yn》 均为线性链表示的随机变量序列，若在给定 X 的条件下，Y 满足马尔可夫性：

P《Yi   X, Y《j ne i》》 = P《Yi   X, Y《i-1》, Y《i+1》》


则称 P《Y X》 为线性链条件随机场。

线性链 CRF 的参数化形式：

P《Y   X》 = 《1/Z《X》》 exp《sum《i=1》n sum《k=1》K lambdak tk《y《i-1》, yi, X, i》》


其中：
- tk：转移特征函数《边上的特征》
- lambdak：对应的权值
- Z《X》：规范化因子

=== CRF 与 HMM 的关系

  特性   HMM   CRF  
 ------ ----- ----- 
  模型类型   生成模型   判别模型  
  建模对象   联合概率 P《O,I》   条件概率 P《Y X》  
  假设   观测独立性、齐次马尔可夫性   无严格独立性假设  
  特征   仅基于状态转移和观测   可使用丰富的特征函数  
  表达能力   较弱   更强  

CRF 可以包含 HMM 所能表达的所有内容，同时还能表达更复杂的依赖关系。

=== CRF 三个基本问题

1. 概率计算：给定模型参数和输入序列 X、输出序列 Y，计算 P《Y X》
 - 解法：类似 HMM 的前向-后向算法

2. 学习：给定训练数据，估计模型参数
 - 解法：最大似然估计 + 正则化，使用 L-BFGS 等优化算法

3. 预测：给定模型和输入序列 X，求最可能的输出序列 Y
 - 解法：维特比算法

=== CRF 中的维特比算法

在 CRF 中进行解码《预测》时，使用维特比算法求最优标注序列：

算法步骤：

1. 初始化：delta1《j》 = sum《k=1》K lambdak ek《y0, yj, X, 1》

2. 递推：对 i = 2, 3, ..., n：
 - deltai《j》 = op《"max"》《y《i-1》》 《delta《i-1》《y《i-1》》 + sum《k=1》K lambdak tk《y《i-1》, yj, X, i》》
 - psii《j》 = op《"arg max"》《y《i-1》》 《delta《i-1》《y《i-1》》 + sum《k=1》K lambdak tk《y《i-1》, yj, X, i》》

3. 终止：yn = op《"arg max"》《yn》 deltan《yn》

4. 回退：对 i = n-1, ..., 1：yi = psi《i+1》《y《i+1》》

== 习题要点

以下为期末考试中概率图模型部分的高频计算题型和重点：

=== 题型一：HMM 概率计算《前向/后向算法》

核心考点：给出模型 lambda = 《A, B, pi》 和观测序列 O，用前向或后向算法计算 P《O lambda》。

解题步骤：
1. 计算初始概率：alpha1《i》 = pii bi《o1》
2. 逐步递推计算所有 alphat《i》
3. 求和得到 P《O lambda》 = sumi alphaT《i》

注意：这是最基础的计算题，务必熟练手算 2-3 步递推。

=== 题型二：HMM 解码《维特比算法》

核心考点：给定模型和观测序列，用维特比算法求最优状态序列。

解题步骤：
1. 计算初始 delta 值
2. 递推计算每个时刻的 delta 和 psi
3. 终止得到最终最优概率和最后状态
4. 回退得到完整最优路径

注意：回退步骤不要漏掉！psi 记录的是"从哪个状态转移过来"。

=== 题型三：Baum-Welch 算法《参数学习》

核心考点：用前向后向概率更新模型参数。

更新公式：
- pii = gamma1《i》
- a《i j》 = 《sum《t=1》《T-1》 xit《i,j》》 / 《sum《t=1》《T-1》 gammat《i》》
- bj《k》 = 《sum《t=1, ot = vk》T gammat《j》》 / 《sum《t=1》T gammat《j》》

注意：分母是"处于该状态的期望次数"，分子是"满足条件的期望次数"。

=== 题型四：最大熵模型的特征函数与模型形式

核心考点：给定特征函数，写出最大熵模型的具体形式。

解题方法：
1. 将特征函数代入 p《y x》 = exp《sumi lambdai fi《x,y》》 / Z《x》
2. 计算规范化因子 Z《x》 = sumy exp《sumi lambdai fi《x,y》》
3. 化简得到最终表达式

=== 题型五：CRF 概率计算与解码

核心考点：给定线性链 CRF 的特征函数和权值，计算条件概率或求最优标注。

解题步骤：
1. 计算每个位置的特征得分
2. 用前向-后向算法计算规范化因子 Z《X》
3. 用维特比算法求最优标注序列

=== 题型六：HMM 与 CRF 的对比分析

核心考点：说明 HMM 和 CRF 的区别与联系。

答题要点：
- HMM 是生成模型，建模联合概率；CRF 是判别模型，建模条件概率
- HMM 有观测独立性假设；CRF 没有
- CRF 可以使用任意丰富的特征函数
- 两者都可用维特比算法解码

=== 题型七：熵与条件熵的计算

核心考点：给定概率分布，计算熵 H《X》、条件熵 H《Y X》、互信息 I《X;Y》。

重要公式：
- H《X》 = -sumx p《x》 log p《x》
- H《Y X》 = -sumx sumy p《x,y》 log p《y x》
- I《X;Y》 = H《X》 - H《X Y》 = H《Y》 - H《Y X》

=== 题型八：IIS 参数更新

核心考点：用改进的迭代尺度法更新最大熵模型的参数。

解题步骤：
1. 计算经验期望：E《p tilde》《fi》 = sumx sumy tilde《p》《x,y》 fi《x,y》
2. 计算模型期望：Ep《fi》 = sumx sumy tilde《p》《x》 p《y x》 fi《x,y》
3. 求解 deltai 使得模型期望等于经验期望
4. 更新 lambdai ← lambdai + deltai

期末复习建议：
- 重点练习前向算法和维特比算法的手算，考试常考 3-5 步递推
- 熟记 Baum-Welch 的三个更新公式，理解其统计意义
- 理解最大熵模型的推导过程：从约束优化到指数族形式
- 对比记忆 HMM 和 CRF 的异同
