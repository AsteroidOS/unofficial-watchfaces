#!/bin/bash
#
# Quick Test Examples
# Run these commands to test specific scenarios
#

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"

echo "=== Quick Test Examples ==="
echo ""

echo "1. Run all tests:"
echo "   cd $REPO_ROOT && ./tests/test_watchface.sh"
echo ""

echo "2. Test help command:"
echo "   $REPO_ROOT/watchface --help"
echo ""

echo "3. Test version command:"
echo "   $REPO_ROOT/watchface version"
echo ""

echo "4. Test clone command (create temp dir first):"
echo "   cd /tmp && $REPO_ROOT/watchface clone analog-asteroid-logo my-test-clone"
echo ""

echo "5. Test with verbose output:"
echo "   $REPO_ROOT/watchface -v version"
echo ""

echo "6. Test invalid command (should fail):"
echo "   $REPO_ROOT/watchface invalid-command"
echo ""

echo "7. Test clone with wrong arguments (should fail):"
echo "   $REPO_ROOT/watchface clone only-one-arg"
echo ""

echo "=== CI/CD Integration ==="
echo ""
echo "The GitHub Actions workflow runs automatically on:"
echo "  - Push to main/master branches"
echo "  - Pull requests"
echo ""
echo "Workflow file: .github/workflows/test.yml"
echo ""

echo "=== Test Development ==="
echo ""
echo "To add a new test:"
echo "1. Edit tests/test_watchface.sh"
echo "2. Add a new test_* function"
echo "3. Call it from run_tests()"
echo "4. Run ./tests/test_watchface.sh to verify"
echo ""
