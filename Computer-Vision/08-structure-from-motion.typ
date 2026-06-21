#import "../template/preamble.typ": *

= 运动恢复结构

/ 运动恢复结构 (Structure from Motion, SfM): 从场景的多张图像中，同时恢复三维结构（3D点坐标）和相机运动（相机位姿）。

#intuition[
  想象用手机围着一个物体拍多张照片。SfM 的目标是：仅从这些 2D 照片，推算出物体的 3D 形状（结构）以及你拍摄时手机的位置和朝向（运动）。
]

== 问题定义

*已知*：
- $n$ 个 3D 点 $X_j$ 在 $m$ 张图像中的对应像素坐标 $x_(i j)$
- 投影关系：$x_(i j) = M_i X_j$，其中 $i = 1, dots, m$（图像编号），$j = 1, dots, n$（点编号）

*求解*：
- $m$ 个相机的投影矩阵 $M_i$（运动 Motion）
- $n$ 个 3D 点的坐标 $X_j$（结构 Structure）

== 欧式结构恢复（双视图）

当已知相机内参 $K$ 时，问题变为求解相机外参（旋转 $R$ 和平移 $T$）以及 3D 点坐标。

=== 问题设定

*已知*：
- $n$ 个 3D 点在两张图像中的像素坐标 $x_(1j), x_(2j)$
- 两个相机的内参矩阵 $K_1, K_2$

*投影关系*：
#formula[
  $
  x_(1j) &= M_1 X_j = K_1 mat(I, bold(0)) X_j \
  x_(2j) &= M_2 X_j = K_2 mat(R, T) X_j
  $
]

第一个相机设为世界坐标系原点（$R_1 = I, T_1 = bold(0)$），第二个相机的外参 $R, T$ 未知。

*求解目标*：
- 相机 2 的外参：旋转 $R$ 和平移 $T$
- $n$ 个 3D 点的坐标 $X_j$

#key[核心困难]：$R, T$ 和 $X_j$ 都未知，需要同时求解。

=== 四步求解流程

双视图欧式结构恢复的标准流程：

#methodblock[
  *步骤 1：求解基础矩阵 $F$*

  使用归一化八点法从对应点 $x_(1j) arrow.l.r x_(2j)$ 估计基础矩阵 $F$。

  *步骤 2：计算本质矩阵 $E$*

  $
  E = K_2^T F K_1
  $

  *步骤 3：分解本质矩阵 $E arrow.r R, T$*

  将 $E$ 分解为旋转 $R$ 和平移 $T$（详见下节）。

  *步骤 4：三角化重建 3D 点*

  已知 $R, T$ 后，对每对对应点进行三角化求解 $X_j$。
]

#warnbox[
  这四步是 SfM 的核心流程，必须掌握。步骤 1-2 求解相机运动，步骤 3 分解得到外参，步骤 4 恢复三维结构。
]

== 本质矩阵分解

本质矩阵 $E = [bold(T)]_times R$ 将旋转和平移编码在一起，需要分解出 $R$ 和 $T$。

=== 分解原理

回顾叉乘的矩阵表示：

#formula[
  $
  bold(a) times bold(b) = mat(
    0, -a_z, a_y;
    a_z, 0, -a_x;
    -a_y, a_x, 0
  ) vec(b_x, b_y, b_z) = [bold(a)]_times bold(b)
  $
]

本质矩阵可以写成：$E = [bold(T)]_times R$

关键性质：反对称矩阵 $[bold(T)]_times$ 可以表示为：

#formula[
  $
  [bold(T)]_times = U Z U^T
  $
]

其中 $U$ 是正交矩阵，$Z = mat(0, 1, 0; -1, 0, 0; 0, 0, 0)$。

=== SVD 分解法

#methodblock[
  *步骤 1：对 $E$ 进行 SVD 分解*

  $
  E = U op("diag")(1, 1, 0) V^T
  $

  注意：本质矩阵的两个非零奇异值必须相等（理论值），实际中强制设为 $(1, 1, 0)$。

  *步骤 2：定义辅助矩阵*

  $
  W = mat(0, -1, 0; 1, 0, 0; 0, 0, 1)
  $

  *步骤 3：计算候选的 $R$ 和 $T$*

  - 旋转矩阵（两种可能）：
    $
    R_1 &= det(U W V^T) dot U W V^T \
    R_2 &= det(U W^T V^T) dot U W^T V^T
    $

    （乘以 $det$ 确保旋转矩阵行列式为 +1）

  - 平移向量（两种可能）：
    $
    T_1 = u_3, quad T_2 = -u_3
    $

    （$u_3$ 是 $U$ 的第三列）

  *步骤 4：消除歧义*

  四种组合 $(R_1, T_1), (R_1, T_2), (R_2, T_1), (R_2, T_2)$ 中只有一种正确。

  #key[验证方法]：三角化一个或多个点，选择使重建点在 #key[两个相机坐标系下深度都为正] 的那组 $(R, T)$。
]

