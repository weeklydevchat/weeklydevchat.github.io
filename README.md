# Weekly Dev Chat Website

A static website for the Weekly Dev Chat community - a weekly virtual developer chat that meets every Tuesday at 12pm Mountain Time.

**Live Site**: [weeklydevchat.com](https://weeklydevchat.com)

![GitHub Pages](https://github.com/weeklydevchat/weeklydevchat.github.io/actions/workflows/ci.yml/badge.svg)
[![Built with Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white)](https://squidfunk.github.io/mkdocs-material/)

## About

This is a static site built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) and hosted on GitHub Pages. The site features:
- Weekly blog posts for Tuesday chat topics
- Tag-based browsing to filter posts by topic
- Host information and community guidelines
- Sponsor information
- Automatic deployment via GitHub Actions

## Technology Stack

- **Static Site Generator**: [MkDocs](https://www.mkdocs.org)
- **Theme**: [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- **Language**: Python 3.x
- **Hosting**: GitHub Pages
- **CI/CD**: GitHub Actions
- **Container Support**: Docker Compose

## Quick Start

### Prerequisites

- Python 3.x (recommended: use a virtual environment)
- OR Docker and Docker Compose

### Local Development (Native)

1. Install dependencies:
   ```bash
   pip install mkdocs-material
   ```

2. Start the development server:
   ```bash
   mkdocs serve
   ```

3. Open your browser to [http://127.0.0.1:8000](http://127.0.0.1:8000)

### Local Development (Docker)

1. Start the development server:
   ```bash
   docker compose up app
   ```

2. Open your browser to [http://localhost:8000](http://localhost:8000)

**Hot Reloading**: The Docker development environment supports hot reloading out of the box. When you edit any file in the `docs/` directory (or `mkdocs.yml`), the site will automatically rebuild and your browser will refresh to show the changes.

**Pip Cache**: Python packages are cached in a Docker volume (`pip-cache`), so subsequent container starts are faster since packages don't need to be re-downloaded.

To stop the server, press `Ctrl+C`. To completely remove containers and volumes:
```bash
docker compose down -v
```

## Creating Blog Posts

### Using Helper Scripts

We provide scripts to automatically create properly formatted blog posts for the next Tuesday:

**Bash (Linux/macOS)**:
```bash
./create_post.sh
```

**PowerShell (Windows)**:
```powershell
.\create_post.ps1
```

These scripts will:
- Calculate the date of the next Tuesday (or use today if it's Tuesday)
- Create the directory structure: `docs/posts/YYYY/MM/DD/`
- Generate an `index.md` file with proper frontmatter

### Manual Blog Post Creation

1. Create a directory following the date pattern: `docs/posts/YYYY/MM/DD/`

2. Create an `index.md` file with the following frontmatter:
   ```yaml
   ---
   title: "Your Blog Post Title"
   date: YYYY-MM-DD
   authors:
     - chris
   categories:
     - Category Name
   tags:
     - relevant-tag
   ---
   ```

3. Add your content following this template:
   ```markdown
   TOPIC_INTRODUCTION_HERE

   Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

   ![alt text](YYYY-MM-DD_image_filename.webp)
   ```

4. Add any images to the same directory as the post

### Categories and Tags

Categories are broad topic groupings and tags are specific topic labels for filtering. New categories and tags can be added as needed — these are the ones currently in use.

**Categories**: Business, Career, Community, Culture, Security, Technical

**Tags**: `administration`, `advent-of-code`, `advent-of-cyber`, `agile`, `ai`, `architecture`, `branding`, `cancelled`, `career`, `change-management`, `claude`, `code-quality`, `coding-challenges`, `coding-practices`, `community`, `conferences`, `creativity`, `ctf`, `culture`, `curriculum`, `cybersecurity`, `data`, `databases`, `design-patterns`, `devops`, `editors`, `education`, `entrepreneurship`, `ergonomics`, `estimation`, `ethics`, `events`, `finance`, `github-copilot`, `goals`, `gratitude`, `growth`, `habits`, `hacktoberfest`, `hardware`, `health`, `hiring`, `history`, `holiday`, `industry`, `infrastructure`, `innovation`, `inspiration`, `irl`, `job-market`, `learning`, `local-tech`, `marketing`, `meetup`, `meetups`, `metaphors`, `methodology`, `metrics`, `mob-programming`, `motivation`, `naming`, `networking`, `open-discussion`, `open-source`, `optimization`, `organizations`, `pair-programming`, `performance`, `philosophy`, `picoctf`, `predictions`, `priorities`, `privacy`, `productivity`, `project-management`, `prototyping`, `quality-assurance`, `reflection`, `remote-work`, `resilience`, `security`, `self-hosting`, `self-improvement`, `side-projects`, `society`, `supply-chain`, `surveys`, `swap-meet`, `systems`, `tdd`, `teaching`, `teamwork`, `technology`, `testing`, `thinking`, `time-management`, `tools`, `trends`, `unconference`, `version-control`, `watch-party`, `wellness`, `work-life-balance`, `workplace`, `workspace`, `year-in-review`

## Project Structure

```
.
├── mkdocs.yml                 # Main configuration file
├── requirements.txt           # Python dependencies
├── docker-compose.yml         # Docker development environment
├── create_post.sh             # Bash script to create blog posts
├── create_post.ps1            # PowerShell script to create blog posts
├── .github/
│   ├── dependabot.yml         # Dependabot configuration
│   └── workflows/
│       └── ci.yml             # GitHub Actions deployment
└── docs/                      # All site content
    ├── .authors.yml           # Author metadata
    ├── index.md               # Homepage
    ├── join.md                # How to join
    ├── tags.md                # Tags index page (auto-populated by tags plugin)
    ├── hosts/                 # Current hosts
    ├── past-hosts/            # Past hosts
    ├── sponsors/              # Sponsors
    ├── posts/                 # Blog posts (YYYY/MM/DD/)
    ├── assets/                # Images, logos
    └── stylesheets/
        └── extra.css          # Custom CSS
```

## Common Commands

```bash
# Development
mkdocs serve                    # Start development server
mkdocs serve -a 0.0.0.0:8000   # Start server accessible on network

# Build
mkdocs build                    # Build static site to site/ directory
mkdocs build --clean            # Clean build

# Help
mkdocs -h                       # Show help

# Docker
docker compose up app           # Start development server (with hot reloading)
docker compose down             # Stop containers
docker compose down -v          # Stop containers and remove volumes (pip cache)
```

## Deployment

### Automatic Deployment

Pushes to the `main` branch automatically trigger deployment via GitHub Actions:

1. The workflow builds the site using `mkdocs gh-deploy`
2. The static HTML is pushed to the `gh-pages` branch
3. GitHub Pages serves the site from `gh-pages`

See [.github/workflows/ci.yml](.github/workflows/ci.yml) for details.

### Manual Deployment

While not typically needed, you can manually deploy:
```bash
mkdocs gh-deploy --force
```

## Dependency Management

The project uses **Dependabot** to automatically keep dependencies up to date. Dependabot is configured to check weekly for:
- Python package updates (mkdocs-material)
- GitHub Actions updates

When updates are available, Dependabot creates pull requests automatically. Review and merge these PRs after verifying the CI workflow passes.

## Troubleshooting

### Build Fails
- Check YAML syntax in post frontmatter
- Verify all referenced images exist
- Check `mkdocs.yml` for syntax errors
- Review GitHub Actions logs for deployment failures

### Images Not Loading
- Image paths must be relative to the markdown file (e.g., `![alt](image.webp)`)
- Verify the image file exists in the same directory as the post's `index.md`

### Navigation Issues
- File paths in the `nav:` section of `mkdocs.yml` must match actual file locations
- New pages need to be added to `nav:` manually

### Styling Not Applied
- Check `docs/stylesheets/extra.css` for syntax errors
- Clear your browser cache
- Theme updates may rename CSS classes — check the [Material for MkDocs changelog](https://squidfunk.github.io/mkdocs-material/changelog/)

## Resources

- [MkDocs Documentation](https://www.mkdocs.org)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Material Blog Plugin](https://squidfunk.github.io/mkdocs-material/plugins/blog/)
- [Material Tags Plugin](https://squidfunk.github.io/mkdocs-material/plugins/tags/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

## Community

Join our virtual chat every Tuesday at 12pm Mountain Time! Visit [weeklydevchat.com/join](https://weeklydevchat.com/join) for details.  We also occasionally do in real-life events.