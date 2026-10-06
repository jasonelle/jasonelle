---
title: Don't Put Logic in Tests
impact: HIGH
impactDescription: prevents bugs in tests and makes expected values obvious
tags: tests, simplicity, kiss, no-logic, readability
---

## Don't Put Logic in Tests

Tests should be straightforward with no conditional logic, loops, or string concatenation. Keep expected values explicit and literal.

### KISS > DRY in Tests

Simplicity is more important than avoiding duplication in tests.

### Problem: Logic Hides Bugs

**Incorrect:**

```java
@Test
public void getPhotosPageUrl() {
    String baseUrl = "https://photos.google.com/";
    UrlBuilder urlBuilder = new UrlBuilder(baseUrl);

    String photosPageUrl = urlBuilder.getPhotosPageUrl();

    // Bug hidden by concatenation: results in "//u/0/photos"
    assertThat(photosPageUrl).isEqualTo(baseUrl + "/u/0/photos");
}
```

**Correct:**

```java
@Test
public void getPhotosPageUrl_happyPath() {
    UrlBuilder urlBuilder = new UrlBuilder("https://photos.google.com/");

    String actualUrl = urlBuilder.getPhotosPageUrl();

    // Explicit literal - bug is obvious: "https://photos.google.com//u/0/photos"
    assertThat(actualUrl).isEqualTo("https://photos.google.com/u/0/photos");
}
```

### Avoid These Patterns in Tests

**Incorrect:**

```java
// Loops in tests
for (int i = 0; i < users.size(); i++) {
    assertThat(users.get(i).isActive()).isTrue();
}

// Conditionals in tests
if (response.isSuccessful()) {
    assertThat(response.getBody()).isNotNull();
}

// String concatenation in assertions
assertThat(result).isEqualTo("Hello, " + userName + "!");

// Calculations in assertions
assertThat(total).isEqualTo(price * quantity + tax);
```

**Correct:**

```java
// Explicit assertions
assertThat(users).extracting(User::isActive).containsOnly(true);

// No conditionals - test specific scenarios
assertThat(response.isSuccessful()).isTrue();
assertThat(response.getBody().getName()).isEqualTo("John");

// Literal expected values
assertThat(result).isEqualTo("Hello, John!");

// Pre-calculated expected values
int expectedTotal = 115; // 100 * 1 + 15 tax, calculated outside test
assertThat(total).isEqualTo(expectedTotal);
```

### When Logic is Necessary

If tests need complex logic, move it to helper functions with their own tests:

```java
// Helper with its own test coverage
public class TestDataGenerator {
    public static String generateExpectedGreeting(User user, LocalDate date) {
        // Complex logic here
    }
}

// TestDataGeneratorTest verifies this helper works correctly
```

### Key Principles

1. **Use literal values** - not computed values
2. **Avoid operators** - no `+`, `*`, string concatenation in assertions
3. **No control flow** - no `if`, `for`, `while` in test bodies
4. **KISS over DRY** - repetition is OK if it makes tests clearer