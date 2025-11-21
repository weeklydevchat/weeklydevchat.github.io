# AGENTS.md

## Project Overview

This is the **Weekly Dev Chat** website, a static site built with MkDocs Material and hosted on GitHub Pages. The site serves as a platform for a weekly virtual developer chat community that meets every Tuesday at 12pm Mountain Time.

**Live Site**: https://weeklydevchat.com
**Repository**: weeklydevchat/weeklydevchat.github.io
**Main Branch**: `main`
**Deployment**: Automated via GitHub Actions to `gh-pages` branch

## Technology Stack

- **Static Site Generator**: MkDocs
- **Theme**: Material for MkDocs
- **Language**: Python 3.x
- **Hosting**: GitHub Pages
- **CI/CD**: GitHub Actions
- **Container Support**: Docker Compose

## Project Structure

```
.
├── mkdocs.yml                 # Main configuration file
├── requirements.txt           # Python dependencies (mkdocs-material)
├── docker-compose.yml         # Docker development environment
├── docker-entrypoint.sh       # Docker startup script
├── create_post.sh             # Bash script to create new blog posts
├── create_post.ps1            # PowerShell script to create new blog posts
├── .github/
│   └── workflows/
│       └── ci.yml             # GitHub Actions deployment workflow
└── docs/                      # All site content
    ├── .authors.yml           # Author metadata (chris, norm, omar)
    ├── index.md               # Homepage
    ├── join.md                # How to join the chat
    ├── past_topics.md         # Archived topics (excluded from build)
    ├── hosts/
    │   └── index.md           # Current hosts page
    ├── past-hosts/
    │   └── index.md           # Past hosts page
    ├── sponsors/
    │   └── index.md           # Sponsors page
    ├── posts/                 # Blog posts organized by date
    │   └── YYYY/
    │       └── MM/
    │           └── DD/
    │               └── index.md  # Blog post content
    ├── assets/                # Images, logos, fonts, design files
    │   └── logo/              # Site branding assets
    └── stylesheets/
        └── extra.css          # Custom CSS overrides
```

## Key Configuration (mkdocs.yml)

### Site Information
- **Site Name**: Weekly Dev Chat
- **Site URL**: https://weeklydevchat.github.io
- **Description**: Every Tuesday at 12pm Mountain Time

### Theme Configuration
- **Theme**: Material for MkDocs
- **Primary Color**: Teal
- **Accent Color**: Blue
- **Font**: Roboto
- **Logo**: `assets/logo/png/square_logo_light_150.png`
- **Favicon**: `assets/logo/Favicons/16X16_favicon2.png`
- **Features**: Navigation indexes enabled

### Plugins
1. **search**: Built-in search functionality
2. **blog**: Enables blog functionality
   - Blog directory: Root (`.`)
   - Pagination: 3 posts per page

### Navigation Structure
- Home (index.md)
- Join (join.md)
- Hosts (hosts/index.md)
- Past Hosts (past-hosts/index.md)
- Sponsors (sponsors/index.md)

### Markdown Extensions
- `attr_list`: Allows specifying image dimensions and attributes

### Custom Styling
- Custom CSS: `stylesheets/extra.css`
- Responsive logo styling for articles

## Authors

Three hosts are configured in `docs/.authors.yml`:

1. **chris** - Chris Cumming (Host)
2. **norm** - Norman Lorrain (Host)
3. **omar** - Omar Ashour (Host)

Each author has a name, description, and avatar URL.

## Blog Post Conventions

### File Structure
Blog posts are organized by date: `docs/posts/YYYY/MM/DD/index.md`

### Post Frontmatter
```yaml
---
title: "Your Blog Post Title"
date: YYYY-MM-DD
authors:
 - chris | norm | omar  # One or more authors
---
```

### Post Content Template
```markdown
TOPIC_INTRODUCTION_HERE

Everyone and anyone are welcome to [join](https://weeklydevchat.com/join/) as long as you are kind, supportive, and respectful of others. Zoom link will be posted at 12pm MDT.

![alt text](YYYY-MM-DD_image_filename.webp)
```

