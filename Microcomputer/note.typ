#import "../template/conf.typ": conf
#import "../template/components.typ": *

#import "@preview/codly:1.3.0": codly, codly-init
#import "@preview/codly-languages:0.1.8": codly-languages
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: codly-init
#codly(languages: codly-languages)

#show: conf.with(
  title: [
    微机原理
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#set figure(numbering: none)

#show table: it => align(center, it)

#set table(
  fill: (x, y) => if y == 0 {luma(80%)},
  align: center+horizon,
)

= 课程介绍 & 微机概述

== 冯诺依曼结构

/ 冯诺依曼结构: 

#figure(
  diagram(
    spacing: 4em,
    {
      let tint(c) = (stroke: c, fill: rgb(..c.components().slice(0,3), 5%), inset: 8pt)
      node(enclose: ((0,0), (0,2)), box(stack(dir: ttb, spacing: 5pt, .."输入设备".split("")), width: 3em), ..tint(teal), name: <input>)  
      node(enclose: ((2,0), (2,2)), box(stack(dir: ttb, spacing: 5pt, .."输出设备".split("")), width: 3em), ..tint(teal), name: <output>)
      node((1, 0), "存储器", ..tint(blue), name: <storage>)
      node((1, 1), "运算器", ..tint(yellow), name: <alu>)
      node((1, 2), "控制器", ..tint(red), name: <cu>)
      node(enclose: ((1,1), (1, 2)), "CPU", ..tint(green), name: <cpu>)
    },

    edge((0, 0), <storage>, "==>", stroke: teal + .75pt),
    edge(<storage>, (2, 0), "==>", stroke: teal + .75pt),
    edge((0, 2), <cu>, "-|>", stroke: blue, shift: 1.5pt),
    edge(<cu>, (0, 2), "-|>", stroke: blue, shift: 1.5pt),
    edge((2, 2), <cu>, "-|>", stroke: blue, shift: 1.5pt),
    edge(<cu>, (2, 2), "-|>", stroke: blue, shift: 1.5pt),
    edge(<cu>, <alu>, "-|>", stroke: blue, shift: 1.5em),
    edge(<alu>, <cu>, "-|>", stroke: blue, shift: 1.5em),
    edge(<storage>, <alu>, "-|>", stroke: blue, shift: 1.5em),
    edge(<alu>, <storage>, "-|>", stroke: blue, shift: 1.5em),
    
    edge(<cu>, <storage>, "-|>", stroke: blue, bend: 30deg, shift: 10pt),
    edge(<storage>, <cu>, "-|>", stroke: blue, bend: 30deg, shift: 10pt),
  ), 
  caption: [冯诺依曼结构]
)

== 计算机分类

*区分* 
- 普林斯顿结构, 哈佛结构
- 指令体系: RISC (精简指令计算机), CISC (复杂指令计算机)

note. C51即为CISC类型. 

#table(
  fill: (x, y) => if y == 0 {luma(80%)}, 
  align: center, 
  columns: 2,
  [*冯·诺依曼结构*], [*哈佛结构 (Harvard architecture)*], 
  [也称普林斯顿结构, 是一种将程序指令存储器和数据存储器合并在一起的存储器结构. 程序指令存储地址和数据存储地址指向同一个存储器的不同物理位置, 但采用不同指令进行操作. ], 
  [是一种将程序指令储存和数据储存分开的存储器结构 ,以便实现并行处理, 执行时可以预先读取下一条指令,具有较高的执行效率 . \ *目前绝大部分微控制器包括MCS-51微控制器都属于哈佛结构.* ]
)

= MCS-51内部结构

- 并行I/O口: 4个8位I/O口, P0-P3, 具有第二功能(P0为地址/数据复用口, P2为高地址线, P3可作为中断、串口、定时器等控制线). 
- 中断系统: 具有5个中断源, 2个中断优先权. (串行口手动清标志位, 其他硬件自动清零)
- 定时器/计数器: 有2个16位的定时器/计数器, 具有4个工作方式. 
- 串行接口: 1个全双工的串行口, 用于微控制器与具有串行街斗的外设进行异步串行通信, 也可以拓展I/O口. ($A<->B$可同时通信)
- 布尔处理器: 具有较强的位寻址, 位处理能力. 
- 时钟电路: 产生位控制器工作所需的时钟脉冲(需要外接晶体震荡器和微调电容)
- 指令系统: 5大功能, 111条指令, 位复杂指令系统(CISC). 

== 控制器

