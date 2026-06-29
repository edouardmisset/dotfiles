// @ts-check
import { defineConfig } from 'eslint/config';
import { buildConfiguration } from '@upfluence/w-conf/eslint';

export default defineConfig(
  ...buildConfiguration({
    // Globs to exclude from linting
    // Preserve patterns from your old .eslintignore
    ignores: [
      // Project-specific directories
      'blueprints/*/files/',
      'vendor/',
      'dist/',
      'tmp/',
      
      // Standard ignored directories
      'node_modules/',
      'coverage/',
      'declarations/',
      
      // Build/package artifacts
      '.node_modules.ember-try/',
      'bower.json.ember-try',
      'package.json.ember-try',
    ],
    
    // Node/CommonJS files that shouldn't be linted with browser rules
    // Include all your config and build files here
    nodeFiles: [
      '.eslintrc.js',
      '.template-lintrc.js',
      'ember-cli-build.js',
      'index.js',
      'testem.js',
      'blueprints/*/index.js',
      'config/**/*.js',
      'tests/dummy/config/**/*.js'
    ]
  })
);
