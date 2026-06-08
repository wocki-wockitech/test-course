---
# Copy this folder into a block and rename it to your lesson slug.
# Example: cp -r _templates/lesson/ block-1/my-lesson/
#
# Don't forget to add the lesson slug to the parent block's `block.yaml`
# under `lessons:`, otherwise it won't appear in the course.

id:                                         # auto-filled by the bot
title: "Lesson title"
estimated_minutes: 10
---

# Lesson title

Brief intro that hooks the student.

## Section 1

Main content. Standard Markdown is supported, including code blocks,
images, links and tables.

```javascript
function example() {
  return "hello";
}
```

## Section 2

Use Obsidian callouts for tips, warnings, hints, and interactive widgets.
See `_templates/question/questions.yaml` and `_templates/challenge/`
for available types.

> [!tip] Authoring tip
> Keep lessons focused. Aim for 5-15 minutes of reading.
> Use the block test for cross-lesson assessment.

## Practice

> [!quiz] example-question

## Summary

Key takeaways:

- Point one
- Point two
- Point three
