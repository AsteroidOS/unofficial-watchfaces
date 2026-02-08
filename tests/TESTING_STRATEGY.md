# Testing Strategy for the `watchface` Script

## Overview

This document outlines the comprehensive testing strategy for automating tests of the `watchface` script, a Bash utility for managing AsteroidOS watchfaces.

## Testing Approach

### 1. Test Framework Choice

We use a **custom Bash testing framework** rather than external tools like BATS (Bash Automated Testing System) for several reasons:

- **Zero external dependencies**: Only requires bash and standard Unix tools
- **Easy to understand**: Simple assertion functions and clear test structure
- **Fast execution**: No overhead from external test runners
- **Portable**: Works on any system with bash 4.0+

### 2. Test Categories

#### Unit Tests
Tests for individual functions and components:
- Help and version display
- Argument parsing and validation
- Error handling

#### Integration Tests
Tests for complete workflows:
- Clone command with various inputs
- Test command validation
- End-to-end command execution

#### Validation Tests
Tests for error conditions:
- Invalid commands
- Missing arguments
- Nonexistent watchfaces

### 3. Test Coverage

The current test suite covers:

| Feature | Coverage | Notes |
|---------|----------|-------|
| Help/Version | ✅ Complete | Tests output format and content |
| Clone command | ✅ Complete | Tests with fixtures and real watchfaces |
| Argument validation | ✅ Complete | Tests all error conditions |
| Error handling | ✅ Complete | Tests exit codes and error messages |
| Deploy command | ⚠️ Partial | Requires mock watch connection |
| Test command | ⚠️ Partial | Requires qmlscene (not tested) |
| Interactive menus | ❌ Not tested | Requires dialog/whiptail/zenity |

### 4. Mocking Strategy

#### Test Fixtures
- Creates minimal watchface structures for testing
- Includes necessary directory hierarchy
- Contains simple QML files for validation

#### Limitations
Tests cannot currently cover:
- Actual SSH/ADB connections to watches
- QML runtime testing (qmlscene)
- Interactive menu dialogs
- Font configuration on live systems

These limitations are acceptable as they test the script logic without requiring hardware or complex dependencies.

## Continuous Integration

### GitHub Actions Workflow

The CI pipeline (`test.yml`) runs on:
- Every push to main/master branches
- Every pull request

**Workflow steps:**
1. Checkout repository
2. Set executable permissions
3. Run test suite
4. Archive test artifacts

### CI Benefits
- Catches regressions before merge
- Validates contributions from multiple developers
- Provides confidence in script reliability
- Documents expected behavior

## Test Maintenance

### Adding New Tests

When adding features to `watchface`:

1. **Write the test first** (TDD approach recommended)
2. **Use existing helpers**: `assert_success`, `assert_failure`, `assert_contains`, etc.
3. **Clean up resources**: Use `TEST_TEMP` for temporary files
4. **Add to test runner**: Include in `run_tests()` function

### Debugging Failed Tests

1. Run tests locally: `./tests/test_watchface.sh`
2. Check verbose output for specific failures
3. Inspect `tests/temp/` for test artifacts (if not cleaned)
4. Run individual test functions for isolation

## Future Enhancements

### Potential Improvements

1. **Static Analysis Integration**
   - Add shellcheck for code quality
   - Integrate with CI pipeline

2. **Code Coverage**
   - Track which script functions are tested
   - Identify untested code paths

3. **Performance Testing**
   - Benchmark script operations
   - Detect performance regressions

4. **Mock Watch Connections**
   - Simulate SSH/ADB for deploy tests
   - Test network failure scenarios

5. **Visual Testing**
   - Validate preview image generation
   - Check image formats and sizes

6. **Integration with BATS**
   - Consider migration to BATS for more features
   - Maintain backward compatibility

## Best Practices

### Test Writing Guidelines

1. **Descriptive names**: Use `test_<feature>_<scenario>` naming
2. **Single responsibility**: Each test validates one thing
3. **Independent tests**: No dependencies between tests
4. **Clear assertions**: Use appropriate assertion helpers
5. **Good error messages**: Provide context in assertion messages

### Example Test Pattern

```bash
test_feature_name() {
    echo -e "\n${YELLOW}Testing: Feature description${NC}"
    
    # Setup
    local test_data="..."
    
    # Execute
    result=$("$WATCHFACE_SCRIPT" command "$test_data" 2>&1)
    exit_code=$?
    
    # Assert
    assert_success "$exit_code" "Command succeeds"
    assert_contains "$result" "expected" "Output contains expected text"
    
    # Cleanup (if needed)
}
```

## Conclusion

This testing strategy provides:
- ✅ Automated validation of script functionality
- ✅ Quick feedback on changes
- ✅ Documentation of expected behavior
- ✅ Confidence in deployments
- ✅ Foundation for future enhancements

The approach balances thorough testing with practical limitations, focusing on testable components while acknowledging areas that require hardware or complex mocking.
