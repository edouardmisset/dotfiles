#!/usr/bin/env bash

set -euo pipefail

if ! command -v node >/dev/null 2>&1; then
  echo "Error: Node.js is required but was not found in PATH." >&2
  echo "Install Node.js, then run this script again." >&2
  exit 1
fi

if ! command -v pnpm >/dev/null 2>&1; then
  echo "Error: pnpm is required but was not found in PATH." >&2
  echo "Install pnpm, then run this script again." >&2
  exit 1
fi

if [[ $# -lt 1 || -z "$1" ]]; then
  echo "Usage: ./scripts/init-artifact.sh <project-name>" >&2
  exit 1
fi

PROJECT_NAME="$1"

printf 'Creating React + TypeScript project: %s\n' "$PROJECT_NAME"
pnpm dlx create-vite@latest "$PROJECT_NAME" --no-interactive --template react-ts
cd "$PROJECT_NAME"

printf '%s\n' 'Installing runtime and build dependencies...'
pnpm install
pnpm add react@latest react-dom@latest @base-ui/react@latest cmdk@latest shiki@latest @shikijs/langs@latest @shikijs/themes@latest
pnpm add -D vite@latest @vitejs/plugin-react@latest typescript@latest @types/react@latest @types/react-dom@latest vite-plugin-singlefile@latest

printf '%s\n' 'Writing project entrypoints and styles...'
rm -rf src/assets
rm -f src/App.css src/index.css src/main.tsx src/App.tsx
mkdir -p src/components src/lib src/styles

cat > index.html <<'EOF'
<!doctype html>
<html lang="en">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <meta name="theme-color" content="#1e1e2e" />
    <link rel="preconnect" href="https://fonts.googleapis.com" />
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
    <link
      href="https://fonts.googleapis.com/css2?family=Atkinson+Hyperlegible+Next:ital,wght@0,400;0,700;1,400;1,700&display=swap"
      rel="stylesheet"
    />
    <link
      rel="stylesheet"
      href="https://cdn.jsdelivr.net/npm/firacode@6.2.0/distr/fira_code.css"
    />
    <title>Artifact</title>
  </head>
  <body>
    <div id="root"></div>
    <script type="module" src="/src/main.tsx"></script>
  </body>
</html>
EOF

cat > src/styles/global.css <<'EOF'
@font-face {
  font-family: "Symbols Nerd Font";
  src: url("https://cdn.jsdelivr.net/gh/ryanoasis/nerd-fonts@v3.4.0/patched-fonts/NerdFontsSymbolsOnly/SymbolsNerdFont-Regular.ttf")
    format("truetype");
  font-display: swap;
}

:root {
  color-scheme: light;
  font-family: "Atkinson Hyperlegible Next", sans-serif;
  font-synthesis: none;
  text-rendering: optimizeLegibility;

  --ctp-rosewater: #dc8a78;
  --ctp-flamingo: #dd7878;
  --ctp-pink: #ea76cb;
  --ctp-mauve: #8839ef;
  --ctp-red: #d20f39;
  --ctp-maroon: #e64553;
  --ctp-peach: #fe640b;
  --ctp-yellow: #df8e1d;
  --ctp-green: #40a02b;
  --ctp-teal: #179299;
  --ctp-sky: #04a5e5;
  --ctp-sapphire: #209fb5;
  --ctp-blue: #1e66f5;
  --ctp-lavender: #7287fd;
  --ctp-text: #4c4f69;
  --ctp-subtext-1: #5c5f77;
  --ctp-subtext-0: #6c6f85;
  --ctp-overlay-2: #7c7f93;
  --ctp-overlay-1: #8c8fa1;
  --ctp-overlay-0: #9ca0b0;
  --ctp-surface-2: #acb0be;
  --ctp-surface-1: #bcc0cc;
  --ctp-surface-0: #ccd0da;
  --ctp-base: #eff1f5;
  --ctp-mantle: #e6e9ef;
  --ctp-crust: #dce0e8;

  --color-background: var(--ctp-base);
  --color-surface: var(--ctp-mantle);
  --color-surface-raised: var(--ctp-surface-0);
  --color-text: var(--ctp-text);
  --color-text-muted: var(--ctp-subtext-0);
  --color-border: var(--ctp-overlay-0);
  --color-focus: var(--ctp-lavender);
  --color-accent: var(--ctp-blue);
  --color-accent-contrast: var(--ctp-base);
  --color-code-background: var(--ctp-mantle);
}

@media (prefers-color-scheme: dark) {
  :root {
    color-scheme: dark;

    --ctp-rosewater: #f5e0dc;
    --ctp-flamingo: #f2cdcd;
    --ctp-pink: #f5c2e7;
    --ctp-mauve: #cba6f7;
    --ctp-red: #f38ba8;
    --ctp-maroon: #eba0ac;
    --ctp-peach: #fab387;
    --ctp-yellow: #f9e2af;
    --ctp-green: #a6e3a1;
    --ctp-teal: #94e2d5;
    --ctp-sky: #89dceb;
    --ctp-sapphire: #74c7ec;
    --ctp-blue: #89b4fa;
    --ctp-lavender: #b4befe;
    --ctp-text: #cdd6f4;
    --ctp-subtext-1: #bac2de;
    --ctp-subtext-0: #a6adc8;
    --ctp-overlay-2: #9399b2;
    --ctp-overlay-1: #7f849c;
    --ctp-overlay-0: #6c7086;
    --ctp-surface-2: #585b70;
    --ctp-surface-1: #45475a;
    --ctp-surface-0: #313244;
    --ctp-base: #1e1e2e;
    --ctp-mantle: #181825;
    --ctp-crust: #11111b;
  }
}

* {
  box-sizing: border-box;
}

html {
  min-width: 320px;
  background: var(--color-background);
}

body {
  min-width: 320px;
  min-height: 100vh;
  margin: 0;
  background: var(--color-background);
  color: var(--color-text);
}

button,
input,
textarea,
select {
  font: inherit;
}

button,
a {
  -webkit-tap-highlight-color: transparent;
}

::selection {
  background: color-mix(in srgb, var(--ctp-overlay-2) 30%, transparent);
}

:focus-visible {
  outline: 2px solid var(--color-focus);
  outline-offset: 3px;
}

pre,
code {
  font-family: "Fira Code", "Symbols Nerd Font", monospace;
  font-variant-ligatures: contextual;
}

.shiki,
.shiki span {
  background-color: var(--shiki-light-bg) !important;
  color: var(--shiki-light) !important;
}

@media (prefers-color-scheme: dark) {
  .shiki,
  .shiki span {
    background-color: var(--shiki-dark-bg) !important;
    color: var(--shiki-dark) !important;
  }
}
EOF

cat > src/App.module.css <<'EOF'
.app {
  width: min(100% - 2rem, 70rem);
  margin: 0 auto;
  padding: 4rem 0;
}

.header {
  display: grid;
  gap: 1rem;
  max-width: 42rem;
  margin-bottom: 2rem;
}

.eyebrow {
  margin: 0;
  color: var(--ctp-teal);
  font-size: 0.8rem;
  font-weight: 700;
  letter-spacing: 0.08em;
  text-transform: uppercase;
}

.title {
  margin: 0;
  color: var(--color-text);
  font-size: clamp(2.25rem, 7vw, 4.75rem);
  line-height: 0.98;
  letter-spacing: 0;
}

.description {
  max-width: 38rem;
  margin: 0;
  color: var(--color-text-muted);
  font-size: 1.1rem;
  line-height: 1.55;
}

.action {
  width: fit-content;
  border: 1px solid var(--ctp-blue);
  border-radius: 0.45rem;
  padding: 0.65rem 1rem;
  background: var(--ctp-blue);
  color: var(--ctp-base);
  cursor: pointer;
  font-weight: 700;
}

.action:hover {
  background: var(--ctp-sapphire);
}

.section {
  display: grid;
  gap: 0.75rem;
  padding-top: 2rem;
  border-top: 1px solid var(--color-border);
}

.sectionTitle {
  margin: 0;
  font-size: 1rem;
}

.sectionText {
  margin: 0;
  color: var(--color-text-muted);
}

@media (max-width: 48rem) {
  .app {
    padding: 2.5rem 0;
  }
}
EOF

cat > src/components/CodeBlock.module.css <<'EOF'
.container {
  overflow: auto;
  border: 1px solid var(--color-border);
  border-radius: 0.5rem;
  background: var(--color-code-background);
}

.code {
  display: block;
  min-width: max-content;
  margin: 0;
  padding: 1rem 1.1rem;
  font-size: 0.85rem;
  line-height: 1.65;
}

.fallback {
  display: block;
  color: var(--color-text);
  white-space: pre;
}
EOF

cat > src/lib/highlighter.ts <<'EOF'
import { createHighlighterCore } from "shiki/core";
import { createOnigurumaEngine } from "shiki/engine/oniguruma";
import css from "@shikijs/langs/css";
import gjs from "@shikijs/langs/gjs";
import gts from "@shikijs/langs/gts";
import hbs from "@shikijs/langs/hbs";
import html from "@shikijs/langs/html";
import js from "@shikijs/langs/js";
import json from "@shikijs/langs/json";
import jsonc from "@shikijs/langs/jsonc";
import jsx from "@shikijs/langs/jsx";
import md from "@shikijs/langs/md";
import mdx from "@shikijs/langs/mdx";
import ts from "@shikijs/langs/ts";
import tsx from "@shikijs/langs/tsx";
import latte from "@shikijs/themes/catppuccin-latte";
import mocha from "@shikijs/themes/catppuccin-mocha";

export const supportedLanguages = [
  "hbs",
  "ts",
  "tsx",
  "js",
  "jsx",
  "html",
  "gts",
  "gjs",
  "md",
  "mdx",
  "css",
  "json",
  "jsonc",
] as const;

export type SupportedLanguage = (typeof supportedLanguages)[number];

const loadedLanguages = [
  css,
  gjs,
  gts,
  hbs,
  html,
  js,
  json,
  jsonc,
  jsx,
  md,
  mdx,
  ts,
  tsx,
];

const highlighterPromise = createHighlighterCore({
  langs: loadedLanguages,
  themes: [latte, mocha],
  engine: createOnigurumaEngine(import("shiki/wasm")),
});

export async function highlightCode(
  code: string,
  language: string
): Promise<string | null> {
  if (!supportedLanguages.includes(language as SupportedLanguage)) {
    return null;
  }

  const highlighter = await highlighterPromise;
  return highlighter.codeToHtml(code, {
    lang: language,
    themes: {
      light: "catppuccin-latte",
      dark: "catppuccin-mocha",
    },
    defaultColor: false,
  });
}
EOF

cat > src/components/CodeBlock.tsx <<'EOF'
import { useEffect, useState } from "react";
import { highlightCode } from "../lib/highlighter";
import styles from "./CodeBlock.module.css";

type CodeBlockProps = {
  code: string;
  language: string;
  label?: string;
};

export function CodeBlock({ code, language, label }: CodeBlockProps) {
  const [highlightedCode, setHighlightedCode] = useState<string | null>(null);

  useEffect(() => {
    let active = true;

    void highlightCode(code, language).then((html) => {
      if (active) {
        setHighlightedCode(html);
      }
    });

    return () => {
      active = false;
    };
  }, [code, language]);

  return (
    <div className={styles.container}>
      {highlightedCode ? (
        <div
          className={styles.code}
          aria-label={label ?? `${language} code`}
          dangerouslySetInnerHTML={{ __html: highlightedCode }}
        />
      ) : (
        <pre className={styles.code} aria-label={label ?? `${language} code`}>
          <code className={styles.fallback}>{code}</code>
        </pre>
      )}
    </div>
  );
}
EOF

cat > src/App.tsx <<'EOF'
import { Button } from "@base-ui/react/button";
import { CodeBlock } from "./components/CodeBlock";
import styles from "./App.module.css";

const sampleCode = `import { Button } from "@base-ui/react/button";

export function Example() {
  return <Button>Ready to compose</Button>;
}`;

export default function App() {
  return (
    <main className={styles.app}>
      <header className={styles.header}>
        <p className={styles.eyebrow}>Web artifacts builder</p>
        <h1 className={styles.title}>A quiet starting point for rich interfaces.</h1>
        <p className={styles.description}>
          React, TypeScript, Base UI, CSS Modules, and a single-file Vite build.
          The generated project follows the user's system light or dark preference.
        </p>
        <Button className={styles.action}>Base UI is ready</Button>
      </header>

      <section className={styles.section} aria-labelledby="code-title">
        <h2 className={styles.sectionTitle} id="code-title">
          Thin syntax highlighting is included
        </h2>
        <p className={styles.sectionText}>
          Only the supported web and documentation grammars are loaded.
        </p>
        <CodeBlock code={sampleCode} language="tsx" label="Base UI example" />
      </section>
    </main>
  );
}
EOF

cat > src/main.tsx <<'EOF'
import { StrictMode } from "react";
import { createRoot } from "react-dom/client";
import App from "./App";
import "./styles/global.css";

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <App />
  </StrictMode>
);
EOF

cat > vite.config.ts <<'EOF'
import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import { viteSingleFile } from "vite-plugin-singlefile";

export default defineConfig({
  base: "./",
  plugins: [
    react(),
    viteSingleFile({
      removeViteModuleLoader: true,
    }),
  ],
  build: {
    assetsInlineLimit: Infinity,
    cssCodeSplit: false,
    rolldownOptions: {
      output: {
        codeSplitting: false,
      },
    },
  },
});
EOF

node -e '
const fs = require("fs");
const path = "package.json";
const packageJson = JSON.parse(fs.readFileSync(path, "utf8"));
packageJson.scripts = {
  ...packageJson.scripts,
  bundle: "vite build",
};
fs.writeFileSync(path, `${JSON.stringify(packageJson, null, 2)}\n`);
'

printf '%s\n' 'Setup complete.'
printf 'Start development with:\n  cd %s\n  pnpm dev\n' "$PROJECT_NAME"
printf '%s\n' 'Build a single HTML artifact with:'
printf '%s\n' '  pnpm bundle'
