# 课程笔记仓库

本仓库包含一部分课程笔记，笔记内容使用Typst书写，pdf版本会发布在Github Release中。

## Get Started

使用`typst`编译文件，编译命令如下：
```cmd
typst compile input.typ [output.pdf]
```

不编译也没关系啦，因为编译的pdf版本会自动发布到Github Release上。

## 🤖 自动化编译与发布

本仓库已配置GitHub Actions工作流，可以自动编译所有Typst文件并发布PDF版本：

- **自动发现**：扫描所有目录中的`note.typ`和`practice.typ`文件
- **智能命名**：PDF文件按`{目录名}-{文件类型}.pdf`格式命名
- **自动发布**：推送到main分支时创建开发版本，打tag时创建正式版本

详细信息请查看 [WORKFLOW.md](WORKFLOW.md)。

### 没有安装`typst`？

使用如下命令安装：

- Windows: `winget install --id Typst.Typst`
- MacOS: `brew install typst`
- Linux: `sudo snap install typst` (Install Snap First)

详情参考[Typst官方仓库](https://github.com/typst/typst).

### 字体！！！

中文字体往往是一大问题，而本笔记统一使用思源宋体（台湾字型）。但由于`Typst`不支持可变字重，需要手动下载安装多种固定字重：
- 简体中文（中国）：[14_SourceHanSerifCN.zip](https://github.com/adobe-fonts/source-han-serif/releases/download/2.003R/14_SourceHanSerifCN.zip)
- 繁体中文（台湾）：[15_SourceHanSerifTW.zip](https://github.com/adobe-fonts/source-han-serif/releases/download/2.003R/15_SourceHanSerifTW.zip)

顺带一提：简中的font family name是Source Han Serif而繁中是思源宋體 TW。

