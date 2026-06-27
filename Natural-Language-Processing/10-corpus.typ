#import "../template/preamble.typ": *

= 语料库与语言知识库

#knowtitle[语料库章节偏概念简答，重点是语料库定义、类型、建设流程、标注一致性和典型语言知识库。]

== 语料库技术的发展

#key[三个发展阶段]：

*第一阶段：20世纪50年代中期之前（早期发展）*
- 语料库在语言研究中被广泛使用
- 应用领域：语言习得、方言学、句法语义、音系研究、语言教学
- 特点：为后续发展奠定基础

*第二阶段：1957～20世纪80年代初期（沉寂时期）*
- 转折点：1957年 Chomsky《句法结构》发表
- Chomsky批判观点：
  - 基于语料库的研究方法有误
  - 语料的不充分性
- 影响：语料库语言学进入长达二十多年的沉寂期
- 转换生成语法成为主流

*第三阶段：20世纪80年代以后（复苏与发展）*

特征一：第二代语料库相继建成
- LOB语料库（1983，Lancaster大学，英国英语）
- TLF语料库（法国，2000书面法语文本，约1.8亿词）
- Helsinki Corpus（芬兰，历史英语，850-1710年）
- ICE语料库（1988，伦敦大学，所有英语国家）

特征二：研究项目显著增长
- 1959-1980（20年）：约140个项目
- 1981-1991（11年）：约480个项目
- 增长3.4倍

*复苏原因*：
1. 技术推动：计算机发展提供技术基础（存储、检索、分析能力）
2. 理论反思：转换生成语言学对语料库的批判不都正确

== 基本概念

/ 语料库 (Corpus): 按一定原则采集、整理并可供检索和统计分析的语言材料集合，可根据用途进一步进行词性、句法或语义标注。

/ 语料库语言学: 基于真实语言数据，通过统计和计算方法研究语言规律的学科方向。

#intuition[语料库就是 NLP 的“训练教材”和“统计样本”。没有高质量语料，统计模型和深度学习模型都很难可靠工作。]

== 语料库类型

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*类型*], [*特点*], [*用途*]),
  [通用语料库], [覆盖多领域、规模大], [语言模型、通用NLP任务],
  [专门语料库], [面向特定领域], [法律、医学、金融文本处理],
  [平衡语料库], [按体裁/领域比例采样], [语言规律研究],
  [平行语料库], [不同语言互译文本对齐], [机器翻译],
  [标注语料库], [带词性、句法、语义等标签], [监督学习模型训练],
)


=== 课程分类体系

#table(
  columns: (auto, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*维度*], [*类型*]),
  [按内容和目的], [异质语料库、同质语料库、系统语料库、专用语料库],
  [按语言种类], [单语语料库、双语/多语语料库],
  [按时间维度], [共时语料库、历时语料库],
  [按标注情况], [生语料：未标注；熟语料：已标注],
)

平衡语料库采集原则：真实性、可靠性、科学性、代表性、权威性、分布性、流通性。分布性要考虑学科、地域、时间和语体分布。


== 语料库建设流程

#methodblock[
  1. #key[确定目标]：明确语料库用途、领域、规模和标注层次。
  2. #key[语料采集]：从书籍、网页、新闻、对话等来源收集文本。
  3. #key[清洗规范化]：去重、纠错、编码统一、格式统一。
  4. #key[切分与预处理]：分句、分词、去噪。
  5. #key[人工/自动标注]：词性、实体、句法、语义等。
  6. #key[一致性检验]：计算标注一致率，修订标注规范。
  7. #key[发布与维护]：提供检索、统计、版本更新和版权管理。
]

#warnbox[语料库建设题不要只写“收集语料”。必须写清洗、标注、质检和维护。]

== 建设中的问题

