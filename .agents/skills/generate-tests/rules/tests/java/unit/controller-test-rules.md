---
title: Controller Test Rules
impact: HIGH
impactDescription: ensures correct web layer testing with MockMvc patterns
tags: java, tests, controller, webmvc, mockmvc, spring
---

## Controller Test Rules

Test Spring controllers using `@WebMvcTest` for isolated web layer tests. Keep controller tests focused on HTTP concerns: request mapping, validation, serialization, and status codes.

### Why `@WebMvcTest` Is the One Framework Exception

`domain-service-rules.md` and `java-test-template.md` keep frameworks out of unit tests.
`@WebMvcTest` does start a Spring context, so it is a **slice test** rather than a pure
unit test — and it is the one exception this distribution allows, because a controller's
behaviour *is* the framework: routing, binding, validation and serialisation have no
observable existence outside it. Calling a controller method directly exercises a plain
Java method and leaves everything the controller exists for untested.

The exception is scoped to controllers; every other unit test stays framework-free.

### Test Setup

Use `@WebMvcTest` to load only the web layer for the target controller.

**FORBIDDEN:** Using `@SpringBootTest` for controller unit tests.

**Incorrect:**

```java
@SpringBootTest
@AutoConfigureMockMvc
class UserControllerTest {
    @Autowired
    private MockMvc mockMvc;
    // Loads the ENTIRE application context - slow!
}
```

**Correct:**

```java
@WebMvcTest(UserController.class)
class UserControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private UserService userService;

    @Test
    void getUser_existingId_returns200WithUser() throws Exception {
        // Given
        var expectedUser = new User("1", "John", "john@test.com");
        when(userService.findById("1")).thenReturn(expectedUser);

        // When-Then
        mockMvc.perform(get("/api/users/1"))
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.id").value("1"))
                .andExpect(jsonPath("$.name").value("John"))
                .andExpect(jsonPath("$.email").value("john@test.com"));
    }
}
```

### Key Annotations

| Annotation | Usage |
|------------|-------|
| `@WebMvcTest(Controller.class)` | Loads only web layer for the specified controller |
| `@MockitoBean` | Creates a Mockito mock and registers it in the Spring context (Spring Boot 3.4+) |
| `@MockBean` | Use this instead of `@MockitoBean` for Spring Boot versions below 3.4 |
| `@Autowired MockMvc` | Inject the MockMvc instance for request simulation |

**Note:** Use `@MockitoBean` (Spring Boot 3.4+). For Spring Boot < 3.4, use `@MockBean` from `org.springframework.boot.test.mock.mockito`.

### What to Test in Controllers

1. **Request mapping**: Correct URL, HTTP method, content type
2. **Request validation**: `@Valid` / `@Validated` annotations trigger validation
3. **Response status codes**: 200, 201, 400, 401, 403, 404, etc.
4. **Response body**: JSON structure via `jsonPath()` assertions
5. **Path variables and query parameters**: Correct binding
6. **Exception handling**: `@ControllerAdvice` / `@ExceptionHandler` responses

### Request Validation Testing

When a field carries **more than one** constraint, assert the constraint that should
have rejected the input, not merely that the field has an error. `attributeHasFieldErrors`
passes on any error on that field, so it keeps passing after the constraint under test
is removed — as long as a different one still fires.

```java
// phone is annotated @NotBlank AND @Pattern(regexp = "\\d{10}")

// Weak: also passes if @Pattern is deleted, because @NotBlank still rejects ""
.andExpect(model().attributeHasFieldErrors("user", "phone"))

// Names the constraint under test
.andExpect(model().attributeHasFieldErrorCode("user", "phone", "Pattern"))
```

The code is the constraint's simple name — `NotBlank`, `Size`, `Pattern`, `Email` — or
the code passed to `result.rejectValue(field, code, message)` for a rejection the
handler makes itself.


