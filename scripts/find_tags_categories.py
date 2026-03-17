#!/usr/bin/env python3
"""
Lists all unique tags and categories found in YAML front matter of .md files.
Looks for both 'tags' and 'categories' keys (common variations).
"""

import yaml
from pathlib import Path

DOCS_DIR = Path(__file__).parent.parent / "docs"
EXTENSIONS = (".md", ".markdown", ".mkd")


def extract_frontmatter(file_path: Path) -> dict[str, list[str]]:
    """Extract YAML front matter if present."""
    content = file_path.read_text(encoding="utf-8")
    if not content.startswith("---"):
        return {}
    try:
        parts = content.split("---", 2)
        if len(parts) < 3:
            return {}
        fm = yaml.safe_load(parts[1])
        if not isinstance(fm, dict):
            return {}
        return fm
    except yaml.YAMLError:
        print(f"Warning: Invalid YAML in {file_path}")
        return {}


def collect_tags() -> tuple[set[str], set[str]]:
    all_tags = set()
    all_categories = set()

    docs_path = Path(DOCS_DIR)
    if not docs_path.is_dir():
        print(f"Error: Directory not found: {docs_path}")
        return all_tags, all_categories

    for file_path in docs_path.rglob("*"):
        if not file_path.is_file() or file_path.suffix.lower() not in EXTENSIONS:
            continue

        fm = extract_frontmatter(file_path)

        tags = fm.get("tags", [])
        all_tags.update(str(t).strip() for t in tags if t)

        cats = fm.get("categories", [])
        all_categories.update(str(c).strip() for c in cats if c)

    all_tags.discard('TAG_ONE')
    all_tags.discard('TAG_TWO')
    all_categories.discard('CATEGORY_ONE')
    all_categories.discard('CATEGORY_TWO')

    return all_tags, all_categories


def main() -> None:
    tags, categories = collect_tags()

    print("\nExisting categories:")
    for cat in sorted(categories):
        print(f"  {cat}")
    print(f"\nExisting tags:")
    for tag in sorted(tags):
        print(f"  {tag}")


if __name__ == "__main__":
    main()


