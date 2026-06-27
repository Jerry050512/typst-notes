#import "../template/preamble.typ": *

= 期末复习备考指南

#knowtitle[本章把自然语言处理课程压缩成「可背、可算、可比较、可答题」的期末复习路线。先看这里建立全局框架，再回到各章补细节。]

== 考试题型分布

#warnbox[

  *考试结构*：
  - *20道选择题（40分）*：基础概念、术语定义、算法特点、易混点辨析
  - *7道简答题（42分）*：原理解释、对比分析、方法步骤、应用场景
  - *2道计算题（18分）*：语言模型概率、平滑、困惑度、HMM算法、IR评价指标
]

#infobox[

  *教学内容占比*：
  - 陈冬梅老师内容（约1/3）：偏重计算，侧重语言模型、概率图模型、信息检索的公式推导和算法步骤
  - 徐涛老师内容（约2/3）：偏重概念，侧重词法分析、句法语义、词向量、深度学习方法的原理对比

  *复习重点*：
  1. 徐涛老师PPT的课后习题务必全部掌握（简答题高度相关）
  2. practice.typ 中的计算题全部过一遍（计算题直接命中）
  3. 各章标注\*的内容是考试高频点
]

== 考试复习总览

#table(
  columns: (auto, 1fr, 1fr, auto),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else if calc.odd(row) { white } else { rgb("#f8f9fa") },
  table.header(
    text(fill: titlecolor, weight: "bold", "模块"),
    text(fill: titlecolor, weight: "bold", "核心考点"),
    text(fill: titlecolor, weight: "bold", "易错点/速记"),
    text(fill: titlecolor, weight: "bold", "分值占比"),
  ),
  [绪论], [NLP定义、研究层次、基本困难、方法范式], [歧义类型要能举例说明], [5%],
  [词法分析], [分词算法(FMM/BMM)、NER、POS、OOV处理、序列标注], [FMM从左到右，BMM从右到左；BIO vs BIOES], [15%],
  [形式语言], [文法层级、自动机对应关系、CFG、正则], [Type-0到3与自动机的对应], [8%],
  [句法分析], [短语结构vs依存、CYK、Earley、句法树], [短语结构有成分，依存只有词], [10%],
  [语义分析], [WSD、SRL(谁对谁做什么)、语义依存], [SRL的Arg0是施事，Arg1是受事], [12%],
  [词向量], [One-hot vs 分布式、CBOW vs Skip-gram、预训练], [CBOW用上下文预测中心，Skip-gram反过来], [10%],
  [信息检索], [VSM、TF-IDF、BM25、P/R/F1/MAP], [*必考计算题*：P分母是检索总数，R分母是相关总数], [15%],
  [语言模型], [链式法则、Bigram MLE、加一平滑、困惑度], [*必考计算题*：分母加V不是加1，PP越小越好], [15%],
  [概率图模型], [HMM五元组、前向后向、Viterbi、CRF], [*必考算法题*：前向用求和，Viterbi用取最大], [15%],
  [语料库], [语料库类型、建设流程、WordNet、HowNet], [HowNet的四个设计原则], [5%],
)

#warnbox[

  *复习优先级*：

  *一档（必须拿满分）*：
  - #key[语言模型计算题]：Bigram概率、加一平滑、困惑度（practice.typ 第8章全部过一遍）
  - #key[HMM算法题]：后向算法、Viterbi算法（practice.typ 第9章务必能默写步骤）
  - #key[信息检索评价]：P/R/F1/MAP计算（公式背熟，分母别搞混）

  *二档（简答题常客）*：
  - #key[词法分析]：FMM/BMM原理、序列标注方法、OOV处理
  - #key[模型对比]：HMM vs CRF、CBOW vs Skip-gram、生成式 vs 判别式
  - #key[NLP困难]：歧义性分类举例、知识依赖、上下文依赖

  *三档（选择题为主）*：
  - 文法与自动机、句法树类型、语义角色、词向量性质
]

== 必背术语速查

#table(
  columns: (auto, auto, 2fr),
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

=== NLP 为什么难？（必考）

