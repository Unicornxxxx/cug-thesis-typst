#let info = (
    // 论文标题，将展示在封面、扉页与页眉上
    // 多行标题请使用数组传入 `("thesis title", "with part next line")`，或使用换行符：`"thesis title\nwith part next line"`
    title: ("中国地质大学学位论文（设计）", "研究生学位论文写作规范（2015-）"),
    title-en: ("The Specification of Writting and Printing", "for CUG thesis"),

    // 论文作者信息：学号、姓名、院系、专业、指导老师
    grade: "2025",
    student-id: "1xxxxxxx",
    school-code: "10491",
    school-name: "中国地质大学",
    school-name-en: "China University of Geosciences",
    author: "张三",
    author-en: "Ming Xing",
    department: "国家地理信息系统工程技术研究中心",
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
    supervisor-en: "Professor My Supervisor",
    supervisor-ii: ("王五", "副教授"),
    supervisor-ii-en: "Professor My Supervisor",

    // 提交日期，默认为论文 PDF 生成日期
    submit-date: datetime.today(),
  )

// #if info.degreetype == "professional" {
  // info.school-name+info.degree + "学位论文"
  // if info.doctype == "doctor" { 
  //   info-key("博士学位论文", is-docname: true, size: 字号.一号, weight: "bold") 
  //   } else if info.degreetype == "professional" {
  //     if info.is-fulltime { info-key("硕士专业学位论文（全日制）", is-docname: true, size: 字号.一号, weight: "bold") 
  //     } else { 
  //       info-key("硕士专业学位论文（非全日制）", is-docname: true, size: 字号.一号, weight: "bold") }
  //   } else { 
  //     info-key("硕士学位论文", is-docname: true, size: 字号.一号, weight: "bold") }
    
  #if info.degreetype == "academic" {
    if info.doctype == "doctor" { 
      info.school-name + "博士学位论文"
      } else {
        info.school-name + "硕士学位论文"
      }
  } else if info.degreetype == "professional" {
    if info.is-fulltime { 
      info.school-name + "\n硕士专业学位论文（全日制）"
      } else { 
        info.school-name + "\n硕士专业学位论文（非全日制）"
      }
  }
    // info.docname = 
    // info.docname_en = ("A Dissertation Submitted to " + info.school-name-en, "For the Doctor Degree of " + info.degree-en)
// }