### Creating New Posts

Two helper scripts are available for creating new blog posts:

1. **Bash Script** (`create_post.sh`):
   - Calculates next Tuesday from current date
   - Creates directory structure: `docs/posts/YYYY/MM/DD/`
   - Generates `index.md` with proper frontmatter template
   - Usage: `./create_post.sh`

2. **PowerShell Script** (`create_post.ps1`):
   - Same functionality as bash script
   - For Windows users
   - Usage: `.\create_post.ps1`

Both scripts automatically determine the date of the next Tuesday (or current day if Tuesday) and create the appropriate directory structure.

## Development Workflows

### Local Development (Native)

**Prerequisites**:
- Python 3.x (recommend using virtual environment)
- mkdocs-material package

**Setup**:
```bash
# Install dependencies
pip install mkdocs-material

# Start development server with live reload
mkdocs serve

# Site available at http://127.0.0.1:8000
```

### Local Development (Docker)

**Prerequisites**:
- Docker and Docker Compose

**Setup**:
```bash
# Start development server
docker compose up app

# Site available at http://localhost:8000
# Hot-reloading enabled for development
```

### Testing Changes
Before pushing changes, always test locally using `mkdocs serve` or Docker to verify:
- Content renders correctly
- Navigation works
- Images load properly
- Custom CSS applies as expected

## Deployment

### Automated Deployment (GitHub Actions)

**Trigger**: Push to `main` branch

**Workflow** (`.github/workflows/ci.yml`):
1. Checks out repository
2. Configures git credentials (github-actions bot)
3. Sets up Python 3.x
4. Caches mkdocs-material dependencies
5. Installs mkdocs-material
6. Runs `mkdocs gh-deploy --force`
7. Deploys to `gh-pages` branch

**Permissions**: Requires `contents: write` permission

**Cache**: Weekly cache refresh based on week number

### Manual Deployment
Not typically needed due to automated workflow, but can be done:
```bash
mkdocs gh-deploy --force
```

## Git Ignore Patterns

The following are ignored:
- `.venv/` - Python virtual environments
- `site/` - MkDocs build output
- `.DS_Store` - macOS metadata files

## Important Files to Modify

### For Content Changes
- `docs/index.md` - Homepage content
- `docs/join.md` - Join instructions
- `docs/hosts/index.md` - Current hosts information
- `docs/sponsors/index.md` - Sponsor information
- `docs/posts/YYYY/MM/DD/index.md` - Blog posts

### For Configuration Changes
- `mkdocs.yml` - Site configuration, theme, plugins, navigation
- `docs/.authors.yml` - Author metadata
- `docs/stylesheets/extra.css` - Custom styling

### For Assets
- `docs/assets/logo/` - Logo files (PNG, SVG)
- `docs/assets/logo/Favicons/` - Favicon files
- `docs/posts/YYYY/MM/DD/` - Post-specific images

## Common Agent Tasks

### Creating a New Blog Post

1. **Determine the date**: Calculate next Tuesday or use provided date
2. **Create directory**: `docs/posts/YYYY/MM/DD/`
3. **Create index.md** with proper frontmatter:
   ```yaml
   ---
   title: "Topic Title"
   date: YYYY-MM-DD
   authors:
    - chris
   ---
   ```
4. **Add content** following the template
5. **Add image** if needed (typically named `YYYY-MM-DD_description.webp` or `.png`)
6. **Test locally** before committing

### Modifying Site Configuration

1. **Edit mkdocs.yml** for:
   - Navigation changes
   - Theme settings
   - Plugin configuration
   - Markdown extensions
2. **Test changes** with `mkdocs serve`
3. **Verify** no build errors
4. **Commit and push** to trigger deployment

### Adding a New Page

1. **Create markdown file** in `docs/` directory
2. **Add to navigation** in `mkdocs.yml` under `nav:` section
3. **Test locally** to verify navigation works
4. **Commit changes**

### Updating Authors

