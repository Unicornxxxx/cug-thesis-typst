#import "../../utils/datetime-display.typ": datetime-display, datetime-en-display, datetime-zh-display
#import "../../utils/justify-text.typ": justify-text
#import "../../utils/style.typ": 字号, 字体, show-cn-fakebold

// 研究生封面
#let postgraduate-cover(
  // documentclass 传入的参数
  // doctype: "master",
  // degreetype: "professional",
  // degree: "工程硕士",
  // degree-en: "Master of Engineering",
  // major: "测绘工程",
  // major-en: "Surveying and Mapping Engineering",
  // is-fulltime: true,
  nl-cover: false,
  anonymous: false,
  twoside: false,
  fonts: (:),
  info: (:),
  // 其他参数
  cover-meta-font: "宋体",
  cover-meta-size: "三号", 
  cover-title-font: "黑体",
  cover-title-size: "二号", 
  bold-info-keys: ("title", "school-name"),
  bold-level: "bold",
  stoke-width: 0.5pt,
  min-title-lines: 2,
  min-reviewer-lines: 5,
  info-inset: (bottom: -2pt),
  info-key-width: 86pt,
  info-column-gutter: 18pt,
  info-row-gutter: 12pt,
  meta-block-inset: (left: -15pt),
  meta-info-inset: (x: 0pt, bottom: 2pt),
  meta-info-key-width: 35pt,
  meta-info-column-gutter: 10pt,
  meta-info-row-gutter: 1pt,
  defence-info-inset: (x: 0pt, bottom: 0pt),
  defence-info-key-width: 110pt,
  defence-info-column-gutter: 2pt,
  defence-info-row-gutter: 12pt,
  anonymous-info-keys: ("student-id", "author", "author-en", "supervisor", "supervisor-en", "supervisor-ii", "supervisor-ii-en", "chairman", "reviewer",
  "school-name", "school-name-en", "school-code"
  ),
  // datetime-display: datetime-display,
  // datetime-en-display: datetime-en-display,
  datetime-zh-display: datetime-zh-display,
) = {
  show: show-cn-fakebold
  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 根据 min-title-lines 和 min-reviewer-lines 填充标题和评阅人
  info.title = info.title + range(min-title-lines - info.title.len()).map((it) => "　")
  // info.reviewer = info.reviewer + range(min-reviewer-lines - info.reviewer.len()).map((it) => "　")
  // 2.3 处理日期
  assert(type(info.submit-date) == datetime, message: "submit-date must be datetime.")
  // if type(info.defend-date) == datetime {
  //   info.defend-date = datetime-display(info.defend-date)
  // }
  // if type(info.confer-date) == datetime {
  //   info.confer-date = datetime-display(info.confer-date)
  // }
  // if type(info.bottom-date) == datetime {
  //   info.bottom-date = datetime-display(info.bottom-date)
  // }
  // 2.4 处理 docname
  // if (degree == "academic") {
  //   info.docname = (info.school-name, info.degreetype + "学位论文")
  //   info.docname-en = ("A Dissertation Submitted to " + info.school-name-en, "For the Doctor Degree of " + info.degree-en)
  // }

  // if (doctype == "doctor") {
  //   info.docname = (info.school-name, "博士学位论文")
  //   info.docname-en = ("A Dissertation Submitted to ",info.school-name-en, "For the Doctor Degree of " + info.degree-en)
  // } else if (doctype == "master" and not is-fulltime) {
  //   info.docname = (info.school-name, "硕士专业学位论文（全日制）")
  //   info.docname-en = ()
  // } else if (doctype == "master" and not is-fulltime) {
  //   info.docname = (info.school-name, "硕士专业学位论文（非全日制）")
  // } else {
  //   info.degree = "学士"
  // }

  // 3.  内置辅助函数
  let info-style(
    body, 
    weight: "regular",
    font: 字体.at(cover-meta-font, default: 字体.宋体),
    size: 字号.at(cover-meta-size, default: 字号.三号),
    align-type: "default", // str(justify), str(default), left, right, center, 
  ) = {
    rect(
      width: 100%, 
      // inset: info-inset,
      stroke: none,
      text(
        font: font, size: size, 
        weight: weight,
        if (align-type == "justify") {
          justify-text(with-tail: true, body)
        } else if (align-type == "default") {
          body
        } else {align(align-type, body)}
      )
    )
  }

  let docname(
    body, weight: "bold",
    font: 字体.宋体,
    size: 字号.一号,
    leading-scale: 1.2,
  ) = {
    rect(
      width: 100%,
      stroke: none,
      text(
        font: font, size: size,
        weight: weight,
        par(body, leading: size * leading-scale)
      )) 
  }
  let docname-en = docname.with(font: 字体.宋体, size: 字号.三号, weight: "regular")
  let title = docname.with(font: 字体.黑体, size: 字号.二号)
  let title-en = docname-en.with(font: 字体.宋体, size: 字号.二号)
  let address-en = docname-en
  

  // 4.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  block(height: 1.38cm, grid(
    columns: (auto, auto, auto, auto), 
    info-style("学校代码：", align-type: right),
    info-style(info.school-code),
    info-style("研究生学号：", align-type: right),
    info-style(info.student-id),
  ))
  // v(0.5cm)
  block(height: 3.9cm, grid(
    columns: auto, 
    align: center,
    if info.degreetype == "academic" {
    if info.doctype == "doctor" { 
      docname(info.school-name + "博士学位论文")
      } else {
        docname(info.school-name + "硕士学位论文")
      }
    } else if info.degreetype == "professional" {
      if info.is-fulltime { 
        docname(info.school-name + "\n硕士专业学位论文（全日制）")
        } else { 
          docname(info.school-name + "\n硕士专业学位论文（非全日制）")
        }
    }
  ))
  // v(1.5cm)
  //论文题目
  block(height: 2.67cm, grid(
    columns: auto, 
    align: center,
    title(info.title.join("\n"), font: 字体.黑体, size: 字号.二号, leading-scale: 0.8),
  ))

  // 学生与指导老师信息
  { //v((9.54cm-(0.99cm+1.07cm+1.14cm+1.17cm+1.23cm))/2)
    set align(center+horizon)
    block(width: 10cm, grid(
    align: (center, left),
    columns: (4.33cm, 5cm),
    rows: (0.99cm, 1.07cm, 1.14cm, 1.17cm, 1.23cm),
    // column-gutter: -3pt,
    // row-gutter: 11.5pt,
    info-style("姓名", align-type: "justify"),
    info-style(info.author),
    ..(if info.degreetype == "professional" {(
      {
        info-style("专业学位类型", align-type: "justify")
      },
      // info-style(info.degree + "（" + info.major + "）"),
      info-style(info.degree),
    )} else {(
      info-style("专业名称", align-type: "justify"),
      info-style(info.major),
    )}),
    info-style("指导教师", align-type: "justify"),
    info-style(info.supervisor.intersperse(" ").sum()),
    ..(if info.supervisor-ii != () {(
      info-style("　"),
      info-style(info.supervisor-ii.intersperse(" ").sum()),
    )} else { () }),
    info-style("培养单位", align-type: "justify"),
    info-style(info.department),
  ))
  v((9.54cm-(0.99cm+1.07cm+1.14cm+1.17cm+1.23cm))/2)
  }
  // v(2.6cm)

  {
    set align(center+bottom)
    block(height: 2.67cm, grid(
      columns: auto, 
      align: center,
      // info-style("二○××年×月", font: 字体.宋体, size: 字号.三号)
      text(datetime-zh-display(info.submit-date, anonymous: false), font: 字体.宋体, size: 字号.三号)
      // text("二○××年×月", font: 字体.宋体, size: 字号.三号)
    ))
  }


  // // 第二页
  pagebreak(weak: true, to: if twoside { "odd" })

  // v(0.5cm)
  block(height: 1.64cm, grid(
    columns: auto, 
    align: center,
    if info.degreetype == "academic" {
    if info.doctype == "doctor" { 
      docname-en("A Dissertation Submitted to "+ info.school-name-en 
      + "For the Doctor Degree of " + info.degree-en)
      } else {
        docname-en("A Dissertation Submitted to "+ info.school-name-en 
      + "For the Master  Degree of " + info.degree-en)
      }
    } else if info.degreetype == "professional" {
      if info.is-fulltime { 
        docname-en("A Dissertation Submitted to "+ info.school-name-en
        + "\nFor the Full-Time Master of Professional Degree of\n" + info.degree-en)
        } else { 
          docname-en("A Dissertation Submitted to "+ info.school-name-en
        + "\nFor the Part-Time Master of Professional Degree of\n" + info.degree-en)
        }
    }
  ))
  v(2.73cm)
  //论文题目
  block(height: 2.67cm, grid(
    columns: auto, 
    align: center,
    title-en(info.title-en.join("\n"), leading-scale: 0.8),
  ))

  // 学生与指导老师信息
  { //v((9.54cm-(0.99cm+1.07cm+1.14cm+1.17cm+1.23cm))/2)
    set align(center+horizon)
    block(width: 80%, grid(
    align: (center, left),
    columns: (6.99cm, auto),
    rows: (0.99cm, 1.07cm, 1.14cm, 1.17cm, 1.23cm),
    // column-gutter: -3pt,
    // row-gutter: 11.5pt,
    ..(if info.doctype == "doctor" {(
      {
        info-style("Ph.D. Candidate: ", align-type: right)
      }, 
      info-style(info.author-en),
    )} else {(
      info-style("Master Candidate: ", align-type: right), 
      info-style(info.author-en),
    )}),
    ..(if info.degreetype == "professional" {(
      {
        info-style("Professional Degree Type: ", align-type: right)
      },
      // info-style(info.degree + "（" + info.major + "）"),
      info-style(info.degree-en),
    )} else {(
      info-style("Major: ", align-type: right),
      info-style(info.major-en),
    )}),
    info-style("Supervisor: ", align-type: right),
    info-style(info.supervisor-en.intersperse(" ").sum()),
    ..(if info.supervisor-en != () {(
      info-style("　"),
      info-style(info.supervisor-ii-en.intersperse(" ").sum()),
    )} else { () }),
  ))
  v((9.54cm-(0.99cm+1.07cm+1.14cm+1.17cm+1.23cm))/2)
  }
  // v(2.6cm)

  {
    set align(center+bottom)
    block(height: 3.55cm, grid(
      columns: auto, 
      align: center,
      address-en("China University of Geosciences\nWuhan 430074 P.R. China"),
      // info-style(info.address-en)
    ))
  }
}

