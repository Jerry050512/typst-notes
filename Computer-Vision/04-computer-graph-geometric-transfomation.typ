#import "../template/preamble.typ": *

= 计算机图形几何变换

#knowtitle[本章内容聚焦数学知识，不算是计算机视觉的核心内容，但理解这些变换有助于理解计算机视觉算法。]

== 基本变换

=== 平移变换 (Translation)

点 $P(x, y, z)$ 沿 $x, y, z$ 轴方向分别移动 $Delta x, Delta y, Delta z$ 得到 $P'(x', y', z')$：

$ vec(x', y', z') = vec(x, y, z) + vec(Delta x, Delta y, Delta z) $

矩阵形式：
$ mat(x'; y'; z') = mat(1, 0, 0; 0, 1, 0; 0, 0, 1) mat(x; y; z) + mat(Delta x; Delta y; Delta z) $

=== 缩放变换 (Scaling)

点 $A(x, y, z)$ 按比例 $s_x, s_y, s_z$ 缩放得到 $A'(x', y', z')$：

$ mat(x'; y'; z') = mat(s_x, 0, 0; 0, s_y, 0; 0, 0, s_z) mat(x; y; z) $

即：
$ x' = s_x x, quad y' = s_y y, quad z' = s_z z $

*相对中心点的缩放*：以 $(x_p, y_p, z_p)$ 为中心缩放，三步操作：

1. 平移至原点：$(x - x_p, y - y_p, z - z_p)$
2. 缩放：$(s_x(x - x_p), s_y(y - y_p), s_z(z - z_p))$
3. 平移回原位置：

$ x' = x_p + s_x(x - x_p) $
$ y' = y_p + s_y(y - y_p) $
$ z' = z_p + s_z(z - z_p) $

=== 旋转变换 (Rotation)

*绕 Z 轴旋转* $alpha$ 角：

$ mat(x'; y'; z') = mat(cos alpha, sin alpha, 0; -sin alpha, cos alpha, 0; 0, 0, 1) mat(x; y; z) $

即：
$ x' = x cos alpha + y sin alpha $
$ y' = -x sin alpha + y cos alpha $
$ z' = z $

*绕 Y 轴旋转* $alpha$ 角：

$ mat(x'; y'; z') = mat(cos alpha, 0, -sin alpha; 0, 1, 0; sin alpha, 0, cos alpha) mat(x; y; z) $

*绕 X 轴旋转* $alpha$ 角：

$ mat(x'; y'; z') = mat(1, 0, 0; 0, cos alpha, sin alpha; 0, -sin alpha, cos alpha) mat(x; y; z) $

== 齐次坐标系统

#knowtitle[齐次坐标主要为了解决平移引入的多的那一项，它将平移和旋转变换统一为矩阵乘法形式，方便进行复合变换。]

/ 齐次坐标: 将 $n$ 维空间的点用 $n+1$ 维向量表示，增加一个齐次坐标分量 $w$。

三维空间中的点 $(x, y, z)$ 的齐次坐标表示为 $(x, y, z, 1)$，向量表示为 $(x, y, z, 0)$。

*齐次坐标的优势*：
- 统一表示所有几何变换（包括平移）
- 可以用矩阵乘法表示复合变换
- 可以表示无穷远点

=== 齐次坐标下的基本变换

所有变换统一为 $4 times 4$ 矩阵形式：

*平移变换*：
$ mat(x'; y'; z'; 1) = mat(1, 0, 0, Delta x; 0, 1, 0, Delta y; 0, 0, 1, Delta z; 0, 0, 0, 1) mat(x; y; z; 1) $

*缩放变换*：
$ mat(x'; y'; z'; 1) = mat(s_x, 0, 0, 0; 0, s_y, 0, 0; 0, 0, s_z, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

*绕 Z 轴旋转*：
$ mat(x'; y'; z'; 1) = mat(cos alpha, sin alpha, 0, 0; -sin alpha, cos alpha, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

*绕 Y 轴旋转*：
$ mat(x'; y'; z'; 1) = mat(cos alpha, 0, -sin alpha, 0; 0, 1, 0, 0; sin alpha, 0, cos alpha, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

*绕 X 轴旋转*：
$ mat(x'; y'; z'; 1) = mat(1, 0, 0, 0; 0, cos alpha, sin alpha, 0; 0, -sin alpha, cos alpha, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

=== 复合变换

多个变换的复合通过矩阵连乘实现：

$ bold(P)' = bold(T)_n bold(T)_(n-1) dots bold(T)_2 bold(T)_1 bold(P) $

#warn[
  *矩阵乘法不满足交换律*：变换顺序会影响最终结果。例如"先旋转后平移"与"先平移后旋转"的结果不同。
]

== 投影变换

=== 正交投影 (Orthographic Projection)

*平行于坐标平面的正交投影*：

投影到 XY 平面（忽略 Z 坐标）：
$ mat(x'; y'; z'; 1) = mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 0, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

投影到 XZ 平面：
$ mat(x'; y'; z'; 1) = mat(1, 0, 0, 0; 0, 0, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

投影到 YZ 平面：
$ mat(x'; y'; z'; 1) = mat(0, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

*斜二侧投影 (Oblique Projection)*：

投影方向与投影平面成角度：
$ mat(x'; y'; z'; 1) = mat(1, 0, L cos theta, 0; 0, 1, L sin theta, 0; 0, 0, 0, 0; 0, 0, 0, 1) mat(x; y; z; 1) $

其中 $L$ 为投影长度比例，$theta$ 为投影角度。常见取值：
- *正等轴测*：$L = 1$，$theta = 45°$
- *工程投影*：$L = 1/2$，$theta = 45°$（Cabinet投影）

=== 透视投影 (Perspective Projection)

透视投影使远处物体看起来更小，产生近大远小的效果。

/ 灭点 (Vanishing Point): 三维空间中的平行线，在透视投影后会相交于一点，这个点称为灭点。平行线越远离观察者，投影后越接近灭点。

*一点透视*（平行透视）：

投影平面平行于 YZ 平面，灭点在 X 轴上：

$ mat(x'; y'; z'; w') = mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; p, 0, 0, 1) mat(x; y; z; 1) $

归一化后（除以 $w'$）：
$ x' = x / (p x + 1), quad y' = y / (p x + 1), quad z' = z / (p x + 1) $

当 $x arrow infinity$ 时，所有平行于 X 轴的线收敛到灭点 $(1/p, 0, 0)$。

*两点透视*（成角透视）：

灭点在 X 轴和 Z 轴上：

$ mat(x'; y'; z'; w') = mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; p, 0, r, 1) mat(x; y; z; 1) $

归一化后：
$ x' = x / (p x + r z + 1), quad y' = y / (p x + r z + 1), quad z' = z / (p x + r z + 1) $

两个灭点分别位于：
- X 轴上的 $(1/p, 0, 0)$
- Z 轴上的 $(0, 0, 1/r)$

*三点透视*：

三个坐标轴方向都有灭点：

$ mat(x'; y'; z'; w') = mat(1, 0, 0, 0; 0, 1, 0, 0; 0, 0, 1, 0; p, q, r, 1) mat(x; y; z; 1) $

三个灭点分别位于：
- X 轴：$(1/p, 0, 0)$
- Y 轴：$(0, 1/q, 0)$
- Z 轴：$(0, 0, 1/r)$

#figure(
  table(
    columns: 3,
    align: center,
    table.header(
      [*透视类型*], [*灭点数量*], [*特点*]
    ),
    [一点透视], [1个灭点], [投影平面平行于两个坐标轴],
    [两点透视], [2个灭点], [投影平面平行于一个坐标轴],
    [三点透视], [3个灭点], [投影平面与三个坐标轴都不平行],
  ),
  caption: [透视投影类型对比]
)

== 变换矩阵总结

#figure(
  table(
    columns: 2,
    align: center+horizon,
    table.header(
      [*变换类型*], [*齐次坐标变换矩阵*]
    ),
    [平移], [$ mat(1, 0, 0, Delta x; 0, 1, 0, Delta y; 0, 0, 1, Delta z; 0, 0, 0, 1) $],
    [缩放], [$ mat(s_x, 0, 0, 0; 0, s_y, 0, 0; 0, 0, s_z, 0; 0, 0, 0, 1) $],
    [旋转], [绕Z轴：$ mat(cos alpha, sin alpha, 0, 0; -sin alpha, cos alpha, 0, 0; 0, 0, 1, 0; 0, 0, 0, 1) $ \ 绕Y轴：第1、3列符号相反 \ 绕X轴：第2、3行应用旋转],
    [透视投影], [一点：$mat(dots.h, dots.h, dots.h, dots.h; dots.h, dots.h, dots.h, dots.h; dots.h, dots.h, dots.h, dots.h; p, 0, 0, 1)$ \ 两点：最后一行 $(p, 0, r, 1)$ \ 三点：最后一行 $(p, q, r, 1)$],
  ),
  caption: [常用几何变换矩阵（前3×3为变换部分，最后一行控制透视）]
)
