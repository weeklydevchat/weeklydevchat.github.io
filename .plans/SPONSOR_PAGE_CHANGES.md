# Sponsors & Donors Page — Implementation Plan

## Problem
The Weekly Dev Chat site needs a unified sponsors/donors page that lists:
- **Current year (2026) donors** prominently at the top
- **Previous year (2025) donors** in a section below
- **Corporate sponsors** organized by year (existing: Saturday MP, Dev Edmonton Society, Edmonton Unlimited)
- **Individual sponsors/donors** organized by year, separate from corporate sponsors

All data should be stored externally in a YAML file and rendered via `mkdocs-macros-plugin` so non-technical editors can manage sponsors/donors without touching markdown templates.

## Approach
Use `mkdocs-macros-plugin` to load a YAML data file and render the sponsors page using Jinja2 templates in the markdown. The existing `/sponsors/` page will be replaced with a combined sponsors + donors page.

## Todos

### 1. Add mkdocs-macros-plugin dependency
- Add `mkdocs-macros-plugin` to `requirements.in`
- Regenerate `requirements.txt`
- Add the `macros` plugin to `mkdocs.yml` plugins list with `include_yaml` pointing to the data file

### 2. Create the YAML data file
- Create `docs/_data/sponsors.yml`
- Structure: yearly sections containing both corporate sponsors and individual donors
- Include existing corporate sponsors organized by year with their images and links
- Add sample/placeholder donors for 2025 and 2026
- Each entry: name, image filename, link URL, link label, and optional description

### 3. Rewrite the sponsors page template
- Replace `docs/sponsors/index.md` with a Jinja2-templated version
- Top section: help/sponsorship info text (kept from current page)
- For each year (2026, 2025, etc.):
  - Current year donors section rendered from data
  - Corporate sponsors section rendered from data
  - Individual donors section rendered from data
- Each sponsor/donor shows: image, name, and link
- Style consistent with existing hosts/past-hosts pages (150px float-left images)

### 4. Add CSS for donor cards (if needed)
- Evaluate if existing styles in `extra.css` suffice
- Add any additional styles for consistent donor/sponsor display

### 5. Verify the build
- Run `mkdocs serve` to confirm the page renders correctly
- Ensure no build errors

## Data File Structure (Draft)

```yaml
# docs/_data/sponsors.yml
# Corporate sponsors and individual donors organized by year
sponsors:
  2026:
    corporate:
      - name: Saturday Morning Productions
        image: smp.jpeg
        link: https://saturdaymp.com/
        description: Thanks to Saturday MP for providing hosting, Zoom, and more.

      - name: Dev Edmonton Society
        image: devEd.png
        link: https://devedmonton.com/
        description: Thanks to DES for providing a Slack channel.

      - name: Edmonton Unlimited
        image: EdmontonUnlimited.jpeg
        link: https://edmontonunlimited.com/
        description: Thanks to Edmonton Unlimited for providing a Meetup Link.

    individual:
      - name: Jane Doe
        image: jane-doe.jpg
        link: https://linkedin.com/in/janedoe
      - name: John Smith
        image: john-smith.jpg
        link: https://johnsmith.dev

  2025:
    corporate:
      - name: Saturday Morning Productions
        image: smp.jpeg
        link: https://saturdaymp.com/
        description: Thanks to Saturday MP for providing hosting, Zoom, and more.

    individual:
      - name: Alice Example
        image: alice-example.jpg
        link: https://linkedin.com/in/aliceexample
```

## Key Decisions
- **mkdocs-macros-plugin** chosen for Jinja2 templating in markdown (clean data/presentation separation)
- **Corporate sponsors** and **individual donors** stored in same YAML file, organized by year
- **Corporate sponsors** for each year listed separately from **individual donors** on the page
- **Sample/placeholder donors** added for 2025 and 2026 so layout can be previewed
- **Images** stay in `docs/sponsors/`, referenced by filename in YAML
- **Existing help/volunteering text** at top of sponsors page is preserved
- **Nav entry** stays the same: `Sponsors: sponsors/index.md`

## Notes
- The `logo_ZM_wordmark_bloom.png` in the sponsors dir doesn't appear to be used in the current page; will leave it in place
- The `docs/_data/` prefix convention (underscore) prevents MkDocs from treating the data file as a documentation page
