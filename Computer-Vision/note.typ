#import "../template/conf.typ": conf

#show: conf.with(
  title: [
    计算机视觉
  ],
  authors: (
    (
      name: [Gang.],
      affiliation: [Hangzhou Dianzi University],
      email: "jerry050512@outlook.com",
    ),
  )
)

#set heading(numbering: none)
#include "00-terms.typ"

#set heading(numbering: "1.1")
#include "01-computer-vision-summary.typ"
#include "02-human-visual-system.typ"
#include "03-visual-system.typ"
#include "04-computer-graph-geometric-transfomation.typ"
#include "05-optical-imaging-model-and-camera-calibration.typ"
#include "06-triangulation-and-polar-geometry.typ"
#include "07-stero-vision.typ"