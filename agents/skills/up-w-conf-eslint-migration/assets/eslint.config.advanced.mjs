// @ts-check
// Advanced ESLint config using named exports for fine-grained control
// Use this when you need to customize specific config blocks or use monorepo patterns

import { defineConfig } from 'eslint/config';
import {
  core,
  emberConfig,
  javascript,
  typescript,
  qunitTests,
  nodeFiles,
  DEFAULT_IGNORES,
  eslintConfigPrettierPlaceLast
} from '@upfluence/w-conf/eslint';

export default defineConfig(
  // Standard ignores (dist/, node_modules/, etc.)
  ...DEFAULT_IGNORES,
  
  // ESLint core recommended rules
  ...core,
  
  // Ember plugin configuration
  ...emberConfig,
  
  // JavaScript/ES6 rules
  ...javascript,
  
  // TypeScript rules (untyped, recommended preset)
  ...typescript,
  
  // QUnit test rules - customize glob patterns as needed
  ...qunitTests(['tests/**/*-test.{js,ts}']),
  
  // Node/CommonJS rules for config files
  ...nodeFiles(['ember-cli-build.js', 'config/**/*.js', 'index.js']),
  
  // Custom project-specific rules
  {
    files: ['addon/**/*.ts'],
    rules: {
      // Add or override rules specific to your project
      'ember/no-deprecated-methods': 'warn'
    }
  },
  
  // Prettier config - MUST BE LAST
  eslintConfigPrettierPlaceLast
);