#warnbox[
  本质矩阵分解有四种可能解，必须通过三角化验证深度正负来消除歧义。这是考试常考点。
]

=== 尺度歧义

#key[重要限制]：从图像对只能恢复 #key[相对尺度]，无法确定绝对尺度。

#example(title: [尺度歧义])[
  看下面两种情况：
  - 场景 A：物体大小 1m，相机间距 10cm
  - 场景 B：物体大小 10m，相机间距 1m

  如果拍摄角度完全相同，两者在图像中看起来完全一样！

  因此，恢复的结构与真实场景相差一个 #key[相似变换]（旋转、平移、缩放）。这种重构称为 *度量重构*。
]

要确定绝对尺度，需要额外的先验信息（如已知基线长度、场景中某物体的真实尺寸等）。

== 三角化

已知两个相机的投影矩阵 $M_1, M_2$ 和对应点 $x_(1j), x_(2j)$，求解 3D 点 $X_j$。

=== 线性三角化法

前面章节（三角化与极几何）已详细介绍，这里简要回顾：

将投影关系 $x = M X$ 展开为线性方程组，通过 SVD 求解。

=== 非线性优化法

最小化重投影误差：

#formula[
  $
  X_j^* = op("argmin", limits: #true)_X [d(x_(1j), M_1 X)^2 + d(x_(2j), M_2 X)^2]
  $
]

其中 $d(dot, dot)$ 是像素坐标的欧氏距离。

== 多视图情况

=== 增量法

对于 $N$ 个视图的场景：

#methodblock[
  + 选择初始图像对（如第 1 和第 2 张），用双视图方法恢复初始结构

  + 依次加入新视图：
    - 用已重建的 3D 点和新视图的 2D 点，通过 PnP 算法估计新相机位姿
    - 三角化新的 3D 点

  + 每加入若干视图后，运行捆绑调整优化所有参数
]

=== 捆绑调整 (Bundle Adjustment)

*目标*：联合优化所有相机参数和 3D 点坐标，最小化全局重投影误差。

#formula[
  $
  min_(M, X) sum_(i=1)^m sum_(j=1)^n D(x_(i j), M_i X_j)^2
  $
]

其中 $D(dot, dot)$ 是观测点 $x_(i j)$ 与重投影点 $M_i X_j$ 之间的距离。

*求解方法*：
- 列文伯格-马夸尔特算法（Levenberg-Marquardt, LM）
- 高斯-牛顿法

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "特点"),
      text(fill: titlecolor, weight: "bold", "说明"),
    ),
    [优势], [同时优化大量视图；可处理缺失数据（某些点在某些视图中不可见）],
    [局限], [参数众多，计算量大；需要良好的初始解（通常由前面步骤提供）],
    [实际应用], [常作为 SfM 流程的最后一步，用增量法或代数法的结果作为初始值],
  ),
  caption: [捆绑调整的特点]
)

== PnP 问题与增量法

/ PnP 问题 (Perspective-n-Point): 已知 $n$ 个 3D 点的世界坐标及其在图像中的像素坐标，求解相机位姿（外参 $R, T$）。

#intuition[
  双视图 SfM 解决了从零开始的重建。但如果已经有了一些 3D 点，如何为新拍的照片找到相机位置？这就是 PnP 问题——它是增量式重建的关键。
]

=== P3P 问题

P3P 是 PnP 的最小情况（3 个点），是理解 PnP 的基础。

*已知*：
- 相机内参 $K$
- 3 个像素点 $bold(a), bold(b), bold(c)$ 的像素坐标
- 对应的 3D 点 $A, B, C$ 在世界坐标系下的坐标

*求解*：相机外参 $R, T$

#methodblock[
  *P3P 求解步骤*：

  *步骤 1：计算射线方向和夹角*

  通过内参将像素坐标转为归一化坐标，得到相机光心到三点的射线方向：
  $
  bold(o a) = (K^(-1) bold(a)) / (||K^(-1) bold(a)||), quad
  bold(o b) = (K^(-1) bold(b)) / (||K^(-1) bold(b)||), quad
  bold(o c) = (K^(-1) bold(c)) / (||K^(-1) bold(c)||)
  $

  计算射线之间的夹角余弦值：
  $
  cos < bold(o a), bold(o b) > = bold(o a) dot bold(o b), quad
  cos < bold(o b), bold(o c) > = bold(o b) dot bold(o c), quad
  cos < bold(o a), bold(o c) > = bold(o a) dot bold(o c)
  $

  *步骤 2：求解线段长度*

  在世界坐标系中，已知 $A B, B C, A C$ 的距离。设 $O A, O B, O C$ 为未知长度，由余弦定理：
  $
  cases(
    O A^2 + O B^2 - 2 O A dot O B dot cos < bold(o a), bold(o b) > = A B^2,
    O B^2 + O C^2 - 2 O B dot O C dot cos < bold(o b), bold(o c) > = B C^2,
    O A^2 + O C^2 - 2 O A dot O C dot cos < bold(o a), bold(o c) > = A C^2
  )
  $

  求解该方程组得到 #key[4 组可能解]，需用第 4 个点验证消歧义。

  *步骤 3：计算相机坐标系下的 3D 坐标*

  结合射线方向和距离，得到 $A, B, C$ 在相机坐标系下的坐标：
  $
  A_"cam" = O A dot bold(o a), quad B_"cam" = O B dot bold(o b), quad C_"cam" = O C dot bold(o c)
  $

  *步骤 4：求解 $R, T$*

  已知 $A, B, C$ 在两个坐标系下的坐标，用 #key[绝对定向] 算法（如 Procrustes 分析或 Kabsch 算法）求解刚体变换 $R, T$。
]

