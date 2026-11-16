# Templates

Ready-to-copy skeletons for everything you'll create in your course.
The platform **ignores** any folder starting with `_`, so files here
won't be indexed or shown to students.

## Workflow

1. Find the template you need below
2. Copy it to the appropriate location in your course
3. Rename folders/files to your slug (e.g. `lesson/` → `dns-lookup/`)
4. Fill in the content
5. Open a PR — `id:` fields will be auto-filled by the GitHub Action

## Available templates

### Block

A new chapter / section of the course.

```bash
cp -r _templates/block/ my-new-block/
```

→ See [`block/`](block/)

### Lesson

A single lesson within a block.

```bash
cp -r _templates/lesson/ my-block/my-new-lesson/
```

→ See [`lesson/`](lesson/)

### Questions

One file with one example per question type. Copy entries from this
file into your lesson's `cards/`.

→ See [`question/cards/`](question/cards/)

### Challenges
// upd test :: todo delete this

Code challenges (coding) and Git-interactive challenges. Each is a
folder under your lesson's `challenges/`.

```bash
cp -r _templates/challenge/coding-go/   my-lesson/challenges/my-new-challenge/
cp -r _templates/challenge/coding-py/   my-lesson/challenges/my-new-challenge/
cp -r _templates/challenge/git/         my-lesson/challenges/my-new-challenge/
```

→ See [`challenge/`](challenge/)

## Naming conventions

- **Slug** = folder name = `[a-z0-9-]+` (lowercase, kebab-case)
- **Slug uniqueness** within parent (block within course, lesson within block, question within lesson)
- **`id`** field — leave empty when creating, the bot will fill it
