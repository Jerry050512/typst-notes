#import "../template/conf.typ": conf
#import "../template/components.typ": *
#import "@preview/cetz:0.3.4"

#show: conf.with(
  title: [
    计算机网络 习题
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#set figure(
  numbering: none
)

= 绪论

#question[Internet的前身是? ] \
#answer[ARPANET]

#question[Internet是建立在`____`协议族基础上的国际互联网络. ] \
#answer[TCP/IP]