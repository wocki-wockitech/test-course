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
│       ├── questions.yaml      ← optional, flat format (backward compatible)
│       ├── questions/           ← optional, new format (one file per question)
│       │   ├── <slug>.yaml
│       │   └── ...
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
| `> [!quiz] question-slug` | Inline quiz (single question from `questions.yaml`) |
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

## questions.yaml

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

## questions/ directory (new format)

Alternative to the flat `questions.yaml`. One file per question, supports
multiple variants (alternative formulations) and i18n.

```
lesson-slug/
├── lesson.md
├── questions.yaml       ← flat format (backward compatible)
└── questions/           ← new format (one file per question)
    ├── source-of-truth.yaml
    ├── template-naming.yaml
    └── obsidian-links.yaml
```

Both formats can coexist — slugs are merged. Slug = file name without `.yaml`.

### Question file structure

```yaml
# questions/<slug>.yaml
id: ""                    # REQUIRED, auto-filled, never change
difficulty: 2             # REQUIRED, 1-5
tags: [git, basics]       # optional

variants:
  - type: multiple_choice
    text:
      ru: "Вопрос?"
      en: "Question?"
    options:
      - text: { ru: "Вариант A", en: "Option A" }
        correct: true
        feedback: { ru: "Верно!", en: "Correct!" }
      - text: { ru: "Вариант B", en: "Option B" }
```

### i18n (localized strings)

Any text field accepts either:
- **Plain string** → uses `default_language` of the course
- **Map `{lang: text}`** → multi-language

Single-language courses use plain strings — zero overhead.

### Variants

`variants[]` — array of alternative formulations of the same concept.

- At display time, a random variant is chosen
- Same `id` per concept — SR is tied to the question, not the variant
- `difficulty` and `tags` are shared across all variants

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

### Type: `ordering` (new)

Students arrange items in the correct order. The correct order = order in the file.

```yaml
- type: ordering
  text: "Arrange in correct order:"
  items:
    - "Step 1"
    - "Step 2"
    - "Step 3"
```

With i18n:
```yaml
- type: ordering
  text: { ru: "Расположите в правильном порядке:", en: "Arrange correctly:" }
  items:
    - { ru: "Шаг 1", en: "Step 1" }
    - { ru: "Шаг 2", en: "Step 2" }
```

Students see items in a shuffled order and rearrange them.

### Type: `matching` (new)

Students connect left items to right items.

```yaml
- type: matching
  text: "Match each term:"
  pairs:
    - left: "Git"
      right: "Version control"
    - left: "PostgreSQL"
      right: "Database"
  distractors:          # extra items on the right (optional)
    - "Web server"
```

### Type: `categorize` (new)

Students distribute items into groups.

```yaml
- type: categorize
  text: "Sort by category:"
  categories:
    - name: "SQL"
      items: ["PostgreSQL", "MySQL"]
    - name: "NoSQL"
      items: ["Redis", "MongoDB"]
  distractors:          # items not belonging to any group (optional)
    - "Nginx"
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
