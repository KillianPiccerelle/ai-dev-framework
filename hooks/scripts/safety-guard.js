#!/usr/bin/env node
// Warns before destructive commands.
// Warns only — never blocks. The developer retains full control.

const cmd = process.argv[2] || '';

const dangerous = [
  // Recursive force delete — all variants
  { pattern: /rm\s+(-[a-zA-Z]*r[a-zA-Z]*f|-[a-zA-Z]*f[a-zA-Z]*r|--recursive.*--force|--force.*--recursive)/, label: 'Recursive force delete (rm -rf)' },
  { pattern: /rm\s+-rf\b/, label: 'Recursive force delete (rm -rf)' },
  { pattern: /rm\s+-fr\b/, label: 'Recursive force delete (rm -fr)' },

  // SQL destructive operations
  { pattern: /DROP\s+TABLE/i, label: 'SQL DROP TABLE' },
  { pattern: /DROP\s+DATABASE/i, label: 'SQL DROP DATABASE' },
  { pattern: /DROP\s+SCHEMA/i, label: 'SQL DROP SCHEMA' },
  { pattern: /TRUNCATE\s+TABLE/i, label: 'SQL TRUNCATE TABLE' },
  { pattern: /DELETE\s+FROM\s+\w+\s*;/i, label: 'SQL DELETE without WHERE clause' },

  // Git force push — all variants
  { pattern: /git\s+push\s+.*--force(?!-with-lease)/, label: 'Git force push (--force)' },
  { pattern: /git\s+push\s+.*-f\b/, label: 'Git force push (-f)' },

  // Dangerous system operations
  { pattern: /chmod\s+-R\s+777/, label: 'Recursive chmod 777 (dangerous permissions)' },
  { pattern: />\s*\/dev\/sd[a-z]/, label: 'Write to block device' },
  { pattern: /mkfs\./, label: 'Filesystem format (mkfs)' },
];

const found = dangerous.filter(d => d.pattern.test(cmd));

if (found.length > 0) {
  found.forEach(f => {
    console.error(`[safety-guard] WARNING: ${f.label} detected.`);
  });
  console.error(`[safety-guard] Command: ${cmd}`);
  console.error('[safety-guard] Confirm this is intentional before proceeding.');
}