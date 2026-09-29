---
title: General Test Principles
impact: HIGH
impactDescription: ensures tests are maintainable, reliable, and focused on behavior
tags: tests, principles, patterns, best-practices
---

## General Test Principles

Follow these core principles for writing effective, maintainable tests.

### 1. Use Given-When-Then / Arrange-Act-Assert Pattern

Structure every test with clear sections for setup, action, and verification.

**Incorrect:**

```java
@Test
void calculateTotal() {
    var result = service.calculateTotal(List.of(product1, product2));
    assertEquals(150.0, result);
    verify(repository).findAll();
}
```

**Correct:**

```java
@Test
void calculateTotal_validProducts_returnsSum() {
    // Given
    var product1 = new Product("A", 50.0);
    var product2 = new Product("B", 100.0);
    when(repository.findAll()).thenReturn(List.of(product1, product2));

    // When
    double actualTotal = service.calculateTotal();

    // Then
    double expectedTotal = 150.0;
    assertThat(actualTotal).isEqualTo(expectedTotal);
}
```

### 2. Use "actual" and "expected" Prefixes

Clearly distinguish between expected and actual values for better readability.

**Incorrect:**

```java
var result = service.getUser(id);
assertThat(result.getName()).isEqualTo(name);
```

**Correct:**

```java
var actualUser = service.getUser(id);
var expectedName = "John Doe";
assertThat(actualUser.getName()).isEqualTo(expectedName);
```

### 3. Focus on Behavior, Not Implementation

Test externally visible effects, not internal implementation details.

**Incorrect:**

```java
// Testing implementation details
@Test
void calculateTotal_usesParallelStream() {
    // verifying internal stream usage
}
```

**Correct:**

```java
// Testing behavior
@Test
void calculateTotal_largeDataset_returnsCorrectSum() {
    // verifying the result, not how it's computed
}
```

### 4. Keep Tests Deterministic and Simple

Tests must produce the same result every time. Avoid business logic in tests.

**Incorrect:**

```java
@Test
void createOrder_setsTimestamp() {
    var order = service.createOrder();
    assertThat(order.getTimestamp()).isCloseTo(Instant.now(), within(1, SECONDS));
}
```

**Correct:**

```java
@Test
void createOrder_setsTimestamp() {
    // Given
    var fixedClock = Clock.fixed(Instant.parse("2024-01-01T00:00:00Z"), ZoneOffset.UTC);
    var service = new OrderService(fixedClock);

    // When
    var actualOrder = service.createOrder();

    // Then
    assertThat(actualOrder.getTimestamp()).isEqualTo(Instant.parse("2024-01-01T00:00:00Z"));
}
```

### 5. Verify Only Relevant Outputs and Interactions

Don't overuse mocks. Never mock the system under test or simple value objects.

**Incorrect:**

```java
// Over-mocking
@Test
void processOrder() {
    var mockProduct = mock(Product.class);
    when(mockProduct.getPrice()).thenReturn(100.0);
    when(mockProduct.getName()).thenReturn("Test");
    // ...
}
```

**Correct:**

```java
// Use real objects for simple value objects
@Test
void processOrder_validProduct_calculatesTotal() {
    // Given
    var product = new Product("Test", 100.0); // real object

    // When
    var actualResult = service.processOrder(product);

    // Then
    assertThat(actualResult.getTotal()).isEqualTo(100.0);
}
```

### 6. Use Helpers and Builders to Remove Duplication

Extract common setup logic into helper methods or builders.

**Incorrect:**

```java
@Test
void test1() {
    var user = new User();
    user.setName("John");
    user.setEmail("john@test.com");
    user.setRole(Role.ADMIN);
    // ...
}

@Test
void test2() {
    var user = new User();
    user.setName("Jane");
    user.setEmail("jane@test.com");
    user.setRole(Role.USER);
    // ...
}
```

**Correct:**

```java
@Test
void test1() {
    var user = createUser("John", "john@test.com", Role.ADMIN);
    // ...
}

@Test
void test2() {
    var user = createUser("Jane", "jane@test.com", Role.USER);
    // ...
}

private User createUser(String name, String email, Role role) {
    var user = new User();
    user.setName(name);
    user.setEmail(email);
    user.setRole(role);
    return user;
}
```