#methodblock[
  *答题框架*（写4-5点即可）：

  1. #key[歧义性]：
     - 词法歧义："结合"（动词 vs 名词）
     - 句法歧义："咬死了猎人的狗"（谁咬谁？）
     - 语义歧义："我看见了那个人用望远镜"（谁用望远镜？）
     - 指代歧义："他对他说"（两个"他"指谁？）

  2. #key[上下文依赖]：
     - 词义："bank"在金融语境是"银行"，在地理语境是"河岸"
     - 省略："你去吗？""去。"（省略了主语和目的地）

  3. #key[知识依赖]：
     - 常识："西瓜比芝麻大"需要世界知识
     - 领域知识：医疗文本需要医学背景

  4. #key[开放性与动态性]：
     - 新词不断产生："打工人""YYDS"
     - 网络用语、方言、缩写层出不穷

  5. #key[形式化困难]：
     - 自然语言规则存在例外，难以穷尽
     - "我不是不喜欢"（双重否定表肯定）
]

#warnbox[简答题评分点：*必须举例*。光写"有歧义"不够，要写"例如'咬死了猎人的狗'可以理解为……"]

=== 词法分析包含哪些任务？

#methodblock[
  1. #key[分词]（中文特有）：将连续字符序列切分成词序列
     - 例如："自然语言处理" → "自然 语言 处理"

  2. #key[词性标注（POS Tagging）]：标注名词、动词、形容词等
     - 例如："我/r 爱/v 自然/n 语言/n 处理/v"

  3. #key[命名实体识别（NER）]：识别人名、地名、机构名等
     - 例如："<PER>李明</PER>在<LOC>北京</LOC>工作"

  4. #key[词形还原/形态分析]：
     - 英文：running → run、better → good
     - 中文较少，但有"了""着""过"等

  5. #key[未登录词（OOV）识别]：
     - 处理新词、专名、缩略语
]

=== HMM 三个基本问题（高频）

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*问题*], [*目标*], [*典型算法*]),
  [概率计算（评估）], [给定模型 $lambda=(A,B,pi)$ 和观测序列 $O$，计算 $P(O|lambda)$], [前向算法 / 后向算法],
  [学习问题（训练）], [给定观测序列，估计参数 $A, B, pi$], [监督：极大似然估计\
无监督：Baum-Welch (EM)],
  [预测/解码], [给定模型和观测，求最可能状态序列 $I^*$], [Viterbi 算法],
)

#warnbox[
  *记忆口诀*：
  - 前向算法：从前往后，用*求和* $sum$，算总概率
  - Viterbi：从前往后，用*取最大* $max$，找最优路径
  - 后向算法：从后往前，用*求和* $sum$，算总概率（另一种方式）
]

=== HMM vs CRF（超高频对比题）

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*HMM*], [*CRF*]),
  [模型类型], [*生成式*：建模联合概率 $P(X,Y)$], [*判别式*：直接建模条件概率 $P(Y|X)$],
  [独立性假设], [有*马尔可夫假设*和*观测独立性假设*], [*放宽*独立性限制],
  [特征能力], [简单：转移概率 $A$ + 发射概率 $B$], [丰富：可使用*任意上下文特征*],
  [训练复杂度], [相对简单，MLE或EM], [较复杂，需优化条件似然],
  [效果], [基线模型，速度快], [序列标注中*通常效果更好*],
  [典型应用], [早期分词、POS、语音识别], [现代分词、NER、POS],
)

#methodblock[
  *答题模板*：
  HMM是生成式模型，需要建模 $P(X,Y)$，对未见数据泛化能力较弱，且有严格的马尔可夫假设和观测独立性假设，限制了特征使用。CRF是判别式模型，直接建模 $P(Y|X)$，可以使用丰富的上下文特征，在序列标注任务中效果更好，但训练更复杂。
]

=== CBOW vs Skip-gram

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*CBOW*], [*Skip-gram*]),
  [预测方向], [用*上下文*预测*中心词*], [用*中心词*预测*上下文*],
  [训练速度], [较快（一个样本一次预测）], [较慢（一个样本多次预测）],
  [适合场景], [大语料、高频词], [小语料、低频词效果更好],
  [记忆口诀], [Context → Word], [Word → Context],
)

#intuition[
  想象你在看一个句子，中间有个空格：
  - CBOW："我 `___` 编程" → 根据"我"和"编程"预测中间是"爱"
  - Skip-gram："我 爱 编程" → 根据"爱"预测周围有"我"和"编程"
]

