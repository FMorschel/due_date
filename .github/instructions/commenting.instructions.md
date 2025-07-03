---
applyTo: '**/*.dart'
---

# Dart Commenting Standards for due_date Library

- All code comments explaining logic, context, or test data (such as "July 1, 2024 is Monday") must appear above the referenced line, not as trailing comments.
- All public members in `/lib` must have Dart doc comments starting with `///`.
- Dart doc comments should use square bracket references to other declarations, e.g. `[memberHere]`.
- Use descriptive, concise, and relevant comments to clarify intent, edge cases, and non-obvious logic.
- Keep comments up to date with code changes.
- Avoid redundant comments that restate the code.
- Create doc templates whenever the comment should be used in multiple places, such as for default constructors and class declarations.
- Getters/properties should have comments stating what they mean and not start with `Returns ...`.
- **Always** write comments in the present tense, as if the code is being executed right now.
- **Always** format comments as sentences, starting with a capital letter and ending with a period.
