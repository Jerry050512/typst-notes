#import "../template/preamble.typ": *

= 期末复习备考指南

#knowtitle[本章专门为期末考试设计，汇总所有高频考点、公式和易混概念，帮助零基础同学快速通过期末考试。]

== 考试题型与分值分布

#table(
  columns: (auto, 1fr, auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 8pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "题型"),
    text(fill: titlecolor, weight: "bold", "内容"),
    text(fill: titlecolor, weight: "bold", "分值"),
    text(fill: titlecolor, weight: "bold", "备考策略"),
  ),
  [填空题], [8个术语翻译（中英互译）], [30分], [背诵术语表，重点记三大会议、RANSAC全称、SfM全称、本质/基础/单应矩阵],
  [简答题], [定性问题、伪代码], [40分], [掌握增量法SfM、相机标定方法、相关法问题、极坐标累加器算法],
  [画图题], [光路图], [5分], [练习给物画像（光学系统五条光线）、极几何示意图、Bayer阵列],
  [计算题], [数值计算], [5分], [熟练掌握焦距选择、瑞利判据、运动清晰成像条件],
  [综合题], [综合应用], [20分], [结合多个知识点的应用题，需灵活运用],
)

#warnbox[
  *重点提示*：
  - 填空题（30分）+ 简答题（40分）= 70分，是得分的关键
  - 术语翻译必须准确记忆，不能有拼写错误
  - 简答题要写完整的算法步骤，不能只写大概思路
]

== 高频考点速查

=== 必考术语翻译（填空题30分）

#table(
  columns: (1fr, 1fr, auto),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "中文"),
    text(fill: titlecolor, weight: "bold", "英文"),
    text(fill: titlecolor, weight: "bold", "考频"),
  ),
  [计算机视觉与模式识别会议], [CVPR], [★★★],
  [国际计算机视觉会议], [ICCV], [★★★],
  [欧洲计算机视觉会议], [ECCV], [★★★],
  [摄影测量], [Photogrammetry], [★★],
  [随机采样一致性], [RANSAC - Random Sample Consensus], [★★★★★],
  [霍夫变换], [Hough Transform], [★★★★],
  [运动恢复结构], [SfM - Structure from Motion], [★★★★★],
  [本质矩阵], [Essential Matrix], [★★★★],
  [基础矩阵], [Fundamental Matrix], [★★★★],
  [单应矩阵], [Homography Matrix], [★★★★],
  [视错觉], [Visual Illusion], [★★],
)

#key[记忆技巧]：
- CVPR, ICCV, ECCV 三大会议：C开头是计算机视觉，V结尾是Vision
- RANSAC：Random（随机）+ Sample（采样）+ Consensus（一致性）
- SfM：Structure（结构）+ from（从）+ Motion（运动）
- 三个矩阵：Essential（本质）、Fundamental（基础）、Homography（单应）

=== 必考简答题

*增量法求SfM\**

#warnbox[*重要程度*：★★★★★ 必考]

*题目*：写出基于增量法的欧式运动恢复结构的过程。

*答题要点*：

#methodblock[
  *一、预处理阶段*

  1. 提取特征点并计算描述符（如SIFT、ORB）
  2. 利用近邻方法进行特征点匹配
  3. 利用RANSAC估计基础矩阵F或单应矩阵H，过滤误匹配

  *二、增量重建阶段*

  1. 计算对应点轨迹（Tracks）- 将多张图像中的匹配点连接成轨迹
  2. 构建连通图G（节点：图像，边：有足够多匹配点的图像对）
  3. 选择初始图像对（匹配点多、基线适中）
  4. 双视图初始化：
     - 用RANSAC+八点法估计本质矩阵E
     - 分解E得到两相机的位姿(R, T)
     - 三角化初始3D点云
  5. 迭代添加新视图：
     - 从G中选择能看到最多已重建3D点的新视图
     - 用PnP方法估计该视图的相机位姿
     - 三角化新的轨迹，重建新的3D点
     - 执行Bundle Adjustment全局优化
     - 从G中删除已处理的边
  6. 当所有边都被处理完，输出最终的相机位姿和3D点云
]

*极坐标平面内的累加器单元算法\**

#warnbox[*重要程度*：★★★★★ 必考大题]

*题目*：写出极坐标平面内的累加器单元算法。

*答题要点*：

*输入*：$x y$-坐标平面内的数据点

*输出*：直线的个数以及直线的极坐标参数

