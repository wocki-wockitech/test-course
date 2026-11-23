# Challenge templates

Each challenge is a folder under your lesson's `challenges/` directory.

## Structure

```
my-lesson/
└── challenges/
    └── my-challenge/         ← challenge folder, slug = folder name
        ├── challenge.yaml    ← required: metadata + UUID
        ├── ...               ← language-specific files (see below)
```

## Available templates

| Template | Type | Stack |
|----------|------|-------|
| [`coding-go/`](coding-go/) | coding | Go + `go test` |
| [`coding-py/`](coding-py/) | coding | Python + `pytest` |
| [`coding-js/`](coding-js/) | coding | Node.js + `vitest` |
| [`coding-sql/`](coding-sql/) | coding | PostgreSQL |
| [`git/`](git/) | git_interactive | bash sandbox |

## Linking to a lesson

In your `cards/` add a question of type `coding` or `git_interactive`
that references the challenge slug:

```yaml
- id:
  slug: implement-thing
  type: coding
  text: "Implement the function as described."
  challenge_slug: my-challenge
```

The student sees the challenge embedded in the lesson:

```markdown
> [!challenge] my-challenge
```

## Adding a new language

Each language has a runner Docker image (`studyme/<lang>-runner`) that
implements the standard contract:

```bash
/opt/runner/run.sh <slug> <input-dir> <output-dir>
```

Output is `results.json` with pass/fail per test. To support a new language,
create a runner image — no platform changes needed. See
[runner spec](https://docs.studyme.wockitech.local/sandbox/runner-contract).