1. **Edit** `docs/.authors.yml`
2. **Add/modify** author entry:
   ```yaml
   author_id:
     name: Full Name
     description: Role
     avatar: https://weeklydevchat.github.io/path/to/avatar.png
   ```
3. **Ensure avatar image** exists in the repository
4. **Test** by creating a post with the new author

### Styling Changes

1. **Edit** `docs/stylesheets/extra.css`
2. **Test** styling changes locally
3. **Ensure responsive design** works (check mobile/desktop)
4. **Commit changes**

## Excluded Content

- `docs/past_topics.md` is explicitly excluded from the build (see `exclude_docs` in mkdocs.yml)

## Important Notes for Agents

1. **Never modify** `.github/workflows/ci.yml` unless explicitly requested - deployment is automated and stable
2. **Always test locally** before pushing changes to main branch
3. **Blog posts must follow** the date-based directory structure: `YYYY/MM/DD/`
4. **Frontmatter is required** for all blog posts (title, date, authors)
5. **Images for blog posts** should be placed in the same directory as the post's `index.md`
6. **The site uses** Material for MkDocs theme - refer to https://squidfunk.github.io/mkdocs-material/ for advanced features
7. **Custom CSS** should be minimal and placed in `docs/stylesheets/extra.css`
8. **Navigation order** is controlled by the `nav:` section in `mkdocs.yml`
9. **The main branch** is protected - all pushes trigger automatic deployment
10. **Posts use** the blog plugin's automatic listing - no manual index needed

## Useful Commands Reference

```bash
# Development
mkdocs serve                    # Start development server
mkdocs serve -a 0.0.0.0:8000   # Start server accessible on network

# Build
mkdocs build                    # Build static site to site/ directory
mkdocs build --clean            # Clean build

# Deployment
mkdocs gh-deploy                # Deploy to GitHub Pages
mkdocs gh-deploy --force        # Force deploy (used by CI)

# Help
mkdocs -h                       # Show help

# Docker
docker compose up app           # Start development server in Docker
docker compose down             # Stop Docker containers

# Create new post
./create_post.sh                # Create post for next Tuesday (bash)
.\create_post.ps1               # Create post for next Tuesday (PowerShell)
```

## MkDocs Material Blog Plugin Details

The blog plugin is configured with:
- **Blog directory**: Root (`.`) - blog appears on homepage
- **Pagination**: 3 posts per page
- **Posts directory**: `docs/posts/`
- **Automatic post discovery**: Based on frontmatter date
- **Archive pages**: Automatically generated
- **Author integration**: Uses `docs/.authors.yml`

For more blog plugin features, see: https://squidfunk.github.io/mkdocs-material/plugins/blog/

## Troubleshooting

### Build Fails
- Check YAML syntax in frontmatter
- Verify all referenced images exist
- Check mkdocs.yml for syntax errors
- Review GitHub Actions logs

### Images Not Loading
- Verify image path is relative to the markdown file
- Check image file exists in correct location
- Ensure image filename matches reference in markdown

### Navigation Issues
- Verify file path in `mkdocs.yml` nav section matches actual file location
- Check for typos in file paths
- Ensure referenced files exist

### Styling Not Applied
- Check `extra.css` syntax
- Verify `extra_css` is configured in `mkdocs.yml`
- Clear browser cache
- Check if Material theme update changed CSS class names

## Resources

- **MkDocs Documentation**: https://www.mkdocs.org
- **Material for MkDocs**: https://squidfunk.github.io/mkdocs-material/
- **Blog Plugin**: https://squidfunk.github.io/mkdocs-material/plugins/blog/
- **GitHub Pages**: https://docs.github.com/en/pages
- **Site**: https://weeklydevchat.github.io

## Project Goals and Philosophy

This is a community-focused project for a weekly developer chat. Content should be:
- Welcoming and inclusive
- Focused on software development topics
- Clear and accessible
- Updated regularly (weekly posts for Tuesday chats)

Keep the site simple, maintainable, and focused on content over complexity.
