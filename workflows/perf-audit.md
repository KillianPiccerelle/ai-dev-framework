---
name: perf-audit
description: Performance audit workflow for web applications, APIs, and CLI tools.
---

# Workflow: performance audit

Analyzes application performance metrics, identifies bottlenecks, and provides optimization recommendations.

## Step 1 — Determine project type (orchestrator)
Read `memory/stack.md` and project structure to determine audit approach:
- **Web frontend**: Lighthouse metrics, bundle size, Core Web Vitals
- **API backend**: Response times, database queries, throughput
- **CLI tool**: Execution time, memory usage, startup performance
- **Mixed/unknown**: General performance best practices

## Step 2 — Collect performance data (agent: codebase-analyst)
Based on project type:

### For web frontend:
1. Check for build configuration (webpack, vite, etc.)
2. Analyze bundle size if build tools available
3. Check for performance monitoring setup
4. Identify large dependencies

### For API backend:
1. Check for database query patterns
2. Look for caching implementation
3. Analyze response time logging
4. Check for async/background job processing

### For all types:
1. Check for profiler tools in dependencies
2. Look for performance test suites
3. Identify known performance anti-patterns in code

## Step 3 — Run performance tests (agent: backend-dev / frontend-dev)
Execute appropriate performance tests:

### Web frontend (if applicable):
1. Suggest running Lighthouse audit (CLI or browser)
2. Check bundle analysis if build config exists
3. Measure Core Web Vitals if production URL available

### API backend:
1. Run load tests if tools configured (k6, artillery, etc.)
2. Analyze database query performance
3. Check response time percentiles from logs

### CLI tools:
1. Profile execution with available tools
2. Measure memory usage patterns
3. Check startup time

## Step 4 — Analyze bottlenecks (agent: qa-engineer)
Review collected data and identify:
1. **Critical issues** (blocking performance)
2. **Major optimizations** (significant impact)
3. **Minor improvements** (incremental gains)

Categorize findings:
- **Bundle size**: Large dependencies, unused code, missing code splitting
- **Database**: N+1 queries, missing indexes, inefficient joins
- **API**: Slow endpoints, missing caching, synchronous operations
- **Memory**: Leaks, high allocation, inefficient data structures
- **CPU**: Expensive computations, blocking operations

## Step 5 — Generate optimization recommendations (orchestrator)
Create prioritized optimization list:

### High priority (critical):
- Database queries causing timeouts
- Memory leaks
- Blocking operations in critical path

### Medium priority (significant impact):
- Large bundle sizes (>250KB main bundle)
- Missing caching for expensive operations
- Inefficient algorithms (O(n²) where O(n) possible)

### Low priority (incremental):
- Minor bundle optimizations
- Small memory usage improvements
- Code style performance improvements

## Step 6 — Create performance report (agent: doc-writer)
Generate `docs/performance-audit-YYYY-MM-DD.md` with:

### Executive summary
- Project type and scope
- Overall performance assessment
- Key findings summary

### Metrics collected
- Bundle sizes (if applicable)
- Response times (if available)
- Database query performance
- Memory usage patterns

### Identified issues
Categorized by:
1. **Critical** - Must fix immediately
2. **High** - Significant user impact
3. **Medium** - Noticeable improvement
4. **Low** - Minor optimizations

### Recommendations
Prioritized list with:
- Estimated impact
- Implementation difficulty
- Dependencies/requirements

### Action plan
- Immediate actions (critical issues)
- Short-term improvements (1-2 weeks)
- Long-term optimizations (1-3 months)

## Step 7 — Update memory (orchestrator)
Add to `memory/progress.md`:
- Date of performance audit
- Summary of findings
- Link to full report
- Performance baseline for future comparisons

## Memory update (mandatory)
- [x] Add performance audit entry to `memory/progress.md`
- [x] Link to `docs/performance-audit-YYYY-MM-DD.md`

## Tools integration
Workflow can integrate with (if available):
- **Lighthouse CI** for web performance
- **Webpack Bundle Analyzer** for bundle size
- **pgHero** / **EXPLAIN ANALYZE** for database
- **k6** / **artillery** for load testing
- **Chrome DevTools** for frontend profiling

## Fallback approach
If no performance tools available:
1. Manual code review for performance anti-patterns
2. Architecture review for potential bottlenecks
3. General performance best practices recommendations
4. Setup instructions for performance monitoring

## Success metrics
- **Web**: Core Web Vitals improvements, bundle size reduction
- **API**: Response time reduction, throughput increase
- **CLI**: Execution time improvement, memory usage reduction
- **All**: Elimination of critical performance issues