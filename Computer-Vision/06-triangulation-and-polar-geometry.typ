#import "../template/preamble.typ": *

= 三角化与极几何

#key[\*考试重点：三角化概念、极点极线极面（画图）、本质矩阵/基础矩阵/单应矩阵（公式+翻译）]

/ 三角化: #key[\*必考概念] 拍一张照片只有二维坐标。但如果有两台相机从不同角度拍同一点，两条射线会在三维空间中相交——这个交点就是三维坐标。这就是 #key[三角化]。

== 对极几何核心概念\*

#figure(
  image("assets/06-epipolar-geometry.png", width: 50%),
  caption: [极几何示意图\* (此处考察概念和画图，必考)],
)

#warnbox[
  #key[\*必考画图题]：可能要求画出极几何示意图，并标注：
  - 两相机光心 $O_1, O_2$
  - 空间点 $P$ 及其在两图像上的投影 $p, p'$
  - 极点 $e, e'$（一相机光心在另一图像上的投影）
  - 极线 $l, l'$（极平面与图像平面的交线）
  - 极平面（三点 $P, O_1, O_2$ 确定的平面）
]

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "概念"),
    text(fill: titlecolor, weight: "bold", "直觉理解"),
  ),
  [极点 $e, e'$], [左相机光心在右图上的投影（反之亦然）；当相机光轴平行时，极点在无穷远处],
  [极平面 $P O_1 O_2$], [两相机光心 + 空间点 $X$ 三点确定的平面],
  [极线 $p e, p' e'$], [极平面与图像平面的交线],
  [基础矩阵 $F$], [把左图点 $x$ 映射到右图极线 $l'$ 的 3×3 矩阵；秩为2],
  [本质矩阵 $E$], [$F$ 的归一化版本（假设已知内参）；编码旋转 $R$ 和平移 $t$],
)

#key[\*必考术语翻译]：
/ 本质矩阵 (Essential Matrix): #key[\*必考翻译] 对规范化摄像机拍摄的两个视点图像间的极几何关系进行代数描述，它编码了两个摄像机间的旋转和平移关系。 $ E = [bold(t)]_times R $
/ 基础矩阵 (Fundamental Matrix): #key[\*必考翻译] 对一般摄像机拍摄的两个视点图像间的极几何关系进行代数描述。 $ F = K'^(-T) E K^(-1) $
/ 单应矩阵 (Homography Matrix): #key[\*必考翻译] 描述空间平面在两个摄像机下的投影变换关系，适用于平面场景。

#example(title: [辨析 $E "&" F$ 矩阵])[
  #key[\*考试必考] 区分 Essential Matrix 和 Fundamental Matrix 的区别。

  *解答*

  #table(
    columns: (auto, 1fr, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else { white },
    table.header(
      text(fill: titlecolor, weight: "bold", "对比项"),
      text(fill: titlecolor, weight: "bold", "本质矩阵 $E$"),
      text(fill: titlecolor, weight: "bold", "基础矩阵 $F$"),
    ),
    [适用场景], [已知相机内参（归一化坐标）], [未知相机内参（像素坐标）],
    [编码信息], [旋转 $R$ 和平移 $bold(t)$], [完整投影关系（包含内参）],
    [关系式], [$E = [bold(t)]_times R$], [$F = K'^(-T) E K^(-1)$],
    [自由度], [5（旋转3+平移方向2）], [7（9元素-尺度-秩2约束）],
    [奇异值], [$sigma_1 = sigma_2 > 0, sigma_3 = 0$], [两个非零奇异值（不一定相等）],
    [对极约束], [$tilde(bold(x))'^T E tilde(bold(x)) = 0$], [$bold(x)'^T F bold(x) = 0$],
  )

  其中 $tilde(bold(x))$ 表示归一化坐标（已除去内参影响），$bold(x)$ 表示像素坐标。
]

=== 对极约束

/ 极线约束: #key[左图点 $bold(x)$ 对应右图极线 $bold(l)'$，对应点 $bold(x)'$ 必在 $bold(l)'$ 上]

对于两图像中的对应点 $bold(x)$ 和 $bold(x)'$（齐次坐标），它们满足对极约束方程：

#formula[
  $bold(x)'^T F bold(x) = 0$
]

极线计算（给定左图点，求右图极线）：

#formula[
  $bold(l)' = F bold(x)$（右图中的极线）$quad$ 对应点 $bold(x)'$ 满足 $bold(l)'^T bold(x)' = 0$
]

=== 基础矩阵性质

- 3×3 矩阵，#key[秩为2]（$det(F) = 0$）
- 自由度：7（9个元素，-1尺度，-1秩2约束）
- 极点在零空间：$F bold(e) = 0$，$F^T bold(e)' = 0$

=== 本质矩阵与基础矩阵的关系

#formula[
  $F = K'^(-T) E K^(-1)$
]

本质矩阵 $E$ 可以分解出相机间的旋转 $R$ 和平移 $bold(t)$（差一个尺度）：

$E = bold([t]_times) R$，其中 $bold([t]_times)$ 是 $bold(t)$ 的反对称矩阵。