#warnbox[
  - P3P 只用 3 个点，易受噪声干扰
  - 实际应用中用 EPnP、UPnP 等算法，利用更多点并迭代优化，提升鲁棒性
  - P3P 有 4 组解，需第 4 个点验证
]

=== 增量法在 SfM 中的作用

增量法通过逐步添加新视图来扩展重建：

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "阶段"),
      text(fill: titlecolor, weight: "bold", "使用方法"),
    ),
    [初始重建], [双视图方法：基础矩阵 $arrow.r$ 本质矩阵 $arrow.r$ 分解 $arrow.r$ 三角化],
    [添加新视图], [PnP 方法：用已重建的 3D 点估计新相机位姿],
    [扩展结构], [三角化：用新相机与已有相机的对应点重建新的 3D 点],
    [全局优化], [Bundle Adjustment：联合优化所有相机和 3D 点],
  ),
  caption: [增量式 SfM 的不同阶段]
)

== 基于增量法的欧式结构恢复系统

#example(title: [必考简答\*])[
  #key[\*原题] 写出基于增量法的欧式运动恢复结构的过程。

  *解答*

  === 预处理阶段

  *输入*：图像集

  *输出*：几何验证后的特征点匹配结果

  #methodblock[
    *步骤 1：计算潜在匹配对*

    1. 提取特征点并计算描述符（如 SIFT、ORB）
    2. 利用近邻方法进行特征点匹配（如最近邻距离比）

    *步骤 2：几何一致性过滤*

    利用 RANSAC 估计：
    - 基础矩阵 $F$（一般运动）
    - 单应矩阵 $H$（平面场景或纯旋转）

    过滤不满足几何约束的误匹配。
  ]

  === 增量重建阶段

  *输入*：相机内参、特征点、几何验证后的匹配结果

  *输出*：三维点云、相机位姿

  #methodblock[
    *步骤 1：计算对应点轨迹（Tracks）*

    将多张图像中的匹配点连接成轨迹 $t$（同一 3D 点在不同视图中的观测序列）。

    *步骤 2：构建连通图 $G$*

    - 节点：图像
    - 边：两图像之间有足够多的匹配点

    边的权重可以是匹配点数量。

    *步骤 3：选择初始图像对*

    从 $G$ 中选择一条边 $e$（通常选择匹配点多、基线适中的图像对）。

    *步骤 4：双视图初始化*

    - 鲁棒估计边 $e$ 对应的本质矩阵 $E$（用 RANSAC + 八点法）
    - 分解 $E$ 得到两相机的位姿 $(R, T)$

    *步骤 5：初始三角化*

    三角化 $t inter e$ 的点（即在这两张图像中都可见的轨迹），得到初始 3D 点云。

    *步骤 6：删除已处理的边*

    从 $G$ 中删除边 $e$。

    *步骤 7：迭代添加新视图*

    当 $G$ 中还有边时，重复以下步骤：

    1. 从 $G$ 中选择边 $e$，使得 $"track"_e inter {"已重建3D点"}$ 最大化

       （优先选择能看到最多已重建 3D 点的新视图）

    2. 用 #key[PnP 方法]估计该视图的相机位姿（外参）

       （利用已重建的 3D 点和该视图中的 2D 观测）

    3. #key[三角化新的轨迹]

       （用新相机与已有相机的对应点重建新的 3D 点）

    4. 从 $G$ 中删除边 $e$

    5. 执行 #key[Bundle Adjustment]

       （全局优化所有相机位姿和 3D 点坐标）

    *步骤 8：结束*

    当所有边都被处理完，输出最终的相机位姿和 3D 点云。
  ]
]

#warnbox[
  
  #key[必考要点]：
  - 预处理：特征提取 + 匹配 + 几何验证（RANSAC + F/H）
  - 初始化：双视图方法（$F arrow.r E arrow.r R,T arrow.r$ 三角化）
  - 增量扩展：选择新视图 $arrow.r$ PnP 估计位姿 $arrow.r$ 三角化新点 $arrow.r$ BA 优化
  - 选择新视图的策略：最大化与已重建点的重合度
]