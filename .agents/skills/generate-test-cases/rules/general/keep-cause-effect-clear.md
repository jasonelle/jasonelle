---
title: Keep Cause and Effect Clear
impact: HIGH
impactDescription: ensures tests are self-contained and easy to understand
tags: tests, readability, cause-effect, self-contained
---

## Keep Cause and Effect Clear

Write tests where the effects immediately follow the causes. Avoid relying on distant setup code.

### Problem: Hidden Setup

When setup is far from the test, it's impossible to understand the test without scrolling.

**Incorrect:**

```java
private final Counter counter = new Counter();

@BeforeEach
public void setUp() {
    counter.increment("key1", 8);
    counter.increment("key2", 100);
    counter.increment("key1", 0);
    counter.increment("key1", 1);
}

// ... 200 lines later ...

@Test
public void testIncrement_existingKey() {
    // Where does 9 come from? Have to scroll up to find out!
    assertThat(counter.get("key1")).isEqualTo(9);
}
```

**Correct:**

```java
private final Counter counter = new Counter();

@Test
public void increment_newKey_setsValue() {
    // Cause and effect are together
    counter.increment("key2", 100);

    assertThat(counter.get("key2")).isEqualTo(100);
}

@Test
public void increment_existingKey_addsToValue() {
    // Clear cause-effect relationship
    counter.increment("key1", 8);
    counter.increment("key1", 1);

    assertThat(counter.get("key1")).isEqualTo(9);
}
```

### Guidelines

1. **Put setup in the test** - if it's relevant to understanding the test
2. **Use @BeforeEach only for** - infrastructure setup (mocks, containers), not test-specific data
3. **Avoid shared mutable state** - each test should set up its own data
4. **Keep tests self-contained** - reader shouldn't need to look elsewhere

### When @BeforeEach is Appropriate

Use `@BeforeEach` for infrastructure, not test data:

```java
@BeforeEach
void setUp() {
    // OK: Infrastructure setup
    mockServer = new MockWebServer();
    mockServer.start();

    // OK: Creating SUT
    service = new UserService(mockServer.url("/").toString());
}

@Test
void getUser_existingUser_returnsUser() {
    // Test-specific data belongs in the test
    mockServer.enqueue(new MockResponse().setBody("{\"name\":\"John\"}"));

    User actualUser = service.getUser("123");

    assertThat(actualUser.getName()).isEqualTo("John");
}
```

### Benefits

- Tests are **self-documenting** - you understand the test by reading it
- Tests are **independent** - changing one test doesn't break others
- Failures are **easier to debug** - all relevant context is visible