控制器由 *操作控制部件、时序发生器、指令寄存器 IR、指令译码器 ID、指令计数器 PC* 等组成. \
它完成取指、译码和执行等全过程的控制. 

=== 指令计数器 `PC (Program Counter)`

- 一个 `16` 位按机器周期自动 `+1` 的计数器
- 总是指向下一条指令的首地址
- 分支、跳转、调用、中断、复位均会改变 `PC` 值
- 用户不可直接读写 `PC`
- 地址范围: `0000H ~ FFFFH`, 可寻址 `64K` 程序空间

=== 堆栈指针 `SP (Stack Pointer)`

- `8` 位寄存器, 位于内部 RAM 的低 128 字节中
- 栈的结构为 *先进后出 (LIFO) *
- 默认复位初值为 `07H`, 即从地址 `08H` 开始存放压栈数据
- 执行 `PUSH` 指令前先 `SP + 1`, 再写入数据；`POP` 则先读取数据, 再 `SP - 1`

=== 数据指针 `DPTR (Data Pointer)`

- 由 `DPH` (高 8 位) 与 `DPL` (低 8 位) 组成的 `16` 位寄存器
- 由用户控制, 常用于操作外部数据存储器或查表指令 (如 `MOVX`, `MOVC`) 
- 是 MCS-51 中较少的*用户可操作的 16 位地址寄存器*

=== 指令寄存器 `IR` 与指令译码器 `ID`

- `IR` 用于暂存当前获取的操作码
- `ID` 根据 `IR` 内容进行译码, 产生微操作控制信号

=== 时序发生器

- 配合振荡器产生的时钟脉冲, 控制 CPU 内部各阶段的操作节奏
- 提供*机器周期*与*状态周期*的划分基础

== 运算器

运算器负责 *数据的运算、处理与加工*, 是中央处理器的核心组成. \
由 *算术逻辑单元 ALU、累加器 ACC、暂存寄存器 TMP、程序状态字 PSW、布尔处理器、BCD 码调整电路* 等部分组成, 并通过 *内部总线* 实现相互连接. 

=== 累加器 `ACC (Accumulator)`

- 是 MCS-51 最常用的数据暂存与运算寄存器
- 绝大多数算术和逻辑运算都以 `ACC` 为默认操作数和结果寄存器
- 许多指令默认将运算结果保存在 `ACC` 中, 例如 `ADD`, `ANL`, `ORL`, `XRL`
- 同时参与奇偶校验判断 (与 `P` 标志位相关) 

=== 程序状态字 `PSW (Program Status Word)`

`PSW.7~0` 分别为: `CY`, `AC`, `F0`, `RS1`, `RS0`, `OV`, `F1`, `P`

- `CY (PSW.7)`: 进位 / 借位标志, 反映最高位运算时是否有进位
- `AC (PSW.6)`: 辅助进位, 用于 BCD 调整指令 (如 `DA A`) (我们可以暂时不关心它)
- `F0, F1 (PSW.5 / PSW.1)`: 用户通用标志位, 可自由设置与读取
- `RS1, RS0 (PSW.4 / PSW.3)`: 当前选中工作寄存器组 (共4组: R0~R7) 
- `OV (PSW.2)`: 溢出标志位 (有符号数运算判断) 
- `P (PSW.0)`: 奇偶标志, 自动根据 `ACC` 中 1 的个数更新 (偶数为0, 奇数为1) 

=== 算术逻辑单元 `ALU`

- 用于执行 *加法、减法、逻辑与/或/异或、比较、移位* 等基本运算
- 运算结果通常保存在 `ACC` 中, 必要时设置 `PSW` 相应标志位
- 是实现数据处理和布尔逻辑的物理核心

=== 暂存寄存器 `TMP`

用于运算数据的暂时存放, 该寄存器不能访问. 

=== 布尔处理器 (位处理器)

- 具有 *强大的位操作能力*, 可位寻址、测试、置位、清零、取反等
- 能直接操作特殊功能寄存器中的位, 如 `SETB TR0`, `CLR IE.7`

能直接对位 (bit) 进行操作, 操作空间是位寻址空间. 位处理器中
功能最强、使用最频繁的位是C, 也称其为位累加器. 

== 存储器

- 数据存储器 RAM (Random Access Memory)
- 程序存储器 ROM (Read Only Memory)

以下三条指令用于不同存储器之间的数据访问: 
- `MOV`: 用于访问 *内部 RAM* 与 *特殊功能寄存器 (SFR) *
- `MOVX`: 用于访问 *外部 RAM*
- `MOVC`: 用于访问 *程序存储器 ROM*, 常用于查表等操作

