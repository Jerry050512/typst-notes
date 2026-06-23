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

=== NDCG

/ NDCG: 考虑相关性等级和排序位置的评价指标，越相关的文档越应该排在前面。

== 本章高频题

#exercise(title: [信息检索])[
  1. 简述信息检索的一般流程。
  2. 比较布尔模型、向量空间模型和概率模型。
  3. 解释 TF-IDF 中 TF 和 IDF 的含义。
  4. 给定检索结果，计算 Precision、Recall、F1。
  5. 简述 BM25 相比 TF-IDF 的改进。
]
