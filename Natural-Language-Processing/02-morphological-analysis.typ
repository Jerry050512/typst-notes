#import "../template/preamble.typ": *

= 词法分析

#knowtitle[词法分析是NLP流水线的入口，常考分词、NER、POS、未登录词，以及“把任务转成序列标注”的思想。]

#intuition[
  计算机看到的是连续字符，而后续句法和语义分析需要“词”作为基本单位。词法分析就是先把原始文本整理成词序列，并给词贴上词性、实体类别等标签。
]

== 定义与任务

/ 词法分析 (Lexical/Morphological Analysis): 从输入字符串中识别词语边界、词形、词性和实体等词级语言信息的处理过程。

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*任务*], [*目标*], [*例子*]),
  [汉语分词], [确定词边界], [自然语言处理 → 自然语言 / 处理],
  [词性标注 POS], [给词标注语法类别], [研究/v 生命/n],
  [命名实体识别 NER], [识别人名、地名、机构名等], [杭州电子科技大学/ORG],
  [形态还原], [将变形词还原为基本形式], [running → run],
  [未登录词识别], [识别词典中没有的新词或专名], [大模型、双减、元宇宙],
)

== 基于词典的分词方法

=== 正向最大匹配 FMM

#methodblock[
  *输入*：待分词字符串、词典、最大词长 $L$。

  1. 从句子左端开始，取当前位置起长度不超过 $L$ 的最长候选串。
  2. 若候选串在词典中，则输出该词，并移动到该词之后。
  3. 若不在词典中，则候选串长度减 1 继续匹配。
  4. 若长度减到 1 仍不匹配，则按单字切分。
  5. 重复直到句子结束。
]

=== 反向最大匹配 BMM 与双向匹配

#methodblock[
  *BMM*：从右向左做最大匹配。很多汉语歧义中，BMM 的错误率通常低于 FMM。

  *双向匹配*：
  1. 分别运行 FMM 和 BMM。
  2. 若结果一致，直接采用。
  3. 若不一致，优先选词数较少者。
  4. 若词数相同，优先选单字词较少者。
  5. 仍相同则通常选 BMM。
]

#warnbox[手工分词题要写出每一步匹配结果，不要只给最终答案。题目给词典时，必须严格按词典切分，不能凭语感加词。]

== 基于字分类的分词

/ 基于字分类法: 将分词转化为字级别序列标注问题，对每个字标注其在词中的位置。

#table(
  columns: (auto, auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*标签*], [*英文*], [*含义*], [*例子*]),
  [B], [Begin], [词首字], [“研究”中的“研”],
  [I/M], [Inside/Middle], [词中字], [“自动化”中的“动”],
  [E], [End], [词尾字], [“研究”中的“究”],
  [S], [Single], [单字词], [“我”],
)

#example(title: [BIES 标注])[
  “我爱自然语言处理” 可标为：我/S 爱/S 自/B 然/I 语/I 言/E 处/B 理/E。
]

== 命名实体识别 NER

/ 命名实体识别 (Named Entity Recognition, NER): 从文本中识别具有特定意义的实体，并标注实体类别。

常见实体类型：人名 PER、地名 LOC、机构名 ORG、时间 TIME、数值 NUM、专有名词等。

=== BIO / BIOES 标注

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*标签*], [*含义*]),
  [B-X], [实体 X 的开始],
  [I-X], [实体 X 的内部],
  [O], [非实体],
  [E-X], [实体 X 的结尾（BIOES）],
  [S-X], [单字实体（BIOES）],
)

#warnbox[BIO 标注题最容易错在实体边界。机构名、人名、地名要先整体识别，再决定 B/I/E/S。]

== POS 标注与 HMM 建模

#methodblock[
  *HMM 词性标注建模*：
  1. 观测序列 $W = (w_1, w_2, dots, w_n)$：句子中的词。
  2. 隐状态序列 $T = (t_1, t_2, dots, t_n)$：词性标签。
  3. 初始概率：$P(t_1)$。
  4. 转移概率：$P(t_i | t_(i-1))$。
  5. 发射概率：$P(w_i | t_i)$。
  6. 用 Viterbi 算法搜索最可能的词性序列。
]

== HMM vs CRF vs 深度学习

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header([*方法*], [*核心思想*], [*优点*], [*缺点*]),
  [HMM], [生成式序列模型], [简单、可解释、解码快], [独立性假设强，特征有限],
  [CRF], [判别式序列标注模型], [可融合丰富上下文特征], [训练复杂],
  [BiLSTM-CRF], [神经网络提特征 + CRF全局解码], [上下文建模强], [依赖标注数据],
  [BERT类模型], [预训练上下文表示 + token分类], [处理OOV和语义上下文强], [计算成本高],
)

== 未登录词 OOV

/ 未登录词 (Out-of-Vocabulary, OOV): 词典中不存在但文本中出现的词，如新词、专名、缩略语和网络词。

处理策略：
- 利用构词规则和词典更新；
- 将分词转为字级序列标注；
- 用 HMM、CRF、BiLSTM-CRF 或 BERT 学习上下文模式；
- 与 NER 结合识别人名、地名、机构名。

== 本章高频题

#exercise(title: [词法分析])[
  1. 简述基于字分类法的分词方法原理。
  2. 简述命名实体识别的概念及常见实体类别。
  3. 列举北大版词性标注集中常见代码：n、v、a、d、m、q、r、p、c、u。
  4. 如何利用 HMM 建立词性标注器？
  5. 给定词典和句子，分别用 FMM 与 BMM 分词。
]
