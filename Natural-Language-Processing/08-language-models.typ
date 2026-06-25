#import "../template/preamble.typ": *

= 语言模型

#knowtitle[语言模型重点：链式法则、N-gram概率计算（MLE）、平滑（加一平滑）、困惑度计算。必考计算题。]

#intuition[
  语言模型的核心任务：判断一个句子是否"像人话"。"狗又咬人了"比"人又咬狗了"更常见，或者在"我今天去"后面预测"上课/学校/吃饭"的概率。
]

== 定义\*

/ 语言模型 (Language Model, LM): 刻画词序列在真实语言中出现概率的模型，用于计算句子的概率或预测下一个词。

#key[链式法则]：

#formula[$ P(w_1, w_2, dots, w_n) = product_(i=1)^n P(w_i | w_1, dots, w_(i-1)) $]

#example(title: [链式法则分解])[
  句子："我 爱 自然 语言 处理"

  $ P("我 爱 自然 语言 处理") = \ P("我") times P("爱"|"我") times P("自然"|"我 爱") times P("语言"|"我 爱 自然") times P("处理"|"我 爱 自然 语言") $
]

#key[句首句尾标记]：
- `<BOS>`（Beginning of Sentence）：句首标记
- `<EOS>`（End of Sentence）：句尾标记

#example(title: [带标记的概率计算])[
  `P(John read a book) = P(John|<BOS>) × P(read|John) × P(a|read) × P(book|a) × P(<EOS>|book)`
]

== N-gram 模型\*

/ N-gram模型: 基于马尔可夫假设，认为当前词只依赖前 $n-1$ 个词，用于简化概率计算。

#key[马尔可夫假设]：当前词的出现只与前面有限个词相关，与更早的词无关。

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

=== 最大似然估计（MLE）\*

#formula[$ P_"MLE"(w_i) = ("count"(w_i)) / N $]

其中 $N$ 是语料中的总词数。

#formula[$ P_"MLE"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i)) / ("count"(w_(i-1))) $]

#warnbox[

  *Bigram MLE 计算要点*：
  - *分子*：二元组 $(w_(i-1), w_i)$ 在语料中出现的次数
  - *分母*：前一词 $w_(i-1)$ 出现的次数
  - 注意：分母是前一词 $w_(i-1)$ 的出现次数，不是当前词 $w_i$ 的出现次数，也不是语料总词数
]

#example(title: [Bigram MLE 计算])[
  给定语料："我 爱 自然 语言 处理 我 爱 编程"

  计算 $P("爱" | "我")$：
  - $"count"("我", "爱") = 2$（"我 爱"出现2次）
  - $"count"("我") = 2$（"我"出现2次）
  - $P("爱" | "我") = 2/2 = 1$

  计算 $P("编程" | "爱")$：
  - $"count"("爱", "编程") = 1$
  - $"count"("爱") = 2$
  - $P("编程" | "爱") = 1/2 = 0.5$
]

== 数据稀疏与平滑\*

/ 数据稀疏: 很多合理的 N-gram 在训练语料中没有出现，导致 MLE 给出 0 概率，进而使整个句子概率为 0。

#key[数据稀疏的根源]：

1. *参数爆炸*：
   - 词表大小为 $V$，Bigram 需要估计 $V^2$ 个参数
   - Trigram 需要 $V^3$ 个参数
   - 参数量随阶数指数增长

2. *Zipf 定律*：
   - 词频与排名近似满足：$f times r approx k$
   - 大量低频词长期存在，很多合理组合未在训练集出现

3. *零概率问题*：
   - 如果某个 N-gram 概率为 0，整个句子概率乘积为 0
   - 即使句子合理，也会被判定为不可能出现

=== 加一平滑（Laplace Smoothing）\*

#key[核心思想]：给所有 N-gram（包括未见过的）都加上一个小的计数（通常为1），避免零概率。

#formula[$ P_"Laplace"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i) + 1) / ("count"(w_(i-1)) + V) $]

其中：
- *分子*：原始计数 + 1
- *分母*：原始计数 + 词表大小 $V$
- $V$ 是词汇表大小（不同词的总数）

