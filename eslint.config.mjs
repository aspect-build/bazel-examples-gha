// @ts-check

import eslint from '@eslint/js';
import tseslint from 'typescript-eslint';
import globals from 'globals';

export default tseslint.config(
  eslint.configs.recommended,
  // Skip generated declaration files — they live in bazel-out and have no reachable tsconfig.json
  { ignores: ['**/*.d.ts', '**/genproto/**'] },
  {
    files: ['**/*.{js,cjs,mjs}'],
    languageOptions: {
      globals: {
        ...globals.node,
      },
    },
  },
  {
    files: ['**/*.ts'],
    extends: [...tseslint.configs.recommended, ...tseslint.configs.stylistic],
  },
  // Demonstrate override for a subdirectory.
  // Note that unlike eslint 8 and earlier, it does not resolve to a configuration file
  // in a parent folder of the files being checked; instead it only looks in the working
  // directory.
  // https://eslint.org/docs/latest/use/configure/migration-guide#glob-based-configs
  {
    files: ['src/subdir/**'],
    rules: {
      'no-debugger': 'off',
      '@typescript-eslint/no-redundant-type-constituents': 'error',
      'sort-imports': 'warn',
    },
  }
);
