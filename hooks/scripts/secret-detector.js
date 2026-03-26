#!/usr/bin/env node
// Détecte les secrets dans les prompts avant envoi
const prompt = process.argv[2] || '';
const patterns = [
  { pattern: /sk-[a-zA-Z0-9]{20,}/, label: 'Clé API (sk-)' },
  { pattern: /ghp_[a-zA-Z0-9]{36}/, label: 'Token GitHub' },
  { pattern: /AKIA[0-9A-Z]{16}/, label: 'Clé AWS' },
  { pattern: /password\s*[:=]\s*['"][^'"]{6,}['"]/i, label: 'Mot de passe en clair' },
  { pattern: /secret\s*[:=]\s*['"][^'"]{6,}['"]/i, label: 'Secret en clair' },
];
const found = patterns.find(p => p.pattern.test(prompt));
if (found) {
  console.error(`[secret-detector] ATTENTION : ${found.label} potentiel détecté dans le prompt.`);
  console.error(`[secret-detector] Vérifie que tu n'envoies pas de données sensibles.`);
}
