#!/usr/bin/env python3
"""
Lists all unique tags and categories found in YAML front matter of .md files.
Looks for both 'tags' and 'categories' keys (common variations).
"""

from pathlib import Path
from typing import Set

DOCS_DIR = Path(__file__).parent.parent / "docs"
EXTENSIONS = (".md", ".markdown", ".mkd")

def extract_frontmatter(file_path: Path) -> dict:
    """Extract tags and categories from YAML front matter using string parsing."""
    content = file_path.read_text(encoding="utf-8")
    if not content.startswith("---"):
        return {}
    parts = content.split("---", 2)
    if len(parts) < 3:
        return {}
    result: dict[str, list[str]] = {"tags": [], "categories": []}
    current_key = None
    for line in parts[1].splitlines():
        stripped = line.strip()
        if stripped in ("tags:", "categories:"):
            current_key = stripped[:-1]
        elif current_key and stripped.startswith("- "):
            result[current_key].append(stripped[2:].strip())
        else:
            current_key = None
    return result

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
        all_tags.update(str(t).strip() for t in tags if t)

        # Handle 'categories' (sometimes used instead / in addition)
        cats = fm.get("categories", [])
        all_categories.update(str(c).strip() for c in cats if c)

    all_tags.discard('TAG_ONE')
    all_tags.discard('TAG_TWO')
    all_categories.discard('CATEGORY_ONE')
    all_categories.discard('CATEGORY_TWO')

    return all_tags, all_categories


def main():
    tags, categories = collect_tags()

    print("\nExisting categories:")
    for cat in sorted(categories):
        print(f"  {cat}")
    print(f"\nExisting tags:")
    for tag in sorted(tags):
        print(f"  {tag}")


if __name__ == "__main__":
    main()


