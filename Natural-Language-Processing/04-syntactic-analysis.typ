#import "../template/preamble.typ": *

= 句法分析

#knowtitle[句法分析常考三类概念比较：句法结构分析、浅层句法分析、依存句法分析；也可能考CFG、PCFG、CYK算法和句法树。]

#intuition[
  词法分析解决“有哪些词”，句法分析解决“这些词如何组成句子”。它要回答：谁修饰谁？哪个短语是主语？哪个词支配哪个词？
]

== 定义与类型

/ 句法分析 (Syntactic Parsing): 在句子层面对词序列进行形式化分析，确定句子的结构或词语之间的依存关系。

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*类型*], [*目标*], [*输出*]),
  [句法结构分析], [分析完整短语结构], [成分句法树],
  [浅层句法分析], [识别局部短语块，不构造完整树], [NP/VP等短语块],
  [依存句法分析], [分析词与词之间的支配关系], [依存弧和依存标签],
)

== 短语结构分析

/ 短语结构分析: 用 CFG 等文法把句子分解为层级短语结构。

常见符号：
- S：句子；
- NP：名词短语；
- VP：动词短语；
- PP：介词短语；
- ADJP：形容词短语；
- ADVP：副词短语。

== 依存句法分析

/ 依存句法分析: 认为句子的核心是词与词之间的依存关系，通常每个词依附于一个中心词。

常见依存关系：
#table(
  columns: (auto, auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*缩写*], [*中文*], [*说明*]),
  [SBV], [主谓关系], [主语依存于谓词],
  [VOB], [动宾关系], [宾语依存于动词],
  [ATT], [定中关系], [修饰名词的定语],
  [ADV], [状中关系], [修饰谓词的状语],
  [CMP], [动补关系], [补语补充说明动词],
  [DE], [“的”字结构], [连接定语和中心词],
)

== PCFG

/ 概率上下文无关文法 (Probabilistic Context-Free Grammar, PCFG): 在 CFG 的每条产生式上附加概率，用于选择最可能的句法树。

#formula[$ P(T) = product_(r in T) P(r) $]

其中 $T$ 是一棵句法树，$r$ 是树中使用到的产生式。

#key[PCFG优点]：在存在多棵句法树时，可以根据规则概率选择最可能的结构。

== CYK 算法

/ CYK算法: 一种自底向上的动态规划句法分析算法，要求文法转为乔姆斯基范式（CNF）。

#methodblock[
  *CYK步骤*：
  1. 将 CFG 转换为 CNF：规则形如 $A -> B C$ 或 $A -> a$。
  2. 初始化表格对角线：填入能推出每个词的非终结符。
  3. 按跨度从短到长枚举子串。
  4. 枚举切分点，将左右子结构组合。
  5. 若完整句子区间包含开始符号 $S$，则句子可由文法生成。
  6. 若需要句法树，记录回溯指针。
]

#warnbox[CYK题关键是“先范式化，再填表”。如果文法没有转成 CNF，直接套 CYK 很容易错。]

== 本章高频题

#exercise(title: [句法分析])[
  1. 比较句法结构分析、浅层句法分析、依存句法分析。
  2. 解释 S、VP、NP、PP；SBV、VOB、ATT、DE 的含义。
  3. 简述 PCFG 的特点和优势。
  4. 用 CYK 算法分析给定 CFG 和句子，注意乔姆斯基范式化和多棵结构树。
]