// 封面测试代码
#let thesis-info = (
    // 论文标题，将展示在封面、扉页与页眉上
    // 多行标题请使用数组传入 `("thesis title", "with part next line")`，或使用换行符：`"thesis title\nwith part next line"`
    title: ("中国地质大学学位论文Typst模板", "参考研究生学位论文写作规范（2015-）"),
    title-en: ("The Specification of Writting and Printing", "for CUG thesis"),

    // 论文作者信息：学号、姓名、院系、专业、指导老师
    grade: "2025",
    student-id: "120222xxxx",
    school-code: "10491",
    school-name: "中国地质大学",
    school-name-en: "China University of Geosciences",
    author: "张三",
    author-en: "Ming Xing",
    department: "国家地理信息系统\n工程技术研究中心",
    department-en: "National Engineering Research Center of Geographic Information System",
    doctype: "master",
    degreetype: "professional", 
    is-fulltime: true,
    degree: "工程硕士", 
    degree-en: "Master of Engineering",
    major: "测绘工程",
    major-en: "Surveying and Mapping Engineering",
    // 指导老师信息，以`("name", "title")` 数组方式传入
    supervisor: ("李四", "教授"),
    supervisor-en: ("Prof.", "Li Si"),
    supervisor-ii: ("王五", "副教授"),
    supervisor-ii-en: ("Prof.", "Wang Wu"),
    address-en: "Wuhan 430074 P.R. China",

    // 提交日期，默认为论文 PDF 生成日期
    submit-date: datetime.today(),
  )

#show: postgraduate-cover(info: thesis-info)
