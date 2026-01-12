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

#show figure: set block(breakable: true)

#include "01-introduction.typ"
#include "02-feedforward-network.typ"
#include "03-convolutional-neuro-network.typ"
#include "04-recurrent-neuro-network.typ"
#include "05-network-optimization-and-regulation.typ"
#include "06-memory.typ"
#include "07-unsupervised-learning.typ"
#include "08-model-independent-learning-methods.typ"