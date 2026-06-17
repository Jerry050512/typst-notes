#import "/book.typ": book-page

#show: book-page.with(title: "Gang's Typst Notes")

欢迎查看杭州电子科技大学课程笔记，用 *Typst* 编写、用 *shiroa* 渲染为响应式 web 站。

== 功能

- 左侧导航 / 顶部搜索 / 多主题切换
- 中文公式表格图全部支持
- 移动端友好（基于 starlight 主题）
- 同源 .typ 同时产出 PDF（GitHub Releases）+ 在线 HTML

== 包含的课程

{{ CourseList }}