=== 平滑方法对比（高频）

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*方法*], [*核心思想*], [*未见N-gram如何分配概率*]),
  [加一平滑], [所有计数+1，简单粗暴], [*均分*（所有未见事件概率相同）],
  [Good-Turing], [用 $N_(r+1)$ 估计 $N_r$ 的调整计数], [*均分*剩余概率质量],
  [Katz回退], [高阶缺失时*回退*到低阶模型], [*按低阶模型分布*分配],
  [插值], [*始终*把各阶模型加权混合], [各阶都参与，*加权平均*],
)

#warnbox[

  *常考区别*：
  - Good-Turing vs Katz：
    - Good-Turing：未见事件*均分*概率
    - Katz：未见事件*按低阶分布*分配（不同未见事件概率不同）

  - 回退 vs 插值：
    - 回退：高阶可用就用高阶，*缺失才用*低阶
    - 插值：*所有阶都用*，按权重混合
]

=== 短语结构 vs 依存句法

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*短语结构（成分句法）*], [*依存句法*]),
  [基本单位], [短语成分（NP、VP、PP等）], [词与词之间的依存关系],
  [树结构], [有*非终结符*节点], [只有*词*节点，无中间成分],
  [表示方式], [树形图，有层次成分], [词与词之间的有向弧],
  [关系类型], [成分关系（如NP、VP）], [依存关系（主谓、动宾等）],
  [典型例子], [Penn Treebank], [依存树库],
)

#example(title: [句子："学生 学习 自然语言处理"])[
  *短语结构树*：
  ```
              S
           /     \
         NP       VP
         |      /    \
        学生    V      NP
              |     /    \
             学习   NP     N
                 /    \    |
               ADJ     N  处理
                |      |
               自然    语言
  ```

  *依存树*：
  ```
         学习 (root)
        /    \
     学生    处理
    (主语)  (动宾)
            |
           语言
          (定中)
            |
           自然
          (定中)
  ```
]

=== 其他易混概念

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*A*], [*B*]),
  [生成式 vs 判别式], [建模 $P(X,Y)$，如HMM、朴素贝叶斯], [建模 $P(Y|X)$，如CRF、逻辑回归],
  [静态 vs 上下文词向量], [Word2Vec一词一向量（固定）], [BERT同词不同语境不同向量],
  [回退 vs 插值], [高阶缺失*才用*低阶], [*始终*混合各阶],
  [Good-Turing vs Katz], [未见事件*均分*概率], [未见事件*按低阶分布*],
  [前向 vs Viterbi], [用*求和* $sum$，算总概率], [用*取最大* $max$，找最优路径],
)

== 必会计算题

=== 语言模型：Bigram MLE（必考）

#key[Bigram 最大似然估计公式]：

#formula[$ P(w_i | w_(i-1)) = ("count"(w_(i-1), w_i)) / ("count"(w_(i-1))) $]

#warnbox[

  *三个常见错误*：
  1. #emoji.crossmark 分母写成 $"count"(w_i)$（当前词）→ #emoji.checkmark 应该是 $"count"(w_(i-1))$（前一词）
  2. #emoji.crossmark 分母写成总词数 $N$ → #emoji.checkmark 应该是前一词出现次数
  3. #emoji.crossmark 忘记添加句首 `<BOS>` 和句尾 `<EOS>` 标记
]

#example(title: [完整计算示例])[
  *语料*："我 爱 编程 我 爱 学习"（加上标记后：`<BOS>` 我 爱 编程 `<EOS>` `<BOS>` 我 爱 学习 `<EOS>`）

  *步骤1*：统计计数
  - $"count"("我") = 2$
  - $"count"("爱") = 2$
  - $"count"(("<BOS>", "我")) = 2$
  - $"count"(("我", "爱")) = 2$
  - $"count"(("爱", "编程")) = 1$
  - $"count"(("爱", "学习")) = 1$

  *步骤2*：计算概率
  - $P("我"|"<BOS>") = 2/2 = 1$
  - $P("爱"|"我") = 2/2 = 1$
  - $P("编程"|"爱") = 1/2 = 0.5$
  - $P("学习"|"爱") = 1/2 = 0.5$

  *步骤3*：计算句子概率
  $ P("<BOS>" "我 爱 编程" "<EOS>") = \ P("我"|"<BOS>") times P("爱"|"我") times P("编程"|"爱") times P("<EOS>"|"编程") $
]

=== 加一平滑（必考）

#key[加一平滑公式]：

#formula[$ P_"Laplace"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i) + 1) / ("count"(w_(i-1)) + V) $]

