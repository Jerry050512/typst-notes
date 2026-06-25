#import "../template/preamble.typ": *

= 拟合

#intuition[
  给定一堆 2D 点，如何找到最能"代表"它们的直线/曲线？这就是拟合问题。

  拟合面临三个层层递进的难题：
  + 如果知道哪些点属于直线 $arrow.r$ #key[最小二乘法]
  + 如果有少量外点（离群点） $arrow.r$ #key[鲁棒拟合]
  + 如果有大量外点或多条直线 $arrow.r$ #key[投票方法：RANSAC、霍夫变换]
]

== 最小二乘法直线拟合

=== 垂直最小二乘法

*问题*：给定点 $(x_1, y_1), dots, (x_n, y_n)$，拟合直线 $y = m x + b$。

*目标*：最小化纵向距离平方和

#formula[
  $
  E = sum_(i=1)^n (y_i - m x_i - b)^2
  $
]

*求解*：通过正规方程 $X^T X B = X^T Y$ 求解，其中 $B = vec(m, b)$。

#warnbox[
  *存在的问题*：
  - #key[非旋转不变]：旋转坐标系后拟合结果不同
  - #key[无法描述垂直线]：$m = infinity$ 时方程退化
]

=== 全最小二乘法

*改进*：采用 *点到直线的垂直距离* 作为误差度量，克服垂直最小二乘法的缺陷。

直线表示为：$a x + b y = d$，其中 $a^2 + b^2 = 1$（单位法向量 $N = (a, b)$）

*目标*：最小化垂直距离平方和

#formula[
  $
  E = sum_(i=1)^n (a x_i + b y_i - d)^2
  $
]

*求解要点*：
- 直线过质心：$d = a overline(x) + b overline(y)$
- 构造数据矩阵 $U$（每行为 $(x_i - overline(x), y_i - overline(y))$）
- 解为 $U^T U$ 的 #key[最小特征值对应的特征向量] $N = (a, b)$

#warnbox[
  全最小二乘法的优点：#key[旋转不变]，可以描述任意方向（包括垂直）的直线。
]

== 最小二乘法的鲁棒性问题

#key[问题]：最小二乘法的平方误差严重惩罚外点。

少量远离的外点会显著拉偏拟合结果，因为它们的平方误差会主导总能量。

=== 鲁棒最小二乘法

*一般方法*：找到使下式最小化的模型参数 $theta$

#formula[
  $
  E = sum_i rho(r_i (x_i, theta), sigma)
  $
]

其中：
- $r_i (x_i, theta)$：关于模型参数 $theta$ 的第 $i$ 个点的残差
- $rho$：具有尺度参数 $sigma$ 的 *鲁棒函数*

常用鲁棒函数：

#formula[
  $
  rho(r, sigma) = r^2 / (r^2 + sigma^2)
  $
]

鲁棒函数 $rho$ 对较小残差表现为平方距离，对较大残差饱和（不会无限增长），从而限制外点影响。

=== 尺度参数 $sigma$ 的选择

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "尺度设置"),
      text(fill: titlecolor, weight: "bold", "效果"),
    ),
    [恰到好处], [外点影响被最小化，内点正常拟合],
    [太小], [拟合结果对所有数据点都不敏感，每个点误差几乎相同，拟合很差],
    [太大], [退化为普通最小二乘法，外点影响依然显著],
  ),
  caption: [鲁棒因子 $sigma$ 的选择]
)

#warnbox[
  鲁棒拟合可以处理 *少量外点*，但当外点比例较高时仍然失效。此时需要用 #key[RANSAC] 等投票方法。
]

== RANSAC

#key[\*重点：RANSAC 全称必考！Random Sample Consensus（随机采样一致性）]

/ RANSAC: #key[\*必考全称] 全称 *Random Sample Consensus*（#key[随机采样一致性]），由 Fischler 和 Bolles 于 1981 年提出，是在存在外点情况下进行模型拟合的非常通用的框架。

