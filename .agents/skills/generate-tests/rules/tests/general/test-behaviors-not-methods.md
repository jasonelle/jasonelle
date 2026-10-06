---
title: Test Behaviors, Not Methods
impact: HIGH
impactDescription: creates resilient tests that survive refactoring
tags: tests, behaviors, resilient, maintainable
---

## Test Behaviors, Not Methods

Structure tests around behaviors (what the system does), not around methods (how it's implemented).

### Problem: Testing a Method

**Incorrect:**

```java
@Test
public void testResetPassword() {
    User user = new User().setPassword("lost password");

    userService.resetPassword(user);

    // Testing multiple behaviors in one test
    assertThat(user.getPassword()).isEmpty();
    assertThat(user.getMailbox().getMessages().get(0).getTitle())
            .isEqualTo("Password reset");
    assertThat(user.getMailbox().getMessages().get(0).getBody())
            .startsWith("You have requested password reset");
    assertThat(counter.get("reset password")).isEqualTo(1);
}
```

**Correct:**

```java
@Test
public void resetPassword_clearsExistingPassword() {
    User user = new User().setPassword("1234");

    userService.resetPassword(user);

    assertThat(user.getPassword()).isEmpty();
}

@Test
public void resetPassword_sendsNotificationEmail() {
    User user = new User().setPassword("1234");

    userService.resetPassword(user);

    assertThat(user.getMailbox().getMessages().get(0).getTitle())
            .isEqualTo("Password reset");
    assertThat(user.getMailbox().getMessages().get(0).getBody())
            .startsWith("You have requested password reset");
}

@Test
public void resetPassword_incrementsResetCounter() {
    User user = new User().setPassword("1234");

    userService.resetPassword(user);

    assertThat(counter.get("reset password")).isEqualTo(1);
}
```

### Benefits

1. **Clear test names** - each test describes one behavior
2. **Focused failures** - when a test fails, you know which behavior broke
3. **Easier refactoring** - changes to one behavior don't affect other tests
4. **Better documentation** - tests describe what the system does

### Identifying Behaviors

Ask: "What are the observable effects of this action?"

For `resetPassword()`:
- User's password becomes empty
- User receives an email
- Reset counter is incremented

Each of these is a separate behavior that should have its own test.

### One Behavior Can Have Multiple Assertions

Testing the email notification behavior:

```java
@Test
public void resetPassword_sendsCorrectNotificationEmail() {
    User user = new User().setPassword("1234").setEmail("john@test.com");

    userService.resetPassword(user);

    // Multiple assertions about the same behavior (the email)
    Message actualEmail = user.getMailbox().getMessages().get(0);
    assertThat(actualEmail.getTo()).isEqualTo("john@test.com");
    assertThat(actualEmail.getTitle()).isEqualTo("Password reset");
    assertThat(actualEmail.getBody()).startsWith("You have requested");
}
```

### Naming Pattern

Name tests after the behavior, not the method:
- `resetPassword_clearsPassword` - describes behavior
- `testResetPassword` - describes method (bad)