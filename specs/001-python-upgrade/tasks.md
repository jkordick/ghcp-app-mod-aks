# Tasks: Python Application Upgrade to Latest Version

**Input**: Design documents from `/specs/001-python-upgrade/`
**Prerequisites**: plan.md ✅, spec.md ✅

**Tests**: Tests are already part of the existing application and will be used for validation (not writing new tests).

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `- [ ] [ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no dependencies)
- **[Story]**: Which user story this task belongs to (e.g., US1, US2, US3)
- Include exact file paths in descriptions

---

## Phase 1: Setup (Environment Preparation)

**Purpose**: Verify Python 3.13 availability and create virtual environment

- [ ] T001 Verify Python 3.13.x is installed on the system using `python3.13 --version`
- [ ] T002 Create Python 3.13 virtual environment in python-app/venv using `python3.13 -m venv venv`
- [ ] T003 Activate virtual environment and verify Python version is 3.13.x
- [ ] T004 Install dependencies from python-app/requirements.txt in the virtual environment
- [ ] T005 Verify installed package versions (pytest==8.3.4, requests==2.32.3)

**Checkpoint**: Virtual environment ready with Python 3.13.x and all dependencies installed

---

## Phase 2: Foundational (Security Verification)

**Purpose**: Verify security posture before proceeding with upgrade

**⚠️ CRITICAL**: Security verification must be complete before user story validation

- [ ] T006 [P] Document Python 3.13.x security improvements over Python 3.9.6
- [ ] T007 [P] Verify pytest 8.3.4 has no known CVEs using security databases
- [ ] T008 [P] Verify requests 2.32.3 has no known CVEs using security databases
- [ ] T009 Run `pip list --outdated` in virtual environment to check for available updates

**Checkpoint**: Security verification complete - no known vulnerabilities in runtime or dependencies

---

## Phase 3: User Story 1 - Core Application Functionality (Priority: P1) 🎯 MVP

**Goal**: Application runs on Python 3.13.x with health check and service info endpoints working

**Independent Test**: Start application with Python 3.13, access health check endpoint, verify successful response

### Implementation for User Story 1

- [ ] T010 [US1] Update shebang line in python-app/main.py from `#!/usr/bin/env python3` to `#!/usr/bin/env python3.13`
- [ ] T011 [US1] Start application using `python main.py` in virtual environment
- [ ] T012 [US1] Verify application starts without errors or warnings
- [ ] T013 [US1] Test GET /health endpoint using `curl http://localhost:8000/health` (verify <1s response time)
- [ ] T014 [US1] Test GET / (root) endpoint using `curl http://localhost:8000/` (verify service information displays)
- [ ] T015 [US1] Stop application and verify clean shutdown

**Checkpoint**: At this point, User Story 1 is fully functional - application runs on Python 3.13.x with core endpoints working

---

## Phase 4: User Story 2 - Customer Data Operations (Priority: P2)

**Goal**: All customer CRUD operations work correctly on Python 3.13.x

**Independent Test**: Make GET and PATCH requests to customer endpoints, verify correct responses and data handling

### Implementation for User Story 2

- [ ] T016 [US2] Start application in Python 3.13 virtual environment
- [ ] T017 [P] [US2] Test GET /customers/1 endpoint (Julia Kordick) and verify complete profile returned
- [ ] T018 [P] [US2] Test GET /customers/2 endpoint (Alexander Wachtel) and verify complete profile returned
- [ ] T019 [P] [US2] Test GET /customers/3 endpoint (Igor Rykhlevskyi) and verify complete profile returned
- [ ] T020 [US2] Test GET /customers/999 (non-existent) and verify 404 error response
- [ ] T021 [US2] Test PATCH /customers/1 with phone_number update and verify updated profile returned
- [ ] T022 [US2] Test PATCH /customers/2 with address update and verify updated profile returned
- [ ] T023 [US2] Test PATCH /customers/3 with multiple field updates (phone, address, email) and verify changes
- [ ] T024 [US2] Test PATCH /customers/999 (non-existent) and verify 404 error response
- [ ] T025 [US2] Test PATCH /customers/1 with empty data and verify 400 error response
- [ ] T026 [US2] Verify all customer operations complete in <500ms
- [ ] T027 [US2] Verify data validation rules still work correctly (email format, phone length, address length)

**Checkpoint**: At this point, User Stories 1 AND 2 both work independently - full customer operations functional

---

## Phase 5: User Story 3 - Test Suite Validation (Priority: P3)

**Goal**: All existing tests pass on Python 3.13.x with no deprecation warnings

**Independent Test**: Run pytest test suite and verify 100% pass rate

### Implementation for User Story 3

- [ ] T028 [US3] Ensure application is stopped before running tests
- [ ] T029 [US3] Run full test suite using `pytest test_main.py -v` in Python 3.13 virtual environment
- [ ] T030 [US3] Verify all 11 tests pass (test_root_endpoint, test_health_check, test_get_existing_customer, test_get_nonexistent_customer, test_get_invalid_customer_id, test_update_customer_phone, test_update_customer_address, test_update_customer_multiple_fields, test_update_nonexistent_customer, test_update_customer_empty_data, test_all_hardcoded_customers_exist)
- [ ] T031 [US3] Check test output for Python deprecation warnings
- [ ] T032 [US3] If any deprecation warnings exist, document them (but they should not block completion)
- [ ] T033 [US3] Run tests again to verify consistency (all tests should pass on second run)

