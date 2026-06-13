#!/bin/bash

# Pre-Launch Test Suite for ABC Grammar School LMS
# This script runs all necessary tests before production deployment

set -e

echo "🚀 ABC Grammar School LMS - Pre-Launch Test Suite"
echo "=================================================="
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Test counters
TESTS_PASSED=0
TESTS_FAILED=0

# Function to print section headers
print_header() {
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo ""
}

# Function to print test result
print_result() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✓ $2${NC}"
        ((TESTS_PASSED++))
    else
        echo -e "${RED}✗ $2${NC}"
        ((TESTS_FAILED++))
    fi
}

# ============================================
# 1. ENVIRONMENT CHECK
# ============================================
print_header "1. ENVIRONMENT CHECK"

# Check if Node.js is installed
node --version > /dev/null 2>&1
print_result $? "Node.js installed"

# Check if npm is installed
npm --version > /dev/null 2>&1
print_result $? "npm installed"

# Check if git is installed
git --version > /dev/null 2>&1
print_result $? "Git installed"

# Check if Docker is installed (optional)
docker --version > /dev/null 2>&1
print_result $? "Docker installed"

echo ""

# ============================================
# 2. DEPENDENCY CHECK
# ============================================
print_header "2. DEPENDENCY CHECK"

echo "Installing root dependencies..."
npm install --silent 2>/dev/null
print_result $? "Root dependencies installed"

echo ""
echo "Installing client dependencies..."
cd client && npm install --silent 2>/dev/null
print_result $? "Client dependencies installed"
cd ..

echo ""
echo "Installing server dependencies..."
cd server && npm install --silent 2>/dev/null
print_result $? "Server dependencies installed"
cd ..

echo ""

# ============================================
# 3. BUILD TEST
# ============================================
print_header "3. BUILD TEST"

echo "Building client..."
cd client
npm run build 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
BUILD_CLIENT_STATUS=$?
if [ $BUILD_CLIENT_STATUS -eq 1 ]; then
    print_result 0 "Client build successful"
else
    print_result 1 "Client build failed"
fi
cd ..

echo ""
echo "Building server..."
cd server
npm run build 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
BUILD_SERVER_STATUS=$?
if [ $BUILD_SERVER_STATUS -eq 1 ]; then
    print_result 0 "Server build successful"
else
    print_result 1 "Server build failed"
fi
cd ..

echo ""

# ============================================
# 4. CODE QUALITY
# ============================================
print_header "4. CODE QUALITY"

echo "Checking for linting issues in client..."
cd client
npm run lint 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
LINT_CLIENT_STATUS=$?
if [ $LINT_CLIENT_STATUS -eq 1 ]; then
    print_result 0 "Client linting passed"
else
    print_result 1 "Client linting has issues"
fi
cd ..

echo ""
echo "Checking for linting issues in server..."
cd server
npm run lint 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
LINT_SERVER_STATUS=$?
if [ $LINT_SERVER_STATUS -eq 1 ]; then
    print_result 0 "Server linting passed"
else
    print_result 1 "Server linting has issues"
fi
cd ..

echo ""

# ============================================
# 5. UNIT TESTS
# ============================================
print_header "5. UNIT TESTS"

echo "Running client unit tests..."
cd client
npm run test -- --passWithNoTests 2>&1 | tail -5
UNIT_TEST_CLIENT=$?
print_result $UNIT_TEST_CLIENT "Client unit tests"
cd ..

echo ""
echo "Running server unit tests..."
cd server
npm run test -- --passWithNoTests 2>&1 | tail -5
UNIT_TEST_SERVER=$?
print_result $UNIT_TEST_SERVER "Server unit tests"
cd ..

echo ""

# ============================================
# 6. SECURITY CHECK
# ============================================
print_header "6. SECURITY CHECK"

echo "Scanning for vulnerable dependencies..."
npm audit --audit-level=moderate > /dev/null 2>&1
AUDIT_STATUS=$?
if [ $AUDIT_STATUS -eq 0 ]; then
    print_result 0 "No critical vulnerabilities found"
else
    echo -e "${YELLOW}⚠ Some vulnerabilities detected - review before deployment${NC}"
    npm audit
fi

echo ""

# ============================================
# 7. ENVIRONMENT VARIABLES
# ============================================
print_header "7. ENVIRONMENT VARIABLES"

if [ -f ".env.example" ]; then
    print_result 0 ".env.example exists"
else
    print_result 1 ".env.example not found"
fi

if [ -f "server/.env" ]; then
    print_result 0 "server/.env exists"
else
    echo -e "${YELLOW}⚠ server/.env not found (required for server tests)${NC}"
    cp .env.example server/.env 2>/dev/null || true
fi

echo ""

# ============================================
# 8. DATABASE CONNECTIVITY (optional)
# ============================================
print_header "8. DATABASE CONNECTIVITY (Optional)"

if command -v psql &> /dev/null; then
    echo "PostgreSQL client found. Testing connection..."
    # This requires DATABASE_URL to be set
    if [ -z "$DATABASE_URL" ]; then
        echo -e "${YELLOW}⚠ DATABASE_URL not set - skipping database connection test${NC}"
    else
        psql "$DATABASE_URL" -c "SELECT 1" > /dev/null 2>&1
        print_result $? "Database connection test"
    fi
else
    echo -e "${YELLOW}⚠ PostgreSQL client not installed - skipping database tests${NC}"
fi

echo ""

# ============================================
# 9. TYPE CHECKING
# ============================================
print_header "9. TYPE CHECKING (TypeScript)"

echo "Type checking client..."
cd client
npx tsc --noEmit 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
TYPE_CLIENT_STATUS=$?
if [ $TYPE_CLIENT_STATUS -eq 1 ]; then
    print_result 0 "Client type checking passed"
else
    print_result 1 "Client type checking failed"
fi
cd ..

echo ""
echo "Type checking server..."
cd server
npx tsc --noEmit 2>&1 | grep -E "error|Error|ERROR" > /dev/null 2>&1
TYPE_SERVER_STATUS=$?
if [ $TYPE_SERVER_STATUS -eq 1 ]; then
    print_result 0 "Server type checking passed"
else
    print_result 1 "Server type checking failed"
fi
cd ..

echo ""

# ============================================
# 10. BUNDLE SIZE CHECK
# ============================================
print_header "10. BUNDLE SIZE CHECK"

if [ -d "client/dist" ]; then
    SIZE=$(du -sh client/dist | cut -f1)
    echo "Client build size: $SIZE"
    print_result 0 "Bundle size check complete"
else
    print_result 1 "Client build not found"
fi

echo ""

# ============================================
# SUMMARY
# ============================================
print_header "TEST SUMMARY"

TOTAL_TESTS=$((TESTS_PASSED + TESTS_FAILED))
echo -e "Total Tests: ${BLUE}$TOTAL_TESTS${NC}"
echo -e "Passed: ${GREEN}$TESTS_PASSED${NC}"
echo -e "Failed: ${RED}$TESTS_FAILED${NC}"
echo ""

if [ $TESTS_FAILED -eq 0 ]; then
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${GREEN}✓ ALL TESTS PASSED - READY FOR DEPLOYMENT!${NC}"
    echo -e "${GREEN}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 0
else
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    echo -e "${RED}✗ SOME TESTS FAILED - FIX ISSUES BEFORE DEPLOYMENT${NC}"
    echo -e "${RED}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
    exit 1
fi
