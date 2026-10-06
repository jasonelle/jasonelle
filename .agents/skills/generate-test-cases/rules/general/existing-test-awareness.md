---
title: Existing Test Awareness
impact: HIGH
impactDescription: prevents duplicate tests and ensures consistency with project conventions
tags: tests, awareness, duplicates, conventions, style
---

## Existing Test Awareness

Before generating tests, check what already exists. Match the project's testing conventions and avoid duplicating coverage.

### Before Generating: Check for Existing Tests

1. **Look for an existing test class** for the target:
   - Search for `{ClassName}Test` or `{ClassName}Tests` in the test directory
   - If found, read it fully before generating anything

2. **If an existing test class is found:**
   - Do NOT create a new test class — add missing test methods to the existing one
   - Preserve existing test structure, imports, and helper methods
   - Follow the same patterns (naming, assertion style, setup approach) already used
   - Only add tests for behaviors not yet covered

3. **If no existing test class is found:**
   - Scan 2-3 neighboring test classes in the same package to learn project conventions
   - Match the style: import order, assertion library, naming pattern, comment style

### What to Match from Existing Tests

- **Assertion library**: If the project uses Hamcrest matchers, don't switch to AssertJ (and vice versa)
- **Test data patterns**: If the project has a `TestDataFactory` or builders, use them
- **Base test classes**: If tests extend a `BaseTest` or `AbstractIntegrationTest`, follow that pattern
- **Static import style**: Match how the project imports assertion methods
- **Comment style**: If existing tests use `// given / when / then` vs `// arrange / act / assert`, match it

### What NOT to Do

**Incorrect:**

```java
// Creating a new test class when one already exists
// File: UserServiceTest.java (NEW - duplicate!)
@ExtendWith(MockitoExtension.class)
class UserServiceTest {
    // 10 test methods, 5 of which already exist in the old file
}
```

**Correct:**

```java
// Adding only missing tests to the existing file
// File: UserServiceTest.java (EXISTING - appended to)
@ExtendWith(MockitoExtension.class)
class UserServiceTest {

    // ... existing tests preserved as-is ...

    // New tests added below existing ones
    @Test
    void updateUser_invalidEmail_throwsValidationException() {
        // ...
    }
}
```

### Decision Checklist

Before writing any test code, verify:
- [ ] Searched for existing test class for the target
- [ ] Read existing tests to understand what's already covered
- [ ] Identified project test conventions from neighboring test files
- [ ] Confirmed which behaviors still need test coverage
