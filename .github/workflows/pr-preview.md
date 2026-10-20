# PR Preview Deployment

Automatic preview deployments for pull requests using GitHub Pages with custom domain.

## Features

- **Live preview URLs** - `https://preview.wafer.space/pr-123/`
- **Automatic updates** - Rebuilds on every commit
- **Preview index** - All active previews at `https://preview.wafer.space/`
- **Deployment tracking** - GitHub deployment status integration
- **Automatic cleanup** - Removed when PR closes

## How It Works

Previews are built in two stages so that pull requests from forks get previews too, without giving fork code access to secrets:

1. **Stage 1, `pr-preview-build.yml` (`pull_request`, untrusted):** runs on every PR, including forks, with no secrets. It only records the PR number, head SHA and title as an artifact.
2. **Stage 2, `pr-preview-deploy.yml` (`workflow_run`, trusted):** runs from `main` with the secrets once Stage 1 finishes. It re-checks the PR through the GitHub API instead of trusting Stage 1's artifact, then:
   - blocks fork PRs that change `_plugins/` or `.github/`, and comments to explain why;
   - for other fork PRs, replaces `_plugins/`, the scripts it runs and `Gemfile`/`Gemfile.lock` with the trusted copies from `main`, and forces `plugins_dir: _plugins`;
   - builds with the private theme, deploys to `/pr-[number]/` and comments the preview URL.
3. **Verification, `preview-verification.yml` (`workflow_run`):** runs after a successful Stage 2 and comments the link check results.
4. Previews update on every push and are removed by `cleanup-previews.yml` when the PR closes.

Because Stages 2 and 3 are `workflow_run` workflows, GitHub always runs the copy on `main`. Changes to them in a PR only take effect after merging, and their runs appear in the Actions tab rather than in the PR's checks.

## Viewing Previews

Click the preview URL in the PR comment:
```
https://preview.wafer.space/pr-123/
```

Browse all active previews:
```
https://preview.wafer.space/
```

## Troubleshooting

### Preview not appearing
- Check GitHub Actions tab for workflow status
- Ensure custom domain DNS is configured for `preview.wafer.space`
- Wait up to 2 minutes for GitHub Pages deployment to complete
- Verify SSH deploy key is configured for theme submodule access

### Preview shows 404 error
- Check if Jekyll build completed successfully in workflow logs
- Verify PR base URL configuration in workflow
- Ensure theme submodule initialized correctly

### Preview index missing PRs
- Check script validation warnings in workflow logs
- Ensure preview directories contain `index.html` file
- Verify PR numbers are numeric format only

### Deployment failures
- Check for merge conflicts in gh-pages branch
- Verify GitHub Pages is enabled for repository
- Ensure workflow has required permissions (contents, pages, deployments)