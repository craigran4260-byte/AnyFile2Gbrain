# Claude Code Skills

Custom skills for Claude Code CLI.

## Skills

### AnyFile2Gbrain

Convert any file format (Excel, PPT, Word, PDF, CSV) to Markdown and import into Gbrain knowledge base.

**Supported formats:**
- Excel: `.xlsx`, `.xls`
- PowerPoint: `.pptx`
- Word: `.docx`
- PDF: `.pdf`
- CSV: `.csv`
- Text: `.txt`, `.md`

**Features:**
- Auto-classification based on filename/content keywords
- Direct sync to Gbrain with embedding generation

**Installation:**

```bash
# Copy to your Claude skills directory
cp -r AnyFile2Gbrain ~/.claude/skills/

# Install dependencies
chmod +x ~/.claude/skills/AnyFile2Gbrain/setup.sh
~/.claude/skills/AnyFile2Gbrain/setup.sh
```

**Usage:**

Just drop a file path in Claude Code conversation:
```
"import this file: ~/Documents/report.xlsx"
```

## Adding New Skills

To add a new skill:

1. Create a directory with `SKILL.md` file
2. Add YAML frontmatter with `name` and `description`
3. Copy to `~/.claude/skills/<skill-name>/`

Skill format:
```markdown
---
name: my-skill
description: Brief description of what the skill does
---

# Skill instructions here...
```
