#!/usr/bin/env node
// Detects secrets in prompts before sending to Claude.
// Warns only — never blocks. False positives are acceptable.

const prompt = process.argv[2] || '';

const patterns = [
  // API keys
  { pattern: /sk-ant-[a-zA-Z0-9\-_]{20,}/, label: 'Anthropic API key' },
  { pattern: /sk-proj-[a-zA-Z0-9\-_]{20,}/, label: 'OpenAI project API key' },
  { pattern: /sk-[a-zA-Z0-9]{20,}/, label: 'API key (sk-)' },

  // Cloud providers
  { pattern: /AKIA[0-9A-Z]{16}/, label: 'AWS access key' },
  { pattern: /ghp_[a-zA-Z0-9]{36}/, label: 'GitHub personal access token' },
  { pattern: /gho_[a-zA-Z0-9]{36}/, label: 'GitHub OAuth token' },
  { pattern: /ghs_[a-zA-Z0-9]{36}/, label: 'GitHub app token' },

  // Payment
  { pattern: /sk_live_[a-zA-Z0-9]{24,}/, label: 'Stripe live secret key' },
  { pattern: /rk_live_[a-zA-Z0-9]{24,}/, label: 'Stripe live restricted key' },

  // Generic credentials in code
  { pattern: /password\s*[:=]\s*['"][^'"]{6,}['"]/i, label: 'Hardcoded password' },
  { pattern: /secret\s*[:=]\s*['"][^'"]{6,}['"]/i, label: 'Hardcoded secret' },
  { pattern: /api[_-]?key\s*[:=]\s*['"][^'"]{8,}['"]/i, label: 'Hardcoded API key' },
  { pattern: /token\s*[:=]\s*['"][^'"]{8,}['"]/i, label: 'Hardcoded token' },

  // Authorization headers
  { pattern: /Bearer\s+[a-zA-Z0-9\-_\.]{20,}/i, label: 'Bearer token in header' },

  // Private keys
  { pattern: /-----BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY-----/, label: 'Private key (PEM)' },

  // Database URLs with credentials
  { pattern: /(?:postgres|mysql|mongodb):\/\/[^:]+:[^@]{6,}@/, label: 'Database URL with credentials' },
];

const found = patterns.filter(p => p.pattern.test(prompt));

if (found.length > 0) {
  found.forEach(f => {
    console.error(`[secret-detector] WARNING: ${f.label} detected in prompt.`);
  });
  console.error('[secret-detector] Review your message before sending sensitive data.');
}