---
name: AnyFile2Gbrain
description: Convert any file format (Excel, PPT, Word, PDF, CSV) to Markdown and import into Gbrain knowledge base. Auto-classifies content into brain directories (people/companies/projects/concepts/meetings/media).
---

# AnyFile2Gbrain

Convert any file format to Markdown and import into your Gbrain knowledge base.

## Supported Formats

| Format | Extensions | Tool |
|--------|-----------|------|
| Excel | `.xlsx`, `.xls` | openpyxl + pandas |
| PowerPoint | `.pptx`, `.ppt` | python-pptx |
| Word | `.docx`, `.doc` | pandoc |
| PDF | `.pdf` | pdfplumber / pandoc |
| CSV | `.csv` | pandas |
| Text | `.txt`, `.md` | direct import |

## Setup

Run this once before first use:

```bash
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

## Workflow

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
| name, profile, bio, resume, CV | `people/` | `John-Smith-Profile.xlsx` → `people/john-smith.md` |
| company, corp, inc, startup, org | `companies/` | `Acme-Corp-Financials.xlsx` → `companies/acme-corp.md` |
| meeting, notes, call, discussion, sync | `meetings/` | `2026-04-13-team-meeting.pptx` → `meetings/2026-04-13-team-meeting.md` |
| idea, concept, theory, insight, brainstorm | `concepts/` | `New-Feature-Idea.docx` → `concepts/new-feature-idea.md` |
| article, book, paper, summary, review | `media/` | `AI-Trends-2026.pdf` → `media/ai-trends-2026.md` |
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
    # Check for tables
    for shape in slide.shapes:
        if shape.has_table:
            table = shape.table
            rows = []
            for row in table.rows:
                rows.append([cell.text.strip() for cell in row.cells])
            # Markdown table
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
import sys

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

# Tables
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
# Try pandoc first (best for structured PDFs)
pandoc '$FILE_PATH' -t markdown --wrap=none > /tmp/converted.md 2>/dev/null || \
# Fallback to pdfplumber for text extraction
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

After conversion, write to brain and sync:

```bash
# Generate slug from filename
SLUG=$(basename '$FILE_PATH' | sed 's/\.[^.]*$//' | tr '[:upper:]' '[:lower:]' | sed 's/[^a-z0-9]/-/g' | sed 's/^-//;s/-$//')

# Determine category (use classification rules above)
CATEGORY="<determined-category>"

# Add frontmatter
cat > ~/brain/$CATEGORY/$SLUG.md << 'EOF'
---
type: media
title: <Original Filename>
tags: [imported, <relevant-tags>]
source: $FILE_PATH
imported: $(date +%Y-%m-%d)
---

EOF

# Append converted content
cat /tmp/converted.md >> ~/brain/$CATEGORY/$SLUG.md

# Sync and embed
gbrain sync --repo ~/brain
gbrain embed --stale

echo "Imported to: ~/brain/$CATEGORY/$SLUG.md"
```

---

## Example Usage

User: "Import this file: ~/Documents/Q1-Financial-Report.xlsx"

Agent:
1. Detects Excel format
2. Converts to Markdown table
3. Classifies to `projects/` (financial report)
4. Writes to `~/brain/projects/q1-financial-report.md`
5. Syncs and embeds
6. Reports: "✅ Imported Q1-Financial-Report.xlsx to projects/q1-financial-report.md"

---

## Notes

- For uncertain classification, ask user: "I'm not sure where to put this. Should it go to people/, companies/, projects/, concepts/, meetings/, or media/?"
- Large files may need chunking for better embedding
- Binary files (images in PPT) cannot be converted to text - note this in the output