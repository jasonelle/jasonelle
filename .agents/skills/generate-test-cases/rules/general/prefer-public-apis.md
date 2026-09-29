---
title: Prefer Testing Public APIs Over Private Methods
impact: HIGH
impactDescription: creates resilient tests that survive refactoring
tags: tests, public-api, private-methods, refactoring, resilience
---

## Prefer Testing Public APIs Over Private Methods

Test the public interface of your code. Private methods and implementation-detail classes should be tested indirectly through public APIs.

### Problem: Testing Implementation Details

**Incorrect:**

```java
// Testing private helper class directly
class UserInfoValidatorTest {
    @Test
    void validate_futureDateOfBirth_throwsException() {
        UserInfoValidator validator = new UserInfoValidator();

        assertThatThrownBy(() -> validator.validate(infoWithFutureDob()))
                .isInstanceOf(ValidationException.class);
    }
}

// This test is fragile - if we inline or rename the validator, test breaks
```

**Correct:**

```java
// Test through the public API
class UserInfoServiceTest {
    @Test
    void save_futureDateOfBirth_throwsValidationException() {
        UserInfoService service = new UserInfoService();
        UserInfo info = createUserInfo().dateOfBirth(FUTURE_DATE).build();

        assertThatThrownBy(() -> service.save(info))
                .isInstanceOf(ValidationException.class)
                .hasMessage("Invalid date of birth");
    }

    @Test
    void save_validInfo_persistsToDatabase() {
        UserInfoService service = new UserInfoService();
        UserInfo info = createUserInfo().dateOfBirth(PAST_DATE).build();

        service.save(info);

        assertThat(database.findById(info.getId())).isPresent();
    }
}
```

### When to Test Private/Internal Classes

Test implementation classes separately only when:
1. **Reused across multiple public APIs** - becomes part of the public contract
2. **Complex enough to warrant isolation** - but consider if it should be extracted
3. **Third-party integration** - adapters that wrap external libraries

### Refactoring Freedom

Testing public APIs allows refactoring without changing tests:

```java
// Original implementation
public class UserInfoService {
    private UserInfoValidator validator = new UserInfoValidator();

    public void save(UserInfo info) {
        validator.validate(info);
        writeToDatabase(info);
    }
}

// Refactored - validator inlined
public class UserInfoService {
    public void save(UserInfo info) {
        if (info.getDateOfBirth().isInFuture()) {
            throw new ValidationException("Invalid date of birth");
        }
        writeToDatabase(info);
    }
}

// Tests don't change because they test the public API!
```

### Guidelines

1. **Test behavior, not implementation** - focus on what, not how
2. **Use public methods as entry points** - even for testing edge cases
3. **Private methods are implementation** - should be covered by public method tests
4. **Consider visibility carefully** - if something needs direct testing, maybe it should be public