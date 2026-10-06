---
title: Java Test Template
impact: HIGH
impactDescription: ensures consistent test structure and prevents inappropriate annotations
tags: java, tests, template, junit, structure
---

## Java Test Template

Use JUnit 5 with consistent structure. Avoid inappropriate annotations that slow down tests.

### FORBIDDEN

- **FORBIDDEN** to use `@SpringBootTest` in unit tests unless explicitly required by the template for that specific test type.

**Incorrect:**

```java
// Using @SpringBootTest for unit test
@SpringBootTest
class CalculatorServiceTest {

    @Autowired
    private CalculatorService calculatorService;

    @Test
    void calculate_validInput_returnsResult() {
        // ...
    }
}
```

**Correct:**

```java
package com.example.service;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.mockito.Mockito.when;

@ExtendWith(MockitoExtension.class)
class CalculatorServiceTest {

    @Mock
    private DependencyService dependencyService;

    @InjectMocks
    private CalculatorService calculatorService;

    @Test
    void calculate_validInput_returnsResult() {
        // Given
        when(dependencyService.getValue()).thenReturn(10);

        // When
        int actualResult = calculatorService.calculate(5);

        // Then
        int expectedResult = 15;
        assertThat(actualResult).isEqualTo(expectedResult);
    }

    @Test
    void calculate_negativeInput_throwsIllegalArgumentException() {
        // Given-When-Then
        assertThatThrownBy(() -> calculatorService.calculate(-1))
                .isInstanceOf(IllegalArgumentException.class)
                .hasMessage("Input must be positive");
    }
}
```

### Basic Template Structure

```java
package {SUT_PACKAGE};

import org.junit.jupiter.api.Test;

class {TestedClassName}Test {

    @Test
    void {testedMethod}_{givenState}_{expectedOutcome}() {
        // Given
        // When
        // Then
    }

    @Test
    void {testedMethod}_anotherState_expectedResult() {
        // Given-When-Then
    }
}
```

### Key Points

1. Place test class in same package as SUT (System Under Test)
2. Use `@ExtendWith(MockitoExtension.class)` for mocking dependencies
3. Use `@Mock` for dependencies, `@InjectMocks` for SUT
4. Follow Given-When-Then pattern with comments
5. Use AssertJ assertions (`assertThat()`) for better readability