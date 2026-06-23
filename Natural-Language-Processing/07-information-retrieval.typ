#import "../template/preamble.typ": *

= 信息检索

#knowtitle[信息检索章节重点是检索模型和评价指标。计算题常围绕 Precision、Recall、F1、AP/MAP、NDCG、TF-IDF、BM25。]

== 定义与框架

/ 信息检索 (Information Retrieval, IR): 根据用户查询，从大规模文档集合中找出相关文档并排序的过程。

#methodblock[
  *典型检索流程*：
  1. 文档采集与预处理：分词、去停用词、规范化。
  2. 建立索引：倒排索引记录词到文档的映射。
  3. 查询处理：对用户查询做同样预处理。
  4. 相关性计算：计算查询与文档的匹配程度。
  5. 排序输出：按相关性得分返回结果。
]

== 基本模型

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*模型*], [*核心思想*], [*特点*]),
  [布尔模型], [用 AND/OR/NOT 精确匹配], [简单但不能排序],
  [向量空间模型 VSM], [把查询和文档表示成向量], [可用余弦相似度排序],
  [概率模型], [估计文档与查询相关的概率], [BM25 是经典代表],
  [语言模型], [估计查询由文档语言模型生成的概率], [从生成概率角度建模检索],
)


== VSM 信息检索框架三关键点

#methodblock[
  1. #key[索引项选择]：从文档中选择能代表内容的词项，可做分词、词性过滤、同义词归并。
  2. #key[权重计算]：为索引项赋权，常用 TF-IDF 表示词在文档中的局部重要性和全局区分度。
  3. #key[相似度评价]：把查询和文档都表示为向量，用余弦相似度等方法排序返回。
]

== LSI 隐性语义标引

/ LSI (Latent Semantic Indexing): 对词项-文档矩阵做奇异值分解，将词项和文档映射到低维潜在语义空间中再检索。

#formula[$ C = U Sigma V^T $]

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*矩阵*], [*含义*]),
  [$C$], [原始词项-文档矩阵：行是词项，列是文档，元素是词项权重],
  [$U$], [左奇异向量，描述词项与潜在语义维度的关系；带尺度的低维词项坐标通常取 $U_k Sigma_k$],
  [$Sigma$], [奇异值对角矩阵，奇异值越大表示该语义维度越重要],
  [$V^T$], [右奇异向量的转置，描述文档与潜在语义维度的关系；带尺度的文档坐标通常取 $Sigma_k V_k^T$],
)

#key[LSI 优势]：降维降噪；缓解一义多词导致的漏检；在低维语义空间中计算相似度，泛化更好。其局限是每个词项仍只有一个整体表示，不能可靠区分同一词的多个词义。


== TF-IDF 与余弦相似度

#formula[$ "tf-idf"(t,d) = "tf"(t,d) dot "idf"(t) $]
#formula[$ "idf"(t) = log(N / "df"(t)) $]
#formula[$ cos(q,d) = (q dot d) / (||q|| dot ||d||) $]

其中：
- $N$：文档总数；
- $"df"(t)$：包含词 $t$ 的文档数；
- TF 反映词在文档中的重要性，IDF 降低常见词权重。

#warnbox[IDF 的直觉：越少文档包含的词，区分能力越强，IDF 越高。]

== BM25

/ BM25: 基于概率检索思想的排序函数，是搜索引擎中常用的经典相关性模型。

#formula[$ "score"(q,d) = sum_(t in q) "IDF"(t) dot (("tf"(t,d) dot (k_1 + 1)) / ("tf"(t,d) + k_1 dot (1 - b + b dot |d| / "avgdl"))) $]

参数含义：
- $k_1$：控制词频饱和；
- $b$：控制文档长度归一化；
- $|d|$：文档长度；
- $"avgdl"$：平均文档长度。

== 评价指标

=== Precision / Recall / F1

#formula[$ P = "检索出的相关文档数" / "检索出的文档总数" $]
#formula[$ R = "检索出的相关文档数" / "所有相关文档总数" $]
#formula[$ F_1 = (2 P R) / (P + R) $]

#key[记忆]：Precision 看“查得准”，Recall 看“查得全”。

=== AP / MAP

/ AP (Average Precision): 对某个查询，在每个相关文档被检索到的位置计算 Precision，并取平均。
/ MAP (Mean Average Precision): 多个查询 AP 的平均。

#formula[$ "AP" = 1/R sum_(k=1)^N P(k) dot "rel"(k) $]

其中 $R$ 是该查询的全部相关文档数，$"rel"(k)$ 表示排名 $k$ 处是否为相关文档；未检出的相关文档贡献为 0。

=== NDCG

/ NDCG: 考虑相关性等级和排序位置的评价指标，越相关的文档越应该排在前面。


== 问答系统 QA

/ 问答系统 (Question Answering, QA): 用户用自然语言提问，系统从文本、网页、知识库或模型参数中查找、抽取或生成答案。

#methodblock[
  *基本流程*：问句分析 → 检索/推理 → 答案抽取或生成 → 返回答案。
]

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*类型*], [*说明*]),
  [FAQ/模板问答], [把问题匹配到已有问答对或模板],
  [基于信息检索的问答], [先检索相关文档，再抽取答案片段],
  [知识库问答 KBQA], [把问题转成知识图谱查询或推理],
  [阅读理解问答 MRC], [在给定篇章中定位答案],
  [生成式问答], [用预训练/大语言模型直接生成答案],
)

#key[QA 评价常见指标]：Accuracy 看答对比例；MRR 看标准答案排名；CWS 可按置信度排序加权评分。


== 本章高频题

#exercise(title: [信息检索])[
  1. 简述信息检索的一般流程。
  2. 比较布尔模型、向量空间模型和概率模型。
  3. 解释 TF-IDF 中 TF 和 IDF 的含义。
  4. 给定检索结果，计算 Precision、Recall、F1。
  5. 简述 BM25 相比 TF-IDF 的改进。
]