=== 程序存储器

- 分为内部和外部ROM
- $overline(E A) = 1$表示内部, 为$0$ 表示外部. 

- `00H~7FH` 低128字节 内部RAM区
  - 工作寄存区
  - 位寻址区
  - 用户寄存区
- `80H~FFH` 高128字节 专用寄存器

*特殊区域*

- `0000H~0002H` `PC`指针复位处
- `0003H~000AH` 外部中断0中断地址区
- `000BH~0012H` 定时器/计数器0中断区
- `0013H~001AH` 外部中断1中断地址区
- `001BH~0022H` 定时器/计数器1中断区
- `0023H~002AH` 串行中断地址区

=== 数据存储器

MCS-51 的数据存储空间由 *内部 RAM* 与 *外部 RAM* 构成: 

- 内部 RAM: `00H ~ FFH` 共 256 字节
  - `00H ~ 7FH` (低 128 字节): 
    - `00H ~ 1FH`: *工作寄存器区*, 分为 4 组 R0~R7
    - `20H ~ 2FH`: *位寻址区*, 可使用 `SETB`, `CLR` 等位操作
    - `30H ~ 7FH`: *用户通用 RAM 区*, 供数据读写
  - `80H ~ FFH` (高 128 字节): 
    - 实际上是 *特殊功能寄存器区 (SFR) *, 如 `P0`、`TMOD`、`IE` 等
    - 注意: 并非全部地址都被定义或使用

- 外部 RAM: 
  - 最大支持 `64KB`, 通过 `MOVX` 指令访问
  - 需配合地址锁存器 (如 74HC573) 与片选电路

=== 总结

#figure(
  image("assets/storage-config.png"), 
  caption: [程序存储器空间配置总结]
)

== 控制器引脚

最小系统: *晶振、复位、电源、时钟、EA (外部访问) *

=== 时钟引脚

- 用于接晶振电路, 提供系统时钟信号. 

- 系统内部通过时钟频率分频生成: 

  - 2 分频 → 状态时钟
  - 6 分频 → ALE 信号
  - 12 分频 → 机器周期时钟

- 振荡周期: 
  \$ T\_c = \frac{1}{f\_\text{osc}} \$

- 状态周期 (不常用): 
  \$ T\_s = 2 T\_c \$

- 机器周期 (常用于时间计算): 
  \$ T\_m = 6 T\_s = 12 T\_c \$

- 指令周期: 执行一条指令所需的机器周期数 (依指令不同可能为 1、2 或 4 个 \$T\_m\$) 

=== 复位引脚

复位电路 (支持上电复位与手动复位): 

#figure(
  image("assets/mannual-reset.png", height: 40%),
  caption: [手动复位电路]
)

=== 控制引脚: `ALE` / `PSEN`

- `ALE` (Address Latch Enable): 

  - 地址锁存允许信号. 
  - 用于将 P0 的低 8 位地址锁存进 74HC573 等锁存器. 
  - 正常工作状态下为 1/6 分频输出, 可用于观察系统是否运行. 

- `PSEN` (Program Store Enable): 

  - 程序存储器读选通信号. 
  - 外部程序存储器 (ROM) 选通信号, 低电平有效. 

=== `P0` 口

- 为复用型口线: 在访问外部存储器时, 作为地址/数据复用总线. 
- 与其他 P 口不同, *无内部上拉电阻*, 需外接上拉. 
- 输入时: 需先将口线写入高电平, 再读取其状态. 
- 输出时: 直接写入电平. 

=== 其他 P 口输入说明 (P1、P2、P3) 

- 默认带内部上拉电阻. 
- 读取输入时, 也需先写入高电平, 然后再读取电平状态. 

`P3`口除了可以用作通用I/O端口, 同时还具有特定的第二功能. 

#table(
  fill: (x, y) => if y == 0 {luma(80%)},
  align: center,
  columns: (auto, auto, 1fr),

  [*I/O引脚*], [*第二功能引脚名称*], [*说明*],
  `P3.0`, `RXD`, [串行通信的数据接收端口],
  `P3.1`, `TXD`, [串行通信的数据发送端口],
  `P3.2`, overline(`INT0`) , [外部中断 0 的请求端口],
  `P3.3`, overline(`INT1`) , [外部中断 1 的请求端口],
  `P3.4`, `T0`, [定时/计数器 0 的外部事件计数输入端],
  `P3.5`, `T1`, [定时/计数器 1 的外部事件计数输入端],
  `P3.6`, overline(`RD`) , [外部数据存储单元的读选通信号],
  `P3.7`, overline(`WR`) , [外部数据存储单元的写选通信号],
)

