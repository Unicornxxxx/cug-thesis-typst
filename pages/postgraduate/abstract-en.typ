#import "../../utils/style.typ": 字号, 字体

// 研究生英文摘要页
#let postgraduate-abstract-en(
  // documentclass 传入的参数
  doctype: "master",
  degree: "academic",
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  abstract-title-weight: "bold",
  leading: 1.27em,
  spacing: 1.27em,
  body,
) = {
  // 1.  默认参数
  fonts = 字体 + fonts
  info = (
    title-en: "CUG Thesis Template for Typst",
    author-en: "Zhang San",
    department-en: "XX Department",
    major-en: "XX Major",
    supervisor-en: ("Prof.", "Li Si"),
    supervisor-ii-en: ("Prof.", "Wang Wu"),
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  [
    // #v(1.27em)
    #align(center, text(font: fonts.宋体, size: 字号.小二, weight: abstract-title-weight, "Abstract", spacing: 1.27em, top-edge: 0.7em, bottom-edge: -0.3em))
    // #v(1.27em)
    #set par(leading: leading, justify: true, spacing: spacing)
    #par(first-line-indent: 2em, body)
    #set text(font: fonts.宋体, size: 字号.小四)
    *Key Words*: #(("",)+ keywords.intersperse("; ")).sum()
  ]
}

// 测试代码
#postgraduate-abstract-en(
  keywords: ("keyword1", "keyword2", "keyword3"),
  [Abstract内容与中文摘要相对应。一般不少于300个英文实词，篇幅以一页为宜。如需要，字数可以略多。]
)