**Checkpoint**: All user stories validated - test suite confirms zero regressions on Python 3.13.x

---

## Phase 6: Performance Validation & Documentation

**Purpose**: Verify performance meets or exceeds baseline and update documentation

- [ ] T034 [P] Benchmark health check endpoint response time (should be <1s)
- [ ] T035 [P] Benchmark customer GET endpoint response time (should be <500ms)
- [ ] T036 [P] Benchmark customer PATCH endpoint response time (should be <500ms)
- [ ] T037 Test concurrent requests (10+ simultaneous requests) and verify no degradation
- [ ] T038 Compare performance metrics with Python 3.9 baseline (if available)
- [ ] T039 [P] Review python-app/README.md and update Python version references if needed
- [ ] T040 [P] Update python-app/README.md installation instructions to reference Python 3.13
- [ ] T041 Document environment setup process (virtual environment creation steps)

---

## Dependencies & Execution Order

### Phase Dependencies

```
Phase 1 (Setup)
    ↓
Phase 2 (Security Verification) - runs in parallel after setup
    ↓
Phase 3 (US1: Core Functionality) - MVP MILESTONE
    ↓
Phase 4 (US2: Data Operations) ──┐
Phase 5 (US3: Test Validation) ──┤ ← Can validate in parallel
    └──────────────────────────────┘
    ↓
Phase 6 (Performance & Docs) - final validation
```

### User Story Dependencies

- **User Story 1 (P1)**: Depends on Setup + Security - No dependencies on other stories
- **User Story 2 (P2)**: Depends on US1 passing - Can run after US1 is validated
- **User Story 3 (P3)**: Depends on Setup + Security - Can run in parallel with US2

### Critical Path

1. **Must complete first**: T001-T005 (Setup)
2. **Must complete before user stories**: T006-T009 (Security)
3. **MVP milestone**: T010-T015 (US1 complete)
4. **Can parallelize**: US2 and US3 after US1
5. **Final validation**: Performance benchmarks and docs

### Parallel Opportunities

**Within Setup Phase:**
- T001-T005 are sequential (each depends on previous)

**Within Security Phase:**
- T006, T007, T008 can run in parallel (different security checks)
- T009 runs after installation complete

**Within US1:**
- T010-T012 are sequential (update → start → verify)
- T013-T014 can run in parallel (different endpoints)

**Within US2:**
- T017-T019 can run in parallel (testing different customer GETs)
- T021-T023 can be parallelized if desired (different PATCH operations)

**Within US3:**
- T028-T033 are mostly sequential (test suite execution)

**Within Phase 6:**
- T034-T036 can run in parallel (different benchmark operations)
- T039-T041 can run in parallel (different documentation files)

---

## Parallel Example: User Story 2

```bash
# Test all customer GET operations together:
Task T017: curl http://localhost:8000/customers/1
Task T018: curl http://localhost:8000/customers/2
Task T019: curl http://localhost:8000/customers/3

# Test customer PATCH operations together:
Task T021: PATCH /customers/1 with phone_number
Task T022: PATCH /customers/2 with address
Task T023: PATCH /customers/3 with multiple fields
```

---

## Implementation Strategy

### MVP First (User Story 1 Only)

1. Complete Phase 1: Setup (T001-T005)
2. Complete Phase 2: Security (T006-T009)
3. Complete Phase 3: User Story 1 (T010-T015)
4. **STOP and VALIDATE**: Application runs on Python 3.13 with working health check
5. Decision point: Continue to full validation or deploy MVP

### Incremental Delivery

1. **Foundation**: Setup + Security → Environment ready and secure
2. **MVP**: + User Story 1 → Application runs on Python 3.13 (deployable!)
3. **Full Functionality**: + User Story 2 → All customer operations validated
4. **Quality Assurance**: + User Story 3 → Test suite confirms zero regressions
5. **Production Ready**: + Phase 6 → Performance verified and documented

### Single Developer Strategy

Follow phases sequentially in order (1 → 2 → 3 → 4 → 5 → 6). Each phase builds on the previous, with clear checkpoints for validation.

---

## Notes

- **No new code needed**: This is a runtime upgrade only - application logic remains unchanged
- **Virtual environment is key**: All testing must be done within the Python 3.13 venv
- **Existing tests are sufficient**: We use the existing 11-test suite for validation
- **[P] tasks**: Can be executed in parallel when appropriate (different operations, no dependencies)
- **[Story] labels**: Map each task to its user story for traceability
- **Checkpoints**: Validate at each phase boundary before proceeding
- **Performance baseline**: Compare with Python 3.9 if metrics available
- **Zero regression target**: All functionality must work identically to Python 3.9 version