#warnbox[

  *最易错点*：分母加的是*词表大小 $V$*，不是加1！

  *原因*：要保证概率归一化。如果有 $V$ 个可能的后续词，每个分子都加1，那么分母就要加 $V$ 才能保证 $sum P = 1$。
]

#example(title: [加一平滑计算])[
  *语料*："我 爱 编程"，词表 $V = {"我", "爱", "编程", "学习", "自然"}$，$|V| = 5$

  *计算 $P_"Laplace"("编程"|"爱")$*（已见）：
  - $"count"(("爱", "编程")) = 1$
  - $"count"("爱") = 1$
  - $ P_"Laplace"("编程"|"爱") = (1+1)/(1+5) = 2/6 = 1/3 $

  *计算 $P_"Laplace"("学习"|"爱")$*（未见）：
  - $"count"(("爱", "学习")) = 0$
  - $"count"("爱") = 1$
  - $ P_"Laplace"("学习"|"爱") = (0+1)/(1+5) = 1/6 $

  *验证归一化*：
  $ sum_(w in V) P("w"|"爱") = 1/3 + 1/6 + 1/6 + 1/6 + 1/6 = 6/6 = 1 " ✓" $
]

=== 困惑度 Perplexity（必考）

#key[困惑度公式]：

#formula[$ "PP"(W) = P(w_1, dots, w_N)^(-1/N) = 2^H $]

其中交叉熵：
#formula[$ H = -1/N sum_(i=1)^N log_2 P(w_i | w_1, dots, w_(i-1)) $]

#methodblock[
  *计算步骤*（按这个顺序，不会错）：

  1. *写出每个词的条件概率*：$P(w_1), P(w_2|w_1), P(w_3|w_1,w_2), dots$
  2. *对每个概率取 $log_2$*：$log_2 P(w_1), log_2 P(w_2|w_1), dots$
  3. *求和再取负平均*：$H = -1/N sum log_2 P(w_i|dots)$
  4. *计算困惑度*：$"PP" = 2^H$
]

#example(title: [困惑度完整计算])[
  *测试句子*："我 爱 编程"（3个词）

  *模型给出的概率*：
  - $P("我") = 0.5$
  - $P("爱"|"我") = 0.5$
  - $P("编程"|"爱") = 0.25$

  *步骤1*：写出条件概率（已给出）

  *步骤2*：取对数
  - $log_2(0.5) = -1$
  - $log_2(0.5) = -1$
  - $log_2(0.25) = -2$

  *步骤3*：计算交叉熵
  $ H = -1/3 times (-1 - 1 - 2) = -1/3 times (-4) = 4/3 $

  *步骤4*：计算困惑度
  $ "PP" = 2^(4/3) = 2^(1.333...) approx 2.52 $

  *解释*：困惑度2.52，意味着模型在每个位置平均"困惑"于约2.52个候选词。
]

#warnbox[

  *困惑度易错点*：
  - PP 越*小*越好（不是越大）
  - 只有测试集、词表、分词方式*完全相同*时才可比
  - 句子概率越高 → 困惑度越低 → 模型越好
]

=== 信息检索：P/R/F1（必考）

#key[核心公式]（必须背熟）：

#formula[$ P = "TP" / ("TP" + "FP") = "检索出的相关文档数" / "检索出的文档总数" $]

#formula[$ R = "TP" / ("TP" + "FN") = "检索出的相关文档数" / "所有相关文档总数" $]

#formula[$ F_1 = (2 P R) / (P + R) $]

#warnbox[

  *分母记忆法*（考试最易混）：
  - *Precision 看"我说的"*：分母是*检索总数*（我返回了多少）
  - *Recall 看"应该说的"*：分母是*相关总数*（真正有多少相关）

  *混淆矩阵*：
  #table(
    columns: (auto, auto, auto),
    stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
    inset: 6pt,
    table.header([], [检索到], [未检索到]),
    [相关], [TP], [FN],
    [不相关], [FP], [TN],
  )
]

#example(title: [P/R/F1 计算])[
  *场景*：检索系统返回10篇文档，其中7篇相关。数据库中实际有20篇相关文档。

  *已知信息*：
  - 检索出的文档总数：10篇
  - 检索出的相关文档：7篇（TP=7）
  - 检索出的不相关文档：3篇（FP=3）
  - 所有相关文档总数：20篇
  - 未检索到的相关文档：13篇（FN=13）

  *计算*：
  - $P = 7/10 = 0.7$（查得准：返回的10篇中70%是对的）
  - $R = 7/20 = 0.35$（查得全：20篇相关的只找回35%）
  - $ F_1 = (2 times 0.7 times 0.35)/(0.7 + 0.35) = 0.49/1.05 approx 0.467 $
]

