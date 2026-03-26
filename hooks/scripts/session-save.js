#!/usr/bin/env node
/**
 * session-save.js — ai-dev-framework v3
 * Triggered automatically by Claude Code on session Stop.
 * Writes a guaranteed snapshot to memory/progress.md.
 * Does not depend on user action.
 */

const fs   = require('fs');
const path = require('path');

const CWD          = process.cwd();
const MEMORY_DIR   = path.join(CWD, 'memory');
const PROGRESS     = path.join(MEMORY_DIR, 'progress.md');
const SESSION_LOG  = path.join(MEMORY_DIR, '.last-session.json');

// ─── Helpers ──────────────────────────────────────────────────────────────────

function exists(p) {
  try { return fs.existsSync(p); } catch { return false; }
}

function readFile(p) {
  try { return fs.readFileSync(p, 'utf8'); } catch { return null; }
}

function writeFile(p, content) {
  try { fs.writeFileSync(p, content, 'utf8'); return true; } catch { return false; }
}

function now() {
  return new Date().toISOString();
}

function formatDate(iso) {
  return new Date(iso).toLocaleString('en-GB', {
    year: 'numeric', month: '2-digit', day: '2-digit',
    hour: '2-digit', minute: '2-digit'
  });
}

// ─── Detect if memory/ exists (we're in a framework project) ──────────────────

if (!exists(MEMORY_DIR)) {
  // Not a framework project — exit silently
  process.exit(0);
}

// ─── Scan memory/ for recently modified files ─────────────────────────────────

const SESSION_START_THRESHOLD_HOURS = 8;
const now_ms = Date.now();
const threshold_ms = SESSION_START_THRESHOLD_HOURS * 60 * 60 * 1000;

function scanMemoryFiles() {
  const results = { modified: [], stale: [] };
  if (!exists(MEMORY_DIR)) return results;

  function scan(dir) {
    const entries = fs.readdirSync(dir, { withFileTypes: true });
    for (const entry of entries) {
      if (entry.name.startsWith('.')) continue;
      const full = path.join(dir, entry.name);
      if (entry.isDirectory()) {
        scan(full);
      } else if (entry.name.endsWith('.md')) {
        const stat = fs.statSync(full);
        const rel  = path.relative(CWD, full);
        const age  = now_ms - stat.mtimeMs;
        if (age < threshold_ms) {
          results.modified.push({ path: rel, modified: new Date(stat.mtimeMs).toISOString() });
        } else {
          results.stale.push({ path: rel, modified: new Date(stat.mtimeMs).toISOString() });
        }
      }
    }
  }

  try { scan(MEMORY_DIR); } catch {}
  return results;
}

// ─── Load previous session log ────────────────────────────────────────────────

let lastSession = null;
const logRaw = readFile(SESSION_LOG);
if (logRaw) {
  try { lastSession = JSON.parse(logRaw); } catch {}
}

// ─── Build snapshot ───────────────────────────────────────────────────────────

const timestamp  = now();
const { modified, stale } = scanMemoryFiles();
const progressExists = exists(PROGRESS);

// Check if progress.md was already updated by Claude this session
// (contains today's date in YYYY-MM-DD format)
const todayDate  = timestamp.slice(0, 10);
const progressContent = readFile(PROGRESS) || '';
const claudeUpdatedToday = progressContent.includes(todayDate);

// ─── Write session log (machine-readable) ─────────────────────────────────────

const sessionData = {
  timestamp,
  modified_files: modified.map(f => f.path),
  claude_updated_progress: claudeUpdatedToday,
};
writeFile(SESSION_LOG, JSON.stringify(sessionData, null, 2));

// ─── Update progress.md with snapshot ────────────────────────────────────────

const snapshotBlock = `
---
## Auto-snapshot — ${formatDate(timestamp)}

**Files modified this session:**
${modified.length > 0
  ? modified.map(f => `- \`${f.path}\``).join('\n')
  : '- *(no memory files modified)*'}

**Status:** ${claudeUpdatedToday
  ? '✓ Claude updated progress.md this session'
  : '✗ Claude did not write a session summary — snapshot only'}

${stale.length > 0 ? `**Potentially stale files** (not modified in ${SESSION_START_THRESHOLD_HOURS}h+):\n${stale.map(f => `- \`${f.path}\``).join('\n')}` : ''}
`;

if (progressExists) {
  // Append snapshot at the end of existing progress.md
  const current = readFile(PROGRESS) || '';
  // Remove previous auto-snapshot blocks to avoid accumulation
  const cleaned = current.replace(/\n---\n## Auto-snapshot[\s\S]*?(?=\n---\n## Auto-snapshot|\n---\n#[^#]|$)/g, '');
  writeFile(PROGRESS, cleaned.trimEnd() + '\n' + snapshotBlock);
} else {
  // Create a minimal progress.md with the snapshot
  const minimal = `# Project progress\n\n> Auto-created by session-save hook.\n> Fill in manually or via Claude after your first session.\n\n## Overall status\n[ ] Not started  [ ] In progress  [ ] In production\n` + snapshotBlock;
  writeFile(PROGRESS, minimal);
}

// ─── Terminal report ──────────────────────────────────────────────────────────

console.log('\n[session-save] Session ended — memory snapshot saved.\n');

if (modified.length > 0) {
  console.log('  Modified this session:');
  modified.forEach(f => console.log(`    ✓ ${f.path}`));
} else {
  console.log('  No memory files were modified this session.');
}

if (!claudeUpdatedToday) {
  console.log('\n  ⚠ Claude did not write a session summary.');
  console.log('  → Ask Claude: "Summarize this session and update memory/progress.md"');
}

if (stale.length > 0) {
  console.log(`\n  Possibly stale (${SESSION_START_THRESHOLD_HOURS}h+ unchanged):`);
  stale.forEach(f => console.log(`    ~ ${f.path}`));
}

console.log('');
