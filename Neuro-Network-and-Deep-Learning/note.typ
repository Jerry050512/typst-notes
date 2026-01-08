#import "../template/conf.typ": conf

#show: conf.with(
  title: [
    神经网络与深度学习
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
#include "02-feedforward-network.typ"
#include "03-convolutional-neuro-network.typ"
#include "04-recurrent-neuro-network.typ"