=== HMM 后向算法（可能考）

#key[后向变量定义]：

#formula[$ beta_t(i) = P(o_(t+1), o_(t+2), dots, o_T | i_t=q_i, lambda) $]

表示：在时刻 $t$ 状态为 $q_i$ 的条件下，从 $t+1$ 到 $T$ 的观测序列概率。

#methodblock[
  *计算步骤*（考试默写版）：

  *1. 初始化*（$t=T$）：
  $ beta_T(i) = 1, quad i=1,2,dots,N $

  *2. 递推*（$t=T-1, T-2, dots, 1$）：
  $ beta_t(i) = sum_(j=1)^N a_(i j) b_j(o_(t+1)) beta_(t+1)(j) $

  *3. 终止*：
  $ P(O|lambda) = sum_(i=1)^N pi_i b_i(o_1) beta_1(i) $
]

#warnbox[

  *记忆要点*：
  - 后向算法从*后往前*算（$T → 1$）
  - 初始化：$beta_T(i) = 1$（规定为1）
  - 递推：从状态 $i$ 转移到 $j$，观测到 $o_(t+1)$，乘以后续的 $beta_(t+1)(j)$
  - 终止：用初始状态概率 $pi_i$ 和第一个观测 $b_i(o_1)$ 加权求和
]

=== Viterbi 算法（可能考）

#key[关键变量定义]：

#formula[$ delta_t(i) = max_(i_1, dots, i_(t-1)) P(i_t=i, i_(t-1), dots, i_1, o_t, dots, o_1 | lambda) $]

#formula[$ psi_t(i) = arg max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] $]

#methodblock[
  *计算步骤*（考试默写版）：

  *1. 初始化*（$t=1$）：
  $ delta_1(i) = pi_i b_i(o_1), quad psi_1(i) = 0 $

  *2. 递推*（$t=2,3,dots,T$）：
  $ delta_t(i) = max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] b_i(o_t) $
  $ psi_t(i) = arg max_(1 <= j <= N) [delta_(t-1)(j) a_(j i)] $

  *3. 终止*：
  $ P^* = max_(1 <= i <= N) delta_T(i), quad i_T^* = arg max_(1 <= i <= N) delta_T(i) $

  *4. 回溯*（$t=T-1, T-2, dots, 1$）：
  $ i_t^* = psi_(t+1)(i_(t+1)^*) $
]

#warnbox[

  *Viterbi vs 前向的核心区别*：
  - 前向用 #key[$sum$]（求和所有路径）
  - Viterbi 用 #key[$max$]（只保留最优路径）
  - 前向算概率，Viterbi 找最优
]

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
  Precision 看"查得准不准"，Recall 看"查得全不全"。F1 是二者的调和平均，任何一个很低都会拖低 F1。
]

== 考前速记清单

=== 必背公式（10个）

#table(
  columns: (auto, 1fr, auto),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*编号*], [*公式*], [*用途*]),
  [1], [$ P(w_i | w_(i-1)) = "count"(w_(i-1), w_i) / "count"(w_(i-1)) $], [Bigram MLE],
  [2], [$ P_"Laplace"(w_i | w_(i-1)) = ("count"(w_(i-1), w_i) + 1) / ("count"(w_(i-1)) + V) $], [加一平滑],
  [3], [$ "PP" = 2^H = P(w_1, dots, w_N)^(-1/N) $], [困惑度],
  [4], [$ H = -1/N sum_(i=1)^N log_2 P(w_i | dots) $], [交叉熵],
  [5], [$ P = "TP" / ("TP" + "FP") $], [精确率],
  [6], [$ R = "TP" / ("TP" + "FN") $], [召回率],
  [7], [$ F_1 = (2 P R) / (P + R) $], [F1值],
  [8], [$ alpha_t(i) = P(o_1, dots, o_t, i_t=q_i | lambda) $], [前向变量],
  [9], [$ delta_t(i) = max P(i_t=i, i_(t-1), dots | lambda) $], [Viterbi变量],
  [10], [$ "TF-IDF" = "TF" times "IDF" = (f_(t,d)) / (max f_(w,d)) times log(N / "df"_t) $], [TF-IDF],
)

=== 必会算法步骤（5个）

