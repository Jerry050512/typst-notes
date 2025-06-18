# GitHub Workflow for Typst Notes Compilation

This repository now includes an automated GitHub Actions workflow that compiles all Typst notes and practice files into PDFs and releases them automatically.

## How it Works

The workflow (`compile-and-release.yml`) automatically:

1. **Discovers** all `note.typ` and `practice.typ` files in subdirectories
2. **Compiles** them using the latest version of Typst
3. **Renames** the output PDFs using the directory name:
   - `note.typ` → `{directory-name}-note.pdf`
   - `practice.typ` → `{directory-name}-practice.pdf`
4. **Releases** the PDFs to GitHub Releases

## Trigger Conditions

The workflow runs automatically when:

- **Push to main branch**: Creates a development release with tag `dev-{commit-sha}`
- **Tagged release** (e.g., `v1.0.0`): Creates a stable release
- **Pull requests**: Compiles files for testing (no release)
- **Manual trigger**: Can be run manually from the Actions tab

## Current Files Being Compiled

Based on the current repository structure, the following PDFs will be generated:

- `Control-Engineering-note.pdf`
- `Control-Engineering-practice.pdf`
- `Microcomputer-note.pdf`
- `Pattern-Recoginition-and-Machine-Learning-note.pdf`
- `Signals-and-Systems-note.pdf`

## Font Support

The workflow includes Chinese font support (Noto CJK fonts) to properly render Chinese characters in the documents.

## Dependencies

The workflow automatically installs:
- Latest Typst compiler
- Noto CJK fonts for Chinese text rendering
- Required Typst packages (like `@preview/cetz:0.3.4`)

## Creating a Release

### Automatic Development Releases
Every push to the main branch creates a development release automatically.

### Stable Releases
To create a stable release:

1. Create and push a tag:
   ```bash
   git tag v1.0.0
   git push origin v1.0.0
   ```

2. The workflow will automatically create a stable release with all compiled PDFs.

## Artifacts

Even for pull requests and non-release builds, compiled PDFs are available as workflow artifacts for 30 days.

## Troubleshooting

If compilation fails:
1. Check the Actions tab for detailed error logs
2. Ensure all Typst files are valid and can be compiled locally
3. Verify that all imported packages are available

## Local Testing

You can test the compilation logic locally using the included test script:

```bash
bash test-workflow.sh
```

This script simulates the workflow logic without actually compiling files (useful for testing the file discovery and naming logic).