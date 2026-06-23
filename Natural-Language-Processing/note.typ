#import "../template/conf.typ": conf

#show: conf.with(
  title: [
    自然语言处理
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#show figure: set block(breakable: true)

#set heading(numbering: none)
#include "00-exam-review.typ"

#set heading(numbering: "1.1")
#include "01-introduction.typ"
#include "02-morphological-analysis.typ"
#include "03-formal-language-automata.typ"
#include "04-syntactic-analysis.typ"
#include "05-semantic-analysis.typ"
#include "06-word-embeddings.typ"
#include "07-information-retrieval.typ"
#include "08-language-models.typ"
#include "09-probabilistic-graphical-models.typ"
#include "10-corpus.typ"
#include "11-exercises.typ"
