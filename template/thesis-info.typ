#let thesis-info = (
    // 论文标题，将展示在封面、扉页与页眉上
    // 多行标题请使用数组传入 `("thesis title", "with part next line")`
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
    department: ("国家地理信息系统", "工程技术研究中心"),
    department-en: "National Engineering Research Center of Geographic Information System",
    doctype: "master",
    degreetype: "professional", 
    is-equivalent: false, 
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