#methodblock[
  *算法步骤*：

  1. 在$x y$-坐标平面内计算所有数据点到原点的距离，其最大值记为$rho_max$
  2. 将$theta in [0, 180 degree]$，$rho in [0, rho_max]$所确定的矩形区域按一定步长划分成小格，并将每个小格的累加器$H(rho, theta)$初始化为零
  3. 对于每个数据点$(x_i, y_i)$，进行以下循环操作：
     - 在$[0, 180 degree]$范围内遍历所有的$theta$
     - 计算$rho = x_i cos theta + y_i sin theta$
     - $H(rho, theta) = H(rho, theta) + 1$
  4. 找到$H(rho, theta)$的局部极值点，每个极值点对应一条直线
  5. 输出直线个数以及每条直线的参数
]

*关键公式*：$rho = x cos theta + y sin theta$（极坐标直线方程）

*相机标定方法\**

#warnbox[*重要程度*：★★★ 可能考]

*题目*：简述相机标定的方法和步骤。

*答题要点*：

#methodblock[
  *方法名称*：张正友标定法（平面标定法）

  *标定板*：平面棋盘格，已知格子尺寸

  *拍摄要求*：至少3个不同角度/位置的图像

  *核心步骤*：
  1. 打印平面棋盘格标定板（已知格子尺寸）
  2. 从至少3个不同角度/位置拍摄标定板图像
  3. 用角点检测算法找到所有角点（亚像素精度）
  4. 对每幅图像，估计单应矩阵H
  5. 利用所有图像的H，求解内参矩阵K
  6. 求解每幅图像的外参R和t
  7. 非线性优化精化所有参数（包括畸变系数）

  *标定板作用*：
  - 提供已知世界坐标的特征点（角点）
  - 平面标定板简化计算（3D投影退化为2D单应变换）
  - 角点检测精度高，提高标定准确性
]

*相关法存在的问题\**

#warnbox[*重要程度*：★★★ 可能考]

*题目*：简述立体匹配中相关法存在的问题。

*答题要点*：

1. #key[遮挡问题]：一个视图可见，另一视图被遮挡
2. #key[同质区域]：纹理平坦，缺乏特征，匹配不唯一
3. #key[重复模式]：周期性纹理导致多个候选匹配
4. #key[透视变形]：不同视角下窗口外观差异大
5. #key[光照变化]：两视图光照不一致
6. #key[窗口大小]：窗口过小噪声多，过大细节丢失
7. #key[噪声干扰]：图像噪声影响相似度计算

=== 必考画图题

*给物画像（光学系统图解法）\**

#warnbox[*重要程度*：★★★★ 必考]

*题目*：给定物体位置，画出经过理想光学系统后的像。

*答题要点*：

1. 画出物方焦点F、像方焦点F'、主平面H和H'、光轴
2. 标注物点位置
3. 使用两条典型光线确定像点：
   - 光线1：从物点引平行于光轴的光线 → 经H'后过F'
   - 光线2：从物点引过F的光线 → 经H后平行于光轴
4. 两条出射光线交点即为像点
5. 标注所有符号：F, F', H, H', 物点、像点

#warn[注意：光线在主平面H和H'之间可画成直线连接（简化表示）]

*极几何示意图\**

#warnbox[*重要程度*：★★★ 可能考]

*题目*：画出双目立体视觉中的极几何示意图。

*答题要点*：

必须标注的要素：
1. 两相机光心$O_1, O_2$
2. 空间点$P$及其在两图像上的投影$p, p'$
3. 极点$e, e'$（一相机光心在另一图像上的投影）
4. 极线$l, l'$（极平面与图像平面的交线）
5. 极平面（三点$P, O_1, O_2$确定的平面）
6. 基线（连接两相机光心的线段）

*Bayer滤波阵列\**

#warnbox[*重要程度*：★★ 了解即可]

*题目*：画出彩色CCD的Bayer滤波阵列。

*答题要点*：

画出2×2基本单元：
```
G R
B G
```

标注说明：
- 绿色像素占50%（2个G）
- 红色和蓝色各占25%（1个R，1个B）
- 绿色多是因为人眼对绿光最敏感
- 通过去马赛克算法插值还原完整RGB图像

=== 必考计算题

*焦距选择计算\**

#warnbox[*重要程度*：★★★★ 高频]

*题型*：给定物体尺寸、传感器尺寸、工作距离，计算并选择镜头焦距。

*解题步骤*：