#warnbox[
  #key[\*考试要点]：
  - RANSAC全称：#key[Random Sample Consensus]（随机采样一致性）
  - 中文翻译：随机采样一致性
  - 这是填空题的高频考点，必须完整记住！
]

#intuition[
  RANSAC 的核心思想：与其试图让一条直线拟合所有点（包括外点），不如 *反复随机抽取最小样本拟合模型*，看哪个模型有最多的"支持者"（内点）。

  少数服从多数——这就是"一致性"的来源。
]

=== 算法概述

#methodblock[
  *RANSAC 核心流程*：

  + 随机均匀地选择一小部分样本点，作为一个子集
  + 根据该子集拟合模型
  + 找到所有与该模型"接近"的剩余点（内点），将其余点作为外点丢弃
  + 多次执行此操作并选择最佳模型
]

=== RANSAC 直线拟合算法

#methodblock[
  *输入*：
  - 观测数据集
  - 采样点数 $n$（拟合直线 $n = 2$）
  - 迭代次数 $k$
  - 判断内点的阈值 $t$
  - 判断模型合理性所需的内点数 $d$

  *输出*：拟合模型

  *算法步骤*：

  1. 迭代 $k$ 次
  2. 从数据集中均匀地随机采样 $n$ 个点
  3. 对 $n$ 个采样点进行直线拟合
  4. 对于未选择的每一个点：
  5. #h(1em) 使用阈值 $t$ 比较点到直线的距离，若距离 $< t$，则判定为内点
  6. 如果有 $gt.eq d$ 个内点，则该拟合足够合理，重新用这些内点拟合直线
  7. 使用拟合误差作为准则，确定最好的拟合模型
]

=== 算法伪代码

#methodblock[
  ```
  输入：数据点集 S、采样点数 n、迭代次数 k、内点阈值 t、合理模型所需内点数 d
  输出：最佳拟合模型

  best_model ← 无；best_error ← ∞
  重复 k 次：
      S_sample ← 从 S 中随机采样 n 个点
      model ← 用 S_sample 拟合直线
      inliers ← 空集
      对 S 中除采样点外的每个点 p：
          若 dist(p, model) < t：
              将 p 加入 inliers
      若 |inliers| ≥ d：
          refined_model ← 用 inliers 重新拟合
          error ← 拟合误差
          若 error < best_error：
              best_model ← refined_model
              best_error ← error
  结束
  返回 best_model
  ```
]

=== 参数选择

*初始点数 $s$*

拟合模型需要的 #key[最小样本点数]：
- 直线：$s = 2$
- 三维平面：$s = 3$（三点不共线）
- 单应矩阵估计：$s = 4$ 对一般位置的点对应
- 基础矩阵估计：七点最小算法 $s = 7$；若明确使用八点算法则 $s = 8$

*距离阈值 $t$*

选择 $t$ 使得拟合误差 $lt.eq t$ 的数据点以不低于 $q$ 的概率被判断为内点。

对于一维、均值为零、标准差为 $sigma$ 的高斯残差，若取95%置信概率：

#formula[
  $
  t^2 = 3.84 sigma^2
  $
]

*样本数 $N$（迭代次数）*

选择 $N$，使至少存在一个样本以概率 $p$（如 $p = 0.99$）被判断为非外点。设外点比例为 $e$：

#formula[
  $
  (1 - (1 - e)^s)^N = 1 - p
  $
]

解出：

#formula[
  $
  N = log(1 - p) / log(1 - (1 - e)^s)
  $
]

样本数 $N$ 随外点比例 $e$ 和初始点数 $s$ 急剧增长：

