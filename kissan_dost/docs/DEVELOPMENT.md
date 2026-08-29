# SOURCE OF TRUTH

These documentation files define the project's intended
architecture, boundaries, conventions, and development rules.

When modifying the project, follow these documents unless the
user explicitly instructs otherwise.

If the existing code conflicts with the documentation, do not
silently restructure the project. Explain the conflict and
propose the smallest appropriate change.

---

# 3. `DEVELOPMENT.md`

This one tells your coding AI **how to work**.

This is extremely useful.

```md
# Development Rules

## General Rule

Work incrementally.

Do not implement the entire application at once.

Each task should be:

1. Inspected
2. Implemented
3. Analyzed
4. Tested
5. Verified

Then stop and wait for the next instruction.

---

# Boundaries

Do not:

- Restructure the project without permission
- Rewrite working code unnecessarily
- Duplicate widgets
- Duplicate providers
- Put feature-specific code in `core`
- Put API calls inside widgets
- Put business logic inside `build()`
- Create unnecessary abstractions
- Create unnecessary services
- Add unnecessary dependencies
- Modify unrelated files
- Implement future features without instruction

If an architectural change is necessary, explain why first.

---

# Reusability

Before creating a new widget:

1. Check whether an existing widget can be reused.
2. If not, determine whether the new widget is feature-specific
   or globally reusable.
3. Put it in the appropriate location.

Do not duplicate UI code.

---

# Performance

Always consider:

- `const` widgets
- fine-grained Riverpod rebuilds
- `.select()`
- avoiding unnecessary API calls
- avoiding expensive work in `build()`
- efficient lists
- proper disposal
- caching where appropriate

Do not prematurely optimize without a reason.

---

# Modification Rule

When changing existing code:

1. Read the existing implementation.
2. Understand its responsibility.
3. Make the smallest required change.
4. Preserve existing behavior.
5. Check dependent code.
6. Run analyzer/tests.

Do not rewrite an entire feature when a small modification is enough.

---

# Completion Rule

A task is not considered complete if it leaves:

- compilation errors
- analyzer errors caused by the change
- broken imports
- broken navigation
- obvious runtime errors

Fix issues introduced by the implementation before reporting completion.

---

# Communication

Before implementation, briefly state:

- What will change
- Files affected
- Why

After implementation, report:

- What changed
- Files changed
- Important architectural decisions
- Performance considerations
- Any remaining issue

Do not automatically continue to the next feature.