#!/usr/bin/env node
// Vérifie si un formatter est disponible après édition
const { execSync } = require('child_process');
const file = process.argv[2] || '';
if (!file) process.exit(0);
try {
  if (file.match(/\.(ts|tsx|js|jsx)$/)) {
    execSync(`npx prettier --check "${file}" 2>/dev/null`, { stdio: 'ignore' });
  }
} catch {
  // Prettier non installé ou fichier non formaté — pas bloquant
}
