#import "../template/preamble.typ": *

= 预训练词向量

#knowtitle[本章重点是词表示方法的演进：One-hot → 分布式表示 → Word2Vec静态词向量 → BERT/GPT上下文表示。常考比较题。]

== 传统词表示

=== One-hot 表示

/ One-hot表示: 用词表长度的稀疏向量表示词，每个词只有一个维度为 1。

优点：简单、无需训练或标注数据；缺点：维度高、稀疏、无法表达语义相似性。

=== 分布式表示

/ 分布式表示 (Distributed Representation): 用低维稠密向量表示词，使语义相近的词在向量空间中距离更近。

#intuition[One-hot 像“身份证号”，只能区分身份；词向量像“性格画像”，能表示词之间相似与差异。]


== 词表示发展路线

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*阶段*], [*核心思想*]),
  [One-hot], [离散稀疏，不能表达相似性],
  [LSA], [词项-文档矩阵 + SVD，获得潜在语义空间],
  [HAL], [滑动窗口统计词-词共现，距离越近权重越高],
  [NNLM/RNNLM], [神经网络语言模型中学习词向量],
  [Word2Vec/GloVe], [局部预测或全局共现学习静态词向量],
  [ELMo/BERT/GPT], [根据上下文动态生成词表示],
)

#intuition[分布语义假设：“You shall know a word by the company it keeps.” 词义可以由它经常出现的上下文来刻画。]

=== LSA、GloVe 与 ELMo 速记

- #key[LSA]：构建词项-文档矩阵 $C$，做 $C=U Sigma V^T$，降维后缓解稀疏并挖掘潜在语义。
- #key[GloVe]：利用全局词-上下文共现矩阵做回归/隐式矩阵分解；Word2Vec 更偏局部窗口预测。
- #key[ELMo]：基于双向 LSTM 的上下文词向量；同一个词在不同句子中向量不同，字符级输入有利于处理 OOV。


== Word2Vec

/ Word2Vec: 通过预测上下文或中心词学习静态词向量的神经网络模型，代表模型包括 CBOW 和 Skip-gram。

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*CBOW*], [*Skip-gram*]),
  [预测方向], [用上下文预测中心词], [用中心词预测上下文],
  [训练速度], [较快], [较慢],
  [低频词效果], [相对较弱], [通常更好],
  [记忆口诀], [Context → Word], [Word → Context],
)

== 训练优化

Word2Vec 常用两种优化方法：
- #key[层次 Softmax]：用 Huffman 树降低计算复杂度；
- #key[负采样]：只更新少量负例，训练更高效。


#warnbox[Word2Vec 负采样的原因：标准 Softmax 需要对整个词表归一化，词表大时计算很慢。负采样把“预测中心词/上下文”改成二分类，只计算真实共现正例和少量随机负例，大幅提高训练效率。]


== 静态词向量 vs 动态词向量

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header([*对比项*], [*静态词向量*], [*动态/上下文词向量*]),
  [代表], [Word2Vec、GloVe、FastText], [ELMo、BERT、GPT],
  [一词多义], [同一个词只有一个向量], [同一个词在不同上下文有不同表示],
  [上下文], [训练后固定，不依赖句子上下文], [根据上下文动态生成],
  [优点], [简单高效], [语义表达强],
  [缺点], [无法解决一词多义], [计算成本高],
)

== 预训练语言模型

/ 预训练语言模型: 在大规模语料上先学习通用语言表示，再迁移到下游任务的模型。

典型范式：
- BERT：双向 Transformer Encoder，适合理解任务；
- GPT：自回归 Transformer Decoder，适合生成任务；
- T5：Encoder-Decoder，把任务统一成文本到文本。

== 本章高频题

#exercise(title: [词向量])[
  1. One-hot 表示有什么缺点？
  2. 什么是分布式词表示？它解决了什么问题？
  3. 比较 CBOW 和 Skip-gram。
  4. 比较静态词向量和上下文词向量。
  5. 简述 NLP 技术四次范式变迁及预训练模型的作用。
]
