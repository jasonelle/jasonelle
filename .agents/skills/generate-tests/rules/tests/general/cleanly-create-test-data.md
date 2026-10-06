---
title: Cleanly Create Test Data
impact: HIGH
impactDescription: improves test readability and maintainability through clean data setup
tags: tests, test-data, helpers, builders, readability
---

## Cleanly Create Test Data

Use helper functions and builder patterns to create test data cleanly. Avoid cluttering tests with irrelevant details.

### Use Helper Functions

Helper functions hide irrelevant details and make tests easier to read.

**Incorrect:**

```java
@Test
void calculateTotal_multipleItems_happyPath() {
    ShoppingCart shoppingCart = new ShoppingCart(new DefaultRoundingStrategy(),
            "unused", NORMAL, false, false, TimeZone.getTimeZone("UTC"), null);
    int totalPrice = shoppingCart.calculateTotal(
            newItem1(),
            newItem2(),
            newItem3());
    assertThat(totalPrice).isEqualTo(25); // Where did this number come from?
}
```

**Correct:**

```java
@Test
void calculateTotal_multipleItems_happyPath() {
    ShoppingCart shoppingCart = newShoppingCart();

    int actualTotal = shoppingCart.calculateTotal(
            newItemWithPrice(10),
            newItemWithPrice(10),
            newItemWithPrice(5));

    int expectedTotal = 25;
    assertThat(actualTotal).isEqualTo(expectedTotal);
}
```

### Use the Test Data Builder Pattern

When helper methods grow with many parameters, use the builder pattern.

**Incorrect:**

```java
// Helper methods become unwieldy with many parameters
Company small = newCompany(2, 2, null, Type.PUBLIC);
Company privatelyOwned = newCompany(null, null, null, Type.PRIVATE);
Company bankrupt = newCompany(null, null, PAST_DATE, Type.PUBLIC);
```

**Correct:**

```java
Company small = newCompany().employeesCount(2).boardMembersCount(2).build();
Company privatelyOwned = newCompany().type(Type.PRIVATE).build();
Company bankrupt = newCompany().bankruptcyDate(PAST_DATE).build();
Company arbitraryCompany = newCompany().build();

// Helper returns builder with required defaults
private static Company.CompanyBuilder newCompany() {
    return Company.builder().type(Type.PUBLIC);
}
```

### Never Rely on Default Values from Helpers

If a test depends on a value, explicitly set it even if it matches the helper's default.

**Incorrect:**

```java
private static Company.CompanyBuilder newCompany() {
    return Company.builder().type(Type.PUBLIC);
}

@Test
void test_publicCompany() {
    // Relies on helper's default - fragile!
    Company company = newCompany().build();
    // ...
}
```

**Correct:**

```java
@Test
void test_publicCompany() {
    // Explicitly set the value this test depends on
    Company company = newCompany()
            .type(Type.PUBLIC)  // Explicit even if matches default
            .boardMembersCount(0)
            .build();
    // ...
}
```

### Helper Function Guidelines

1. **Name helpers descriptively** - `createProductWithCategory("Office")` not `createProduct()`
2. **Only expose relevant parameters** - hide irrelevant details
3. **Keep helpers simple** - no business logic
4. **Consider builders for complex objects** - when many field combinations are needed