1. 计算放大倍数：$beta = "传感器尺寸" / "物体尺寸"$
2. 计算焦距：$f' = (beta dot "WD") / (1 + beta)$
3. 选择最接近的标准镜头（8mm, 12.5mm, 16mm, 25mm, 50mm）
4. 验证工作距离：$"WD" = f' dot (1 + beta) / beta$

*示例*：零件大小6cm，传感器6.6mm，工作距离10-30cm，求镜头焦距。

- $beta = 6.6/60 = 0.11$
- 取WD中值20cm：$f' = (0.11 times 200)/(1+0.11) = 19.82"mm"$
- 选择16mm镜头（最接近）
- 验证：$"WD" = 16 times 1.11/0.11 = 161.5"mm" = 16.1"cm"$（在范围内✓）

*瑞利判据计算\**

#warnbox[*重要程度*：★★ 了解即可]

*题型*：利用瑞利判据计算分辨能力。

*瑞利判据*：两点成像的艾里斑中心距离等于艾里斑半径时，刚好能分辨。

*公式*：$theta_min = 1.22 lambda / D$

其中：
- $theta_min$：最小分辨角
- $lambda$：光波长
- $D$：孔径直径

*运动清晰成像条件\**

#warnbox[*重要程度*：★★ 了解即可]

*题型*：计算物体运动时的最大曝光时间。

*公式*：$t_"exp" lt.eq "像元尺寸" / (v dot beta)$

其中：
- $t_"exp"$：曝光时间
- $v$：物体运动速度
- $beta$：放大倍率

*示例*：物体以100mm/s速度运动，像元尺寸5μm，放大倍率0.1，求最大曝光时间。

$t_"exp" lt.eq (5 times 10^(-3))/(100 times 0.1) = 0.5"ms"$

== 公式汇总

=== 光学成像

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "公式名称"),
    text(fill: titlecolor, weight: "bold", "公式"),
  ),
  [牛顿公式], [$x x' = f f'$],
  [高斯公式], [$1/f = 1/d_o + 1/d_i$],
  [垂轴放大率], [$beta = y'/y = -d_i / d_o = f/x = -x'/f'$],
  [镜头F数], [$F = f / D$（$f$焦距，$D$孔径直径）],
  [焦距选择], [$f' = (beta dot "WD") / (1 + beta)$],
  [清晰成像], [$t_"exp" lt.eq "像元尺寸" / (v dot beta)$],
)

=== 光度学

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "物理量"),
    text(fill: titlecolor, weight: "bold", "公式/单位"),
  ),
  [光通量与辐通量], [$Phi_v = K_m integral Phi_e(lambda) V(lambda) d lambda$，$K_m = 683"lm/W"$],
  [发光强度], [$I = (d Phi) / (d Omega)$，单位：cd（坎德拉）],
  [照度], [$E = (d Phi) / (d A)$，单位：lx（勒克斯）],
  [亮度], [$L = (d I) / (d A cos theta)$，单位：cd/m²],
)

=== 相机标定与坐标变换

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "变换"),
    text(fill: titlecolor, weight: "bold", "公式"),
  ),
  [内参矩阵], [$K = mat(alpha, 0, c_x; 0, beta, c_y; 0, 0, 1)$],
  [完整投影], [$Z_c tilde(bold(p)) = K [R|t] tilde(bold(P))_w$],
  [透视投影], [$x_p = f dot X_c / Z_c, quad y_p = f dot Y_c / Z_c$],
)

=== 极几何

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "矩阵"),
    text(fill: titlecolor, weight: "bold", "公式"),
  ),
  [本质矩阵], [$E = [bold(t)]_times R$],
  [基础矩阵], [$F = K'^(-T) E K^(-1)$],
  [对极约束], [$bold(x)'^T F bold(x) = 0$],
  [极线计算], [$bold(l)' = F bold(x)$（右图极线）],
)

=== 双目立体视觉

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "公式名称"),
    text(fill: titlecolor, weight: "bold", "公式"),
  ),
  [视差], [$d = x_l - x_r$],
  [深度计算], [$Z = (f dot B) / d$（$f$焦距，$B$基线长度）],
  [归一化相关匹配], [$"NCC" = ((bold(w) - overline(w))^T (bold(w)' - overline(w)')) / (||bold(w) - overline(w)|| dot ||bold(w)' - overline(w)'||)$],
)

=== 拟合

#table(
  columns: (1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "方法"),
    text(fill: titlecolor, weight: "bold", "公式"),
  ),
  [RANSAC迭代次数], [$N = log(1 - p) / log(1 - (1 - e)^s)$],
  [霍夫变换（极坐标）], [$rho = x cos theta + y sin theta$],
)

