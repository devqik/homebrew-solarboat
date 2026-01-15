# Homebrew Integration

This document explains how Solarboat automatically updates its Homebrew formula when new releases are published.

## Overview

When you create a new release (by pushing a git tag like `v0.8.0`), the following happens automatically:

1. **Build & Test** → Tests pass and binaries are built for macOS and Linux
2. **Publish to crates.io** → The Rust crate is published
3. **Create GitHub Release** → Release is created with binary artifacts
4. **Update Homebrew** → The Homebrew formula is automatically updated

## Repository Structure

- **Main Repository**: `devqik/solarboat` (this repository - contains Rust source code)
- **Homebrew Tap**: `devqik/homebrew-solarboat` (contains the Homebrew formula)

## How It Works

### 1. Release Workflow

The `.github/workflows/release.yml` file includes an `update-homebrew` job that:

- Downloads the built binaries
- Calculates SHA256 hashes for macOS and Linux binaries
- Sends a repository dispatch event to the Homebrew tap repository

### 2. Cross-Repository Communication

The release workflow sends an API request to trigger the formula update in the tap repository:

```bash
curl -X POST \
  -H "Authorization: token $HOMEBREW_TAP_TOKEN" \
  "https://api.github.com/repos/devqik/homebrew-solarboat/dispatches" \
  -d '{"event_type":"update-formula","client_payload":{"version":"0.8.0","macos_sha256":"...","linux_sha256":"..."}}'
```

### 3. Automatic Formula Update

The Homebrew tap repository receives the dispatch event and:

- Updates the formula with the new version and SHA256 hashes
- Creates a pull request with the changes
- Runs tests to ensure the formula works

## Setup Requirements

### GitHub Token

You need to create a GitHub Personal Access Token and add it as a repository secret:

1. **Create Token**: Go to GitHub Settings → Developer settings → Personal access tokens

   - Token name: `HOMEBREW_TAP_TOKEN`
   - Scopes: `repo` (full repository access)
   - Make sure it has access to both repositories

2. **Add Secret**: In this repository (`devqik/solarboat`):
   - Go to Settings → Secrets and variables → Actions
   - Add a new secret:
     - Name: `HOMEBREW_TAP_TOKEN`
     - Value: Your GitHub token

### Repository Permissions

Ensure the token has access to:

- `devqik/solarboat` (this repository)
- `devqik/homebrew-solarboat` (the tap repository)

## Manual Usage

You can also manually trigger Homebrew updates using the script:

```bash
# After creating a release manually
./scripts/update-homebrew.sh 0.8.0 <macos_sha256> <linux_sha256>
```

## Creating a Release

To create a new release that triggers the Homebrew update:

1. **Update version** in `Cargo.toml`
2. **Commit changes**: `git add . && git commit -m "Release v0.8.0"`
3. **Create tag**: `git tag v0.8.0`
4. **Push tag**: `git push origin v0.8.0`

The release workflow will automatically:

- Run tests
- Build binaries for macOS and Linux
- Create GitHub release
- Update Homebrew formula

## Troubleshooting

### Common Issues

1. **Missing HOMEBREW_TAP_TOKEN**

   ```
   Error: Bad credentials
   ```

   → Add the GitHub token as a repository secret

2. **Permission Denied**

   ```
   Error: Resource not accessible by integration
   ```

   → Ensure the token has `repo` scope and access to both repositories

3. **Formula Update Fails**
   - Check the workflow logs in the tap repository
   - Verify binary file names match what the formula expects
   - Ensure SHA256 hashes are calculated correctly

### Debugging

- **Release Workflow**: Check Actions tab in this repository
- **Formula Update**: Check Actions tab in `devqik/homebrew-solarboat`
- **Manual Test**: Run `./scripts/update-homebrew.sh` locally

## Files

- `.github/workflows/release.yml` - Main release workflow with Homebrew integration
- `scripts/update-homebrew.sh` - Script for manual Homebrew updates
- `HOMEBREW_INTEGRATION.md` - This documentation
