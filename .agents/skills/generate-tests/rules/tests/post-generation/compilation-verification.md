---
title: Post-Generation Compilation Verification
impact: HIGH
impactDescription: ensures generated tests compile successfully before delivery
tags: tests, compilation, verification, build, ci
---

## Post-Generation Compilation Verification

After generating test files, verify they compile successfully. Fix any issues before completing the task.

### Compilation Commands by Build System

| Build System | Command |
|--------------|---------|
| Maven | `mvn test-compile -q` |
| Gradle | `./gradlew testClasses -q` (use the wrapper; a bare `gradle` may be absent or the wrong version) |
| npm/yarn | `npm run build` or `npx tsc --noEmit` |
| Python | `python -m py_compile <test_file>` |
| Go | `go build ./...` |
| Rust | `cargo check --tests` |
| .NET | `dotnet build` |
| Mix (Elixir) | `mix compile` |
| sbt (Scala) | `sbt Test/compile` |
| Swift | `swift build` |

### Process

1. **Create the test file** in the correct location
2. **Run compilation** using the appropriate command
3. **If compilation fails:**
   - Read the error message
   - Fix the issue (missing imports, wrong dependencies, syntax errors)
   - Add missing dependencies to the appropriate config file
   - Re-run compilation
4. **Repeat until successful** (max 5 attempts)

### Common Issues and Fixes

**Missing Imports:**
```java
// Error: cannot find symbol
// Fix: Add the missing import
import org.junit.jupiter.api.Test;
import static org.assertj.core.api.Assertions.assertThat;
```

**Missing Dependencies (Maven):**
```xml
<!-- Add to pom.xml -->
<dependency>
    <groupId>org.testcontainers</groupId>
    <artifactId>testcontainers</artifactId>
    <scope>test</scope>
</dependency>
```

**Missing Dependencies (Gradle):**
```groovy
// Add to build.gradle
testImplementation 'org.testcontainers:testcontainers'
testImplementation 'org.testcontainers:junit-jupiter'
```

**Wrong Package:**
```java
// Error: package does not exist
// Fix: Verify package declaration matches directory structure
package com.example.service; // Must match src/test/java/com/example/service/
```

**Type Mismatch:**
```java
// Error: incompatible types
// Fix: Check return types and parameter types
// Wrong: assertThat(result).isEqualTo("123");  // if result is Long
// Correct: assertThat(result).isEqualTo(123L);
```

### Verification Checklist

- [ ] Test file is in correct directory
- [ ] Package declaration matches directory structure
- [ ] All imports are present and correct
- [ ] All dependencies are available
- [ ] No syntax errors
- [ ] Type compatibility is correct
- [ ] Compilation command succeeds

### Example Workflow

```bash
# 1. Create test file
# (using Write tool)

# 2. Run compilation
mvn test-compile -q

# 3. If errors, fix and retry
# Error: cannot find symbol: class LocalStackContainer
# Fix: Add testcontainers dependency

# 4. Verify success
mvn test-compile -q
# BUILD SUCCESS
```

**IMPORTANT:** Never deliver tests that don't compile. Always verify compilation before completing the task.