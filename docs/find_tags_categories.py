#!/usr/bin/env python3
"""
Lists all unique tags and categories found in YAML front matter of .md files.
Looks for both 'tags' and 'categories' keys (common variations).
"""

import os
import yaml
from pathlib import Path
from typing import Set

DOCS_DIR = Path(__file__).parent
EXTENSIONS = (".md", ".markdown", ".mkd")

def extract_frontmatter(file_path: Path) -> dict:
    """Extract YAML front matter if present."""
    content = file_path.read_text(encoding="utf-8")
    if not content.startswith("---"):
        return {}
    try:
        parts = content.split("---", 2)
        if len(parts) < 3:
            return {}
        fm = yaml.safe_load(parts[1]) or {}
        return fm if isinstance(fm, dict) else {}
    except yaml.YAMLError:
        print(f"Warning: Invalid YAML in {file_path}")
        return {}

def collect_tags() -> tuple[Set[str], Set[str]]:
    all_tags: Set[str] = set()
    all_categories: Set[str] = set()

    docs_path = Path(DOCS_DIR)
    if not docs_path.is_dir():
        print(f"Error: Directory not found: {docs_path}")
        return all_tags, all_categories

    for file_path in docs_path.rglob("*"):
        if not file_path.is_file() or not file_path.suffix.lower() in EXTENSIONS:
            continue

        fm = extract_frontmatter(file_path)

        # Handle 'tags'
        tags = fm.get("tags", [])
        if isinstance(tags, str):
            tags = [t.strip() for t in tags.split(",") if t.strip()]
        if isinstance(tags, list):
            all_tags.update(str(t).strip() for t in tags if t)

        # Handle 'categories' (sometimes used instead / in addition)
        cats = fm.get("categories", [])
        if isinstance(cats, str):
            cats = [c.strip() for c in cats.split(",") if c.strip()]
        if isinstance(cats, list):
            all_categories.update(str(c).strip() for c in cats if c)
        
        all_tags.discard('TAG_ONE')
        all_tags.discard('TAG_TWO')
        all_categories.discard('CATEGORY_ONE')
        all_categories.discard('CATEGORY_TWO')

    return all_tags, all_categories


def main():
    tags, categories = collect_tags()

    print(f"\nExisting categories: {', '.join(sorted(categories))}", )
    print(f"\nExisting tags: {', '.join(sorted(tags))}", )


if __name__ == "__main__":
    main()


