# AGENTS.md

Weekly Dev Chat website — MkDocs Material static site. Read `mkdocs.yml` and recent posts in `docs/posts/` for configuration and conventions.

## Blog Post Rules

- Posts are for Tuesdays (the weekly chat day). Use next Tuesday's date unless told otherwise.
- End post body with this paragraph (before the image):
  `Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.`
- Place images in the same directory as the post's `index.md`.
- Use `./create_post.sh` to scaffold a new post (calculates next Tuesday automatically).
- **Multiple posts on the same date:** If a date folder already has an `index.md`, prefix the filename with a number and dash (e.g., `0-index.md`). The newest/latest post should use the lowest number so it appears first on the homepage. The original `index.md` keeps its name.

## Guardrails

- Pushing to `main` triggers automatic deployment to production. Do not push without explicit approval.
- Do not modify `.github/workflows/ci.yml` unless explicitly asked.
- Verify changes build cleanly with `mkdocs serve` before committing.
