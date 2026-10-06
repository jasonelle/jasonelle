---
title: What Makes a Good Test
impact: HIGH
impactDescription: defines core qualities that every test should have
tags: tests, quality, clarity, completeness, conciseness, resilience
---

## What Makes a Good Test

Every good test should have four qualities: Clarity, Completeness, Conciseness, and Resilience.

### 1. Clarity

A test should be easy to read and understand at a glance.

**Signs of clarity:**
- Test name describes the scenario
- Given-When-Then structure is obvious
- No need to look elsewhere to understand the test

**Incorrect:**

```java
@Test
void test1() {
    var x = svc.process(getData());
    assertTrue(x.isValid());
}
```

**Correct:**

```java
@Test
void process_validInput_returnsValidResult() {
    // Given
    var input = createValidInput();

    // When
    var actualResult = service.process(input);

    // Then
    assertThat(actualResult.isValid()).isTrue();
}
```

### 2. Completeness

A test should contain all information needed to understand it without looking elsewhere.

The line this draws with Conciseness below: **every value the assertion depends on
must be visible inside the test method**; everything the assertion does not depend
on should be hidden behind a helper. `@BeforeEach` and shared constants are fine for
the second kind and wrong for the first.

**Incorrect:**

```java
// Relies on class-level constants and @BeforeEach
@Test
void testCalculation() {
    assertThat(calculator.calculate()).isEqualTo(EXPECTED_VALUE);
}
```

**Correct:**

```java
@Test
void calculate_multipleItems_returnsSumOfPrices() {
    // All relevant data is visible in the test
    calculator.add(newItemWithPrice(10));
    calculator.add(newItemWithPrice(20));

    int actualTotal = calculator.calculate();

    int expectedTotal = 30;
    assertThat(actualTotal).isEqualTo(expectedTotal);
}
```

### 3. Conciseness

A test should contain only information relevant to the scenario. Hide irrelevant details.

**Incorrect:**

```java
@Test
void getUser_existingUser_returnsUser() {
    var user = new User();
    user.setId("123");
    user.setName("John");
    user.setEmail("john@test.com");
    user.setCreatedAt(Instant.now());
    user.setUpdatedAt(Instant.now());
    user.setRole(Role.USER);
    user.setActive(true);
    // ... more irrelevant setup
}
```

**Correct:**

```java
@Test
void getUser_existingUser_returnsUser() {
    // Helper hides irrelevant details
    var user = createUser("123", "John");
    when(repository.findById("123")).thenReturn(Optional.of(user));

    var actualUser = service.getUser("123");

    assertThat(actualUser.getName()).isEqualTo("John");
}
```

### 4. Resilience

A test should not break when unrelated code changes. It should only fail when the tested behavior breaks.

**Signs of resilience:**
- Tests behavior, not implementation
- Uses public APIs
- Doesn't over-specify mock interactions
- Doesn't rely on specific field order or formatting

**Incorrect:**

```java
// Brittle: breaks if JSON field order changes
assertThat(response.getBody())
    .isEqualTo("{\"name\":\"John\",\"age\":30}");
```

**Correct:**

```java
// Resilient: names the fields it cares about, ignores order and formatting
mockMvc.perform(get("/api/users/1"))
        .andExpect(jsonPath("$.name").value("John"))
        .andExpect(jsonPath("$.age").value(30));
```

`jsonPath(...)` returns a `ResultMatcher`, so it belongs inside `andExpect(...)`.
Outside MockMvc, parse the response and assert on the resulting object — parsing is
what keeps the assertion independent of field order and whitespace alike.

### Summary Checklist

- [ ] **Clarity**: Can I understand this test in 10 seconds?
- [ ] **Completeness**: Is all relevant information in the test?
- [ ] **Conciseness**: Is irrelevant information hidden?
- [ ] **Resilience**: Will this test survive refactoring?