#methodblock[
  *1. FMM（正向最大匹配）*
  - 从左到右扫描
  - 每次匹配词典中最长的词
  - 匹配失败则减少一个字符

  *2. 前向算法*
  - 初始化：$ alpha_1(i) = pi_i b_i(o_1) $
  - 递推：$ alpha_(t+1)(j) = [sum_i alpha_t(i) a_(i j)] b_j(o_(t+1)) $
  - 终止：$ P(O|lambda) = sum_i alpha_T(i) $

  *3. Viterbi 算法*
  - 初始化：$ delta_1(i) = pi_i b_i(o_1) $
  - 递推：$ delta_t(i) = max_j [delta_(t-1)(j) a_(j i)] b_i(o_t) $记录 $psi_t(i)$
  - 终止：找 $max delta_T(i)$
  - 回溯：根据 $psi$ 从后往前

  *4. 困惑度计算*
  - 写出条件概率
  - 取 $log_2$
  - 求平均负对数得 $H$
  - 计算 $"PP" = 2^H$

  *5. P/R/F1 计算*
  - 数清楚 TP、FP、FN
  - $P$ 分母是检索总数
  - $R$ 分母是相关总数
  - $ F_1 = (2 "PR")/(P+R) $
]

=== 必记对比（8组）

#table(
  columns: 4,
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*A*], [*B*], [*记忆点*]),
  [HMM vs CRF], [生成式 $P(X,Y)$], [判别式 $P(Y|X)$], [CRF特征更丰富],
  [CBOW vs Skip-gram], [上下文→中心], [中心→上下文], [CBOW快，Skip-gram对低频词好],
  [前向 vs Viterbi], [求和 $sum$], [取最大 $max$], [前向算概率，Viterbi找路径],
  [Good-Turing vs Katz], [未见均分], [未见按低阶], [Katz依赖低阶模型],
  [回退 vs 插值], [缺失才用低阶], [始终混合], [插值更稳健],
  [短语 vs 依存], [有NP/VP等成分], [只有词和关系], [短语有层次，依存更直接],
  [静态 vs 上下文], [一词一向量], [同词不同向量], [BERT能处理多义词],
  [Precision vs Recall], [查得准（检索总数）], [查得全（相关总数）], [分母别搞混],
)

=== 易错点提醒（10条）

#warnbox[
  1. *Bigram 分母*：是前一词出现次数 $"count"(w_(i-1))$，不是当前词，不是总词数
  2. *加一平滑分母*：加的是词表大小 $V$，不是加1
  3. *困惑度*：越小越好（不是越大），$"PP"=2^H$
  4. *HMM 五元组*：Q、V、A、B、π，不要漏掉π（初始概率）
  5. *前向 vs Viterbi*：前向用 $sum$，Viterbi 用 $max$，别混
  6. *后向算法方向*：从后往前（$T → 1$），初始化 $beta_T(i) = 1$
  7. *Viterbi 回溯*：要记录 $psi_t(i)$，最后从后往前回溯
  8. *P/R 分母*：P 看检索总数，R 看相关总数，F1 是调和平均不是算术平均
  9. *Good-Turing vs Katz*：Good-Turing 未见均分，Katz 按低阶分布
  10. *CRF vs HMM*：CRF 是判别式，HMM 是生成式，CRF 特征更丰富
]

=== 各章核心一句话

#table(
  columns: (auto, 2fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*章节*], [*核心一句话*]),
  [绪论], [NLP难在歧义性、上下文依赖、知识依赖和形式化困难],
  [词法分析], [分词（FMM/BMM）、POS标注、NER识别实体，处理OOV用统计+规则],
  [形式语言], [Type-0到Type-3对应图灵机、LBA、下推自动机、有限自动机],
  [句法分析], [短语结构有成分层次（NP/VP），依存句法只有词间关系],
  [语义分析], [WSD消歧多义词，SRL标注"谁对谁做了什么"，篇章看连贯],
  [词向量], [Word2Vec学静态向量，BERT学上下文向量，能处理多义词],
  [信息检索], [VSM用余弦相似度，TF-IDF加权，P看准、R看全、F1调和平均],
  [语言模型], [链式法则分解，Bigram用MLE，加一平滑避免零概率，PP越小越好],
  [概率图模型], [HMM生成式三问题（前向/Viterbi/Baum-Welch），CRF判别式更强],
  [语料库], [采集-清洗-标注-质检，WordNet同义集，HowNet义原分解],
)

