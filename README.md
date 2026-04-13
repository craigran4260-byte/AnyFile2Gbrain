# AnyFile2Gbrain

[English](#english) | [中文](#chinese)

---

<a name="english"></a>
## English

### The Problem

Gbrain only accepts Markdown files. But your knowledge comes in many formats — Excel spreadsheets, PowerPoint presentations, Word documents, PDF reports. Each time you want to import them, you have to manually convert to Markdown. That's tedious.

### The Solution

**AnyFile2Gbrain** lets you drop any file to Claude Code, which automatically:
- Detects the file format
- Converts to structured Markdown
- Classifies into the right category (people, companies, projects, etc.)
- Imports directly into your Gbrain knowledge base

Just tell Claude: *"Import this file: ~/Documents/report.xlsx"* — and it's done.

### Supported Formats

| Format | Extensions | Output |
|--------|-----------|--------|
| Excel | `.xlsx`, `.xls` | Markdown tables |
| PowerPoint | `.pptx` | Slide-by-slide Markdown |
| Word | `.docx` | Full Markdown document |
| PDF | `.pdf` | Extracted text in Markdown |
| CSV | `.csv` | Markdown table |
| Text | `.txt`, `.md` | Direct import |

### Auto-Classification

Files are automatically sorted based on filename and content:

| Keywords | Category | Example |
|----------|----------|---------|
| name, profile, resume, CV | `people/` | `John-Profile.xlsx` → `people/john.md` |
| company, corp, startup | `companies/` | `Acme-Financials.xlsx` → `companies/acme.md` |
| meeting, notes, call | `meetings/` | `Team-Meeting.pptx` → `meetings/team-meeting.md` |
| idea, concept, brainstorm | `concepts/` | `Feature-Idea.docx` → `concepts/feature-idea.md` |
| article, book, paper | `media/` | `AI-Trends.pdf` → `media/ai-trends.md` |
| (default) | `projects/` | `Q1-Report.xlsx` → `projects/q1-report.md` |

### Installation

```bash
# Clone the repo
git clone https://github.com/craigran4260-byte/AnyFile2Gbrain-skill.git

# Copy to Claude skills directory
cp -r AnyFile2Gbrain-skill/AnyFile2Gbrain ~/.claude/skills/

# Install dependencies
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

### Usage

In Claude Code conversation, just drop a file path:

```
"Import this file: ~/Documents/report.xlsx"
"Add this presentation to my brain: ~/Downloads/slides.pptx"
"Convert this PDF: ~/Files/notes.pdf"
```

Claude will handle everything — conversion, classification, and import.

---

<a name="chinese"></a>
## 中文

### 问题

Gbrain 只能导入 Markdown 文件。但你的知识来源多种多样 — Excel 表格、PPT 演示文稿、Word 文档、PDF 报告。每次导入都要手动转换，繁琐又耗时。

### 解决方案

**AnyFile2Gbrain** 让你直接把任意格式的文件丢给 Claude Code，它会自动：
- 识别文件格式
- 转换为结构化 Markdown
- 智能分类到对应目录（人物、公司、项目等）
- 直接导入 Gbrain 知识库

只需告诉 Claude：*"导入这个文件: ~/Documents/report.xlsx"* — 一切搞定。

### 支持格式

| 格式 | 扩展名 | 输出 |
|------|--------|------|
| Excel | `.xlsx`, `.xls` | Markdown 表格 |
| PowerPoint | `.pptx` | 分页 Markdown |
| Word | `.docx` | 完整 Markdown 文档 |
| PDF | `.pdf` | 提取文本转为 Markdown |
| CSV | `.csv` | Markdown 表格 |
| 文本 | `.txt`, `.md` | 直接导入 |

### 自动分类

根据文件名和内容自动归类：

| 关键词 | 分类 | 示例 |
|--------|------|------|
| name, profile, resume, CV, 个人, 简介 | `people/` | `张三简介.xlsx` → `people/zhang-san.md` |
| company, corp, startup, 公司, 企业 | `companies/` | `阿里财报.xlsx` → `companies/alibaba.md` |
| meeting, notes, call, 会议, 讨论 | `meetings/` | `周会纪要.pptx` → `meetings/weekly-meeting.md` |
| idea, concept, brainstorm, 想法, 创意 | `concepts/` | `新功能创意.docx` → `concepts/new-feature.md` |
| article, book, paper, 文章, 书籍 | `media/` | `AI趋势.pdf` → `media/ai-trends.md` |
| (默认) | `projects/` | `Q1报告.xlsx` → `projects/q1-report.md` |

### 安装

```bash
# 克隆仓库
git clone https://github.com/craigran4260-byte/AnyFile2Gbrain.git

# 复制到 Claude skills 目录
cp -r AnyFile2Gbrain/AnyFile2Gbrain ~/.claude/skills/

# 安装依赖
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

### 使用方法

在 Claude Code 对话中，直接丢文件路径：

```
"导入这个文件: ~/Documents/report.xlsx"
"把这个 PPT 加入我的 brain: ~/Downloads/slides.pptx"
"转换这个 PDF: ~/Files/notes.pdf"
```

Claude 会自动处理 — 转换、分类、导入，全程无需你操心。