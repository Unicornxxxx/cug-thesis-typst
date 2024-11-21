#import "@preview/anti-matter:0.0.2": anti-front-end
#import "@preview/i-figured:0.2.4"
#import "../utils/style.typ": 字号, 字体
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": heading-display, active-heading, current-heading
#import "../utils/indent.typ": fake-par
#import "../utils/unpairs.typ": unpairs

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  fonts: (:),
  // 其他参数
  leading: 1em, // 1.0 * 15.6pt - 0.7em, 固定行距20磅
  spacing: 1em, // 1.0 * 15.6pt - 0.7em,
  justify: true,
  first-line-indent: 2em,
  numbering: custom-numbering.with(first-level: "第一章 ", depth: 4, "1.1 "),
  // 正文字体与字号参数
  text-args: auto, // auto =>宋体、小四
  // 标题字体与字号
  heading-font: auto,  // auto => 黑体
  heading-size: (字号.三号, 字号.四号, 字号.小四, ),
  heading-weight: ("bold", "bold", "regular", ),
  heading-above: (2.0 * 1em * 120%, 1.0 * 1em * 120%, 1.0 * 1em * 120%, ),
  heading-below: (2.0 * 1em * 120%, 1.0 * 1em * 120%, 1.0 * 1em * 120%, ),
  heading-pagebreak: (true, false, false, ),
  heading-align: (center, center, left, ),
  // 页眉
  header-render: auto,
  header-vspace: 0cm,
  display-header: true,
  skip-on-first-level: true,
  stroke-width: 0.5pt,
  reset-footnote: true,
  // caption 的 separator
  separator: " ",
  // caption 样式
  caption-style: strong, //TODO: 查看参数
  caption-size: 字号.五号,
  // figure 计数
  show-figure: i-figured.show-figure,
  // equation 计数
  show-equation: i-figured.show-equation,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  set text(fallback: false, lang: "zh")
  set page(margin: (x: 3cm, y: 3cm))
  anti-front-end()


  // 1.  默认参数
  fonts = 字体 + fonts
  if (text-args == auto) {
    text-args = (font: fonts.宋体, size: 字号.小四, top-edge: 20pt - 0.7em, bottom-edge: 20pt + 0.3em)
  }
  
  // 1.1 字体与字号
  if (heading-font == auto) {
    heading-font = (fonts.黑体,)
  }
  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args.named().pairs()
    .filter((pair) => pair.at(0).starts-with("heading-"))
    .map((pair) => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent
  )
  show par: set block(spacing: spacing)
  show raw: set text(font: fonts.等宽)
  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // 3.3 设置 figure 的编号
  show heading: i-figured.reset-counters
  show figure: show-figure
  // 3.4 设置 equation 的编号和假段落首行缩进
  show math.equation.where(block: true): show-equation
  // 3.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table
  ): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: set text(font: fonts.宋体, size: 字号.五号)
  // 3.6 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists
        .map((pair) => (pair.at(0), array-at(pair.at(1), it.level))))
    )
    set block(
      above: array-at(heading-above, it.level),
      below: array-at(heading-below, it.level),
    )
    it
    fake-par
  }
  // 4.3 标题居中与自动换页
  show heading: it => {
    if (array-at(heading-pagebreak, it.level)) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if ("label" not in it.fields() or str(it.label) != "no-auto-pagebreak") {
        pagebreak(weak: true)
      }
    }
    if (array-at(heading-align, it.level) != auto) {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  // 5.  处理页眉
  set page(..(if display-header {
    ( 
      header: {
        // 重置 footnote 计数器
        if reset-footnote {
          counter(footnote).update(0)
        }
        context if calc.even(counter(page).get().first()) {
          //奇数页页眉
          set text(font: 字体.宋体, size: 字号.五号)
          counter(page).display("1")
        } else {
          //偶数页页眉
          h(1fr)
          set text(font: 字体.宋体, size: 字号.五号)
          counter(page).display("1")
        }
        line(length: 100%, stroke: stroke-width + black) // 底部横线
      },
      header-ascent: 0.5cm,             // 
        // locate(loc => {
        //   // 5.1 获取当前页面的一级标题
        //   let cur-heading = current-heading(level: 1, loc)
        //   // 5.2 如果当前页面没有一级标题，则渲染页眉
        //   if not skip-on-first-level or cur-heading == none {
        //     if header-render == auto {
        //       // 一级标题和二级标题
        //       let first-level-heading = if not twoside or calc.rem(loc.page(), 2) == 0 { heading-display(active-heading(level: 1, loc)) } else { "" }
        //       let second-level-heading = if not twoside or calc.rem(loc.page(), 2) == 2 { heading-display(active-heading(level: 2, prev: false, loc)) } else { "" }
        //       set text(font: fonts.楷体, size: 字号.五号)
        //       stack(
        //         first-level-heading + h(1fr) + second-level-heading,
        //         v(0.25em),
        //         if first-level-heading != "" or second-level-heading != "" { line(length: 100%, stroke: stroke-width + black) },
        //       )
        //     } else {
              // header-render(loc)
        //     }
        
        // v(header-vspace)
        //   }
        // })
      
    )
  } else {
    (
      header: {
        // 重置 footnote 计数器
        if reset-footnote {
          counter(footnote).update(0)
        }
      }
    )
  }))

  it
}