- #key[代表性]：语料是否能代表目标语言或目标领域；
- #key[规模]：规模不足会导致统计不可靠；
- #key[标注一致性]：不同标注者是否遵循同一标准；
- #key[版权与隐私]：网络语料、对话语料需要合规使用；
- #key[动态更新]：语言不断变化，语料库需要维护。

== 语料库标注\*

/ 语料标注: 为语料中的语言单位添加词性、句法、语义等标签的过程。

#key[常见标注层次]：

*一、词性标注（POS Tagging）*

常用标注集：
- 名词(n)、动词(v)、形容词(a)、副词(d)
- 介词(p)、连词(c)、助词(u)、叹词(e)
- 代词(r)、数词(m)、量词(q)

#example(title: [词性标注示例])[
  *句子1*：今天/t 天气/n 很/d 好/a 。/w

  - 今天：时间词(t)
  - 天气：名词(n)
  - 很：副词(d)
  - 好：形容词(a)
  - 。：标点(w)

  *句子2*：美丽/a 的/u 花朵/n 开放/v 了/u 。/w

  - 美丽：形容词(a)
  - 的：助词(u)，结构助词
  - 花朵：名词(n)
  - 开放：动词(v)
  - 了：助词(u)，动态助词
  - 。：标点(w)
]

#warnbox[
  *标注要点*：
  - "的"、"了"、"着"、"过"等是助词(u)
  - "很"、"非常"等程度副词标注为(d)
  - 注意区分时间词(t)和名词(n)
]

*二、命名实体识别（NER）*

常见实体类型：
- 人名(PER)、地名(LOC)、机构名(ORG)
- 时间(TIME)、日期(DATE)、货币(MONEY)

*三、句法标注*

- 成分句法：标注短语结构树（NP、VP、PP等）
- 依存句法：标注词与词之间的依存关系（主谓、动宾等）

== 语言知识库\*

/ 语言知识库: 以结构化方式组织语言知识的资源，如词典、同义词词林、WordNet、HowNet、知识图谱等。

=== WordNet

*核心概念*：
- #key[Synset（同义词集）]：表示同一概念的同义词集合
- #key[语义关系]：
  - 上下位关系（Hypernym/Hyponym）
  - 整体-部分关系（Holonym/Meronym）
  - 反义关系（Antonym）

#example(title: [WordNet 语义结构])[
  以"汽车"(car)为例构建语义结构图：

  *上位词（更抽象）*：
  - car → motor vehicle（机动车）→ vehicle（交通工具）→ conveyance（运输工具）

  *下位词（更具体）*：
  - car → sedan（轿车）
  - car → SUV（越野车）
  - car → sports car（跑车）

  *部分-整体关系*：
  - car 的部分(Meronym)：wheel（轮子）, engine（引擎）, door（车门）, windshield（挡风玻璃）

  *同义词*：
  - car, automobile, auto, motorcar

  *反义词*：
  - 无直接反义词（概念性名词通常没有反义词）

  *相关词*：
  - driver（驾驶员）, garage（车库）, traffic（交通）

  语义结构图：
  ```
              vehicle (交通工具)
                   ↑
            motor vehicle (机动车)
                   ↑
                  car ←→ automobile (同义词)
                   ↓
        ┌──────────┼──────────┐
       sedan      SUV    sports car
        (轿车)   (越野车)   (跑车)

  部分关系：
  car ⊃ {wheel, engine, door, windshield}
  ```
]

=== HowNet（知网）\*

/ HowNet: 以"义原"为基础描述概念间关系的中英双语知识库，由董振东先生主持开发。

#key[设计原则]（作业重点）：

*一、义原（Sememe）*
- 最小的、不可再分的语义单位
- 类似"语义原子"
- HowNet构建了约2000个基本义原
- 例如："医生"可以分解为{人, 职业, 医疗}等义原

#key[义原分类]：
- 实体（Thing）：human|人、animal|动物、tree|树、tool|用具
- 属性（Attribute）：color|颜色、shape|形状、size|大小
- 属性值（Value）：red|红、round|圆、big|大
- 事件（Event）：eat|吃、run|跑、write|写
- 部分（Part）：head|头、tail|尾巴、wing|翅膀

