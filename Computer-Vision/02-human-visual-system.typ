#import "../template/preamble.typ": *

= 人眼视觉感知系统

== 视觉

- 可见光范围：#key[380nm - 740nm]
- 亮度范围：#key[$10^(-6) ~ 10^8"cd/m"^2$]

#key[\*考试重点]：
- #key[正常视力标准]：能在标准距离（5米）识别视力表上的 1.0 行（对应视角 1 分角）
- #key[1 分角（1'）]：人眼能分辨的最小视角单位，约 1/60 度
- #key[视觉空间分辨能力标准]：瑞利判据（Rayleigh Criterion）- 两点成像的艾里斑中心距离等于艾里斑半径时，刚好能分辨
- #key[视网膜屏幕]：像素密度达到人眼分辨极限（约 300 PPI 以上），使人眼无法分辨单个像素
- #key[视觉残留（Persistence of Vision）]：视觉刺激消失后，视觉印象仍保留约 0.1–0.4 秒。这是电影和动画的基础原理（24 fps 即可产生连续运动感）

#warnbox[
  #key[\*瑞利判据]：光学系统分辨两点的判据，当两点的艾里斑中心距离等于艾里斑半径时，刚好能分辨。
]

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

/ 视觉适应过程\*:
- #key[暗适应（Dark Adaptation）]：从亮处进入暗处，视杆细胞逐渐恢复视紫红质，约 #key[20–30分钟]完全适应。
- #key[明适应（Light Adaptation）]：从暗处进入亮处，视锥细胞快速接管，约 #key[1分钟] 完成。

#warnbox[
  #key[\*视错觉原因]：视觉系统对信息的解释受到上下文、经验、注意力等因素影响，导致感知与客观现实不一致。经典例子：
  - #key[看不见的大猩猩]：选择性注意（Selective Attention）- 专注某任务时会忽略明显的非预期刺激
  - 缪勒-莱尔错觉：两条等长线段因箭头方向不同而看起来长度不同
  - 赫尔曼方格：白色交叉处出现灰色幻影点
]

=== 双眼视差
#key[双眼视差（Binocular Disparity）]：两眼间距约65mm，看近处物体时两眼视角不同，大脑利用这个差异感知深度。这是立体视觉（第7章）的生物学基础。

=== 关键参数速记\*

#key[\*考试重点：人眼参数]

- #key[眨眼时间]：约 0.2–0.4 秒（200–400 毫秒）
- #key[暗适应]：约 20–30 分钟完全完成（视杆细胞视紫红质再生）
- #key[明适应]：约 1 分钟
- 人眼水平视野：约 200°（双眼）；清晰视野约 60°
- 眼轴长：约 24 mm
- #key[白昼瞳孔直径]：约 2–4 mm
- #key[晚间瞳孔直径]：约 4–8 mm（最大可达 8 mm）
- 双眼视差（Binocular Disparity）：两眼因位置差异产生的视角差，是立体视觉主要深度线索

#warnbox[
  #key[\*考试要点]：
  - 眨眼时间：约 0.2–0.4 秒
  - 暗适应：20–30 分钟；明适应：1 分钟
  - 白昼瞳孔：2–4 mm；晚间瞳孔：4–8 mm
]

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
/ 光通量$phi.alt_(e v)$: 可见光对人眼的视觉刺激程度的量，单位为流明（lm）#key[\*重要]

#key[\*考试重点]：
- #key[光通量与辐通量的关系]：光通量是辐通量经过人眼视觉响应函数加权后的结果
- #key[照度单位与定义]：照度（Illuminance）$E$，单位勒克斯（lx），定义为单位面积接收到的光通量 $ E = (d Phi) / (d A) $

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

=== CIE 1931 颜色系统

CIE（国际照明委员会）通过#key[颜色匹配实验]定义了标准观察者的三刺激值：

#key[\*考试重点]：
- #key[颜色匹配实验]：实验中观察者调节三种原色光（红、绿、蓝）的比例，使其混合光与给定的单色光在视觉上完全一致。实验结果建立了 CIE RGB 颜色匹配函数 $macron(r)(lambda), macron(g)(lambda), macron(b)(lambda)$
- #key[光源对视觉成像的影响因素]：光源的光谱分布、色温、显色指数（CRI）会影响物体的颜色感知

#formula[
  $ R = integral_lambda k phi(lambda) macron(r)(lambda) d lambda, quad
    G = integral_lambda k phi(lambda) macron(g)(lambda) d lambda, quad
    B = integral_lambda k phi(lambda) macron(b)(lambda) d lambda $
]

其中 $macron(r), macron(g), macron(b)$ 是颜色匹配函数（CIE标准曲线），$phi(lambda)$ 是光谱分布。

*色品坐标*（去掉亮度，只保留颜色信息）：

#formula[
  $ x = X/(X+Y+Z), quad y = Y/(X+Y+Z), quad z = Z/(X+Y+Z) $
  约束：$x + y + z = 1$（只需 $x, y$ 即可确定颜色）
]

#intuition[
  色品坐标就像归一化：把绝对亮度去掉，只留颜色本身的信息。就像不管灯有多亮，只关心灯是什么颜色。
]

/ CIE 1931 xy系统色品图: 在光谱轨迹外面的所有颜色都是物理上不能实现的。光谱轨迹曲线以及连接光谱两端点的直线所构成的马蹄形内包括了一切物理上能实现的颜色。

#figure(
  image("assets/02-system-color.png", width: 70%),
  caption: "CIE 1931 xy色品图"
)

/ 颜色宽容度: 在色度图上，把人眼感觉不出颜色变化的范围

#intuition[在CIE-1931xy色度图的不同位置上，颜色的宽容量不一样，如*蓝色部分宽容量最小，绿色部分最大*。
]


=== 常用颜色空间对比

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "颜色空间"),
    text(fill: titlecolor, weight: "bold", "特点"),
    text(fill: titlecolor, weight: "bold", "典型用途"),
  ),
  [RGB], [设备相关，三通道线性叠加，最直观], [相机输出、显示器],
  [XYZ], [设备无关，颜色匹配实验定义的标准空间], [颜色转换中间枢纽],
  [xy色品图], [二维，仅表达颜色（去除亮度）], [色域可视化、白点定义],
  [Lab], [感知均匀（等距=等感知差异），L亮度/a绿-红/b蓝-黄], [颜色差计算（$Delta E$）],
  [HSV], [H色调/S饱和度/V明度，更贴近人描述颜色的方式], [图像分割、颜色选取],
)

#key[同色异谱（Metamerism）]：光谱不同，但在某观察者眼中颜色完全相同。这就是为什么不同品牌的白纸在某些光源下颜色"不一样"。

#key[颜色恒常性（Color Constancy）]：不同光照下，大脑倾向于认为物体颜色不变（你知道香蕉是黄的，无论在什么灯下）。

