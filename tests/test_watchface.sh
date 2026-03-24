#!/bin/bash
#
# Test suite for the watchface script
# This file contains automated tests for the watchface utility
#

# Test configuration
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
WATCHFACE_SCRIPT="${REPO_ROOT}/watchface"
TEST_FIXTURES="${SCRIPT_DIR}/fixtures"
TEST_TEMP="${SCRIPT_DIR}/temp"

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Setup function - called before tests
setup() {
    mkdir -p "${TEST_TEMP}"
    mkdir -p "${TEST_FIXTURES}"
}

# Teardown function - called after tests
teardown() {
    if [ -d "${TEST_TEMP}" ]; then
        rm -rf "${TEST_TEMP}"
    fi
}

# Test helper functions
assert_equals() {
    local expected="$1"
    local actual="$2"
    local message="${3:-Assertion failed}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$expected" = "$actual" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        echo "  Expected: $expected"
        echo "  Actual:   $actual"
        return 1
    fi
}

assert_success() {
    local exit_code=$1
    local message="${2:-Command should succeed}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$exit_code" -eq 0 ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message (exit code: $exit_code)"
        return 1
    fi
}

assert_failure() {
    local exit_code=$1
    local message="${2:-Command should fail}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ "$exit_code" -ne 0 ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message (expected non-zero exit code)"
        return 1
    fi
}

assert_file_exists() {
    local file="$1"
    local message="${2:-File should exist: $file}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ -f "$file" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        return 1
    fi
}

assert_dir_exists() {
    local dir="$1"
    local message="${2:-Directory should exist: $dir}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [ -d "$dir" ]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        return 1
    fi
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    local message="${3:-String should contain substring}"
    
    TESTS_RUN=$((TESTS_RUN + 1))
    
    if [[ "$haystack" == *"$needle"* ]]; then
        TESTS_PASSED=$((TESTS_PASSED + 1))
        echo -e "${GREEN}✓${NC} $message"
        return 0
    else
        TESTS_FAILED=$((TESTS_FAILED + 1))
        echo -e "${RED}✗${NC} $message"
        echo "  Looking for: $needle"
        echo "  In: $haystack"
        return 1
    fi
}

# Create a minimal test watchface fixture
create_test_watchface() {
    local name="$1"
    local base_dir="${2:-$TEST_FIXTURES}"
    local watchface_dir="${base_dir}/${name}"
    
    mkdir -p "${watchface_dir}/usr/share/asteroid-launcher/watchfaces"
    mkdir -p "${watchface_dir}/usr/share/asteroid-launcher/watchfaces-preview/128"
    
    # Create a minimal QML file
    cat > "${watchface_dir}/usr/share/asteroid-launcher/watchfaces/${name}.qml" << EOF
import QtQuick 2.0

Item {
    id: ${name}
    anchors.fill: parent
    
    Text {
        anchors.centerIn: parent
        text: "Test Watchface: ${name}"
        color: "white"
    }
}
EOF
    
    # Create a dummy preview image
    touch "${watchface_dir}/usr/share/asteroid-launcher/watchfaces-preview/128/${name}.png"
    
    echo "$watchface_dir"
}

# ============================================================================
# Test Cases
# ============================================================================

# Test: Script exists and is executable
test_script_exists() {
    echo -e "\n${YELLOW}Testing: Script exists and is executable${NC}"
    assert_file_exists "$WATCHFACE_SCRIPT" "Watchface script exists"
    
    if [ -x "$WATCHFACE_SCRIPT" ]; then
        assert_success 0 "Watchface script is executable"
    else
        assert_failure 0 "Watchface script is executable"
    fi
}

# Test: Help option works
test_help_option() {
    echo -e "\n${YELLOW}Testing: Help option${NC}"
    
    local output
    output=$("$WATCHFACE_SCRIPT" --help 2>&1)
    local exit_code=$?
    
    # Note: The script exits with code 1 for help (non-standard but existing behavior)
    # We test the output content rather than the exit code
    assert_contains "$output" "watchface" "Help output contains script name"
    assert_contains "$output" "Available options" "Help output contains options section"
    assert_contains "$output" "Available commands" "Help output contains commands section"
}

# Test: Version option works
test_version_option() {
    echo -e "\n${YELLOW}Testing: Version option${NC}"
    
    local output
    output=$("$WATCHFACE_SCRIPT" version 2>&1)
    local exit_code=$?
    
    assert_success "$exit_code" "Version command returns success"
    assert_contains "$output" "watchface v" "Version output contains version number"
}