#figure(
  table(
    columns: 9,
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 5pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", $s$),
      text(fill: titlecolor, weight: "bold", "5%"),
      text(fill: titlecolor, weight: "bold", "10%"),
      text(fill: titlecolor, weight: "bold", "20%"),
      text(fill: titlecolor, weight: "bold", "25%"),
      text(fill: titlecolor, weight: "bold", "30%"),
      text(fill: titlecolor, weight: "bold", "40%"),
      text(fill: titlecolor, weight: "bold", "50%"),
    ),
    [2], [2], [3], [5], [6], [7], [11], [17], [],
    [3], [3], [4], [7], [9], [11], [19], [35], [],
    [4], [3], [5], [9], [13], [17], [34], [72], [],
    [5], [4], [6], [12], [17], [26], [57], [146], [],
    [6], [4], [7], [16], [24], [37], [97], [293], [],
    [7], [4], [8], [20], [33], [54], [163], [588], [],
    [8], [5], [9], [26], [44], [78], [272], [1177], [],
  ),
  caption: [不同外点比例 $e$ 和最小样本数 $s$ 下所需的迭代次数 $N$ (p=0.99)]
)

*一致性点集大小 $d$*

应符合预期的内点比率（用来判断模型是否足够好）。

=== 自适应确定样本数量

外点比例 $e$（等价地，内点比例 $1-e$）通常未知，可采用自适应过程：

#methodblock[
  + 初始化 $N = infinity$，采样数 $= 0$
  + 当 $N >$ 采样数时：
    - 选择一个样本并计算内点数量
    - 设 $e = 1 - "内点数"/"总点数"$
    - 根据新的 $e$ 重新计算 $N = log(1-p) / log(1-(1-e)^s)$
    - 采样数 $+ 1$
]

通常从最坏情况开始（如 $e = 50%$），在发现更多内点时调整。

=== RANSAC 的优缺点

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "方面"),
      text(fill: titlecolor, weight: "bold", "描述"),
    ),
    [优点], [简单通用；适用于许多不同问题；实践中往往效果很好],
    [缺点 1], [参数较多需要调整],
    [缺点 2], [内点比率较低时效果不佳（迭代次数太多甚至失效）],
    [缺点 3], [不能总是基于最小样本数得到一个好的初始模型],
  ),
  caption: [RANSAC 优缺点]
)

#warnbox[
  *为什么"最小样本数"不一定好？*

  以直线拟合为例，两点离得越近，直线方向对噪声越敏感。哪怕这两点只是因为轻微测量误差偏离真实位置，拟合的直线也会严重偏斜。
]

== 霍夫变换

#key[\*考试重点：霍夫变换（翻译必考）、极坐标平面内累加器单元算法（必考大题）]

#warnbox[
  #key[\*必考术语]：霍夫变换 - #key[Hough Transform]

  考试可能要求：
  - 翻译"霍夫变换"为英文
  - 或将"Hough Transform"翻译为中文
]

#intuition[
  RANSAC 是 *随机抽样投票*，霍夫变换则是 *每个点对所有可能的模型投票*。

  关键思路：图像空间中的"点拟合直线"问题，被转换为参数空间中的"找峰值"问题。
]

=== 基本思想

#methodblock[
  + 将参数空间离散化为一个个格子（累加器单元）
  + 对图像中的每个特征点，在参数空间中对应的每个格子进行投票
  + 查找得票最多的格子，即为检测到的直线参数
]

=== $(m, b)$ 参数空间

直线方程 $y = m x + b$ 中，$(m, b)$ 是参数。

*对偶关系*：
- 图像空间中的一条直线 $arrow.l.r$ 霍夫空间中的一个点 $(m, b)$
- 图像空间中的一个点 $(x_0, y_0)$ $arrow.l.r$ 霍夫空间中的一条直线 $b = -x_0 m + y_0$

*多点共线的几何含义*：包含 $(x_0, y_0)$ 和 $(x_1, y_1)$ 的直线 = 霍夫空间中 $b = -x_0 m + y_0$ 与 $b = -x_1 m + y_1$ 的 *交点*。

=== $(m, b)$ 空间的累加器单元算法

