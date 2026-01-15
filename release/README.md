# Release Automation

This directory contains scripts and documentation for automating the Homebrew formula updates when your main tool repository is separate from your Homebrew tap repository.

## Overview

The Homebrew formula is automatically updated when a new release is published in the main solarboat repository. This is achieved through GitHub Actions and repository dispatch events sent **from your main repository to this tap repository**.

## Repository Structure

- **Main Repository**: `devqik/solarboat` (contains your CLI tool source code)
- **Homebrew Tap**: `devqik/homebrew-solarboat` (this repository, contains the Homebrew formula)

## Files

- `update-homebrew.sh` - Script to trigger formula updates from the main repository
- `README.md` - This documentation

## How it Works

1. **New Release Published**: When a new version of solarboat is released in `devqik/solarboat`
2. **Script Execution**: The `update-homebrew.sh` script is called from your main repository
3. **Cross-Repository Dispatch**: The script sends a repository dispatch event to this tap repository (`devqik/homebrew-solarboat`)
4. **Automatic Update**: The `update-formula.yml` GitHub Action is triggered in this tap repository
5. **Pull Request**: A PR is automatically created with the updated formula
6. **Testing**: The `test.yml` workflow validates the formula on macOS and Linux

## Usage

### Option 1: Copy script to your main repository

Copy `release/update-homebrew.sh` to your main `devqik/solarboat` repository and integrate it into your release workflow:

```bash
# In your main repository after creating a release:
./scripts/update-homebrew.sh 0.7.3 <macos_sha256> <linux_sha256>
```

### Option 2: Direct integration in GitHub Actions

Add this to your main repository's release workflow (in `devqik/solarboat`):

```yaml
- name: Update Homebrew Formula
  env:
    GITHUB_TOKEN: ${{ secrets.HOMEBREW_TAP_TOKEN }}
  run: |
    # Calculate SHA256 hashes for the release binaries
    MACOS_SHA256=$(shasum -a 256 solarboat-x86_64-apple-darwin.tar.gz | cut -d' ' -f1)
    LINUX_SHA256=$(shasum -a 256 solarboat-x86_64-unknown-linux-gnu.tar.gz | cut -d' ' -f1)

    # Trigger Homebrew formula update in the tap repository
    curl -X POST \
      -H "Accept: application/vnd.github.v3+json" \
      -H "Authorization: token $GITHUB_TOKEN" \
      -H "Content-Type: application/json" \
      "https://api.github.com/repos/devqik/homebrew-solarboat/dispatches" \
      -d "{\"event_type\":\"update-formula\",\"client_payload\":{\"version\":\"${{ github.event.release.tag_name }}\",\"macos_sha256\":\"$MACOS_SHA256\",\"linux_sha256\":\"$LINUX_SHA256\"}}"
```

### Option 3: Manual trigger via GitHub Actions

You can manually trigger the update workflow from this tap repository's GitHub Actions tab:

1. Go to the [Actions tab](https://github.com/devqik/homebrew-solarboat/actions)
2. Select "Update Formula" workflow
3. Click "Run workflow"
4. Enter the version and SHA256 hashes

## Requirements

### GitHub Token Setup

Create a GitHub Personal Access Token with the following permissions:

- `repo` scope (to trigger workflows)
- Access to both repositories: `devqik/solarboat` and `devqik/homebrew-solarboat`

Add this token as a secret in your **main repository** (`devqik/solarboat`):

- Secret name: `HOMEBREW_TAP_TOKEN`
- Secret value: Your GitHub token

### Repository Configuration

1. **Main Repository** (`devqik/solarboat`): Contains the `HOMEBREW_TAP_TOKEN` secret
2. **Tap Repository** (`devqik/homebrew-solarboat`): This repository, no additional secrets needed

## Customization for Different Repositories

If you have different repository names or organizations, update the variables in `update-homebrew.sh`:

```bash
# Update these variables to match your setup
TAP_REPO_OWNER="your-username"     # GitHub username/org for the tap repo
TAP_REPO_NAME="homebrew-yourtool"  # Name of your tap repository
```

## Troubleshooting

- **Permission Denied**: Ensure your `HOMEBREW_TAP_TOKEN` has repo access to both repositories
- **Workflow Not Triggering**: Check that repository dispatch events are enabled in your tap repository
- **SHA256 Mismatch**: Verify the binary file names match those expected in the formula
