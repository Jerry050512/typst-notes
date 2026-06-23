#import "../template/preamble.typ": *

= 期末复习备考指南

#knowtitle[本章把自然语言处理课程压缩成“可背、可算、可比较、可答题”的期末复习路线。先看这里建立全局框架，再回到各章补细节。]

== 考试复习总览

#table(
  columns: (auto, 1fr, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "模块"),
    text(fill: titlecolor, weight: "bold", "高频考点"),
    text(fill: titlecolor, weight: "bold", "常见题型"),
    text(fill: titlecolor, weight: "bold", "复习策略"),
  ),
  [绪论], [NLP定义、研究层次、基本困难、方法范式], [名词解释/简答/选择], [背定义+能举例说明歧义],
  [词法分析], [分词、NER、POS、OOV、BIO/BIOES], [简答/标注题], [会手算FMM/BMM，会写序列标注流程],
  [形式语言与自动机], [文法、自动机、正则语言、CFG], [概念/推导], [记住 Chomsky 层级与自动机对应关系],
  [句法分析], [CFG、短语结构、依存句法、句法分析方法], [画树/比较/简答], [能区分短语结构树和依存树],
  [语义分析], [WSD、SRL、语义依存、篇章语义], [简答/应用题], [抓住“消歧”和“谁对谁做了什么”],
  [词向量], [One-hot、分布式表示、Word2Vec、CBOW/Skip-gram、Transformer预训练], [比较/简答], [会比较静态词向量和上下文词向量],
  [信息检索], [布尔模型、VSM、TF-IDF、BM25、评价指标], [计算/简答], [公式必须会用，P/R/F1/MAP/NDCG要分清],
  [语言模型], [链式法则、N-gram、平滑、困惑度、神经LM], [计算题/比较], [重点练概率、加一平滑、PP计算],
  [概率图模型], [HMM、前向后向、Viterbi、最大熵、CRF], [算法步骤/计算/比较], [这是算法大题核心，步骤必须能默写],
  [语料库], [语料库类型、建设流程、标注一致性], [简答], [按“采集-清洗-标注-质检-应用”答],
)

#warnbox[
  *复习优先级*：如果时间有限，优先掌握 #key[词法分析 + 语言模型 + HMM/CRF + 信息检索评价]。这些章节最容易出“步骤题/计算题/比较题”，也最容易拉开分数。
]

== 必背术语速查

#table(
  columns: (1fr, 1fr, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*中文*], [*英文/缩写*], [*一句话解释*]),
  [自然语言处理], [Natural Language Processing, NLP], [让计算机理解、处理和生成自然语言的技术体系],
  [词法分析], [Lexical/Morphological Analysis], [把原始文本转换为词、词性、实体等基础语言单元],
  [命名实体识别], [Named Entity Recognition, NER], [识别人名、地名、机构名、时间等专名实体],
  [词性标注], [Part-of-Speech Tagging, POS], [给每个词标注名词、动词、形容词等语法类别],
  [词义消歧], [Word Sense Disambiguation, WSD], [根据上下文判断多义词的具体含义],
  [语义角色标注], [Semantic Role Labeling, SRL], [识别谓词及其施事、受事、时间、地点等角色],
  [信息检索], [Information Retrieval, IR], [从文档集合中找出与用户查询相关的文档],
  [语言模型], [Language Model, LM], [给词序列分配概率，并预测下一个词],
  [隐马尔可夫模型], [Hidden Markov Model, HMM], [隐藏状态序列生成可观测序列的概率模型],
  [条件随机场], [Conditional Random Field, CRF], [直接建模 $P(Y|X)$ 的判别式序列标注模型],
  [困惑度], [Perplexity, PP], [衡量语言模型预测测试文本时的平均不确定性],
)

== 高频简答题模板

=== NLP 为什么难？

#methodblock[
  *答题模板*：自然语言处理困难的根源在于自然语言不是严格形式化系统，具有开放性、歧义性和强语境依赖。

  1. #key[歧义性]：同一表达可能有多种解释，包括词法歧义、句法歧义、语义歧义和指代歧义。
  2. #key[上下文依赖]：词义和句义需要结合上下文、说话人意图和语境判断。
  3. #key[知识依赖]：很多理解依赖常识、世界知识和领域知识。
  4. #key[开放性]：新词、新句式、网络用语不断出现，规则难以穷尽。
  5. #key[形式化困难]：自然语言规则存在例外，难以像程序语言一样完全精确定义。
]

#warnbox[简答题不要只写“语言有歧义”。至少要写出歧义类型并举例，例如“咬死了猎人的狗”可产生句法歧义。]

=== 词法分析包含哪些任务？

