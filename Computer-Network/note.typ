#import "../template/conf.typ": conf

#show: conf.with(
  title: [
    计算机网络与技术
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#include "01-introduction.typ"
#include "02-physical.typ"
#include "03-links.typ"
