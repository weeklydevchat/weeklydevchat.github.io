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

**Open design question:** Should the current year be a distinct hero section (different styling, more emphasis) or just the first-rendered year block (same template, top position)? This changes the template's structure — decide before step 3.

## Todos

### 1. Confirm dependency + plugin wiring
- Verify `mkdocs-macros-plugin` resolves in `requirements.txt` after regeneration.
- Decide where the YAML lives (see step 2) and confirm the `include_yaml` path in `mkdocs.yml` matches.

### 2. Create the YAML data file
- Create the data file. **Path choice:** MkDocs does NOT auto-exclude `_data/` just because of the underscore. Two options:
  - (a) Put it at `data/sponsors.yml` (outside `docs/`) and update `include_yaml` accordingly, OR
  - (b) Keep it at `docs/_data/sponsors.yml` and add `_data/` to the `exclude_docs` block in `mkdocs.yml`.
  Option (a) is cleaner — data isn't documentation.
- Structure: yearly sections containing both corporate sponsors and individual donors.
- Include existing corporate sponsors organized by year with their images and links.
- **Do not commit placeholder/sample donors.** Fake names with non-existent image files will break the build and may confuse editors who copy the pattern. Start with empty `individual: []` lists (or keep examples in a commented block at the top of the YAML for editor reference).
- Each entry: `name`, optional `image`, optional `link`, optional `link_label`, optional `description`. Make it explicit in a header comment that `image` and `link` are optional so donors can opt out of being pictured/linked.

### 3. Rewrite the sponsors page template
- Replace `docs/sponsors/index.md` with a Jinja2-templated version.
- Top section: help/sponsorship info text (kept from current page). Decide whether to keep `SaturdayMP, the main Weekly Dev Chat sponsor` hardcoded or make it data-driven via a `primary_sponsor` field in the YAML. Hardcoded is fine for now — just call out the decision.
- Iterate years newest-first with explicit sorting, not map iteration order:
  ```jinja
  {% for year in sponsors.sponsors.keys() | sort(reverse=true) %}
  ```
- For each year: corporate sponsors section, then individual donors section, both rendered from data.
- Each sponsor/donor shows: image (if present), name, and link (if present). Use Jinja conditionals so missing fields don't render broken `<img>` tags or empty links.
- Add alt text (`alt="{{ s.name }}"`) to every image — the existing page uses `![]()` with no alt, which is an accessibility gap worth fixing here.
- Style consistent with existing hosts/past-hosts pages (150px float-left images).

### 4. Privacy / consent check
- Before listing any individual by name, confirm they've opted in. Worth flagging to Chris as a launch gate.
- Document this in a comment at the top of the YAML file so future editors know the policy.

### 5. Add CSS for donor cards (if needed)
- Evaluate if existing styles in `extra.css` suffice.
- Add any additional styles for consistent donor/sponsor display.

### 6. Verify the build
- Run `docker compose run --rm mkdocs serve` (per AGENTS.md) to confirm the page renders correctly.
- Confirm the YAML data file is not rendered as its own page.
- Ensure no build errors.

## Data File Structure (Draft)

```yaml
# docs/_data/sponsors.yml  (or data/sponsors.yml — see step 2)
# Corporate sponsors and individual donors organized by year.
# Fields: name (required), image (optional), link (optional),
#         link_label (optional), description (optional).
# Policy: list individuals only with their explicit consent.
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

    individual: []

  2025:
    corporate:
      - name: Saturday Morning Productions
        image: smp.jpeg
        link: https://saturdaymp.com/
        description: Thanks to Saturday MP for providing hosting, Zoom, and more.

    individual: []
```

## Key Decisions
- **mkdocs-macros-plugin** chosen for Jinja2 templating in markdown (clean data/presentation separation).
- **Corporate sponsors** and **individual donors** stored in same YAML file, organized by year.
- **Corporate sponsors** for each year listed separately from **individual donors** on the page.
- **No placeholder donors** in committed data — start with empty lists.
- **Images** stay in `docs/sponsors/`, referenced by filename in YAML.
- **Existing help/volunteering text** at top of sponsors page is preserved.
- **Nav entry** stays the same: `Sponsors: sponsors/index.md`.
- **Years rendered newest-first** via explicit Jinja sort, not map order.
- **Optional fields** (`image`, `link`) so donors can opt out of photo/link display.

## Notes
- `logo_ZM_wordmark_bloom.png` in the sponsors dir doesn't appear to be used in the current page; leave it in place.
- If staying with `docs/_data/`, remember to add it to `exclude_docs` — the underscore prefix alone is not sufficient in MkDocs.
