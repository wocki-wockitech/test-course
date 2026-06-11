# Content Format Reference

Full schema for everything in a StudyMe course repository.

## File hierarchy

```
<repo root>/
├── course.yaml                 ← REQUIRED, exactly one
├── <block-slug>/
│   ├── block.yaml              ← REQUIRED for each block
│   └── <lesson-slug>/
│       ├── lesson.md           ← REQUIRED for each lesson
│       ├── cards/      ← optional, but recommended
│       └── challenges/
│           └── <challenge-slug>/
│               ├── challenge.yaml  ← REQUIRED for each challenge
│               └── ...             ← language-specific files
└── assets/                     ← shared images, optional
```

## Slug rules

- Slug = folder name for blocks, lessons, challenges
- Slug for questions = `slug:` field in YAML entry
- Format: `[a-z0-9-]+` (lowercase, kebab-case, no underscores)
- Length: 2-64 characters
- Unique within parent (block within course, lesson within block, etc.)

## Reserved prefixes

The platform skips any path starting with:
- `_` — used for templates, drafts, scratch (`_templates/`, `_drafts/`)
- `.` — used for tooling (`.github/`, `.studyme-cache/`)

Use `.studymeignore` for additional ignored paths.

## course.yaml

```yaml
id:                  # REQUIRED, UUID v4, auto-filled, never change
slug: my-course      # REQUIRED, lowercase kebab-case
title: "Title"       # REQUIRED, max 200 chars
description: >       # REQUIRED, max 1000 chars
  Multi-line description.
language: ru         # REQUIRED, ISO 639-1
difficulty: beginner # REQUIRED, beginner | intermediate | advanced
tags: []             # optional, array of strings
cover: path/to.png   # optional, repo-relative path
license: MIT         # optional, SPDX or 'Proprietary'
authors:             # optional
  - name: "Name"
    url: "https://..."
blocks:              # REQUIRED, ordered array of block slugs
  - block-1
```

## block.yaml

```yaml
id:                  # REQUIRED, auto-filled, never change
title: "Title"       # REQUIRED
description: "..."   # optional
lessons:             # REQUIRED, ordered array of lesson slugs
  - lesson-1
test:                # optional, defaults shown
  question_count: 10
  pass_threshold: 0.7
  prefer_failed: true
  time_limit_per_question: null  # seconds, null = no limit
```

## lesson.md frontmatter

```yaml
id:                  # REQUIRED, auto-filled
title: "Title"       # REQUIRED
estimated_minutes: 5 # optional, integer
tags: []             # optional
```

After frontmatter — standard Obsidian-flavored Markdown.

### Callouts (Obsidian native)

```markdown
> [!info] Optional title
> Body text. Multiple lines supported.
> Markdown inside works: **bold**, `code`, [links](https://...).

> [!warning]+ Expanded by default
> Plus sign = foldable, expanded.

> [!hint]- Click to reveal
> Minus sign = foldable, collapsed.
```

Supported types: `note`, `info`, `tip`, `important`, `success`, `check`,
`done`, `question`, `help`, `faq`, `warning`, `caution`, `attention`,
`failure`, `fail`, `danger`, `error`, `bug`, `example`, `quote`, `cite`,
`abstract`, `summary`, `tldr`, `todo`, `hint`.

### Interactive widgets (StudyMe-specific callouts)

| Syntax | Renders |
|--------|---------|
| `> [!card] question-slug` | Inline quiz (single question from `cards/`) |
| `> [!challenge] challenge-slug` | Coding challenge (editor + tests) |
| `> [!sandbox] go` | Runnable sandbox without tests |

The body of `[!sandbox]` is shown as the description above the editor.

### Wiki-links and embeds (Obsidian native)

| Syntax | Result |
|--------|--------|
| `[[lesson-slug]]` | Link to another lesson |
| `[[lesson-slug\|custom label]]` | Link with custom label |
| `[[lesson-slug#anchor]]` | Link to a section anchor |
| `![[image.png]]` | Embed an image |
| `![[image.png\|alt text]]` | Embed with alt text |

Standard markdown links `[text](url)` and `![alt](url)` also work.

### Diagrams

```markdown
​```mermaid
graph LR
    A --> B
​```
```

Mermaid uses the standard fenced code block — same as in Obsidian with
the Mermaid plugin enabled.

### Other formatting

| Syntax | Result |
|--------|--------|
| `==text==` | Highlighted text |
| `~~text~~` | Strikethrough |
| `**text**` | Bold |
| `*text*` | Italic |
| `` `code` `` | Inline code |

## cards/

```yaml
questions:
  - id:              # REQUIRED, auto-filled
    slug: my-q       # REQUIRED, unique within lesson
    type: ...        # REQUIRED: see types below
    difficulty: 2    # REQUIRED, 1-5
    text: "..."      # REQUIRED
    tags: []         # optional
    reference_answer: "..."  # optional, shown after answer
    # ...type-specific fields...
```

### Type: `multiple_choice`

```yaml
type: multiple_choice
options:                       # REQUIRED, 2-10 items
  - text: "Answer A"
    feedback: "Why A is wrong"
  - text: "Answer B"
    correct: true              # mark correct option(s) with correct: true
    feedback: "Why B is right"
  - text: "Answer C"
    feedback: "Why C is wrong"
```

Single vs multi-select is determined automatically: one `correct: true` →
radio buttons, multiple `correct: true` → checkboxes.

Each option:
- `text` (required) — displayed to the student
- `correct` (optional, default false) — marks the correct answer(s)
- `feedback` (optional) — shown after the student answers, explains why right/wrong

### Type: `true_false`

```yaml
type: true_false
correct: true              # REQUIRED, bool
```

### Type: `free_text`

```yaml
type: free_text
reference_answer: "..."    # REQUIRED, used for AI grading
evaluation_criteria:       # optional, helps AI grade
  must_mention: ["term1", "term2"]
  bonus: ["nice-to-have"]
max_score: 5               # optional, default 5
pass_threshold: 0.6        # optional, default 0.6
```

### Type: `coding`

```yaml
type: coding
challenge_slug: my-challenge   # REQUIRED, slug in challenges/
```

### Type: `git_interactive`

```yaml
type: git_interactive
challenge_slug: my-git-task    # REQUIRED, slug in challenges/
```

## challenge.yaml

Common fields:

```yaml
id:                  # REQUIRED, auto-filled
title: "..."         # REQUIRED
description: "..."   # REQUIRED, multi-line markdown allowed
language: go         # REQUIRED for coding type
type: coding         # optional, defaults to "coding"; use "git_interactive" for git
timeout_sec: 20      # optional, default 20 (coding), 300 (git)
limits:              # optional, all defaults shown
  memory_mb: 256
  cpu_cores: 1
  network: false
hints: []            # optional, array of strings
```

### Coding challenge files

```yaml
files:
  template: solution.go         # REQUIRED, student starting code
  tests:    solution_test.go    # REQUIRED, hidden from student
  solution: solution/solution.go # REQUIRED, hidden, used for "show solution"
```

### Git challenge files

```yaml
files:
  setup:    setup.sh            # REQUIRED, runs before terminal opens
  check:    check.sh            # REQUIRED, exit 0 = pass
  solution: solution.md         # REQUIRED, shown after N attempts
```

## Validation

Run the linter locally before pushing:

```bash
npx @wockitech/studyme-lint .
```

Or it'll run automatically in CI on every PR.
