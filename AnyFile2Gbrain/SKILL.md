---
name: AnyFile2Gbrain
description: |
  Convert any file format (Excel, PPT, Word, PDF, CSV) to Markdown and import 
  into Gbrain knowledge base. Auto-classifies content into brain directories 
  (people/companies/projects/concepts/meetings/media).
  将任意格式文件转换为 Markdown 并导入 Gbrain 知识库，自动分类识别。
---

# AnyFile2Gbrain

[English](#english-skill) | [中文](#chinese-skill)

---

<a name="english-skill"></a>
## English

Convert any file format to Markdown and import into your Gbrain knowledge base.

### Supported Formats

| Format | Extensions | Tool |
|--------|-----------|------|
| Excel | `.xlsx`, `.xls` | openpyxl + pandas |
| PowerPoint | `.pptx` | python-pptx |
| Word | `.docx` | pandoc |
| PDF | `.pdf` | pdfplumber / pandoc |
| CSV | `.csv` | pandas |
| Text | `.txt`, `.md` | direct import |

### Setup

Run this once before first use:

```bash
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

### Workflow

When user provides a file path:

1. **Detect format** from extension
2. **Convert to Markdown** using appropriate tool
3. **Auto-classify** based on filename/content keywords
4. **Write to brain directory** (`~/brain/<category>/`)
5. **Sync and embed**: `gbrain sync --repo ~/brain && gbrain embed --stale`

---

## Auto-Classification Rules

**Analyze filename and content to determine target directory:**

| Keywords | Directory | Example |
|----------|-----------|---------|
| name, profile, bio, resume, CV | `people/` | `John-Profile.xlsx` → `people/john.md` |
| company, corp, inc, startup, org | `companies/` | `Acme-Financials.xlsx` → `companies/acme.md` |
| meeting, notes, call, discussion, sync | `meetings/` | `Team-Meeting.pptx` → `meetings/team-meeting.md` |
| idea, concept, theory, insight, brainstorm | `concepts/` | `Feature-Idea.docx` → `concepts/feature-idea.md` |
| article, book, paper, summary, review | `media/` | `AI-Trends.pdf` → `media/ai-trends.md` |
| (default) | `projects/` | `Q1-Report.xlsx` → `projects/q1-report.md` |

**Slug generation**: lowercase, hyphens, remove special chars

---

## Conversion Commands

### Excel (.xlsx, .xls) → Markdown

```bash
python3 -c "
import pandas as pd
import sys

file = '$FILE_PATH'
xlsx = pd.ExcelFile(file)
md = ''

for sheet in xlsx.sheet_names:
    df = pd.read_excel(xlsx, sheet_name=sheet)
    md += f'## Sheet: {sheet}\n\n'
    md += df.fillna('').to_markdown(index=False)
    md += '\n\n'

print(md)
" > /tmp/converted.md
```

### PowerPoint (.pptx) → Markdown

```bash
python3 -c "
from pptx import Presentation
import sys

prs = Presentation('$FILE_PATH')
md = ''

for slide_num, slide in enumerate(prs.slides, 1):
    md += f'## Slide {slide_num}\n\n'
    for shape in slide.shapes:
        if hasattr(shape, 'text') and shape.text.strip():
            md += shape.text.strip() + '\n\n'
    for shape in slide.shapes:
        if shape.has_table:
            table = shape.table
            rows = []
            for row in table.rows:
                rows.append([cell.text.strip() for cell in row.cells])
            if rows:
                header = '| ' + ' | '.join(rows[0]) + ' |'
                separator = '| ' + ' | '.join(['---'] * len(rows[0])) + ' |'
                body = '\n'.join(['| ' + ' | '.join(r) + ' |' for r in rows[1:]])
                md += header + '\n' + separator + '\n' + body + '\n\n'

print(md)
" > /tmp/converted.md
```

### Word (.docx) → Markdown

```bash
pandoc '$FILE_PATH' -t markdown --wrap=none > /tmp/converted.md
```

Or fallback with python-docx:
```bash
python3 -c "
from docx import Document

doc = Document('$FILE_PATH')
md = ''

for para in doc.paragraphs:
    style = para.style.name.lower()
    text = para.text.strip()
    if not text:
        continue
    if 'heading 1' in style:
        md += f'# {text}\n\n'
    elif 'heading 2' in style:
        md += f'## {text}\n\n'
    elif 'heading 3' in style:
        md += f'### {text}\n\n'
    else:
        md += text + '\n\n'

for table in doc.tables:
    rows = [[cell.text.strip() for cell in row.cells] for row in table.rows]
    if rows:
        header = '| ' + ' | '.join(rows[0]) + ' |'
        separator = '| ' + ' | '.join(['---'] * len(rows[0])) + ' |'
        body = '\n'.join(['| ' + ' | '.join(r) + ' |' for r in rows[1:]])
        md += '\n' + header + '\n' + separator + '\n' + body + '\n\n'

print(md)
" > /tmp/converted.md
```

### PDF → Markdown

```bash
pandoc '$FILE_PATH' -t markdown --wrap=none > /tmp/converted.md 2>/dev/null || \
python3 -c "
import pdfplumber

with pdfplumber.open('$FILE_PATH') as pdf:
    md = ''
    for page in pdf.pages:
        text = page.extract_text()
        if text:
            md += text + '\n\n'
    print(md)
" > /tmp/converted.md
```

### CSV → Markdown

```bash
python3 -c "
import pandas as pd

df = pd.read_csv('$FILE_PATH')
print(df.fillna('').to_markdown(index=False))
" > /tmp/converted.md
```

---

## Import to Gbrain

```bash
SLUG=$(basename '$FILE_PATH' | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/^-//;s/-$//')
CATEGORY="<determined-category>"

cat > ~/brain/$CATEGORY/$SLUG.md << 'EOF'
---
type: media
title: <Original Filename>
tags: [imported, <relevant-tags>]
source: $FILE_PATH
imported: $(date +%Y-%m-%d)
---

EOF

cat /tmp/converted.md >> ~/brain/$CATEGORY/$SLUG.md
gbrain sync --repo ~/brain
gbrain embed --stale
echo "Imported to: ~/brain/$CATEGORY/$SLUG.md"
```

---

<a name="chinese-skill"></a>
## 中文

将任意格式文件转换为 Markdown 并导入 Gbrain 知识库。

### 支持格式

| 格式 | 扩展名 | 转换工具 |
|------|--------|----------|
| Excel | `.xlsx`, `.xls` | openpyxl + pandas |
| PowerPoint | `.pptx` | python-pptx |
| Word | `.docx` | pandoc |
| PDF | `.pdf` | pdfplumber / pandoc |
| CSV | `.csv` | pandas |
| 文本 | `.txt`, `.md` | 直接导入 |

### 安装

首次使用前运行：

```bash
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

### 工作流程

用户提供文件路径后：

1. **检测格式** — 根据扩展名识别
2. **转换 Markdown** — 使用对应工具转换
3. **自动分类** — 根据文件名/内容关键词推断
4. **写入 brain** — 存入 `~/brain/<分类目录>/`
5. **同步嵌入** — 执行 `gbrain sync --repo ~/brain && gbrain embed --stale`

---

## 自动分类规则

**根据文件名和内容推断目标目录：**

| 关键词 | 目录 | 示例 |
|--------|------|------|
| name, profile, bio, resume, CV, 个人, 简介 | `people/` | `张三简介.xlsx` → `people/zhang-san.md` |
| company, corp, inc, startup, org, 公司, 企业 | `companies/` | `阿里财报.xlsx` → `companies/alibaba.md` |
| meeting, notes, call, discussion, sync, 会议, 讨论 | `meetings/` | `周会纪要.pptx` → `meetings/weekly-meeting.md` |
| idea, concept, theory, insight, brainstorm, 想法, 创意 | `concepts/` | `新功能创意.docx` → `concepts/new-feature.md` |
| article, book, paper, summary, review, 文章, 书籍 | `media/` | `AI趋势.pdf` → `media/ai-trends.md` |
| (默认) | `projects/` | `Q1报告.xlsx` → `projects/q1-report.md` |

**Slug 生成规则**：小写、连字符、移除特殊字符

---

## 使用示例

用户: "导入这个文件: ~/Documents/Q1-财务报表.xlsx"

Agent:
1. 检测为 Excel 格式
2. 转换为 Markdown 表格
3. 分类到 `projects/`（财务报表）
4. 写入 `~/brain/projects/q1-财务报表.md`
5. 同步并嵌入
6. 返回: "✅ 已导入 Q1-财务报表.xlsx 到 projects/q1-财务报表.md"

---

## 注意事项

- 分类不确定时询问用户："不确定分类，请选择：people/、companies/、projects/、concepts/、meetings/ 或 media/"
- 大文件可能需要分块以获得更好的嵌入效果
- PPT 中的图片无法转换为文本，需在输出中注明