#key[语义角色]：
- agent：动作发出者（施事）
- patient：动作承受者（受事）
- modifier：修饰、属性
- host：属性宿主、所属主体
- tool：工具
- time：时间
- space：空间
- product：产物、结果

#key[HowNet表示格式]：
- 核心结构：主概念义原:语义角色={修饰/从属义原}
- 整体用 {} 包裹，多层嵌套表示复杂语义
- 每个义原用 英文|中文 标明

*二、层次化描述*
- 上下位关系：构建概念层次体系
- 从抽象到具体逐层分解

*三、属性-值对*
- 用属性和值对描述概念
- 例如：{occupation=医疗, agent=人}

*四、关系网络*
- 描述概念之间的多种语义关系
- 如：因果、时间、空间、属性等

#example(title: [HowNet 示例1：医生])[
  *概念*：医生

  *义原分解*：
  - 上位词：人（human）
  - 属性：occupation=医疗（medical）
  - 功能：治疗（cure|医）、诊断（diagnose|诊）
  - 知识：medical=know（医学知识）

  *HowNet 表示*：
  ```
  医生 {
    DEF: human|人, #occupation|职业, medical|医, #cure|医治
  }
  ```

  *语义关系*：
  - 上位：人 → 职业人员 → 医疗人员 → 医生
  - 相关：病人、医院、疾病、药物
  - 活动：治疗、诊断、手术
]

#example(title: [HowNet 示例2：学习])[
  *概念*：学习

  *义原分解*：
  - 上位：动作（act）
  - 施事：人（human）
  - 内容：知识（knowledge）
  - 方式：acquire（获得）

  *HowNet 表示*：
  ```
  学习 {
    DEF: act|行为, #acquire|获得, knowledge|知识,
         agent=human|人
  }
  ```

  *语义关系*：
  - 上位：获得 → 学习
  - 下位：学习 → 阅读、听讲、实践
  - 相关：知识、老师、学生、课程
  - 结果：掌握、理解
]

#warnbox[
  *HowNet vs WordNet*：
  - WordNet：基于同义词集和语义关系网络（英语为主）
  - HowNet：基于义原分解和概念描述（中英双语）
  - WordNet更关注词汇关系，HowNet更关注概念内部结构
]


== 典型语料库与知识库\*

=== 国际语料库

*Brown Corpus（布朗语料库）*
- 世界上较早按系统原则采样的标准语料库
- 规模：约 100 万词、500 个样本
- 特点：平衡语料库，涵盖多种文体
- 链接：https://www.nltk.org/book/ch02.html

*Penn Treebank（宾州树库）*
- 带句法结构标注的树库
- 特点：为每个句子标注成分句法树（短语结构树）
- 用途：句法分析器训练和评测的标准数据集

*PropBank & NomBank*
- PropBank：在树库基础上标注谓词-论元/语义角色
- NomBank：标注名词谓词及其论元
- 用途：语义角色标注（SRL）任务

#key[PropBank 语义角色标注体系]：

*核心论元（Arg0-Arg5）*：
- Arg0：施事者（Agent），有意志的动作发起者
- Arg1：受事者（Patient/Theme），动作直接影响的对象
- Arg2：工具（Instrument）、受益者（Benefactive）或属性
- Arg3：起点（Starting Point）
- Arg4：终点（Ending Point）
- Arg5：特殊论元（少数谓词使用）

*附加论元（ArgM-XX）*：
- ArgM-MNR：方式（Manner），如"认真地"
- ArgM-LOC：地点（Locative），如"在图书馆"
- ArgM-TMP：时间（Temporal），如"昨天"
- ArgM-CAU：原因（Cause），如"因为下雨"
- ArgM-PRP：目的（Purpose），如"为了学习"
- ArgM-NEG：否定（Negation），如"不""没有"
- ArgM-MOD：情态（Modality），如"可能""会"

