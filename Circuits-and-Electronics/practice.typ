#import "../template/conf.typ": conf
#import "../template/components.typ": *
#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.8": codly-languages

#show: codly-init
#codly(languages: codly-languages)

#show: conf.with(
  title: [
    电路与电子学 习题
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#set image(height: 20%)

= 直流电路

#rect[
  某小区一用户，一个月的用电量约180度，若一个月按30天计算，该用户平均每小时消耗功率`____`W。
  - 250
]

#rect[
  某一实际电压源外接负载，当电流I=0.05A时负载两端电压为5.4V.，当负载开路时，电压为6V，则电压源内阻$R_0$=`____`#sym.Omega，短路电流$I_"sc"$=`____`A。
  - 12
  - 0.5
]

#rect[
  #figure(
    image("assets/practice/001.png", height: 20%)
  )
  上图电路有`____`个支路, `____`个节点, `____`个网孔.
  - 6, 4, 3 
]

#rect[
  #figure(
    image("assets/practice/002.png", height: 20%)
  )
  用电源等效变换求如图所示中的电流I=`____`A。
  - 
]

#rect[
  #figure(
    image("assets/practice/003.png", height: 20%)
  )
  如图（a）所示的电路，根据戴维南定理可等效为图（b）所示的电路，则图（b）中$U_"oc" = $`____`V，$R_o$=`____`#sym.Omega， U=`____`V。
  - -4
  - 6
  - -10
]

#rect[
  #figure(
    image("assets/practice/004.png", height: 20%)
  )
  用*电源等效变换/支路电流法/节点点位法*求如图所示电路中的电流I = `____`A，电压源功率$P_"9V"$ = `____`W
  - 1
  - -9
]

= 一阶动态电路的暂态分析

#rect[
  #figure(
    image("assets/practice/005.png", height: 20%)
  )
  电路如图所示，开关在0时由1扳向2，已知开关在1时电路已处于稳定。则$u_C(0_+) = $`____`V，$i_C(0_+)=$`____`A，$u_L(0_+)=$`____`V, $i_L(0_+)=$`____`A。
  - 4
  - -1
  - -4
  - 2
]

#rect[
  #figure(image("assets/practice/006.png"))
  如图所示电路原已达稳态，t=0时开关闭合，换路后，根据*三要素法*计算，则有 $i_L(0_+)=$`____`A, $i_L(infinity)=$`____`A, $tau = $`____`s。
  - 0.5
  - $1/3$
  - 0.5
]

= 正弦稳态电路的分析

#rect[
  已知电压$u(t) = 10sin(6pi t + 15deg)$V，电流$i(t) = 5cos(6pi t - 45deg)$A，则电压与电流的相位差为: 
  - $i$超前$u$ $30deg$
]

#rect[
  已知，某一正弦交流电路中的电压为$u(t)=156sin(377t+15°)$V，则下列描述有误的一项是：
  - 电压的相量形式为$accent(U, .)_m = 156angle j 15degree$V
]

#rect[
  #figure(image("assets/practice/007.png"))
  如图所示RC串联电路的阻抗Zab可以表示为
  - $Z_"ab" = R - omega C$
]

#rect[
  #figure(image("assets/practice/008.png"))
  如图所示电路的等效阻抗Zab的实部是`____`#sym.Omega, 虚部是`____`#sym.Omega。
  - 10
  - 10
]

#rect[
  已知某正弦交流电路中的有功功率P=16kW，功率因数$lambda$=0.8（超前），则电路的视在功率S=`____`kVA，无功功率Q=`____`kvar。
  - 20
  - -12
]

#rect[
  在RLC串联谐振电路中，角频率$omega = omega_0$，此时电路呈`____`性，当$omega > omega_0$时电路呈`____`性, 当$omega < omega_0$时电路呈`____`性
  - 电阻
  - 电感
  - 电容
]