# Test: Clone command with valid watchface
test_clone_command() {
    echo -e "\n${YELLOW}Testing: Clone command${NC}"
    
    # Create a source watchface
    local source_name="test-source-watchface"
    create_test_watchface "$source_name" "$TEST_TEMP"
    
    # Clone it
    cd "$TEST_TEMP"
    local dest_name="test-cloned-watchface"
    "$WATCHFACE_SCRIPT" clone "$source_name" "$dest_name" 2>&1
    local exit_code=$?
    
    assert_success "$exit_code" "Clone command succeeds"
    assert_dir_exists "${TEST_TEMP}/${dest_name}" "Cloned watchface directory exists"
    assert_file_exists "${TEST_TEMP}/${dest_name}/usr/share/asteroid-launcher/watchfaces/${dest_name}.qml" "Cloned QML file exists with new name"
    
    # Check that the content was updated
    if [ -f "${TEST_TEMP}/${dest_name}/usr/share/asteroid-launcher/watchfaces/${dest_name}.qml" ]; then
        local content
        content=$(cat "${TEST_TEMP}/${dest_name}/usr/share/asteroid-launcher/watchfaces/${dest_name}.qml")
        assert_contains "$content" "$dest_name" "QML file content references new name"
    fi
    
    cd "$REPO_ROOT"
}

# Test: Clone command with invalid source
test_clone_invalid_source() {
    echo -e "\n${YELLOW}Testing: Clone command with invalid source${NC}"
    
    cd "$TEST_TEMP"
    "$WATCHFACE_SCRIPT" clone "nonexistent-watchface" "test-dest" 2>&1
    local exit_code=$?
    
    assert_failure "$exit_code" "Clone command fails with invalid source"
    cd "$REPO_ROOT"
}

# Test: Clone command with existing real watchface
test_clone_real_watchface() {
    echo -e "\n${YELLOW}Testing: Clone command with real watchface${NC}"
    
    # Find a real watchface in the repo
    local real_watchface="analog-asteroid-logo"
    
    if [ ! -d "${REPO_ROOT}/${real_watchface}" ]; then
        echo -e "${YELLOW}Skipping test - ${real_watchface} not found${NC}"
        return
    fi
    
    cd "$REPO_ROOT"
    local dest_name="test-cloned-real"
    # Use relative path from repo root
    "$WATCHFACE_SCRIPT" clone "${real_watchface}" "${TEST_TEMP}/${dest_name}" 2>&1
    local exit_code=$?
    
    assert_success "$exit_code" "Clone command succeeds with real watchface"
    assert_dir_exists "${TEST_TEMP}/${dest_name}" "Cloned watchface directory exists"
    
    cd "$REPO_ROOT"
}

# Test: Invalid command
test_invalid_command() {
    echo -e "\n${YELLOW}Testing: Invalid command${NC}"
    
    "$WATCHFACE_SCRIPT" invalid-command-xyz 2>&1
    local exit_code=$?
    
    assert_failure "$exit_code" "Invalid command returns error"
}

# Test: Clone with wrong number of arguments
test_clone_wrong_args() {
    echo -e "\n${YELLOW}Testing: Clone command with wrong arguments${NC}"
    
    "$WATCHFACE_SCRIPT" clone only-one-arg 2>&1
    local exit_code=$?
    
    assert_failure "$exit_code" "Clone with one argument fails"
    
    "$WATCHFACE_SCRIPT" clone arg1 arg2 arg3 2>&1
    local exit_code=$?
    
    assert_failure "$exit_code" "Clone with three arguments fails"
}

# Test: Test command validation (without actually running qmlscene)
test_test_command_validation() {
    echo -e "\n${YELLOW}Testing: Test command validation${NC}"
    
    # Test with invalid watchface
    "$WATCHFACE_SCRIPT" test nonexistent-watchface 2>&1
    local exit_code=$?
    
    assert_failure "$exit_code" "Test command fails with nonexistent watchface"
}

# ============================================================================
# Test Runner
# ============================================================================

run_tests() {
    echo "======================================"
    echo "  Watchface Script Test Suite"
    echo "======================================"
    
    setup
    
    # Run all tests
    test_script_exists
    test_help_option
    test_version_option
    test_clone_command
    test_clone_invalid_source
    test_clone_real_watchface
    test_invalid_command
    test_clone_wrong_args
    test_test_command_validation
    
    teardown
    
    # Print summary
    echo ""
    echo "======================================"
    echo "  Test Results"
    echo "======================================"
    echo -e "Tests run:    $TESTS_RUN"
    echo -e "${GREEN}Passed:       $TESTS_PASSED${NC}"
    echo -e "${RED}Failed:       $TESTS_FAILED${NC}"
    echo "======================================"
    
    if [ $TESTS_FAILED -eq 0 ]; then
        echo -e "${GREEN}All tests passed!${NC}"
        exit 0
    else
        echo -e "${RED}Some tests failed!${NC}"
        exit 1
    fi
}

# Run tests if script is executed directly
if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    run_tests
fi
