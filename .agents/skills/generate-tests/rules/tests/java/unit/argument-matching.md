---
title: Argument Matching in Mockito
impact: HIGH
impactDescription: ensures meaningful verification of method arguments
tags: java, tests, mockito, argument-captor, verification
---

## Argument Matching in Mockito

Capture and verify actual arguments instead of using `any()` matchers for DTOs and model objects.

### Rules

- In `verify(...)`, capture DTO/model arguments with `ArgumentCaptor` and assert the
  fields that matter — `any(...)` in that position asserts nothing about the data
- In `when(...)`, `any(...)` is the right choice: a stub decides what the mock returns,
  it makes no assertion. See "Stubbing and Verification Are Different Positions" below

**Incorrect:**

```java
@Test
void createOrder_validRequest_callsRepository() {
    // Using any() - doesn't verify actual data passed
    orderService.createOrder(new OrderRequest("product-1", 5));

    verify(orderRepository).save(any(Order.class));
}

@Test
void sendNotification_validUser_sendsEmail() {
    // any() hides what's actually being sent
    userService.notifyUser(user);

    verify(emailService).send(any(EmailMessage.class));
}
```

**Correct:**

```java
@Test
void createOrder_validRequest_savesCorrectOrder() {
    // Given
    var request = new OrderRequest("product-1", 5);
    var captor = ArgumentCaptor.forClass(Order.class);

    // When
    orderService.createOrder(request);

    // Then
    verify(orderRepository).save(captor.capture());

    Order actualOrder = captor.getValue();
    assertThat(actualOrder.getProductId()).isEqualTo("product-1");
    assertThat(actualOrder.getQuantity()).isEqualTo(5);
}

@Test
void sendNotification_validUser_sendsCorrectEmail() {
    // Given
    var user = new User("john@test.com", "John");
    var captor = ArgumentCaptor.forClass(EmailMessage.class);

    // When
    userService.notifyUser(user);

    // Then
    verify(emailService).send(captor.capture());

    EmailMessage actualMessage = captor.getValue();
    assertThat(actualMessage.getTo()).isEqualTo("john@test.com");
    assertThat(actualMessage.getSubject()).contains("John");
}
```

### Stubbing and Verification Are Different Positions

This rule constrains **verification**, not stubbing. A stub answers "what should
the mock return"; a verification answers "what did the code actually pass". Only
the second is an assertion, so only the second has to name real values.

`any()` inside `when(...)` paired with a captor inside `verify(...)` is the correct
combination — the stub stays loose so the call reaches the code under test, and the
captor does the checking:

```java
// Given
when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);

// When
orderService.createOrder(new OrderRequest("product-1", 5));

// Then — the assertion lives here, on real captured values
var captor = ArgumentCaptor.forClass(Order.class);
verify(orderRepository).save(captor.capture());
assertThat(captor.getValue().getProductId()).isEqualTo("product-1");
```

Keep `captor.capture()` in `verify(...)` — Mockito documents captors as a
verification tool. A captor in a stub captures only when a call actually matches that
stub, so when the code never reaches it the test fails late, at `captor.getValue()`,
with `MockitoException: No argument value was captured!` — an error that points at the
assertion rather than at the call that never happened. The same captor in `verify(...)`
fails at the verification and names the call Mockito expected.

### When `any()` is Acceptable in Verification

Use `any()` in a `verify(...)` only for:
- Primitive types where the exact value doesn't matter
- Simple types (String, Integer) when focus is on other behavior
- Verify that method was called at all (existence check)

```java
// OK - verifying call count, not data
verify(logger, times(3)).log(anyString());

// OK - primitive doesn't affect test focus
when(cache.get(anyString())).thenReturn(Optional.empty());
```

### ArgumentCaptor Best Practices

```java
// Declare at class level for reuse
@Captor
private ArgumentCaptor<Order> orderCaptor;

// Or create inline
var captor = ArgumentCaptor.forClass(Order.class);

// For generic types — forClass is raw, so declare the captor's type explicitly
// or use @Captor, which keeps the generics
@Captor
private ArgumentCaptor<List<Order>> orderListCaptor;

// Verify multiple calls
verify(repository, times(2)).save(captor.capture());
List<Order> allOrders = captor.getAllValues();
assertThat(allOrders).hasSize(2);
```