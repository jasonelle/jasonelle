---
title: JSON Serialization in Tests
impact: HIGH
impactDescription: prevents test fragility and ensures explicit test data
tags: java, tests, json, serialization, objectmapper, gson
---

## JSON Serialization in Tests

Use explicit JSON string literals instead of runtime serializers to ensure tests are deterministic and clearly show expected data.

### Rules

- **DO NOT** call runtime serializers in tests (`objectMapper.writeValueAsString`, `gson.toJson`, etc.)
- You **MUST** use explicit JSON string literals in stubs and assertions

**Incorrect:**

```java
@Test
void createUser_validRequest_returns201() throws Exception {
    // Using runtime serializer - fragile, unclear expected format
    var request = new UserRequest("John", "john@test.com");
    String requestJson = objectMapper.writeValueAsString(request);

    mockMvc.perform(post("/users")
            .contentType(MediaType.APPLICATION_JSON)
            .content(requestJson))
            .andExpect(status().isCreated());
}

@Test
void getUser_existingId_returnsUser() {
    // Serializing response for comparison - hides expected structure
    var expectedUser = new User("1", "John");
    when(service.findById("1")).thenReturn(expectedUser);

    var result = controller.getUser("1");

    assertThat(objectMapper.writeValueAsString(result))
            .isEqualTo(objectMapper.writeValueAsString(expectedUser));
}
```

**Correct:**

```java
@Test
void createUser_validRequest_returns201() throws Exception {
    // Explicit JSON literal - clear, deterministic
    String requestJson = """
            {
                "name": "John",
                "email": "john@test.com"
            }
            """;

    mockMvc.perform(post("/users")
            .contentType(MediaType.APPLICATION_JSON)
            .content(requestJson))
            .andExpect(status().isCreated());
}

@Test
void getUser_existingId_returnsUserJson() throws Exception {
    // Explicit expected JSON in assertion
    when(service.findById("1")).thenReturn(new User("1", "John"));

    mockMvc.perform(get("/users/1"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.id").value("1"))
            .andExpect(jsonPath("$.name").value("John"));
}

// For WireMock stubs
@Test
void fetchData_validResponse_parsesCorrectly() {
    // Explicit stub response
    stubFor(get("/api/data")
            .willReturn(aResponse()
                    .withHeader("Content-Type", "application/json")
                    .withBody("""
                            {
                                "status": "success",
                                "data": {"value": 42}
                            }
                            """)));
    // ...
}
```

### Note on mockMvc Usage

The `mockMvc` examples above apply to web layer tests (e.g., `@WebMvcTest` or standalone `MockMvcBuilders.standaloneSetup()`). These are distinct from `@SpringBootTest` — they only load the web layer, keeping tests fast. The JSON literal rule applies equally to both web layer tests and pure unit tests.

### Benefits

1. **Readability** - Expected data is visible directly in test
2. **Determinism** - No dependency on serializer configuration
3. **Debugging** - Easy to see what's being tested
4. **Maintenance** - Changes to serializer settings don't break tests