#methodblock[
  1. #key[分词]：将连续字符序列切分成词序列，汉语中尤其重要。
  2. #key[词性标注]：为每个词标注名词、动词、形容词等类别。
  3. #key[命名实体识别]：识别人名、地名、机构名、时间、数值等实体。
  4. #key[形态还原/词形分析]：处理英文中 running → run、better → good 等形态变化。
  5. #key[未登录词识别]：识别词典中不存在的新词、专名和缩略语。
]

=== HMM 三个基本问题

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*问题*], [*目标*], [*典型算法*]),
  [概率计算], [给定模型 $lambda$ 和观测序列 $O$，计算 $P(O|lambda)$], [前向算法 / 后向算法],
  [学习问题], [给定观测序列，估计 $A, B, pi$], [监督极大似然 / Baum-Welch],
  [预测/解码], [给定模型和观测序列，求最可能状态序列], [Viterbi 算法],
)

== 必会计算题

=== N-gram 概率计算

#formula[$ P(w_1, dots, w_n) = product_(i=1)^n P(w_i | w_1, dots, w_(i-1)) $]

Bigram 近似：
#formula[$ P(w_1, dots, w_n) approx product_(i=1)^n P(w_i | w_(i-1)) $]

最大似然估计：
#formula[$ P(w_i | w_(i-1)) = ("count"(w_(i-1), w_i)) / ("count"(w_(i-1))) $]

#warnbox[
  *最常见错误*：Bigram 的分母是前一个词出现次数 $"count"(w_(i-1))$，不是语料总词数，也不是当前词出现次数。
]

=== 加一平滑

#formula[$ P_"Laplace"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i) + 1) / ("count"(w_(i-1)) + V) $]

其中 $V$ 是词汇表大小，即不同词的个数。

=== 困惑度 PP

#formula[$ "PP"(W) = P(w_1, dots, w_N)^(-1/N) = 2^(-1/N sum_(i=1)^N log_2 P(w_i | w_1, dots, w_(i-1))) $]

#methodblock[
  *计算步骤*：
  1. 写出每个词的条件概率。
  2. 对概率取 $log_2$。
  3. 求平均负对数，得到交叉熵 $H$。
  4. 计算 $"PP" = 2^H$。
]

#warnbox[在测试集、词元化方式和词表定义相同的前提下，困惑度越小，模型越好；它可以理解为“模型预测下一个词时平均面对多少个等可能候选”。]

== 易混概念辨析

=== HMM vs CRF

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*HMM*], [*CRF*]),
  [模型类型], [生成式模型，建模 $P(X,Y)$], [判别式模型，直接建模 $P(Y|X)$],
  [独立性假设], [有马尔可夫假设和观测独立性假设], [放宽独立性限制，可使用丰富上下文特征],
  [特征能力], [主要依赖转移概率和发射概率], [可加入任意特征模板],
  [典型任务], [分词、POS、语音识别早期模型], [分词、NER、POS 等序列标注],
  [考试结论], [简单高效但表达能力有限], [效果通常更好但训练更复杂],
)

=== CBOW vs Skip-gram

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*CBOW*], [*Skip-gram*]),
  [预测方向], [用上下文预测中心词], [用中心词预测上下文],
  [训练速度], [较快], [较慢],
  [适合场景], [大语料、高频词], [小语料、低频词效果更好],
  [记忆口诀], [Context → Word], [Word → Context],
)

=== Precision / Recall / F1

#formula[$ P = "检索出的相关文档数" / "检索出的文档总数" $]
#formula[$ R = "检索出的相关文档数" / "所有相关文档总数" $]
#formula[$ F_1 = (2 P R) / (P + R) $]

#warnbox[
  Precision 看“查得准不准”，Recall 看“查得全不全”。F1 是二者的调和平均，任何一个很低都会拖低 F1。
]

== 考前复习路线

=== 考前一周

1. 每天背一轮术语表，重点记英文缩写：NLP、NER、POS、WSD、SRL、IR、LM、HMM、CRF、PP。
2. 完成 3 类计算题：N-gram 概率、加一平滑、Precision/Recall/F1/PP。
3. 默写 HMM 三问题、前向算法、Viterbi 算法、HMM vs CRF。
4. 将词法、句法、语义、信息检索、语言模型各章的“习题要点”整理成简答题答案。

=== 考前一天

1. 只看本章速查表和各章 `#warnbox`。
2. 默写高频简答模板，不再扩展新内容。
3. 把公式中的分母、单位、符号意义检查一遍。
4. 对易混概念做最后对比：HMM/CRF、CBOW/Skip-gram、Precision/Recall、词法/句法/语义。