== 易混概念辨析

=== 本质矩阵 vs 基础矩阵

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
  [编码信息], [旋转$R$和平移$bold(t)$], [完整投影关系（包含内参）],
  [关系式], [$E = [bold(t)]_times R$], [$F = K'^(-T) E K^(-1)$],
  [自由度], [5（旋转3+平移方向2）], [7（9元素-尺度-秩2约束）],
  [奇异值], [$sigma_1 = sigma_2 > 0, sigma_3 = 0$], [两个非零奇异值（不一定相等）],
  [秩], [2], [2],
)

=== CCD vs CMOS

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "特性"),
    text(fill: titlecolor, weight: "bold", "CCD"),
    text(fill: titlecolor, weight: "bold", "CMOS"),
  ),
  [工作原理], [电荷串行转移读出], [每像素独立晶体管读出],
  [读出速度], [慢（串行）], [快（并行）],
  [功耗], [高], [低（约CCD的1/10）],
  [成本], [高], [低],
  [主要应用], [天文、医学高质量成像], [消费相机、工业、高速],
)

=== 全局曝光 vs 卷帘曝光

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "曝光方式"),
    text(fill: titlecolor, weight: "bold", "Global Shutter"),
    text(fill: titlecolor, weight: "bold", "Rolling Shutter"),
  ),
  [曝光方式], [所有像素同时曝光和读出], [逐行顺序曝光],
  [运动失真], [无], [有（果冻效应Jelly Effect）],
  [适用场景], [高速运动拍摄], [静态或低速场景],
  [成本], [较高], [较低],
)

=== 远心镜头三种类型

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header(
    text(fill: titlecolor, weight: "bold", "类型"),
    text(fill: titlecolor, weight: "bold", "作用"),
    text(fill: titlecolor, weight: "bold", "解决的问题"),
  ),
  [物方远心], [孔径光阑在像方焦平面], [物距变化不影响放大倍率],
  [像方远心], [孔径光阑在物方焦平面], [CCD位置偏差不影响测量],
  [双侧远心], [同时具备物方和像方远心], [物体和CCD位置偏差都不影响],
)

== 重要参数记忆

=== 人眼参数

- 眨眼时间：0.2-0.4秒
- 暗适应：20-30分钟
- 明适应：约1分钟
- 白昼瞳孔直径：2-4mm
- 晚间瞳孔直径：4-8mm
- 视觉残留：0.1-0.4秒
- 正常视力：能识别1分角（1/60度）
- 对绿光（555nm）最敏感

=== 相机参数

- 1英寸 = 25.4mm（但传感器"1英寸"是历史命名）
- 标准镜头焦距：8mm、12.5mm、16mm、25mm、50mm
- 相邻光圈档位F数相差$sqrt(2)$倍（约1.4倍）
- 常见F数：f/1.4, f/2, f/2.8, f/4, f/5.6, f/8, f/11, f/16

=== 光度学参数

- $K_m = 683"lm/W"$（明视觉，555nm）
- $K'_m = 1725"lm/W"$（暗视觉，507nm）
- 可见光范围：380nm - 740nm

== 备考策略

=== 考前一周

1. *术语翻译*：每天背诵术语表30分钟，确保拼写准确
2. *简答题*：熟练背诵增量法SfM和极坐标累加器算法
3. *画图题*：练习给物画像和极几何示意图各5次
4. *计算题*：做焦距选择计算题至少3道

=== 考前一天

1. 快速浏览术语表，重点记RANSAC、SfM全称
2. 默写一遍增量法SfM的完整步骤
3. 默写一遍极坐标累加器算法的步骤
4. 复习公式汇总，特别是焦距选择公式

=== 考试答题技巧

1. *填空题*：术语拼写必须准确，注意大小写
2. *简答题*：写完整的算法步骤，分点作答，不要只写概括
3. *画图题*：标注清楚所有符号，光线用箭头表示方向
4. *计算题*：写出公式，带单位计算，步骤清晰
5. *综合题*：先理清思路，分步骤作答，部分分很重要

#warnbox[
  *考试注意事项*：
  - 术语翻译不能有拼写错误，注意大小写（RANSAC, SfM等）
  - 简答题要写完整步骤，不能只写大纲
  - 画图题要标注所有符号和要素
  - 计算题要写公式、带单位、步骤清晰
  - 时间分配：填空10分钟，简答50分钟，画图10分钟，计算10分钟，综合40分钟
]