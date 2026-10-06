---
title: Logging Output Verification
impact: MEDIUM
impactDescription: enables testing of log output and console messages
tags: java, tests, logging, output-capture, stdout, stderr
---

## Logging Output Verification

Use `OutputCaptureExtension` to capture and verify log output in tests.

### Which Logs to Cover

Whether a log line is consumed downstream — by an alert rule, a log parser, a
dashboard, a compliance report — is decided **outside this repository**, in the
observability stack. The code does not say so, and neither does anything you can read
here. So do not try to infer it, and do not assume a log line is noise because it looks
routine.

Decide by log level instead, which the code does state:

| Level | Cover it | Why |
|---|---|---|
| `ERROR`, `WARN` | Yes | This is what on-call and alerting read. Assume something depends on it. |
| `INFO` | Yes | Emitted deliberately for someone outside the process. Assume the same. |
| `DEBUG`, `TRACE` | No | Developer scaffolding, switched off in production. Not observable output. |

Assert on the **stable part** of the message — the identifiers and values interpolated
into it, not the sentence around them:

```java
// Resilient: survives any rewording of the message
assertThat(output.getOut()).contains("order-123");

// Brittle: breaks the moment someone rephrases the log line
assertThat(output.getOut()).isEqualTo("Processing order: order-123");
```

That keeps coverage of everything operations might depend on without coupling the test
to wording, which is what `what-makes-good-test.md` ("Resilience") asks for. Where the
failure has no identifier to anchor on, asserting the message text is the only option
available — do it, and keep the asserted fragment short.

### Rules

- When testing log output or stdout/stderr, use `@ExtendWith(OutputCaptureExtension.class)`
- Assert the captured output using the `CapturedOutput` parameter

**Incorrect:**

```java
@Test
void processOrder_success_logsMessage() {
    // No way to verify logs
    orderService.processOrder(order);

    // Can't assert anything about logging
}

// Using manual System.out capture - fragile
@Test
void processOrder_success_logsMessage() {
    ByteArrayOutputStream outContent = new ByteArrayOutputStream();
    System.setOut(new PrintStream(outContent));

    orderService.processOrder(order);

    assertThat(outContent.toString()).contains("Order processed");
    System.setOut(System.out); // Don't forget to reset!
}
```

**Correct:**

```java
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.boot.test.system.CapturedOutput;
import org.springframework.boot.test.system.OutputCaptureExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;

@ExtendWith(OutputCaptureExtension.class)
class OrderServiceTest {

    private OrderService orderService = new OrderService();
    private CacheService cacheService = new CacheService();

    @Test
    void processOrder_success_logsOrderId(CapturedOutput output) {
        // Given
        var order = new Order("order-123", "product-1");

        // When
        orderService.processOrder(order);

        // Then — the production line is INFO; anchor on the id, not the wording
        assertThat(output.getOut()).contains("order-123");
    }

    @Test
    void processOrder_failure_logsError(CapturedOutput output) {
        // Given
        var invalidOrder = new Order(null, "product-1");

        // When
        assertThatThrownBy(() -> orderService.processOrder(invalidOrder))
                .isInstanceOf(IllegalArgumentException.class);

        // Then — ERROR, and this path has no id to anchor on: assert a short fragment
        assertThat(output.getErr()).contains("Invalid order");
    }

    @Test
    void cacheHit_secondCall_noLogOutput(CapturedOutput output) {
        // Given
        var key = "key-1";

        // When
        cacheService.getData(key); // First call - cache miss
        cacheService.getData(key); // Second call - cache hit

        // Then - the cache miss is logged at INFO, so it is covered; the hit adds nothing
        assertThat(output.getOut()).containsOnlyOnce("Loading from database");
    }
}
```

### CapturedOutput Methods

```java
// Get stdout content
output.getOut()

// Get stderr content
output.getErr()

// Get all output (stdout + stderr)
output.getAll()

// Use with standard assertions
assertThat(output.getOut()).contains("expected message");
assertThat(output.getOut()).doesNotContain("error");
assertThat(output.getErr()).isEmpty();
```

### Dependency Note

`OutputCaptureExtension` and `CapturedOutput` come from the `spring-boot-test` dependency (`org.springframework.boot:spring-boot-test`). This extension does **NOT** start a Spring context — it only captures `System.out`/`System.err`, so it is fully compatible with unit tests (no `@SpringBootTest` needed).

For non-Spring projects, use alternative approaches:
- SLF4J's `ListAppender` to capture log events programmatically
- JUnit 5's `@ExtendWith` with a custom extension that redirects stdout/stderr

### Use Cases

1. **Error and warning logs** - verify failures are recorded, with the identifiers
   needed to trace them
2. **INFO lifecycle events** - verify important events are logged
3. **Cache behavior** - verify cache hits/misses, when the miss is logged at INFO or above

`DEBUG` and `TRACE` output is out of scope — it is off in production, so no test
should depend on it.