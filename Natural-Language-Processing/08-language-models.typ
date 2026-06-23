#import "../template/preamble.typ": *

= 语言模型

#knowtitle[语言模型是计算题重点：链式法则、N-gram概率、平滑、困惑度必须会算；神经网络语言模型常考简答和比较。]

== 定义

/ 语言模型 (Language Model, LM): 刻画词序列在真实语言中出现概率的模型。

#formula[$ P(w_1, w_2, dots, w_n) = product_(i=1)^n P(w_i | w_1, dots, w_(i-1)) $]

#intuition[语言模型要判断“狗又咬人了”比“人又咬狗了”更常见，或者在“我今天去”后面预测“上课/学校/吃饭”的概率。]

== N-gram 模型
#example(title: [句首句尾标记])[
  计算句子概率时常加入 `<BOS>` 和 `<EOS>`：
  `P(John read a book) = P(John|<BOS>) P(read|John) P(a|read) P(book|a) P(<EOS>|book)`。
]




/ N-gram模型: 基于马尔可夫假设，认为当前词只依赖前 $n-1$ 个词。

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*模型*], [*假设*], [*估计公式*]),
  [Unigram], [词之间相互独立], [$P(w_i)$],
  [Bigram], [当前词只依赖前一词], [$P(w_i | w_(i-1))$],
  [Trigram], [当前词依赖前两词], [$P(w_i | w_(i-2), w_(i-1))$],
)

最大似然估计：
#formula[$ P_"MLE"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i)) / ("count"(w_(i-1))) $]

#warnbox[Bigram 分母是前一词出现次数，不是当前词出现次数，也不是语料总词数。]

== 数据稀疏与平滑

/ 数据稀疏: 很多合理的 N-gram 在训练语料中没有出现，MLE 会给出 0 概率。


=== 数据稀疏根源

- 参数爆炸：词表大小为 $V$，N-gram 阶数越高，需要估计的条件概率越多。
- Zipf 定律：词频与排名近似满足 $f times r approx k$，大量低频词长期存在。
- 零概率问题：合理词序列可能训练集中没出现，MLE 会把整个句子概率乘成 0。


=== 加一平滑

#formula[$ P_"Laplace"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i) + 1) / ("count"(w_(i-1)) + V) $]

$V$ 是词汇表大小。

=== Good-Turing 估计

#formula[$ r^* = (r + 1) N_(r+1) / N_r $]

其中 $N_r$ 表示恰好出现 $r$ 次的 N-gram 个数。

=== 回退、插值与 Kneser-Ney

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*方法*], [*核心思想*], [*特点*]),
  [回退 Back-off], [高阶 N-gram 缺失时退到低阶模型], [利用多阶信息],
  [插值 Interpolation], [把不同阶 N-gram 加权求和], [不会完全依赖某一阶],
  [Kneser-Ney], [低阶概率看“作为新续接词的能力”], [经典强基线，效果好],
)

== 神经网络语言模型

/ 神经网络语言模型 (NNLM): 用神经网络和分布式词向量建模条件概率。

优点：
- 缓解 N-gram 数据稀疏；
- 利用词向量表达词语相似性；
- RNN/LSTM/Transformer 可建模更长上下文。

缺点：训练成本更高，可解释性弱。


#warnbox[加一平滑简单但粗糙：它给所有未出现事件分配相同概率，往往把过多概率质量给低频/未见事件，并压低高频事件概率。]

=== Katz 回退与插值

- 回退：高阶 N-gram 不可靠时退到低阶模型，并用归一化系数调整概率质量。
- 插值：把 unigram、bigram、trigram 按权重加权求和，权重和为 1。


== 评价：困惑度

/ 困惑度 (Perplexity, PP): 衡量语言模型对测试文本的不确定性，越低越好。

#formula[$ "PP"(W) = P(w_1, dots, w_N)^(-1/N) $]
#formula[$ "PP"(W) = 2^(-1/N sum_(i=1)^N log_2 P(w_i | w_1, dots, w_(i-1))) $]

#methodblock[
  *PP计算步骤*：
  1. 写出测试序列中每个词的条件概率。
  2. 对每个概率取 $log_2$。
  3. 求平均负对数，即交叉熵 $H$。
  4. 计算 $"PP" = 2^H$。
]


=== BLEU 与 ROUGE

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*指标*], [*常用场景*], [*核心思想*]),
  [Perplexity], [语言模型], [越低说明模型越不困惑],
  [BLEU], [机器翻译], [基于 N-gram 精确率，候选译文与参考译文越重合越好],
  [ROUGE], [自动摘要], [偏召回率，摘要覆盖参考答案关键信息越多越好],
)

=== GPT 与 BERT 速记

- GPT：自回归 Transformer Decoder，按从左到右预测下一个词，适合生成。
- BERT：双向 Transformer Encoder，采用 MLM 和 NSP 训练，适合理解任务。


== 本章高频题

#exercise(title: [语言模型])[
  1. 写出语言模型的链式法则分解。
  2. 给定语料，计算 unigram/bigram/trigram 的 MLE 概率。
  3. 用加一平滑计算 bigram 概率，注意词表大小 $V$。
  4. 计算困惑度 PP，并说明 PP 越小越好。
  5. 比较 N-gram 语言模型和神经网络语言模型。
]
