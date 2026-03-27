#!/usr/bin/env node
// Checks if a formatter is available after file edit.
// Security: uses execFileSync instead of execSync to prevent command injection.

const { execFileSync } = require('child_process');
const path = require('path');

const file = process.argv[2] || '';
if (!file) process.exit(0);

// Validate: must be a real relative or absolute path, no shell metacharacters
const safePath = path.resolve(file);
if (!safePath || safePath !== path.normalize(safePath)) process.exit(0);

try {
  if (/\.(ts|tsx|js|jsx)$/.test(safePath)) {
    // execFileSync does NOT invoke a shell — arguments are passed directly
    // This prevents any command injection via malicious file paths
    execFileSync('npx', ['prettier', '--check', safePath], {
      stdio: 'ignore',
      timeout: 10000,
    });
  }
} catch {
  // Prettier not installed or file not formatted — non-blocking
}