= 指令系统

== 指令格式

```asm
ANNOTATION: COMMAND TARGET, SOURCE  ; comment
```

/ 指令格式: 任一条指令均由*操作码*和*操作数*两部分组成。操作码用来规定指令所要完成的操作；操作数是指令操作的对象。

== 寻址方式

- 立即寻址
- 直接寻址
- 寄存器寻址
- 间址寻址
- 变址寻址
- 相对寻址
- 位寻址

=== 立即寻址

操作数以立即数的形式在指令中直接给出，立即数表示为`#data`，`#data16`。数字前加“\#”符号，即表示为立即数。

例如: 
```asm
MOV  A, #30H            
MOV  DPTR ,#8000H
```

=== 直接寻址

指令中给出的操作数是实际操作数的存储地址，即存放实际操作数的内部RAM的单元地址或SFR的地址，该单元的内容为指令的操作数。
对比两种区别: 
```asm
MOV 30H, 50H   ; 操作码  直接地址  直接地址
               ; 85       30       50
MOV 30H, #50H  ; 操作码  直接地址  立即数
               ; 75       30       50
```

直接寻址的寻址空间（数据空间RAM）：
- 内部RAM的低128个字节单元（00H-7FH）
- 特殊功能寄存器区（直接寻址是访问的*唯一方式*）

=== 寄存器寻址

指令中给出操作数所在的寄存器，即寄存器的内容是操作数。
```asm
MOV A, R1 
INC R0
```
（该类指令大多数为单字节指令，操作数隐含在操作码中）
寄存器寻址空间为： R0\~R7，A

=== 寄存器间接寻址

操作数的地址存放在寄存器中，即寄存器的内容是操作数所在的内存地址。
用于间接寻址的寄存器有Ri(i=0或1)、DPTR，要在寄存器前加@。
```asm
MOV  A, @R1
MOVX A, @DPTR
```

=== 变址寻址

以`DPTR`或`PC`作*基址寄存器*，`A`作*变址寄存器*（存放8位无符号数），两者相加形成的16位程序存储器地址，作为操作数所在地址。
8051微控制器共有3条变址寻址的指令（均为单字节指令）
```asm
MOVC A, @A+DPTR
MOVC A, @A+PC
JMP  @A+DPTR           
```

变址寻址空间为： *程序存储器*

=== 相对寻址

用于程序控制，利用指令修改PC指针内容实现转移。指令中给出的操作数为程序转移的偏移量（relative）。以PC当前值（执行这条指令时的PC）加上偏移量，所得结果即为转移的目的地址。
$
  "目的地址" & = "转移指令下一条指令首址" + "rel" \
  & = "转移指令所在地址" + "转移指令字节数" + "rel" "等价于 当前PC值" + "rel"
$
例如`SJMP rel`, `JNZ rel`, `DJNZ Rn, rel`等 \
`rel`是一个带符号数的8位二进制补码数，其范围为（-128）-（+127）

=== 位寻址

SFR中的可寻址位既有位地址又有符号名称，如PSW的位7为，其位地址为D7H；P0的位0为P0.0，位地址为80H。建议在指令中使用位符号名称，以增加程序的可读性。
```asm
MOV C, P1.0 ; P1口中最低位P1.0口线的状态输入到Cy。
```
位寻址（对于位）与直接寻址（对于字节）的地址形式完全相同，通过操作码
来区分。

为提高程序的可读性，对于SFR和SFR中的位地址通常用符号表示。
例如`C`, `P`, `OV`, `P1.0-P1.7`, `EA`, `ACC.7`(累加器`A`的最高位)

=== 比较

- 对于SFR (特殊功能寄存器, Special Function Register)，只能用直接寻址方式，直接地址可用*单元地址或寄存器名*，
- 对于内部RAM的（地址与SFR重叠），只能用*寄存器间接寻址*。         
- 对于内部RAM的0，既可以用直接寻址，也可以用寄存器间接寻址。

== 数据传送类

数据传送类指令是最基本、使用最多的一类指令，共有29条。主要用于*数据的传送、保存以及交换*等场合。\
该类指令中，除给`A`赋值（`A`内容发生变化）会影响`P`标志外，其余标志不受影响。可分为以下五组：
#align(
  center, 
  grid(
    columns: 2, 
    align: left, 
    inset: 3pt,
    [内部RAM数据传送类指令: ], [16条 (`MOV`)], 
    [程序存储器访问类指令: ], [2条 (`MOVC`)], 
    [外部RAM访问类指令: ], [4条 (`MOVX`)], 
    [堆栈操作类指令: ], [2条], 
    [数据交换类指令: ], [5条]
  )
)