#warnbox[

  *加一平滑要点*：
  - 分母加的是词表大小 $V$，而不是加1
  - 原因：要保证概率归一化，即 $sum_(w_i in V) P(w_i | w_(i-1)) = 1$
  - 如果有 $V$ 个可能的后续词，每个都在分子上加1，那么分母就要加 $V$
]

#example(title: [加一平滑计算])[
  给定语料："我 爱 自然 语言 处理"（共5个词）

  假设词表 $V = {"我", "爱", "自然", "语言", "处理"}$，$|V| = 5$

  计算 $P("处理" | "语言")$ 的加一平滑概率：
  - $"count"("语言", "处理") = 1$
  - $"count"("语言") = 1$
  - $P_"Laplace"("处理" | "语言") = (1 + 1) / (1 + 5) = 2/6 = 1/3$

  计算未见 N-gram $P("自然" | "处理")$ 的加一平滑概率：
  - $"count"("处理", "自然") = 0$（语料中未出现）
  - $"count"("处理") = 1$
  - $P_"Laplace"("自然" | "处理") = (0 + 1) / (1 + 5) = 1/6$
]

#intuition[
  加一平滑简单但粗糙：它给所有未出现事件分配相同概率，往往把过多概率质量分给低频/未见事件，并压低高频事件概率。实践中效果一般，更好的方法有 Good-Turing、Kneser-Ney 等。
]

=== 其他平滑方法速记

*Good-Turing 估计*：

#formula[$ r^* = (r + 1) N_(r+1) / N_r $]

其中 $N_r$ 表示恰好出现 $r$ 次的 N-gram 个数。核心思想：用出现 $r+1$ 次的 N-gram 数量来调整出现 $r$ 次的 N-gram 的概率。

*回退（Back-off）与插值（Interpolation）*：

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*方法*], [*核心思想*], [*特点*]),
  [回退 Back-off], [高阶 N-gram 缺失时退到低阶模型], [利用多阶信息],
  [插值 Interpolation], [把不同阶 N-gram 加权求和], [不会完全依赖某一阶],
  [Kneser-Ney], [低阶概率看"作为新续接词的能力"], [经典强基线，效果最好],
)

#intuition[
  回退：高阶不行就往低阶退，如 Trigram → Bigram → Unigram。插值：把各阶模型按权重混合，如 $lambda_1 P_1 + lambda_2 P_2 + lambda_3 P_3$，其中 $lambda_1 + lambda_2 + lambda_3 = 1$。
]

== 神经网络语言模型\*

/ 神经网络语言模型 (Neural Network Language Model, NNLM): 用神经网络模型代替条件概率模型，基于分布式词向量建模语言规律。

#key[核心思想]：
- 将词表示为低维稠密向量（词向量/词嵌入）
- 用神经网络学习条件概率 $P(w_i | w_(i-n+1), dots, w_(i-1))$
- 自动学习词与词之间的相似性

#key[相比 N-gram 的优势]：

1. *缓解数据稀疏*：
   - N-gram：每个词序列独立计数，未见过的组合概率为0
   - NNLM：通过词向量的相似性泛化，"我爱编程"和"我喜欢编程"共享知识

2. *利用词语相似性*：
   - N-gram：把"计算机"和"电脑"视为完全不同的词
   - NNLM：相似词有相似的向量表示，可以相互借鉴

3. *更长的上下文*：
   - N-gram：Trigram 只能看前2个词，再长会导致参数爆炸
   - NNLM：RNN/LSTM/Transformer 可以建模更长甚至整个句子的上下文

#key[主要缺点]：
- 训练成本更高（需要大量计算资源）
- 推理速度较慢（相比简单的查表）
- 可解释性较弱（黑盒模型）

#key[典型架构]：
- *NNLM*：前馈神经网络 + 词向量
- *RNNLM*：循环神经网络（RNN/LSTM/GRU）
- *Transformer LM*：自注意力机制（GPT 系列）

== 评价标准\*

=== 困惑度（Perplexity）\*

/ 困惑度 (Perplexity, PP): 衡量语言模型对测试文本的不确定性；困惑度越低，模型性能越好。

