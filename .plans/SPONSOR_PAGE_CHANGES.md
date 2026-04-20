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

### 1. Confirm dependency + plugin wiring ✅
- Verified `mkdocs-macros-plugin` is in `requirements.txt`.
- Decided on option (a): YAML lives at `data/sponsors.yml` (outside `docs/`). `include_yaml` in `mkdocs.yml` is already wired to `sponsors: data/sponsors.yml`. `data/` directory exists (empty).

### 2. Create the YAML data file ✅
- Created `data/sponsors.yml` using option (a) — data file outside `docs/`.
- Header comment documents required/optional fields and the consent policy, with an example entry kept commented out for editor reference.
- **Deduplicated structure:** sponsor details live once in a top-level `sponsors` map keyed by ID. Year entries under `years:` reference sponsors by ID only, so a sponsor returning across multiple years appears exactly once in the source.
- 2026 and 2025 corporate entries populated from the existing sponsors page. `individual: []` empty lists in both years — no placeholder donors committed.

### 3. Rewrite the sponsors page template ✅
- Replaced `docs/sponsors/index.md` with a Jinja2-templated version that preserves the top help/sponsorship text (SaturdayMP kept hardcoded).
- Years iterated newest-first via `sponsors.years.keys() | sort(reverse=true)`.
- For each year: Corporate Sponsors section; Individual Donors section rendered only when the list is non-empty. IDs are looked up in the top-level `sponsors` map; unknown IDs render a visible `> **WARNING:** ...` blockquote so typos fail loudly.
- Image, name, and link are each rendered behind a Jinja conditional — missing optional fields don't produce broken tags or empty links.
- Alt text added to every image. 150px float-left style matches the hosts/past-hosts pages, with a `<div style="clear: both;">` after each entry so floats don't collide.

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
# data/sponsors.yml
# Sponsor details are defined once under `sponsors:` and referenced by ID
# in each year under `years:`. This avoids duplicating a sponsor's record
# when they return across multiple years — update their info in one place.
#
# Sponsor fields: name (required), image (optional), link (optional),
#                 link_label (optional), description (optional).
# Policy: list individuals only with their explicit consent.

sponsors:
  saturday-mp:
    name: Saturday Morning Productions
    image: smp.jpeg
    link: https://saturdaymp.com/
    description: Thanks to Saturday MP for providing hosting, Zoom, and more.

  dev-edmonton:
    name: Dev Edmonton Society
    image: devEd.png
    link: https://devedmonton.com/
    description: Thanks to DES for providing a Slack channel.

  edmonton-unlimited:
    name: Edmonton Unlimited
    image: EdmontonUnlimited.jpeg
    link: https://edmontonunlimited.com/
    description: Thanks to Edmonton Unlimited for providing a Meetup Link.

years:
  2026:
    corporate:
      - saturday-mp
      - dev-edmonton
      - edmonton-unlimited
    individual: []

  2025:
    corporate:
      - saturday-mp
    individual: []
```

Example template lookup:
```jinja
{% for id in sponsors.years[year].corporate %}
  {% set s = sponsors.sponsors[id] %}
  ...
{% endfor %}
```

## Key Decisions
- **mkdocs-macros-plugin** chosen for Jinja2 templating in markdown (clean data/presentation separation).
- **Corporate sponsors** and **individual donors** stored in same YAML file, organized by year.
- **Corporate sponsors** for each year listed separately from **individual donors** on the page.
- **Sponsor records deduplicated**: defined once under `sponsors:` by ID, referenced by ID from each year under `years:`. A returning sponsor is updated in one place.
- **No placeholder donors** in committed data — start with empty lists.
- **Images** stay in `docs/sponsors/`, referenced by filename in YAML.
- **Existing help/volunteering text** at top of sponsors page is preserved.
- **Nav entry** stays the same: `Sponsors: sponsors/index.md`.
- **Years rendered newest-first** via explicit Jinja sort, not map order.
- **Optional fields** (`image`, `link`) so donors can opt out of photo/link display.

## Notes
- `logo_ZM_wordmark_bloom.png` in the sponsors dir doesn't appear to be used in the current page; leave it in place.
- If staying with `docs/_data/`, remember to add it to `exclude_docs` — the underscore prefix alone is not sufficient in MkDocs.
