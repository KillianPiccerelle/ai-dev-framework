#!/usr/bin/env node
// Rappel de mise à jour mémoire en fin de session
const fs = require('fs');
const path = require('path');
const progressFile = path.join(process.cwd(), 'memory', 'progress.md');
if (fs.existsSync(progressFile)) {
  const content = fs.readFileSync(progressFile, 'utf8');
  const today = new Date().toISOString().split('T')[0];
  if (!content.includes(today)) {
    console.log('[session-save] Pense à mettre à jour memory/progress.md avec ce qui a été fait aujourd\'hui.');
  }
}
