---
title: Post-Generation Test Execution Verification
impact: HIGH
impactDescription: ensures generated tests actually pass, not just compile
tags: tests, execution, verification, pass, fail
---

## Post-Generation Test Execution Verification

After tests compile successfully, run them and verify they pass. Tests that compile but fail are not deliverable.

### Process

1. **Run only the generated test class** (not the entire test suite):

| Build System | Command |
|--------------|---------|
| Maven | `mvn test -Dtest={TestClassName} -q` |
| Gradle | `./gradlew test --tests "{fully.qualified.TestClassName}" -q` (use the wrapper) |
| npm/yarn | `npx jest {testFile}` or `npm test -- --testPathPattern={testFile}` |
| Python | `python -m pytest {test_file} -v` |
| Go | `go test -run {TestFuncName} ./...` |
| .NET | `dotnet test --filter "FullyQualifiedName~{TestClassName}"` |

2. **If any test fails:**
   - Read the failure output carefully
   - Identify the root cause (wrong expected value, incorrect mock setup, missing stubbing, wrong method behavior assumption)
   - Fix the test, leaving the production code as it is
   - Re-run to verify the fix
   - Repeat (max 3 fix attempts per failing test)

3. **If a test cannot be fixed after 3 attempts:**
   - Keep it in the file. A test you could not make pass is the most informative
     output of the whole run — it is either a bug in the production code or a
     wrong assumption about it, and that signal is worth more than a green build.
   - Annotate it `@Disabled("<what it asserts, and the failure you could not resolve>")`
     so it stays in the file, stays visible in the test report, and stays runnable
     once the cause is understood
   - Report it explicitly in the summary: the test name, what it asserts, the
     actual failure, and which of the two explanations you think is more likely

### Common Failure Causes and Fixes

**Wrong expected value:**
```java
// Failure: expected "John Doe" but was "John"
// Fix: Read the production code to understand the actual return value
assertThat(actualUser.getName()).isEqualTo("John"); // Match actual behavior
```

**Missing mock stubbing:**
```java
// Failure: Unnecessary stubbings detected / Missing stubbing
// Fix: Only stub methods that are actually called in the code path
when(repository.findById("1")).thenReturn(Optional.of(user)); // Verify this is called
```

**Strict stubbing violation (Mockito):**
```java
// Failure: UnnecessaryStubbingException
// Fix: Remove stubs for methods not called in this specific test scenario
// Do NOT add lenient() — instead, remove the unnecessary stub
```

**NullPointerException in test:**
```java
// Failure: NPE when calling method on result
// Fix: Check if mock returns null by default — add proper stubbing
when(service.findById(any())).thenReturn(Optional.empty()); // stub before calling
```

### IMPORTANT

- Never deliver tests that fail. Passing tests are the minimum bar.
- Do NOT modify production code to make tests pass. Fix the tests instead.
- If the production code has a bug, the test should document the CURRENT behavior and add a comment noting the suspected bug.
