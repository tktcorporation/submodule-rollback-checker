# submodule-rollback-checker action

This GitHub Action checks if any submodule in a pull request has been rolled back compared to the base branch. If a rollback is detected, it posts a warning comment on the pull request and fails the job.

## Features

- **Automatic Detection of Rollbacks:**  
  Compares the submodule commit hashes on the PR head branch to those on the base branch. If the PR’s submodule commit does not contain the base’s commit in its history, it's considered a rollback.
  
- **Commenting on the PR:**  
  On detecting a rollback, the Action posts a warning comment to the pull request to alert reviewers and contributors.

- **Failure on Rollback:**  
  If a rollback is detected, the job fails, preventing unintended merges.

## Prerequisites

- This Action is designed to run on a `pull_request` event.
- The repository should have submodules defined in `.gitmodules`.
- The `token` (e.g., `${{ secrets.GITHUB_TOKEN }}` or a PAT with `repo` permissions) must have sufficient read access to fetch submodules. For private submodules, ensure that the token has appropriate permissions.

## Usage

Add this Action to a workflow triggered by `pull_request` events. For example:

```yaml
name: Check for Submodule Rollback
on:
  pull_request:
    types: [opened, reopened, synchronize]

jobs:
  check-submodule-rollback:
    runs-on: ubuntu-latest
    steps:
      - name: Check Submodule Commit
        uses: your-org/action-check-submodule-commit@v1
        with:
          token: ${{ secrets.GITHUB_TOKEN }}
```

### Inputs

| Name  | Required | Default | Description                                                           |
|-------|-----------|---------|-----------------------------------------------------------------------|
| token | true      |         | A token with permission to read submodules (e.g., GITHUB_TOKEN).      |

### Outputs

| Name        | Description                                                   |
|-------------|---------------------------------------------------------------|
| has_warning | `true` if a submodule rollback is detected, otherwise `false`. |

If a rollback is detected:
- A warning comment is posted on the PR.
- The job fails to prevent merging.

## Permissions & Tokens

- If submodules reside in private repositories, you need a token with at least `repo` (read) permissions.
- For public submodules, the default `GITHUB_TOKEN` is often sufficient, but ensure it has `contents: read` permission if you use a Fine-Grained Personal Access Token.
  
In your repository settings or at the organization level, you may need to grant `GITHUB_TOKEN` the appropriate read permissions for submodules:
- Navigate to **Settings > Actions > General** and ensure that `GITHUB_TOKEN` has adequate `read` permission on the repository content.

## Local Debugging with `act`

You can use [act](https://github.com/nektos/act) to debug the Action locally:

1. **Install `act`**: Follow instructions at [nektos/act](https://github.com/nektos/act).

2. **Create a PR event payload** (e.g., `events/pull_request.json`):
   ```json
   {
     "pull_request": {
       "number": 1,
       "head": { "sha": "HEAD_COMMIT_SHA" },
       "base": { "sha": "BASE_COMMIT_SHA" }
     }
   }
   ```
   Replace `HEAD_COMMIT_SHA` and `BASE_COMMIT_SHA` with actual commit SHAs from your repo for testing.

3. **Set secrets**:  
   Create a `.secrets` file at the repository root (not committed) containing:
   ```
   TOKEN=ghp_xxx...xxx
   ```
   
4. **Create a test workflow** (e.g., `.github/workflows/test.yml`):
   ```yaml
   name: Test Submodule Rollback Action
   on:
     pull_request:
       types: [opened, synchronize]

   jobs:
     test:
       runs-on: ubuntu-latest
       steps:
         - name: Checkout
           uses: actions/checkout@v4
         - name: Run Submodule Rollback Check
           uses: ./
           with:
             token: ${{ secrets.TOKEN }}
   ```

5. **Run `act` locally**:
   ```bash
   act pull_request -e events/pull_request.json -s TOKEN=ghp_xxx...xxx
   ```
   
   This simulates the pull_request event locally, allowing you to debug steps, logs, and outputs.

## License

[MIT License](LICENSE)

## Contributing

Pull requests are welcome! If you find a bug or want to improve the Action, feel free to submit an issue or PR.

---

*This README.md is a reference template. Adjust repository URLs, token usage, branding, and instructions to fit your context.*