// #show regex("[“‘’”]|——|……"): set text(font: "SimSun")
#show: mainmatter(
          twoside: false,
          display-header: true,
          [
            = 绪论
== 研究背景和意义 
随着城市人口的增加和城市化进程的加速推进，道路网络的规模和覆盖范围不断扩大。根据研究结果显示，全球道路的长度正在急速扩展。据预测，到2050年，全球将新增2500万公里的道路，增长率达60%#super([1])。道路作为城市规划和建设的关键元素，在城市化进程和智慧城市发展中具有重要意义。数字化、网络化和智能化是当前道路基础设施发展的重要趋势。数字道路作为地理信息系统中重要的基础性地理要素之一，在城市规划、交通管理和导航等领域具有重要意义[2]。准确获取和实时更新数字道路数据对于提高交通安全性、优化交通流量、改善城市交通规划和提升导航准确性具有重要影响。因此，数字道路的研究和发展具有重要的学术和实践意义。

道路信息提取和道路网选取是数字道路研究的两项重要任务。通常情况下，数字道路信息的获取依赖于专业测绘手段的现场采集和手动标记。然而，这种方式存在收集成本高、更新周期长等问题，导致生成的地图实时性难以满足生产与更新的需求。随着遥感技术、信息通信和计算机等技术的进步，海量的时空大数据得以积累，极大丰富了获取道路信息的数据源，如GPS轨迹、遥感影像、城市街景和激光点云等[3-5]。其中，遥感影像和GPS轨迹数据因其覆盖范围广和获取成本低等优势成为重要的道路数据来源。遥感影像能够以较高的空间分辨率对地物进行精细解译，提高地物目标的提取能力[6]；GPS轨迹记录了城市地区大量的人类活动，而这些活动大多受到基础道路网络的限制[7]。基于现有技术从遥感影像和GPS轨迹快速提取道路信息减少了很多工作量。然而，尽管当前的技术手段和数据条件在不断进步，但仍难以突破单一数据源本身的限制。例如，在基于GPS轨迹提取道路信息时，一些不太受欢迎的道路历史轨迹很少甚至为零，定位的偏移和错位会导致地图提取任务的误检；另一方面，基于遥感影像的道路信息提取受到树木、阴影和建筑物的遮挡，难以识别出被遮挡的道路，而具有上下分层、多方向行驶的复杂立交桥结构也难以准确识别。鉴于这两种数据具有互补的特点，如GPS轨迹可以填补遥感影像中受遮挡的道路缺口，而遥感影像可以覆盖出行频率较低的居民道路，即一种数据源中可能包含着另一种数据源丢失的信息。因此，融合这两种数据的互补信息有望进一步提升道路信息提取的效果。

随着城市路网的不断建设与更新，基于位置的移动服务的普及与应用，多尺度地理空间数据库的建设和其更新需求日益繁重，例如在北京和深圳等大城市，每年有超过40%的地图内容需要更新[8]，制图综合已经成为国家基础地理信息服务的重要组成部分。道路网作为地理空间数据库中线要素的核心，道路地图的更新对地理信息方面的研究具有重要意义。实现道路地图从大比例尺到小比例尺变化的道路网选取研究是地图更新的主要方式。本质上，道路网选取是一种多属性决策问题，涉及基础地理信息更新、地理空间数据库衍生、空间数据的多尺度表示以及各类专题地图制作的主要任务[9]。传统的道路网选取方法主要依据道路的几何特征和拓扑特征进行约束，未顾及道路网的重要语义特征。GPS轨迹点形成的交通流量从现实生活角度反映了道路的重要程度及其相互之间的联系。因此，为了充分考虑道路网的实时语义信息，引入轨迹交通流量进行选取尤为重要。

综上所述，获取实时性好、准确性高且具备丰富细节的道路信息变得越发重要。因此，探究融合遥感影像和GPS轨迹数据的城市道路自动提取、结合GPS轨迹数据的道路网智能选取，实现数字道路地图从信息提取到自动选取一体化研究具有重要意义。
== 国内外研究现状
=== 道路提取研究现状
==== 基于遥感影像的城市道路提取
随着深度学习的发展，卷积神经网络的运用提高了从遥感图像中提取道路的效率和精度，一些研究把道路提取表示为分割后处理问题，Cheng等人[10]使用端到端级联神经网络从卫星图像中提取道路分割图，他们将二值阈值应用于道路分割，并使用形态学细化的后处理方式来提取道路中心线。U-Net[11]和LinkNet[12]是在语义分割中使用较多的编码器-解码器结构，Zhang等人[13]将残差连接应用于U-Net，从而学习得到道路分割的更多精细特征。Zhou等人[14]提出了D-linkNet，该方法结合了空洞卷积和LinkNet，旨在增加对高分辨率遥感影像中道路提取任务的接收场。最近的研究中，Zhang等人[15]提出了一种名为D-FusionNet的新型语义分割网络，该网络集成了稀释卷积块模块，在提取任务中能够扩大感受野和减少特征的丢失。RoadCT[16]不仅集成了卷积神经网络和变换神经网络的优势，还采用了关系融合块来合并不同感受野的道路特征，以提高道路提取的性能。然而这些方法由于依赖中间的分割表示，尽管后处理步骤能够在一定程度上弥补道路连通性的缺陷，但无法从根本上解决问题。
另外一些研究把道路提取表示为基于图的迭代探索问题，为了直接获得具有更好连接性的道路提取结果，Bastani等人[17]提出RoadTracer，它使用基于CNN的决策函数指导的迭代探索算法从航空图像中自动提取道路网络。Tan等人[18]在RoadTracer的基础上提出了一种基于点的迭代探索搜索方案VecRoad，它将下一个移动的位置表示为一个“点”，该点统一了多个约束的表示形式，用于指导下一步行动和实现更好的道路对齐。Li等人[19]开发了一种新的框架，利用多边形来适应道路和建筑物的形状，以有效地整合道路形状特征，包括点、边缘和区域特征，进一步提高道路连通性和道路识别精度。He等人[20]提出了一种新的编码方案Sat2Graph，其关键思想是一种新的编码方案——图张量编码，它将道路图编码为张量表示，一次性生成完整道路图而不需要中间的分割表示。然而，这些方法受遥感影像数据质量的影响，例如被树木和建筑物遮挡的道路无法识别。

==== 基于GPS轨迹的城市道路提取
目前，基于GPS轨迹的城市道路提取研究已经取得了显著的成果。其主要方法是利用聚类技术聚类轨迹或GPS点，再通过拟合的方法生成路网图。Qiu等人[21]提出了一种自适应k均值算法，通过角度阈值来确定k值，对轨迹点数据聚类以重建近似直线的线段。Stanojevic等人[22]和Qiu等人[23]首先对交叉口区域的轨迹点进行分离，然后采用聚类方法对轨迹点聚类提取交叉口，最后通过连接交叉口之间的路段形成路网。Liu等人[24]从几何距离与方向差异的角度对轨迹点进行聚类，然后利用B样条曲线拟合聚类的点簇获取道路中心线。除了聚类的方法，还有一些别的方法用于从轨迹数据中提取道路。核密度估计[25, 26]（Kernel Density Estimation，KDE）是一种抗GPS噪声和视差的流行方法。Cao等人基于重力[27]模型，利用引力和斥力的作用，将同一道路上的轨迹段聚集在一起，并以增量式的方式生成道路网。Shi[28]等人将轨迹数据转化为栅格图，对其进行二值化处理后，利用样条函数拟合曲线的方法提取道路中心线。在最近的研究中，Dal Poz等人[29]提出一种不需要将轨迹点栅格化的提取方法，而是基于轨迹点的折现采用形态学分析和骨架化技术重建路网。然而，这些方法大多是以基于启发式的方法解决问题，而不是以学习的方式解决，并且仍然无法消除噪声或提取跟踪点很少甚至为零的区域中的道路。

==== 基于多源数据的城市道路提取
考虑到遥感影像在道路提取上的单源局限性，有一些研究工作在其他数据源的帮助下使用遥感影像来提取道路。Audebert等人[30]研究了激光雷达和多光谱数据的早期和晚期融合。Cao等人[31]根据GPS轨迹生成道路种子点，来有效指导基于遥感影像的道路提取任务，帮助提取道路中心线。Xu等人[32]基于遥感影像和部分道路地图进行道路提取的新思路，设计门控自注意模块融合两个数据分支的特征。Sun等人[33]将遥感影像和GPS轨迹特征图串联在一起作为成共同输入，提出1D Decodr多方向卷积来提取城市道路信息。Wu等人[34]利用门控模块，以互补感知的方式显式控制来自两种模态的信息流，在特征提取的多个阶段筛选出遥感影像和GPS轨迹具有更多道路特征的一个，有效结合两种数据的优势提取精确、完整的道路信息。Li等人[35]提出了一种名为MTMSAF的多任务、多源自适应融合网络，MTMSAF针对遥感影像和出租车轨迹，以引导的方式融合每个级别的各个道路特征，同时执行道路提取任务和交叉路口检测任务。最近的研究中，Li等人[36]使用两个独立的Res-Unet模型，一个输入遥感影像，另一个输入GPS轨迹，基于门控融合模块对来自解码器的两种数据进行融合，从而提取道路信息。Li等人[37]基于双编码器结构利用门控融合模块融合遥感影像和GPS轨迹提取道路。然而，这些工作中的大多数要么简单地连接特征，要么平均两种模态的预测以执行数据融合，且融合过程没有充分使用轨迹数据的属性特征。

总的来说，利用遥感影像和GPS轨迹的道路提取研究已经取得了丰富的成果，但仍有待改进的空间。基于遥感影像的分割后处理方法依赖于中间的分割结果，且后处理工作相对繁琐；基于图的迭代探索方法中起始点的选择会影响最终生成的结果。基于GPS轨迹的道路提取受数据质量的影响精度不高。基于多源数据融合的道路提取方法融合过于简单，要么使用早期融合的方法，将轨迹数据与遥感影像在数据层面进行融合，拼接成多通道图像，然后输入网络进行道路特征学习。或是使用晚期融合的方法，将两种数据源各自提取的结果进行加权后作为最终结果。未能充分利用两种数据的道路特征。
],
          // fonts: 字体,
        )

