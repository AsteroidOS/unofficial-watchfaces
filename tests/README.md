# Watchface Script Test Suite

This directory contains automated tests for the `watchface` script.

## Overview

The test suite provides comprehensive testing coverage for the `watchface` utility script, including:

- **Unit tests**: Testing individual functions and components
- **Integration tests**: Testing command-line interface and workflows
- **Validation tests**: Testing error handling and edge cases

## Running Tests

### Quick Start

Run all tests:
```bash
./tests/test_watchface.sh
```

### Test Structure

- `test_watchface.sh` - Main test suite with all test cases
- `fixtures/` - Test data and sample watchfaces
- `temp/` - Temporary directory for test artifacts (auto-cleaned)

## Test Coverage

### Commands Tested

1. **Help and Version**
   - `--help` flag displays usage information
   - `version` command shows version number

2. **Clone Command**
   - Clone existing watchfaces to new names
   - Proper file copying and name substitution
   - Error handling for invalid sources

3. **Test Command**
   - Validation of watchface existence
   - Error handling for nonexistent watchfaces

4. **Error Handling**
   - Invalid commands
   - Wrong number of arguments
   - Missing required arguments

### Test Assertions

The test framework includes several assertion helpers:

- `assert_equals` - Compare two values
- `assert_success` - Verify command succeeded (exit code 0)
- `assert_failure` - Verify command failed (non-zero exit code)
- `assert_file_exists` - Check file existence
- `assert_dir_exists` - Check directory existence
- `assert_contains` - Verify string contains substring

## Continuous Integration

Tests are automatically run on every push and pull request via GitHub Actions.
See `.github/workflows/test.yml` for the CI configuration.

## Test Philosophy

These tests follow these principles:

1. **Minimal dependencies**: Tests use only bash and standard Unix tools
2. **Fast execution**: Tests complete in seconds
3. **Clear output**: Color-coded pass/fail with detailed messages
4. **Isolation**: Each test is independent and doesn't affect others
5. **No side effects**: Tests clean up after themselves

## Adding New Tests

To add new tests:

1. Add a new test function following the naming convention `test_*`
2. Use the provided assertion helpers for validation
3. Add the test function call in the `run_tests()` function
4. Ensure proper cleanup of any temporary resources

Example:
```bash
test_my_new_feature() {
    echo -e "\n${YELLOW}Testing: My new feature${NC}"
    
    # Test implementation
    local result=$("$WATCHFACE_SCRIPT" mycommand 2>&1)
    local exit_code=$?
    
    assert_success "$exit_code" "My command succeeds"
    assert_contains "$result" "expected output" "Output is correct"
}
```

## Known Limitations

These tests focus on CLI functionality that doesn't require:

- An actual AsteroidOS watch connected
- Qt/QML runtime (qmlscene)
- SSH/ADB connections
- GUI tools (zenity, dialog, whiptail)

Tests that require these dependencies are either mocked or skipped.

## Troubleshooting

If tests fail:

1. Check that you're running from the repository root or tests directory
2. Ensure the `watchface` script is executable: `chmod +x watchface`
3. Review the test output for specific failure messages
4. Check that you have bash 4.0+ installed: `bash --version`

## Future Enhancements

Potential improvements for the test suite:

- Mock SSH/ADB connections for deployment tests
- Integration with shellcheck for static analysis
- Code coverage reporting
- Performance benchmarking tests
- Visual regression testing for preview images