```java
@Test
void createUser_blankName_returns400() throws Exception {
    String requestJson = """
            {
                "name": "",
                "email": "john@test.com"
            }
            """;

    mockMvc.perform(post("/api/users")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(requestJson))
            .andExpect(status().isBadRequest());
}

@Test
void createUser_invalidEmail_returns400() throws Exception {
    String requestJson = """
            {
                "name": "John",
                "email": "not-an-email"
            }
            """;

    mockMvc.perform(post("/api/users")
                    .contentType(MediaType.APPLICATION_JSON)
                    .content(requestJson))
            .andExpect(status().isBadRequest());
}
```

### Security Annotation Testing

When the controller uses `@PreAuthorize`, `@Secured`, or `@RolesAllowed`:

```java
@WebMvcTest(AdminController.class)
@Import(SecurityConfig.class) // Import your security configuration
class AdminControllerTest {

    @Autowired
    private MockMvc mockMvc;

    @MockitoBean
    private AdminService adminService;

    @Test
    @WithMockUser(roles = "ADMIN")
    void deleteUser_adminRole_returns204() throws Exception {
        mockMvc.perform(delete("/api/admin/users/1"))
                .andExpect(status().isNoContent());
    }

    @Test
    @WithMockUser(roles = "USER")
    void deleteUser_userRole_returns403() throws Exception {
        mockMvc.perform(delete("/api/admin/users/1"))
                .andExpect(status().isForbidden());
    }

    // Status depends on the entry point — see "Unauthenticated Requests" below.
    // This example assumes httpBasic.
    @Test
    void deleteUser_unauthenticated_returnsUnauthorized() throws Exception {
        mockMvc.perform(delete("/api/admin/users/1"))
                .andExpect(status().isUnauthorized());
    }
}
```

#### Unauthenticated Requests

A request with no authentication does not have one correct status. The configured
`AuthenticationEntryPoint` decides it, so read the project's `SecurityConfig` and
assert what that chain actually produces:

| Entry point in `SecurityConfig` | Status | Test name |
|---|---|---|
| `httpBasic()` | 401 Unauthorized | `..._unauthenticated_returnsUnauthorized` |
| `formLogin()` | 302 redirect to the login page | `..._unauthenticated_redirectsToLogin` |
| none configured | 403 Forbidden | `..._unauthenticated_returnsForbidden` |

Name the test after the outcome you assert, not after a status code copied from
another project.

### Redirects

A handler that returns `"redirect:/..."` decides two things: that it redirects, and
where to. Assert both — a flash-attribute assertion alone leaves the destination
untested, and the destination is usually built from data the handler produced.

```java
.andExpect(redirectedUrl("/users/42"));         // concrete path
.andExpect(redirectedUrlPattern("**/login"));   // when part of the path varies
```

Where the path carries an id the handler produced, stub the save to assign it, so the
assertion names a concrete path. `view().name("redirect:/users/{id}")` asserts the
unresolved template and says nothing about the value substituted into it, so prefer
`redirectedUrl` when that value is the point.

### Service Exception Handling

Test how the controller handles exceptions thrown by the service layer:

```java
@Test
void getUser_nonExistentId_returns404() throws Exception {
    // Given
    when(userService.findById("999")).thenThrow(new UserNotFoundException("999"));

    // When-Then
    mockMvc.perform(get("/api/users/999"))
            .andExpect(status().isNotFound());
}
```

### Pagination and Query Parameters

```java
@Test
void listUsers_withPagination_returns200WithPage() throws Exception {
    // Given
    var page = new PageImpl<>(List.of(new User("1", "John", "john@test.com")));
    when(userService.findAll(any(Pageable.class))).thenReturn(page);

    // When-Then
    mockMvc.perform(get("/api/users")
                    .param("page", "0")
                    .param("size", "10"))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.content").isArray())
            .andExpect(jsonPath("$.content[0].id").value("1"));
}
```
