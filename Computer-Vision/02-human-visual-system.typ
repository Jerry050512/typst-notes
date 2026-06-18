#import "../template/preamble.typ": *

= 人眼视觉感知系统

== 视觉

- 可见光范围：#key[380nm - 740nm]
- 亮度范围：#key[$10^(-6) ~ 10^8"cd/m"^2$]

=== 感光细胞：视锥 vs 视杆

#table(
  columns: (auto, auto, auto),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "特性"),
    text(fill: titlecolor, weight: "bold", "视锥细胞（Cone）"),
    text(fill: titlecolor, weight: "bold", "视杆细胞（Rod）"),
  ),
  [数量], [约 600 万], [约 1.2 亿（是视锥的20倍！）],
  [分布], [集中在中央凹], [分布在视网膜周边],
  [工作环境], [明亮（明视觉 photopic）], [昏暗（暗视觉 scotopic）],
  [颜色感知], [有（L/M/S 三型，分别感红/绿/蓝）], [无（只有灰度感知）],
  [敏感度], [低（需要较多光）], [极高（单光子即可激活）],
)

=== 视觉适应过程\*
- #key[暗适应（Dark Adaptation）]：从亮处进入暗处，视杆细胞逐渐恢复视紫红质，约 #key[20–30分钟]完全适应。
- #key[明适应（Light Adaptation）]：从暗处进入亮处，视锥细胞快速接管，约 #key[1分钟] 完成。

=== 双眼视差
#key[双眼视差（Binocular Disparity）]：两眼间距约65mm，看近处物体时两眼视角不同，大脑利用这个差异感知深度。这是立体视觉（第7章）的生物学基础。

=== 关键参数速记

- 暗适应：约 20–30 分钟完全完成（视杆细胞视紫红质再生）
- 明适应：约 1 分钟
- 人眼水平视野：约 200°（双眼）；清晰视野约 60°
- 眼轴长：约 24 mm
- 双眼视差（Binocular Disparity）：两眼因位置差异产生的视角差，是立体视觉主要深度线索

#warnbox[
  视锥/视杆细胞的分布位置和功能常混淆：#key[视锥集中在中央凹（明视/彩色），视杆分布在周边（暗视）]。
]

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  table.header(
    [结构],
    [参数/特性],
    [作用],
    [相机类比],
  ),
  [角膜 Cornea], [横向直径约11.5mm，厚度约1mm；平均折射率1.375，屈光度45D], [提供约3/4折射能力，透明无血管], [镜头前组（固定）],
  [房水], [前房中央深度1.64~2.21mm；折射率1.334], [维持眼内压，营养角膜与晶状体], [-],
  [瞳孔 Pupil], [平均直径2.5~4mm，变化范围1.5~8mm], [光强决定大小], [光圈开口],
  [晶状体 Lens], [组合折射率1.420；直径9~10mm，厚度4~5mm；前表面曲率10mm，后表面曲率6mm（调节时变化最大）], [可调节焦距（睫状肌控制曲率）], [镜头后组（可变焦）],
  [玻璃体], [折射率1.335], [支撑眼球形状，维持透明光路], [-],
  [虹膜 Iris], [-], [控制瞳孔大小，调节进光量], [光圈叶片],
  [视网膜 Retina], [-], [感光细胞所在层，成像关键部位], [CMOS/CCD 传感器],
  [中央凹 Fovea], [直径约1.5mm], [视觉最敏锐区], [传感器中心高分辨区],
  [盲点], [-], [视神经汇聚处，无感光细胞], [传感器边缘死点],
)

== 光度学与色度学

人眼对不同波长的电磁辐射具有不同的响应灵敏度。#key[对555nm最敏感]。

/ 光谱光效率函数$V(lambda)$: 人眼观看同样功率的辐射，对不同波长的辐射感觉的明亮程度不同。常用光谱光视效率曲线来表示。
/ 辐通量$phi.alt_e$: 单位时间内通过某截面的所有波长的总电磁辐射能量。(瓦：W) 辐射体发出各种波长成分，不同波长具有不同的辐射能量。
/ 光通量$phi.alt_(e v)$: 可见光对人眼的视觉刺激程度的量，单位为流明（lm）

=== 光度学基础量

#table(
  columns: (auto, auto, auto, auto),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "量"),
    text(fill: titlecolor, weight: "bold", "符号"),
    text(fill: titlecolor, weight: "bold", "定义"),
    text(fill: titlecolor, weight: "bold", "单位"),
  ),
  [光通量], [$Phi_v$], [光源辐射的总可见光量], [lm（流明）],
  [发光强度], [$I$], [单位立体角内的光通量], [cd（坎德拉）],
  [照度], [$E$], [单位面积接收到的光通量], [lx（勒克斯）],
  [亮度], [$L$], [单位投影面积+单位立体角发光强度], [cd/m²（尼特）],
)

=== 颜色感知三色理论

人眼只有三种视锥细胞（L/M/S），三色理论（Trichromacy）：
#key[任何颜色都可以用三种原色的线性组合来匹配感知]（不一定能匹配物理光谱，但视觉上等效）。

=== 光通量与辐通量的关系式

明视觉 $ Phi_v = K_m integral_380^760 Phi_e (lambda) V(lambda) d lambda $
暗视觉 $ Phi'_v = K'_m integral_380^760 Phi_e (lambda) V'(lambda) d lambda $

$K_m = 683 "lm/W"$, 表示示在人眼视觉系统最敏感的波长(555nm)上，每瓦光功率相应的流明数；\
$K'_m = 1725 "lm/W"$；表示在暗视觉(507nm)上，每瓦光功率相应的流明数。

#example(title: "光通量与辐通量的关系式")[
  辐射通量为164W的660nm红光与1W的555nm绿光发生相同亮暗感触。求660nm红光的光谱光效率函数值。

  *解答*
  $ V(lambda) = phi_555 / phi_lambda = 1 / 164 $
]

/ 平面角: 单位弧度，1弧度表示为半径为1米的圆上，1米长的圆弧对圆心所张的角。
$ alpha = l / r $
/ 立体角: 单位球面度(sr)，1球面度表示半径为1米的球面上，1平方米的球面对球心所张的立体角
$ Omega = S / r^2 $
/ 发光强度: 描述点光源发光能力大小的物理量, 为了描述点光源在某一指定方向上发出光通量能力的大小。在指定方向上的一个很小的立体角元内所包含的光通量值，除以这个立体角元，所得的商为光源在此方向上的发光强度。
$ I = (d Phi) / (d Omega) $
/ 亮度及朗伯定律: 亮度：表示每单位面积上的发光强度。
$ L = (d I) / (d A cos theta) = (d^2 Phi) / (d Omega d A cos theta) $
/ 朗伯定律: 一个亮度在各个方向上都相等的发光面，在某一方向上的发光强度等于这个面垂直方向上的发光强度乘以方向角的余弦
$ I_theta = I_0 dot cos theta $
/ 照度: 单位面积上的光通量。单位 (lx)
$ E = (d Phi) / (d A) $