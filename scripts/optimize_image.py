#!/usr/bin/env python3
"""
Optimize images for the Weekly Dev Chat website.

Converts images to WebP format, resizes to a max width, and reports savings.
The original file is preserved; the optimized WebP is written alongside it.

Usage:
    python scripts/optimize_image.py image1.png image2.jpg
    python scripts/optimize_image.py --quality 85 --max-width 1600 image.png
"""

import argparse
import sys

if sys.version_info < (3, 14):
    print(
        f"Error: Python 3.14 or later is required (running {sys.version}).",
        file=sys.stderr,
    )
    sys.exit(1)

from pathlib import Path

try:
    from PIL import Image, ImageOps
except ImportError:
    print(
        "Error: Pillow is not installed.\n"
        "Install dev dependencies with:\n"
        "  pip install -r requirements-dev.txt\n"
        "Or install Pillow directly:\n"
        "  pip install Pillow",
        file=sys.stderr,
    )
    sys.exit(1)

SUPPORTED_EXTENSIONS = {".png", ".jpg", ".jpeg", ".gif", ".bmp", ".tiff", ".tif"}


def _quality_int(value: str) -> int:
    """Argparse type for --quality: integer in range 1–100."""
    v = int(value)
    if not (1 <= v <= 100):
        raise argparse.ArgumentTypeError(f"quality must be between 1 and 100 (got {v})")
    return v


def _positive_int(value: str) -> int:
    """Argparse type for --max-width: integer greater than 0."""
    v = int(value)
    if v <= 0:
        raise argparse.ArgumentTypeError(f"max-width must be greater than 0 (got {v})")
    return v


def optimize_image(input_path: Path, *, quality: int, max_width: int) -> Path | None:
    """Optimize a single image. Returns the output path, or None on error."""
    if input_path.suffix.lower() not in SUPPORTED_EXTENSIONS:
        print(f"  Skipping {input_path.name}: unsupported format")
        return None

    try:
        img = Image.open(input_path)
    except Exception as e:
        print(f"  Error opening {input_path.name}: {e}", file=sys.stderr)
        return None

    # Apply EXIF orientation so JPEGs rotated via metadata are correctly oriented
    img = ImageOps.exif_transpose(img)

    # Convert palette/RGBA images appropriately for WebP
    if img.mode in ("P", "PA"):
        img = img.convert("RGBA")
    elif img.mode not in ("RGB", "RGBA"):
        img = img.convert("RGB")

    # Resize if wider than max_width, preserving aspect ratio
    if img.width > max_width:
        ratio = max_width / img.width
        new_height = round(img.height * ratio)
        img = img.resize((max_width, new_height), Image.LANCZOS)

    output_path = input_path.with_suffix(".webp")
    img.save(output_path, "WEBP", quality=quality)

    original_size = input_path.stat().st_size
    optimized_size = output_path.stat().st_size
    change_pct = (optimized_size / original_size - 1) * 100 if original_size > 0 else 0

    print(f"  {input_path.name}")
    print(f"    {original_size:,} bytes → {optimized_size:,} bytes ({change_pct:+.1f}%)")
    print(f"    Saved to {output_path.name} ({img.width}x{img.height})")

    return output_path


def main() -> None:
    parser = argparse.ArgumentParser(
        description="Optimize images for the Weekly Dev Chat website.",
    )
    parser.add_argument(
        "images",
        nargs="+",
        type=Path,
        help="One or more image file paths to optimize.",
    )
    parser.add_argument(
        "--quality",
        type=_quality_int,
        default=80,
        help="WebP quality (1-100, default: 80).",
    )
    parser.add_argument(
        "--max-width",
        type=_positive_int,
        default=1200,
        help="Max image width in pixels (default: 1200). Images smaller than this are not upscaled.",
    )
    args = parser.parse_args()

    successes = 0
    failures = 0

    for image_path in args.images:
        if not image_path.is_file():
            print(f"  Warning: {image_path} not found, skipping.", file=sys.stderr)
            failures += 1
            continue

        result = optimize_image(image_path, quality=args.quality, max_width=args.max_width)
        if result:
            successes += 1
        else:
            failures += 1

    print(f"\nDone: {successes} optimized, {failures} skipped/failed.")
    sys.exit(1 if failures > 0 and successes == 0 else 0)


if __name__ == "__main__":
    main()
