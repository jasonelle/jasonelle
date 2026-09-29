---
title: Domain and Service Unit Test Rules
impact: HIGH
impactDescription: ensures fast, isolated unit tests for business logic
tags: java, tests, unit, domain, service, mockito
---

## Domain and Service Unit Test Rules

Use Mockito for unit testing services and domain logic. Keep tests fast and isolated.

### Rules

- Use `@ExtendWith(MockitoExtension.class)` for collaborators
- Do NOT start frameworks or containers for unit tests
- Mock external dependencies, not the system under test
- Never mock simple value objects
- Capture arguments in `verify(...)` — Mockito documents captors as a verification
  tool. A captor in a stub captures only when a call matches that stub, so a test that
  never reaches it fails late at `captor.getValue()` ("No argument value was
  captured!") instead of at the call that never happened

**Incorrect:**

```java
// Starting Spring context for unit test - slow!
@SpringBootTest
class OrderServiceTest {

    @Autowired
    private OrderService orderService;

    @Test
    void calculateTotal_validOrder_returnsSum() {
        // ...
    }
}

// Mocking value objects - unnecessary
@Test
void processOrder_validOrder_calculatesCorrectly() {
    var mockProduct = mock(Product.class);
    when(mockProduct.getPrice()).thenReturn(100.0);
    when(mockProduct.getName()).thenReturn("Test");
    // ...
}
```

**Correct:**

```java
import java.util.List;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.ArgumentCaptor;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import static org.assertj.core.api.Assertions.assertThat;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
class OrderServiceTest {

    @Mock
    private OrderRepository orderRepository;

    @Mock
    private PaymentService paymentService;

    @Mock
    private NotificationService notificationService;

    @InjectMocks
    private OrderService orderService;

    @Test
    void createOrder_validRequest_savesAndReturnsOrder() {
        // Given
        var request = new OrderRequest("product-1", 5);
        var savedOrder = new Order("order-123", "product-1", 5);
        when(orderRepository.save(any(Order.class))).thenReturn(savedOrder);

        // When
        Order actualOrder = orderService.createOrder(request);

        // Then
        assertThat(actualOrder.getId()).isEqualTo("order-123");

        var captor = ArgumentCaptor.forClass(Order.class);
        verify(orderRepository).save(captor.capture());
        Order capturedOrder = captor.getValue();
        assertThat(capturedOrder.getProductId()).isEqualTo("product-1");
        assertThat(capturedOrder.getQuantity()).isEqualTo(5);
    }

    @Test
    void processPayment_validOrder_callsPaymentService() {
        // Given
        var order = new Order("order-123", "product-1", 5);
        order.setTotal(500.0);
        when(paymentService.charge("order-123", 500.0)).thenReturn(true);

        // When
        boolean actualResult = orderService.processPayment(order);

        // Then
        assertThat(actualResult).isTrue();
        verify(paymentService).charge("order-123", 500.0);
    }

    @Test
    void processPayment_paymentFails_throwsPaymentException() {
        // Given
        var order = new Order("order-123", "product-1", 5);
        order.setTotal(500.0);
        when(paymentService.charge("order-123", 500.0)).thenReturn(false);

        // When-Then
        assertThatThrownBy(() -> orderService.processPayment(order))
                .isInstanceOf(PaymentException.class)
                .hasMessageContaining("Payment failed");
    }

    @Test
    void calculateTotal_multipleProducts_returnsSumOfPrices() {
        // Given - use real value objects
        var product1 = new Product("A", 50.0);
        var product2 = new Product("B", 100.0);
        var order = new Order(List.of(product1, product2));

        // When
        double actualTotal = orderService.calculateTotal(order);

        // Then
        assertThat(actualTotal).isEqualTo(150.0);
    }
}
```

### What to Mock vs What to Use Real Objects

**Mock:**
- Repositories / DAOs
- External service clients
- Messaging producers
- Cache services
- Any I/O operation

**Use Real Objects:**
- DTOs / Value Objects
- Domain entities (in most cases)
- Utility classes
- Mappers (usually)

### Verification Patterns

```java
// Verify method was called with ArgumentCaptor for model objects
var captor = ArgumentCaptor.forClass(Order.class);
verify(repository).save(captor.capture());
assertThat(captor.getValue().getProductId()).isEqualTo("product-1");

// Verify method was NOT called
verify(notificationService, never()).send(any());

// Verify call count
verify(repository, times(2)).findById(anyString());

// Verify no more interactions
verifyNoMoreInteractions(paymentService);
```