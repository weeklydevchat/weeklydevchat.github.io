# Weekly Dev Chat Website

A static website for the Weekly Dev Chat community - a weekly virtual developer chat that meets every Tuesday at 12pm Mountain Time.

**Live Site**: [weeklydevchat.com](https://weeklydevchat.com)

![GitHub Pages](https://github.com/weeklydevchat/weeklydevchat.github.io/actions/workflows/ci.yml/badge.svg)
[![Built with Material for MkDocs](https://img.shields.io/badge/Material_for_MkDocs-526CFE?style=for-the-badge&logo=MaterialForMkDocs&logoColor=white)](https://squidfunk.github.io/mkdocs-material/)

## About

This is a static site built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/) and hosted on GitHub Pages. The site features:
- Weekly blog posts for Tuesday chat topics
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
   ---
   ```

3. Add your content following this template:
   ```markdown
   TOPIC_INTRODUCTION_HERE

   Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

   ![alt text](YYYY-MM-DD_image_filename.webp)
   ```

4. Add any images to the same directory as the post

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

## Resources

- [MkDocs Documentation](https://www.mkdocs.org)
- [Material for MkDocs](https://squidfunk.github.io/mkdocs-material/)
- [Material Blog Plugin](https://squidfunk.github.io/mkdocs-material/plugins/blog/)
- [GitHub Pages Documentation](https://docs.github.com/en/pages)

## Community

Join our virtual chat every Tuesday at 12pm Mountain Time! Visit [weeklydevchat.com/join](https://weeklydevchat.com/join) for details.  We also occasionally do in real-life events.