#methodblock[
  *输入*：$x y$-坐标平面内的数据点

  *输出*：直线的个数和每条直线的参数

  *算法步骤*：

  1. 将 $x y$-坐标平面内给定的所有数据点映射为 $a b$-坐标平面内的直线
  2. 在 $a b$-坐标平面内计算每两条直线的交点，记录交点坐标 $(a_i, b_i)$, $i=1,2,dots,k$，$k$ 为交点数
  3. 分别求 $a_i$ 和 $b_i$ 的最小值和最大值：$a_min, a_max, b_min, b_max$
  4. 将 $a_min, a_max, b_min, b_max$ 确定的矩形区域划分成小格，在每个小格中统计交点个数 $m_i$, $i = 1, 2, dots, n$，$n$ 为格子数
  5. 设置足够大的阈值 $m_T$，当 $m_i gt.eq m_T$ 时，认为第 $i$ 个坐标位置对应 $x y$-坐标平面内的一条直线
  6. 输出直线个数和每条直线的参数
]

#warnbox[
  *$(m, b)$ 参数空间存在的问题*：
  - #key[参数域无界]：$m$ 可以取任意实数
  - #key[无法处理垂直线]：垂直线 $m arrow infinity$

  解决方案：使用 *极坐标表示*
]

=== 极坐标表示

直线的极坐标方程：

#formula[
  $
  x cos theta + y sin theta = rho
  $
]

其中：
- $rho$：有符号垂直距离
- $theta$：直线法向量与 $x$ 轴的夹角。常用唯一参数域为 $theta in [0, 180 degree)$、$rho in [-rho_max, rho_max]$

*对偶关系*：
- 图像空间中的一个点 $arrow.l.r$ 极坐标参数空间中的一条 *正弦曲线*
- 图像空间中的一条直线 $arrow.l.r$ 极坐标参数空间中的一个 *点* $(rho, theta)$

每个图像点 $(x, y)$ 对应参数空间中的正弦曲线 $rho = x cos theta + y sin theta$。

=== 极坐标平面内的累加器单元算法\*

#key[\*必考大题：极坐标平面内的累加器单元算法]

#example(title: [必考大题\*])[
  #key[\*原题] 写出极坐标平面内的累加器单元算法。

  *解答*

  *输入*：$x y$-坐标平面内的数据点

  *输出*：直线的个数以及直线的极坐标参数

  #methodblock[
    *算法步骤*：

    + 在 $x y$-坐标平面内计算所有数据点到原点的距离，其最大值记为 $rho_max$

    + 将 $theta in [0, 180 degree)$，$rho in [-rho_max, rho_max]$ 所确定的矩形区域按一定步长划分成小格，并将每个小格的累加器 $H(rho, theta)$ 初始化为零

    + 对于每个数据点 $(x_i, y_i)$，进行以下循环操作：

    4. #h(1em) 在 $[0, 180 degree)$ 范围内遍历所有离散的 $theta$，进行以下循环操作：

    5. #h(2em) 计算 $rho = x_i cos theta + y_i sin theta$

    6. #h(2em) $H(rho, theta) = H(rho, theta) + 1$

    7. #h(1em) 结束内循环

    + 结束外循环

    + 找到 $H(rho, theta)$ 超过阈值的 #key[局部最大值]，每个峰值对应一条候选直线

    + 输出直线个数以及每条直线的参数
  ]
]

#warnbox[
  #key[\*必考要点（背诵版）]：

  *输入输出*：
  - 输入：$x y$ 平面的数据点
  - 输出：直线个数 + 每条直线的极坐标参数 $(rho, theta)$

  *核心步骤*：
  1. 计算 $rho_max$（所有点到原点的最大距离）
  2. 初始化累加器 $H(rho, theta) = 0$，参数范围：$theta in [0, 180 degree)$，$rho in [-rho_max, rho_max]$
  3. 对每个数据点 $(x_i, y_i)$：
     - 遍历所有 $theta$
     - 计算 $rho = x_i cos theta + y_i sin theta$
     - 累加器投票：$H(rho, theta) = H(rho, theta) + 1$
  4. 找累加器超过阈值的局部最大值，每个峰值对应一条候选直线
  5. 输出结果

  *关键公式*：$rho = x cos theta + y sin theta$（极坐标直线方程）
]

