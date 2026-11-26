# GitHub Scripts

- `verify-preview-site.sh`: Runs the preview checks by hand (see `.github/docs/preview-verification.md`)
- `generate-preview-root.py`: Writes the root of preview.wafer.space, the preview index (from `.github/templates/preview-index.html`) and the `redirects.json` the redirects sync Worker loads into Cloudflare. The preview deploy and cleanup actions run it as their `root-script`, from the default branch's checkout, never a pull request's.
- `check-html-links.py`: The **Source checks** workflow's check for internal links ending in `.html`

The PR preview workflows (`pr-preview-build.yml`, `pr-preview-deploy.yml`, `preview-verification.yml` and `cleanup-previews.yml`) run actions from [wafer-space/actions](https://github.com/wafer-space/actions/tree/main/pr-preview), pinned to a commit. Their scripts and templates live there, so the privileged preview jobs never run code from the pull request being previewed. See `.github/workflows/pr-preview.md`.