#example(title: [PropBank标注示例])[
  *例句*：He accepted the gift from his friend privately.

  *标注*：
  - Rel: accepted.01（谓词）
  - Arg0: He（施事者，接受者）
  - Arg1: the gift（受事者，被接受的事物）
  - Arg2: from his friend（来源）
  - ArgM-MNR: privately（方式）
]

*PDTB（Penn Discourse Treebank）*
- 标注篇章关系（因果、对比、顺承等）
- 用途：篇章分析和连贯性研究

#key[篇章关系类型]：
- Temporal：时间关系
- Contingency：条件/因果关系
- Expansion：扩展关系
- Comparison：比较/对比关系

=== 中文语料库

*人民日报标注语料库*
- 来源：人民日报新闻文本
- 标注：分词、词性标注
- 特点：权威性高，新闻领域覆盖广
- 获取：北京大学计算语言学研究所

*中文树库（Chinese Treebank, CTB）*
- 宾州大学主导的中文句法树库
- 标注：分词、词性、句法结构
- 链接：https://catalog.ldc.upenn.edu/LDC2010T07

*LCMC（Lancaster Corpus of Mandarin Chinese）*
- 平衡语料库，参照Brown Corpus设计
- 规模：约 100 万字
- 特点：涵盖多种文体和领域

=== 其他重要资源

*Wikipedia Dumps*
- 维基百科数据转储
- 特点：多语言、开放、持续更新
- 链接：https://dumps.wikimedia.org/
- 用途：预训练语言模型、知识抽取

*Common Crawl*
- 大规模网络爬取语料
- 特点：规模极大（PB级）、多语言
- 链接：https://commoncrawl.org/
- 用途：大规模预训练


== 语料库与知识库的区别

#table(
  columns: (auto, 1fr, 1fr),
  stroke: (paint: rgb("#ccc"), thickness: 0.5pt),
  inset: 6pt,
  fill: (col, row) => if row == 0 { sectionbg } else { white },
  table.header([*对比项*], [*语料库*], [*语言知识库*]),
  [性质], [真实语言样本的集合], [结构化的语言知识],
  [数据形式], [文本、对话等原始材料], [概念、关系、规则等],
  [获取方式], [采集、清洗、标注], [人工构建、专家整理],
  [典型代表], [Brown、Penn Treebank、人民日报], [WordNet、HowNet、同义词词林],
  [主要用途], [统计分析、模型训练], [语义理解、推理、消歧],
)

二者可结合用于语义分析、信息抽取和问答系统。

== 本章高频题\*

#exercise(title: [语料库])[
  *必考概念题*：
  1. #key[语料库定义]：什么是语料库？语料库语言学研究什么？
  2. #key[语料库类型]：语料库有哪些类型？各有什么用途？
  3. #key[建设流程]：简述语料库建设流程（必须包括清洗、标注、质检）
  4. #key[建设问题]：语料库建设中有哪些主要问题？

  *作业题型*：
  5. #key[语料库列举]：列举2-3个国内外相关语料库，附上链接和介绍
  6. #key[标注实践]：对给定句子进行词性标注（注意助词、副词、时间词）
  7. #key[语义结构图]：自选单词构造完整语义标注结构（上下位、同义、反义、部分-整体）
  8. #key[HowNet 设计原则]：简介HowNet的设计原则，并给出2个简单示例

  *比较题*：
  9. 比较语料库和语言知识库的区别
  10. 比较 WordNet 和 HowNet 的区别
]

#warnbox[
  *答题要点*：
  - 语料库建设：不要只写"收集语料"，必须写清洗、标注、质检、维护
  - 标注实践：注意"的"、"了"是助词(u)，"很"是副词(d)
  - HowNet原则：义原、层次化、属性-值对、关系网络
  - 语义结构图：必须包含上下位、同义、反义、部分-整体等多种关系
]

