---
title: Only Verify Relevant Method Arguments
impact: MEDIUM
impactDescription: reduces test fragility and focuses verification on tested behavior
tags: tests, verification, mocks, arguments, focused
---

## Only Verify Relevant Method Arguments

When verifying mock interactions, only check arguments that are relevant to the specific behavior being tested. Use `any()` for irrelevant arguments.

### Problem: Over-Specified Verification

**Incorrect:**

```java
@Test
public void displayGreeting_showsSpecialGreetingOnNewYearsDay() {
    clock.setTime(NEW_YEARS_DAY);
    user.setName("Frank Sinatra");

    userGreeter.displayGreeting();

    // Verifying ALL arguments - fragile!
    verify(userPrompter).updatePrompt(
            "Hi Frank Sinatra! Happy New Year!",
            TitleBar.of("2024-01-01"),
            PromptStyle.NORMAL
    );
}
// This test breaks if TitleBar format or PromptStyle changes,
// even though it's testing the greeting message
```

**Correct:**

```java
@Test
public void displayGreeting_showsSpecialGreetingOnNewYearsDay() {
    clock.setTime(NEW_YEARS_DAY);
    user.setName("Frank Sinatra");

    userGreeter.displayGreeting();

    // Only verify the argument this test cares about
    verify(userPrompter)
            .updatePrompt(eq("Hi Frank Sinatra! Happy New Year!"), any(), any());
}

@Test
public void displayGreeting_usesTitleBarWithCurrentDate() {
    clock.setTime(NEW_YEARS_DAY);

    userGreeter.displayGreeting();

    // This test focuses on TitleBar
    verify(userPrompter)
            .updatePrompt(any(), eq(TitleBar.of("2024-01-01")), any());
}

@Test
public void displayGreeting_usesNormalPromptStyle() {
    userGreeter.displayGreeting();

    // This test focuses on PromptStyle
    verify(userPrompter)
            .updatePrompt(any(), any(), eq(PromptStyle.NORMAL));
}
```

### Benefits

1. **Focused tests** - each test verifies one behavior
2. **Resilient tests** - changes to unrelated arguments don't break tests
3. **Clear intent** - obvious what behavior is being tested

### When to Verify All Arguments

Verify all arguments only when they're all relevant to the behavior:

```java
@Test
public void sendEmail_allFieldsAreCorrect() {
    // When testing the complete email composition
    orderService.sendConfirmation(order);

    verify(emailService).send(
            eq("customer@test.com"),
            eq("Order Confirmation #123"),
            contains("Thank you for your order")
    );
}
```

### Combining with ArgumentCaptor

This rule stops at the boundary of the captured object. Which *arguments* of the call to
pin is decided here; which *fields inside* a captured object to assert is decided by
`keep-tests-focused.md` — assert together the fields whose failure means the outcome in
the test's name is wrong, and give a field that could be wrong on its own its own test.

```java
@Test
public void createOrder_validRequest_savesOrderWithRequestedProductAndQuantity() {
    var captor = ArgumentCaptor.forClass(Order.class);

    orderService.createOrder(new OrderRequest("product-123", 5));

    verify(repository).save(captor.capture());
    Order actualOrder = captor.getValue();
    assertThat(actualOrder.getProductId()).isEqualTo("product-123");
    assertThat(actualOrder.getQuantity()).isEqualTo(5);
}
```