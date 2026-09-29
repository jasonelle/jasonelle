---
title: Test Naming Conventions
impact: HIGH
impactDescription: ensures consistent, readable test names that describe behavior
tags: tests, naming, conventions, readability
---

## Test Naming Conventions

Use consistent naming patterns that clearly describe the test scenario and expected outcome.

### Test Class Naming

Use the target language's idioms:
- `[TestedClass]Test` (Java, Kotlin)
- `[TestedClass]Tests` (C#)
- `test_[module_name].py` (Python)
- `[name].test.js` or `[name].spec.ts` (JavaScript/TypeScript)

### Test Method Naming

Format: `{testedMethod}_{givenState}_{expectedOutcome}`

**Incorrect:**

```java
// Too vague
@Test
void testCalculate() { ... }

// No outcome described
@Test
void calculateTotal_validProducts() { ... }

// Implementation details instead of behavior
@Test
void calculateTotal_usesStreamApi_returnsSum() { ... }
```

**Correct:**

```java
// Clear state and outcome
@Test
void calculateTotal_validProducts_returnsSum() { ... }

@Test
void calculateTotal_emptyList_throwsIllegalArgumentException() { ... }

@Test
void getUser_unauthorized_returns401() { ... }

@Test
void getUser_forbidden_returns403() { ... }

@Test
void saveOrder_validOrder_persistsToDatabase() { ... }

@Test
void deleteUser_nonExistentId_throwsNotFoundException() { ... }
```

### Naming Guidelines

1. **Be specific about the state/condition** - "validProducts" not "goodInput"
2. **Be specific about the outcome** - "returns401" not "fails"
3. **Use domain language** - "unauthorized" not "noToken"
4. **Avoid technical jargon** - describe behavior, not implementation