本质矩阵奇异值特征：#key[两个非零奇异值相等]，第三个为零（$sigma_1 = sigma_2, sigma_3 = 0$）。

#warnbox[
  基础矩阵 $F$ 是 #key[秩2矩阵]（$det(F)=0$），自由度7；本质矩阵 $E$ 的两个非零奇异值 #key[相等]。这两点是常考区分点。
]

=== 八点法估计 $F$

#methodblock[
  + *坐标归一化*（Hartley归一化）：将点平移到质心，缩放使均值距离为 $sqrt(2)$
  + 对每对对应点展开 $bold(x)'^T F bold(x) = 0$，构建一行：
    $[x' x, x' y, x', y' x, y' y, y', x, y, 1] bold(f) = 0$
  + 8对以上点叠加得 $A bold(f) = 0$，SVD求最小奇异值对应右奇异向量
  + 强制秩2约束：对结果 $F$ 做 SVD，将最小奇异值置零重构
  + 反归一化：$F = T'^T hat(F) T$
]

#warnbox[
  - $F$（基础矩阵）是秩2矩阵，自由度7，不需要知道内参
  - $E$（本质矩阵）需要已知内参，两个非零奇异值相等
  - 对极约束：$bold(x)'^T F bold(x) = 0$（等号，不是约等于！）
  - 8点算法必须做 Hartley 归一化，否则数值严重不稳定
]

== 极几何特例：平行视图

#key[\*考试重点：平行视图三角测量]

平行视图（Parallel View）是对极几何的一种特殊配置，在立体视觉中具有重要应用：

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "特征"),
      text(fill: titlecolor, weight: "bold", "说明"),
    ),
    [两图像平面平行], [左右相机的图像平面共面],
    [基线平行于图像平面], [两相机光心连线 $O_1 O_2$ 平行于图像平面],
    [极点位置], [#key[极点 $bold(e)$ 和 $bold(e)'$ 位于无穷远处]],
    [极线方向], [#key[极线平行于图像坐标系的 $u$ 轴（水平方向）]],
    [对应点搜索], [同一点在两幅图像中处于 #key[相同行]，只需沿行进行一维搜索],
  ),
  caption: [平行视图的几何特征\*（可能考简答）]
)

#warnbox[
  #key[\*考试要点]：
  - 平行视图的定义：两图像平面平行，基线平行于图像平面
  - 极点在无穷远处，极线水平
  - 对应点在同一行（$v = v'$），简化匹配过程
  - 通过立体校正可将普通图像对转换为平行视图
]

=== 立体校正

*立体校正（Stereo Rectification）* 的目的是将双目相机拍摄的非共面、非行对准的两幅图像，校正为共面行对准的平行视图。

#key[为什么要立体校正？] 平行视图使得对应点搜索从二维变为一维：只需在同一行内搜索匹配点，大大降低计算复杂度和匹配错误率。

校正前后对比：
- *校正前*：对应点 $bold(p)$ 和 $bold(p)'$ 可能位于不同行，极线方向任意
- *校正后*：对应点位于同一行（$v = v'$），极线水平，沿 $u$ 轴搜索即可

== 单应矩阵 (了解概念即可)

/ 单应矩阵 (Homography Matrix): 描述空间中 #key[平面] 在两个摄像机视角下的投影变换关系。

=== 单应矩阵公式

已知条件：
- 第一个相机内参 $K$，第二个相机内参 $K'$
- 第二个相机相对于第一个相机的位置 $(R, bold(t))$
- 平面 $pi$ 在第一个相机坐标系下的单位法向量 $bold(n)$，原点到平面距离 $d$

则平面 $pi$ 的单应矩阵为：

#formula[
  $H = K' (R + bold(t) bold(n)_d^T) K^(-1)$
]

其中 $bold(n)_d = bold(n) \/ d$，满足 $bold(p)' = H bold(p)$（$bold(p)$ 和 $bold(p)'$ 是平面上点在两相机中的像素坐标）。

=== 单应矩阵估计

*已知*：$m$ 对点对应 $bold(p)_i arrow.l.r bold(p)'_i$ 满足 $bold(p)' = H bold(p)$

*求解*：单应矩阵 $H$（3×3）

#methodblock[
  + 展开齐次坐标关系 $bold(p)' = H bold(p)$：
    $
    u' / w' &= (h_1 u + h_2 v + h_3) / (h_7 u + h_8 v + h_9) \
    v' / w' &= (h_4 u + h_5 v + h_6) / (h_7 u + h_8 v + h_9)
    $
  + 不失一般性令 $w' = 1$，交叉相乘得到两个线性方程：
    $
    u'(h_7 u + h_8 v + h_9) &= h_1 u + h_2 v + h_3 \
    v'(h_7 u + h_8 v + h_9) &= h_4 u + h_5 v + h_6
    $
  + 每对点贡献两行，构建线性系统 $A bold(h) = 0$（$bold(h)$ 是 $H$ 的9个元素）
  + SVD求解最小奇异值对应的右奇异向量
]

*自由度分析*：单应矩阵有8个自由度（9个元素 -1 尺度），#key[至少需要4对点对应]。实际应用中使用远多于4对点以提高鲁棒性。