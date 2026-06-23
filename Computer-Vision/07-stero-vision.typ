#import "../template/preamble.typ": *

= 双目立体视觉

#intuition[
  人类用两只眼睛感知深度——两眼看同一物体的角度略有不同（视差）。双目相机系统复刻这一原理：两台相机水平排列，通过测量同一场景点在两幅图像中的*横向位移（视差 disparity）*来恢复深度。

  视差越大 → 物体越近；视差越小 → 物体越远。
]

== 平行视图的三角测量

=== 视差与深度的关系

#figure(
  image("assets/07-disparity-parrallal-view.png", height: 30%),
  caption: [平行视图下的视差示意图]
)

#warnbox[\* 这张图要学会绘图与图上要素的标注。]

*标准双目模型（平行基线）：*
两台相机光轴平行，焦距相同 $f$，基线长度 $b$（两相机光心间距）。场景点 $P$ 在左图对应点 $P_u$，右图对应点 $P_u '$。

#formula[
  $ "Disparity: " d = l_l - l_r $
  $ Z = (f dot b)/d $
]

- $f$：焦距（像素单位）
- $b$：基线长度（物理单位，如 mm）
- $d$：视差（像素）
- $Z$：场景点深度（与 $b$ 同单位）

#warnbox[
  视差与深度 #key[成反比]：视差越大，深度越小（物体越近）；视差越小，深度越大（物体越远）。这是双目测距的核心原理。
]

/ 视差图 (Disparity Map): 记录图像中每个像素点视差值的图像，可以直接反映场景的深度信息。

=== 平行视图的优势

左摄像机像面上的任意一点 $bold(p)$，只要能在右摄像机像面上找到对应的匹配点 $bold(p)'$，就可以通过视差公式确定该点的三维坐标。

在平行视图下：
- 极点位于无穷远处：$bold(e) = (1, 0, 0)^T$，$bold(e)' = (1, 0, 0)^T$
- 极线平行于 $u$ 轴（水平方向）
- 对应点 $bold(p)$ 和 $bold(p)'$ 的 $v$ 坐标相同：$p_v = p'_v$

这意味着 #key[对应点搜索从二维降为一维]：只需沿着同一行（扫描线）进行水平搜索。

== 图像校正/立体校正

*目标*：将两幅非平行的图像变换为平行视图，使得极线水平且行对准。

=== 校正步骤（五步法）

#methodblock[
  + 在两幅图像 $I$ 和 $I'$ 中找到一组匹配点 $bold(p)_i arrow.l.r bold(p)'_i$（不少于8个）

  + 计算基础矩阵 $F$，求解两幅图像中的极点 $bold(e)$ 和 $bold(e)'$：
    - 求解 $bold(e)$：$F^T bold(p)'_i = bold(l)_i$，所有极线 $bold(l)_i$ 过 $bold(e)$
      $
      mat(bold(l)_1^T; dots.v; bold(l)_n^T) bold(e) = bold(0)
      $
    - 求解 $bold(e)'$：$F bold(p)_i = bold(l)'_i$，所有极线 $bold(l)'_i$ 过 $bold(e)'$
      $
      mat(bold(l)'_1^T; dots.v; bold(l)'_n^T) bold(e)' = bold(0)
      $

  + 选择透视变换 $H'$ 将 $bold(e)'$ 映射到无穷远点 $(f, 0, 0)$：
    $
    H' = T^(-1) G R T
    $
    其中：
    - $T$：平移到图像中心
    - $R$：旋转使 $bold(e)'$ 对齐到 $(f, 0, 1)$
    - $G$：投影到无穷远 $(f, 0, 0)$

  + 寻找对应的透视变换矩阵 $H$，使得左右图像校正后的极线尽可能水平对齐

  + 分别用矩阵 $H$ 和 $H'$ 对左右两幅图像 $I$ 和 $I'$ 进行重采样
]

#warnbox[
  立体校正是实现高效立体匹配的前提。校正后，对应点搜索从整个图像的二维空间缩减为单行的一维空间，计算复杂度大幅降低。
]

== 对应点问题（相关匹配）

/ 对应点问题: 给定左图中的点 $bold(p)$，在右图中找到对应点 $bold(p)'$，也称为 #key[双目融合问题]。

图像校正后，对应点必定在同一行（$p_v = p'_v$），因此只需沿着扫描线（同一行）搜索即可。

=== 相关匹配法\*

#key[基本思想]：以左图点 $bold(p)$ 为中心取窗口 $W$，在右图同一行滑动窗口 $W'$，计算窗口相似度，相似度最大处即为匹配点。

#methodblock[
  *四步匹配流程*：

  + 在左图 $bold(p) = (p_u, p_v)$ 处选择一个窗口 $W$（如 $3 times 3$），展开成向量 $bold(w)$

    例：$bold(w) = [100, 100, 100, 100, 100, 20, 160, 180, 200]^T$

  + 在右图中沿扫描线（同一行 $p_v$）在每个位置 $s'_u$ 建立窗口 $W'$，获得向量 $bold(w)'$

  + 计算每个位置 $s'_u$ 的相似度度量

  + 选择相似度最大的位置作为匹配点：
    $
    p'_u = op("argmax", limits: #true)_(s'_u) "similarity"(bold(w), bold(w)')
    $
]

