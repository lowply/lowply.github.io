# Task 3 Report: Remove Node and Sass Build Tooling

## Summary
- Deleted `package.json` and `package-lock.json`.
- Simplified `Makefile` to Hugo-only `build`, `check`, and `local` targets.
- Removed Node.js dependency setup and Dart Sass installation from `.github/workflows/pages.yml`.
- Removed `node_modules` from `.gitignore`.
- Updated `README.md` to state that Hugo is the only required build tool.
- Applied the recorded integration ruling in `script/check-css-migration.sh` so the check accepts Hugo's minified unquoted `href` and `rel` attributes while still requiring the fingerprinted `/css/main.min.*.css` path and a non-empty quoted `integrity` value.
- Verified `make check` is green and the active-reference search is clean.

## TDD Evidence

### RED 1: `make check` fails before tooling removal
Command executed:
```bash
make check
```

Output:
```text
hugo --cleanDestinationDir
Start building sites … 
hugo v0.166.0+extended+withdeploy darwin/arm64 BuildDate=2026-09-09T14:45:02Z VendorInfo=Homebrew

WARN  Raw HTML omitted while rendering "/Users/sho/ghq/github.com/lowply/lowply.github.io/content/photo/bali-2009.md"; see https://gohugo.io/getting-started/configuration-markup/#rendererunsafe
You can suppress this warning by adding the following to your project configuration:
ignoreLogs = ['warning-goldmark-raw-html']

                  │ EN  
──────────────────┼─────
 Pages            │  38 
 Paginator pages  │   0 
 Non-page files   │   0 
 Static files     │ 266 
 Processed images │   0 
 Aliases          │   9 
 Cleaned          │   0 

Total in 532 ms
./script/check-css-migration.sh
obsolete dependency file remains: package.json
make: *** [check] Error 1
```

Why this RED is expected:
- Task 2 intentionally left the package manifests in place.
- `Makefile` still required `npm ci`, so Task 3 began from the expected failing state.

### RED 2: The existing stylesheet check rejects Hugo's minified link syntax
Command executed:
```bash
printf 'Extraction test: '; if stylesheet_path=$(sed -n 's/.*href="\([^"]*\/css\/main\.min\.[^"]*\.css\)".*/\1/p' public/index.html | head -n 1) && [ -n "$stylesheet_path" ]; then printf 'PASS %s\n' "$stylesheet_path"; else printf 'FAIL (empty)\n'; fi
printf 'Attribute regex test: '; if grep -Eq 'href="[^"]*/css/main\.min\.[^"]*\.css" rel="stylesheet" integrity="[^"]+"' public/index.html; then printf 'PASS\n'; else printf 'FAIL\n'; fi
```

Output:
```text
Extraction test: FAIL (empty)
Attribute regex test: FAIL
```

Why this RED is expected:
- Hugo minifies the `<link>` tag to `href=/css/... rel=stylesheet integrity="..."`.
- The original `sed` and `grep` logic required quoted `href="..." rel="..."`, so the hidden cross-task integration mismatch reproduced exactly as recorded in the plan ledger.

## Implementation Details
1. Deleted `package.json` and `package-lock.json`.
2. Replaced the `Makefile` Node/npm prerequisite chain with the Hugo-only targets required by the brief:
   - `build: hugo --cleanDestinationDir`
   - `check: build` then `./script/check-css-migration.sh`
   - `local: hugo server --config config.yaml,config-local.yaml`
3. Removed the following GitHub Pages workflow steps:
   - `Setup Node.js`
   - `Install Node.js dependencies`
   - `Install Dart Sass`
4. Removed `node_modules` from `.gitignore` and deleted the local untracked `node_modules/` directory so the checkout stayed clean after the ignore rule was removed.
5. Updated `README.md` so the build section explicitly says Hugo is the only required build tool while keeping the existing `make build` and `make local` commands.

## Script-Ruling Implementation
Applied the recorded Task 2 → Task 3 ruling with the smallest practical edit to `script/check-css-migration.sh`:

1. **Fingerprint extraction**
   - Changed the `sed` capture so `href=` may be quoted or unquoted.
   - Stopped the match at a space or `>` so Hugo's minified one-line HTML is parsed correctly.
2. **Integrity assertion**
   - Relaxed `href` and `rel` to accept either quoted or unquoted forms.
   - Kept the required stylesheet path anchored to `/css/main.min.*.css`.
   - Kept `integrity="[^"]+"`, so the integrity attribute must still be present, quoted, and non-empty.