=== 算法简洁伪代码

#methodblock[
  ```
  将累加器 H 初始化为全零
  对图像中的每个边缘点 (x, y):
      对 θ = 0 到 180:
          ρ = x cos θ + y sin θ
          H(θ, ρ) = H(θ, ρ) + 1
      结束
  结束

  找到 H(θ, ρ) 取局部最大值时的 (θ, ρ)
  图像中检测到的直线由下式给出:
      ρ = x cos θ + y sin θ
  ```
]

=== 噪声处理

*格子大小（离散化）的选择*

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "格子大小"),
      text(fill: titlecolor, weight: "bold", "问题"),
    ),
    [太粗], [太多不同的直线对应到同一 bucket，获得大量伪票],
    [太细], [一些不完全共线的点投票给不同 bucket，错过一些直线],
  ),
  caption: [格子离散化的权衡]
)

*其他改进策略*

- *增量式邻居网格*：在累加器数组中进行平滑投票
- *去除不相关特征*：只取具有显著梯度的边缘点

=== 结合图像梯度的改进霍夫变换

#key[核心改进]：检测边缘点时已知梯度方向，等价于直线方向已经确定！

#methodblock[
  *改进的霍夫变换*：

  对每个边缘点 $(x, y)$：
  - $theta = (x, y)$ 处的梯度方向
  - $rho = x cos theta + y sin theta$
  - $H(theta, rho) = H(theta, rho) + 1$
  结束
]

每个边缘点只投 *一票*，大幅减少计算量和伪峰。

== 圆的霍夫变换

=== 参数空间

圆的方程（笛卡尔坐标）：

#formula[
  $
  (x - x_0)^2 + (y - y_0)^2 = r^2
  $
]

参数空间为 *三维*：$(x_0, y_0, r)$。

引入夹角 $theta$ 改写：

#formula[
  $
  x_0 = x - r cos theta, quad y_0 = y - r sin theta
  $
]

=== 参数空间的几何

对图像中固定一点 $(x, y)$，在以 $(x_0, y_0, r)$ 为轴的三维空间中：
- 当 $r = 0$ 时：曲线退化为点 $(x, y, 0)$
- 当 $r > 0$ 时：形成以 $(x, y)$ 为圆心、半径为 $r$ 的圆
- 整体形成一个 #key[倒立的圆锥面]

=== 利用梯度方向加速

在边缘点 $(x, y)$ 处可得到梯度 $nabla I(x, y)$：
- 圆心必沿梯度方向（指向圆心或反方向）
- 令单位梯度方向 $bold(g)=nabla I(x,y) / ||nabla I(x,y)||$，候选圆心为 $(x, y) + r bold(g)$ 或 $(x, y) - r bold(g)$
- 随半径变化，候选点位于穿过该边缘点的同一直线上，分别沿两个相反方向延伸

这将 3D 投票降为 *1D 投票*，效率大幅提升。

=== 圆霍夫变换的优缺点

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "方面"),
      text(fill: titlecolor, weight: "bold", "描述"),
    ),
    table.cell(rowspan: 3)[优点], [可处理非局部性和遮挡],
    [可检测模型的多个实例（多条直线/多个圆）],
    [对噪声有一定鲁棒性（噪声点不太可能同时影响多个格子）],
    table.cell(rowspan: 3)[缺点], [#key[搜索时间复杂度随参数数量呈指数增长]],
    [非目标形状可能在参数空间产生伪峰],
    [很难选择合适的离散化网格尺寸],
  ),
  caption: [霍夫变换的优缺点]
)