=== 相似度度量

*方法一：内积法*

$
"similarity" = bold(w)^T bold(w)'
$

取内积最大的位置。

*方法二：归一化相关匹配（推荐）*

考虑窗口的灰度均值，对光照变化更鲁棒：

#formula[
  $
  "NCC"(bold(w), bold(w)') = ((bold(w) - overline(w))^T (bold(w)' - overline(w)')) / (||bold(w) - overline(w)|| dot ||bold(w)' - overline(w)'||)
  $
]

其中 $overline(w)$ 是窗口 $W$ 内的灰度均值，$overline(w)'$ 是窗口 $W'$ 内的灰度均值。

归一化相关匹配：

#methodblock[
  + 在左图 $bold(p) = (p_u, p_v)$ 处选择窗口 $W$，建立向量 $bold(w)$

  + 在右图中沿扫描线在每个位置 $s'_u$ 建立窗口 $W'$，获得向量 $bold(w)'$

  + 计算每个位置 $s'_u$ 的归一化相关系数：
    $
    "NCC"(s'_u) = ((bold(w) - overline(w))^T (bold(w)' - overline(w)')) / (||bold(w) - overline(w)|| dot ||bold(w)' - overline(w)'||)
    $

  + 选择归一化相关系数最大的位置：
    $
    p'_u = op("argmax", limits: #true)_(s'_u) "NCC"(s'_u)
    $
]

#warnbox[
  归一化相关匹配相比简单内积法更鲁棒，能够抵抗线性光照变化（亮度和对比度变化）。这是因为减去均值消除了亮度偏移，归一化消除了对比度缩放。
]

=== 窗口大小的影响

#figure(
  table(
    columns: (auto, 1fr, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else { white },
    table.header(
      text(fill: titlecolor, weight: "bold", "窗口大小"),
      text(fill: titlecolor, weight: "bold", "优点"),
      text(fill: titlecolor, weight: "bold", "缺点"),
    ),
    [较小窗口（如 $3 times 3$）], [细节丰富，能保留边缘和精细结构], [噪声较多，容易误匹配],
    [较大窗口（如 $20 times 20$）], [视差图更平滑，噪声更少], [细节丢失，边界模糊],
  ),
  caption: [匹配窗口大小的权衡]
)

实际应用中需要根据场景特点选择合适的窗口大小，或采用自适应窗口策略。

== 对应点问题的挑战

#key[\*考试重点：相关法存在的问题]

相关匹配虽然简单直观，但在实际场景中仍然是一个困难问题，主要挑战包括：

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "问题"),
      text(fill: titlecolor, weight: "bold", "描述"),
    ),
    [遮挡], [一个视图中可见的点在另一个视图中被遮挡，无法找到匹配点],
    [透视缩短], [不同视角下物体形状发生透视变形，窗口外观差异大],
    [基线选择], [基线过短视差小、精度低；基线过长遮挡增多、匹配困难],
    [同质区域], [纹理平坦区域（如白墙）缺乏显著特征，难以唯一确定匹配],
    [重复性模式], [周期性纹理（如栅栏、砖墙）导致多个候选匹配位置],
    [光照变化], [两相机光照条件不同导致窗口灰度值差异],
    [噪声干扰], [图像噪声影响相似度计算的准确性],
  ),
  caption: [立体匹配的主要挑战\*（可能考简答：相关法存在的问题）]
)

#warnbox[
  #key[\*考试要点：相关法存在的问题（简答题）]

  相关匹配法的主要问题：
  1. #key[遮挡问题]：一个视图可见，另一视图被遮挡
  2. #key[同质区域]：纹理平坦，缺乏特征，匹配不唯一
  3. #key[重复模式]：周期性纹理导致多个候选匹配
  4. #key[透视变形]：不同视角下窗口外观差异大
  5. #key[光照变化]：两视图光照不一致
  6. #key[窗口大小]：窗口过小噪声多，过大细节丢失
]

#key[解决思路]：引入更多的约束条件来提高匹配的准确性和鲁棒性。

== 其他匹配约束

为了提高匹配准确性，除了相关匹配，还可以引入以下约束：

#figure(
  table(
    columns: (auto, 1fr),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
    table.header(
      text(fill: titlecolor, weight: "bold", "约束"),
      text(fill: titlecolor, weight: "bold", "含义"),
    ),
    [唯一性], [一张图像中的任何点，在另一张图像中最多只有一个匹配点],
    [顺序性/单调性], [左右视图中的对应点次序一致],
    [平滑性], [视差函数通常是平滑的（除了遮挡边界和深度不连续处）],
  ),
  caption: [立体匹配的常用约束]
)