This preserves the regression contract while matching Hugo's actual minified output instead of an unminified HTML shape the site does not emit.

### GREEN 1: Updated stylesheet parser accepts the real Hugo output
Command executed:
```bash
printf 'Extraction test: '; if stylesheet_path=$(sed -n 's/.*href="\{0,1\}\([^" >]*\/css\/main\.min\.[^" >]*\.css\)"\{0,1\}.*/\1/p' public/index.html | head -n 1) && [ -n "$stylesheet_path" ]; then printf 'PASS %s\n' "$stylesheet_path"; else printf 'FAIL (empty)\n'; fi
printf 'Attribute regex test: '; if grep -Eq 'href="?/css/main\.min\.[^" >]*\.css"?[[:space:]]+rel="?stylesheet"?[[:space:]]+integrity="[^"]+"' public/index.html; then printf 'PASS\n'; else printf 'FAIL\n'; fi
```

Output:
```text
Extraction test: PASS /css/main.min.dbe131c1f159e7d769fd50ab3d7deb1e4b97b7a84aa8e56ec3cd423883490326.css
Attribute regex test: PASS
```

## Post-change Verification

### GREEN 2: `make check` passes after the tooling cleanup
Command executed:
```bash
make check
```

Output:
```text
hugo --cleanDestinationDir
Start building sites … 
hugo v0.166.0+extended+withdeploy darwin/arm64 BuildDate=2026-09-09T14:45:02Z VendorInfo=Homebrew

WARN  Raw HTML omitted while rendering "/Users/sho/ghq/github.com/lowply/lowply.github.io/content/photo/bali-2009.md"; see https://gohugo.io/getting-started/configuration-markup/#rendererunsafe
You can suppress this warning by adding the following to your project configuration:
ignoreLogs = ['warning-goldmark-raw-html']

                  │ EN  
──────────────────┼─────
 Pages            │  38 
 Paginator pages  │   0 
 Non-page files   │   0 
 Static files     │ 266 
 Processed images │   0 
 Aliases          │   9 
 Cleaned          │   0 

Total in 416 ms
./script/check-css-migration.sh
```

Interpretation:
- The Hugo build succeeds.
- The regression contract now succeeds end-to-end without Node, npm, or Dart Sass.

## Active-Reference Search
Command executed:
```bash
printf '%s\n' 'Broader active-reference search (tracked files, excluding content, plans, and detector script):' && git --no-pager grep -nEi 'bootstrap|dart.?sass|sass|scss|npm|node(\.js)?|setup-node|css\.Sass' -- . ':!content/**' ':!.superpowers/**' ':!script/check-css-migration.sh' || true
```

Output:
```text
Broader active-reference search (tracked files, excluding content, plans, and detector script):
```

Interpretation:
- No active tracked source/build files still reference Bootstrap, Dart Sass, Sass/SCSS compilation, npm, or Node.js.
- `content/**` was excluded per brief because historical prose is out of scope.
- `.superpowers/**` and `script/check-css-migration.sh` were excluded because they intentionally record historical task notes or detector literals that mention the removed tools by name.

## Files Changed
Tracked source/build file status before adding this report:
```text
M	.github/workflows/pages.yml
M	.gitignore
M	Makefile
M	README.md
D	package-lock.json
D	package.json
M	script/check-css-migration.sh
```

Final committed task files:
- `.github/workflows/pages.yml`
- `.gitignore`
- `.superpowers/sdd/plan/task-3-report.md`
- `Makefile`
- `README.md`
- `package-lock.json` (deleted)
- `package.json` (deleted)
- `script/check-css-migration.sh`

## Self-Review
- [x] Deleted both Node package manifests.
- [x] Simplified `Makefile` exactly to the Hugo-only targets in the brief.
- [x] Removed Node.js dependency setup and Dart Sass installation from the Pages workflow.
- [x] Removed `node_modules` from `.gitignore` while keeping Hugo-generated paths ignored.
- [x] Updated the README build section without changing the documented build/run commands.
- [x] Implemented the recorded script ruling minimally and preserved the fingerprint/integrity assertions.
- [x] Captured the required RED `make check` before implementation.
- [x] Captured GREEN `make check` after implementation.
- [x] Ran the required active-reference search and verified it was clean.

## Concerns
1. `make check` still emits a pre-existing Hugo Goldmark warning for `content/photo/bali-2009.md` raw HTML during the build step, but it is non-failing and unchanged by this task.