#key[直觉理解]：
- 困惑度表示模型在预测下一个词时"困惑"的程度
- 如果模型很确定下一个词，困惑度低
- 如果模型不确定（概率分布很平均），困惑度高

#formula[$ "PP"(W) = P(w_1, dots, w_N)^(-1/N) $]

等价形式：
#formula[$ "PP"(W) = 2^H $]

其中 $H$ 是交叉熵：
#formula[$ H = -1/N sum_(i=1)^N log_2 P(w_i | w_1, dots, w_(i-1)) $]

#methodblock[
  *困惑度计算步骤*：

  1. *计算条件概率*：对测试序列中每个词，计算其条件概率
     - $P(w_1 | "context")$，$P(w_2 | "context")$，...，$P(w_N | "context")$

  2. *取对数*：对每个概率取 $log_2$
     - $log_2 P(w_1)$，$log_2 P(w_2)$，...

  3. *求平均负对数*（交叉熵）：
     - $H = -1/N sum_(i=1)^N log_2 P(w_i | "context")$

  4. *计算困惑度*：
     - $"PP" = 2^H$
]

#example(title: [困惑度计算])[
  给定测试句子："我 爱 编程"（3个词）

  假设模型给出的条件概率：
  - $P("我") = 0.5$
  - $P("爱" | "我") = 0.25$
  - $P("编程" | "我 爱") = 0.125$

  *步骤1*：计算句子概率
  $ P("我 爱 编程") = 0.5 times 0.25 times 0.125 = 0.015625 $

  *步骤2*：计算困惑度
  $ "PP" = (0.015625)^(-1/3) = (1/0.015625)^(1/3) = (64)^(1/3) = 4 $

  *或者用对数形式*：
  - $log_2 P("我") = log_2(0.5) = -1$
  - $log_2 P("爱"|"我") = log_2(0.25) = -2$
  - $log_2 P("编程"|"我 爱") = log_2(0.125) = -3$
  - $H = -1/3 times (-1 - 2 - 3) = -1/3 times (-6) = 2$
  - $"PP" = 2^2 = 4$

  *解释*：困惑度为4，意味着模型在每个位置平均"困惑"于4个候选词。
]

#warnbox[
  - 困惑度越小越好，表示模型预测越准确
  - 只有在测试集、词元化方式、词表定义相同时，不同模型的困惑度才可比
  - 英语文本中，N-gram 模型的困惑度范围大致为 50~1000
  - 困惑度的本质：当多个语言模型比较时，对同一测试集，模型计算出的句子总概率越大，困惑度越小，模型越好
]

=== BLEU 与 ROUGE 速记

#table(
  columns: (auto, auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*指标*], [*常用场景*], [*核心思想*]),
  [Perplexity], [语言模型评价], [越低说明模型越不困惑，预测越准确],
  [BLEU], [机器翻译], [基于 N-gram 精确率（Precision），候选译文与参考译文越重合越好],
  [ROUGE], [自动摘要], [基于 N-gram 召回率（Recall），摘要覆盖参考答案关键信息越多越好],
)

#intuition[
  BLEU 偏精确：翻译的每个词是否都在参考中（不能乱说）。ROUGE 偏召回：参考中的重要信息是否都被摘要覆盖（不能漏说）。两者常同时使用以综合评估。
]

== 预训练语言模型速记

#key[GPT vs BERT]：

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*模型*], [*架构与训练*], [*特点与应用*]),
  [GPT], [自回归 Transformer Decoder，从左到右预测下一个词], [单向，适合生成任务（文本生成、对话）],
  [BERT], [双向 Transformer Encoder，MLM（掩码语言模型）+ NSP], [双向，适合理解任务（分类、NER、问答）],
)

== 本章高频题

#exercise(title: [语言模型])[
  1. 写出语言模型的链式法则分解。
  2. 给定语料，计算 unigram/bigram/trigram 的 MLE 概率。
  3. 用加一平滑计算 bigram 概率，注意分母要加词表大小 $V$。
  4. 计算困惑度 PP：先算条件概率，取对数，求平均，最后 $2^H$。
  5. 比较 N-gram 语言模型和神经网络语言模型的优缺点。
  6. 解释困惑度的含义，并说明为什么困惑度越小越好。
]
