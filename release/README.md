# Release Automation

This directory contains scripts and documentation for automating the Homebrew formula updates.

## Overview

The Homebrew formula is automatically updated when a new release is published in the main solarboat repository. This is achieved through GitHub Actions and repository dispatch events.

## Files

- `update-homebrew.sh` - Script to trigger formula updates from the main repository

## How it Works

1. **New Release Published**: When a new version of solarboat is released
2. **Script Execution**: The `update-homebrew.sh` script is called with version and SHA256 hashes
3. **Repository Dispatch**: The script sends a repository dispatch event to this tap repository
4. **Automatic Update**: The `update-formula.yml` GitHub Action is triggered
5. **Pull Request**: A PR is automatically created with the updated formula
6. **Testing**: The `test.yml` workflow validates the formula on macOS and Linux

## Usage

### From the main solarboat repository

```bash
# After creating a release, run:
./release/update-homebrew.sh 0.7.3 <macos_sha256> <linux_sha256>
```

### Manual trigger via GitHub Actions

You can also manually trigger the update workflow from the GitHub Actions tab:

1. Go to the [Actions tab](https://github.com/devqik/homebrew-solarboat/actions)
2. Select "Update Formula" workflow
3. Click "Run workflow"
4. Enter the version and SHA256 hashes

## Requirements

- `GITHUB_TOKEN` environment variable with repo permissions
- The token should have access to both the main solarboat repository and this tap repository

## Integration with Main Repository

To integrate this with your main solarboat repository's release process, add the following to your release workflow:

```yaml
- name: Update Homebrew Formula
  env:
    GITHUB_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
  run: |
    # Calculate SHA256 hashes for the release binaries
    MACOS_SHA256=$(shasum -a 256 solarboat-x86_64-apple-darwin.tar.gz | cut -d' ' -f1)
    LINUX_SHA256=$(shasum -a 256 solarboat-x86_64-unknown-linux-gnu.tar.gz | cut -d' ' -f1)

    # Trigger Homebrew formula update
    curl -X POST \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: application/json" \
      "https://api.github.com/repos/devqik/homebrew-solarboat/dispatches" \
      -d "{\"event_type\":\"update-formula\",\"client_payload\":{\"version\":\"${{ github.event.release.tag_name }}\",\"macos_sha256\":\"$MACOS_SHA256\",\"linux_sha256\":\"$LINUX_SHA256\"}}"
```