#let e(body) = text(body, weight: "bold", stroke: red, fill: red)

=== 内部RAM数据传送类指令

#e("MOV")E

该组指令实现8051MCU内部工作寄存器、存储单元、SFR之间的数据传送。
```asm
MOV TARGET, SOURCE
```

#align(
  center,
  block(
    width: 50%,
    table(
      columns: (1fr, 1fr), 
      `TARGET`, `SOURCE`, 
      table.cell(`A`, rowspan: 4),
      `Rn`, `direct`, `@Ri`, `#data`, 
      table.cell(`direct`, rowspan: 5), 
      `A`, `Rn`, `direct`, `@Ri`, `#data`, 
      table.cell(`Rn`, rowspan: 3), 
      `A`, `direct`, `#data`, 
      table.cell(`@Ri`, rowspan: 3), 
      `A`, `direct`, `#data`, 
      `DPTR`, `data16`
    )
  )
)

*注意* 这些都是非法指令
```asm
MOV Rn,    Rn
MOV @Ri,   @Ri
MOV Rn,    @Ri
MOV #data, A
```

=== 外部RAM访问类指令

#e("MOV")E E#e("X")TERNAL RAM

该组指令实现8051MCU与外部RAM的数据传送。

```asm
MOVX A,     @DPTR          
MOVX A,     @Ri               
MOVX @DPTR, A         
MOVX @Ri,   A 
```

=== 查表指令

#e("MOV")E #e("C")ODE

该组指令的功能是从ROM中读取数据，通常是对存放在ROM中的数据表格进行查找读取。

i. 远程查表

```asm
MOVC A, @A+DPTR
```

- 功能：将`DPTR`的内容与`A`的内容相加后形成一个ROM单元地址，将该ROM单元的内容送至`A`。DPTR内容不变。
- 基址寄存器`DPTR`是常数，指向数据表格的首地址；
- 变址寄存器`A`为表格首址到被访问数据的地址偏移量；
- `DPTR` 、 `A`都可以改变，`A`的范围是`0-255`；
- DPTR的范围是`0000H-0FFFFH`。

- 优点：可以查找存放在64K ROM中任何地址的数据表格，因此称为远程查表指令。
- 缺点：要占用`DPTR`寄存器。

ii. 近程查表

```asm
MOVC A, @A+PC
```

- 功能：将`A`和当前`PC`值相加，形成要寻址的ROM单元地址，将该ROM单元中的内容送到A。
- 注意：当前`PC`值，应为该指令所在地址加1。

- 优点：不占用其他的SFR，不改变`PC`的值。根据`A`的内容就可查到数据。
- 缺点：只能查找该指令后256字节范围内的数据表格，因此称为近程查表指令

=== 堆栈操作指令

该组指令采用*直接寻址方式*，入栈操作是把直接寻址单元的内容传送到堆栈指针SP所指的单元中，出栈操作是把SP所指单元的内容送到直接寻址单元中。

```asm
PUSH direct ; 先修改SP指针，再将内部RAM  direct单元的内容压入堆栈。
POP  direct ; 将堆栈栈顶的内容弹出，送到内部RAM direct单元，再修改SP指针。
```

=== 数据交换指令

该组指令是把A中的内容与源操作数所指的数据相互交换。有整字节交换和半字节交换。

- E#e("XCH")ANGE 字节交换
- E#e("XCH")ANGE LOW-ORDER #e("D")IGIT 低四位交换
- #e("SWAP") 交换高低四位

```asm
XCH  A, Rn
XCH  A, direct
XCH  A, @Ri
XCHD A, @Ri
SWAP A
```



== 算数运算类

== 控制转移类

== 伪指令

与编译器的约定. 

= 单片机扩展及应用

== 三总线结构

/ 地址总线: 
/ 数据总线: 
/ 控制总线: 

= 中断系统

== 结构

- 5个中断源
- 使能控制, 优先级控制, 中断标识
- CPU #sym.arrow 中断响应程序

== 中断入口

= 定时器

== 结构

= 人机交互

== 键盘

=== 去抖

- 硬件去抖
- 软件去抖

== 数码管

- 共阴极数码管
- 共阳极数码管

= 串行口

/ 波特率: 

= 模拟口

