#!/usr/bin/env bash
#
# Compress every supported image under docs/ to WebP, rewrite references to the
# new filename across docs/ and mkdocs.yml, and remove the original file.
#
# Safe to re-run: images whose .webp sibling already exists are skipped.
#
# Usage:
#   scripts/optimize_all_images.sh            # convert everything under docs/
#   scripts/optimize_all_images.sh --dry-run  # show what would happen, no changes

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$REPO_ROOT"

SCAN_DIR="docs"
REFERENCE_ROOTS=("docs" "mkdocs.yml")

# Portable byte size lookup (BSD stat on macOS, GNU stat on Linux, wc -c fallback).
# Always emits only digits so it is safe to use in arithmetic contexts.
filesize() {
    local sz
    # Try BSD stat (macOS), then GNU stat (Linux), then wc -c. Each is tried
    # independently so stdout from a partially-failing earlier call cannot be
    # concatenated with the next. Only a clean digits-only result is returned.
    if sz=$(stat -f %z "$1" 2>/dev/null) && [[ $sz =~ ^[0-9]+$ ]]; then
        printf '%s' "$sz"; return
    fi
    if sz=$(stat -c %s "$1" 2>/dev/null) && [[ $sz =~ ^[0-9]+$ ]]; then
        printf '%s' "$sz"; return
    fi
    sz=$({ wc -c <"$1" | tr -dc '0-9'; } 2>/dev/null)
    [[ -n $sz ]] && printf '%s' "$sz" || printf '0'
}

# Format a byte count as a human-readable string (e.g. "1.23 MB").
human_bytes() {
    awk -v b="$1" 'BEGIN {
        split("B KB MB GB TB", u)
        i = 1
        while (b >= 1024 && i < 5) { b /= 1024; i++ }
        if (i == 1) printf "%d %s", b, u[i]
        else        printf "%.2f %s", b, u[i]
    }'
}

DRY_RUN=0
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=1
    echo "DRY RUN — no files will be changed"
    echo
fi

# Collect every candidate image (null-delimited so names with spaces survive).
IMAGES=()
while IFS= read -r -d '' path; do
    IMAGES+=("$path")
done < <(find "$SCAN_DIR" -type f \( \
    -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' \
    -o -iname '*.gif' -o -iname '*.bmp' -o -iname '*.tiff' -o -iname '*.tif' \
    \) -print0)

total=${#IMAGES[@]}
if [[ $total -eq 0 ]]; then
    echo "No images found under $SCAN_DIR"
    exit 0
fi

echo "Found $total image(s) under $SCAN_DIR"
echo

converted=0
skipped=0
failed=0
index=0
total_original_bytes=0
total_webp_bytes=0

for image in "${IMAGES[@]}"; do
    index=$((index + 1))
    dir="$(dirname "$image")"
    base="$(basename "$image")"
    stem="${base%.*}"
    webp_base="$stem.webp"
    webp_path="$dir/$webp_base"

    echo "[$index/$total] $image"

    if [[ -e "$webp_path" ]]; then
        echo "  skip: $webp_path already exists"
        skipped=$((skipped + 1))
        echo
        continue
    fi

    if [[ $DRY_RUN -eq 1 ]]; then
        echo "  would convert → $webp_path"
        echo "  would rewrite references: $base → $webp_base"
        echo "  would remove: $image"
        converted=$((converted + 1))
        echo
        continue
    fi

    if ! python3 scripts/optimize_image.py "$image"; then
        echo "  FAILED: optimize_image.py exited non-zero, leaving original in place"
        failed=$((failed + 1))
        echo
        continue
    fi

    if [[ ! -f "$webp_path" ]]; then
        echo "  FAILED: expected $webp_path was not produced, leaving original in place"
        failed=$((failed + 1))
        echo
        continue
    fi

    orig_bytes=$(filesize "$image")
    new_bytes=$(filesize "$webp_path")
    orig_bytes=${orig_bytes:-0}
    new_bytes=${new_bytes:-0}
    # 10# forces base-10 so a leading zero is never parsed as octal.
    total_original_bytes=$((total_original_bytes + 10#$orig_bytes))
    total_webp_bytes=$((total_webp_bytes + 10#$new_bytes))
    pct=$(awk -v o="$orig_bytes" -v n="$new_bytes" 'BEGIN {
        if (o == 0) { printf "0.0"; exit }
        printf "%+.1f", (n/o - 1) * 100
    }')
    echo "  size: $(human_bytes "$orig_bytes") → $(human_bytes "$new_bytes") (${pct}%)"

    # Rewrite references by basename across docs/ and mkdocs.yml.
    # Filename is passed via env so shell/regex specials in the name are safe;
    # \Q...\E makes perl treat the old name as a literal string, and the
    # lookbehind/lookahead prevents matches inside other filenames (e.g. we
    # must not rewrite "a.png" when it appears inside "aa.png" or "a.png.bak").
    ref_count=0
    while IFS= read -r -d '' refpath; do
        OLD_NAME="$base" NEW_NAME="$webp_base" perl -i -pe '
            s/(?<![A-Za-z0-9_.\-])\Q$ENV{OLD_NAME}\E(?![A-Za-z0-9_.\-])/$ENV{NEW_NAME}/g
        ' "$refpath"
        ref_count=$((ref_count + 1))
    done < <(grep -rlI --null --fixed-strings -- "$base" "${REFERENCE_ROOTS[@]}" 2>/dev/null || true)

    rm -- "$image"

    if [[ $ref_count -gt 0 ]]; then
        echo "  updated $ref_count file(s) referencing $base"
    else
        echo "  no references to $base found"
    fi
    echo "  removed original"
    converted=$((converted + 1))
    echo
done

echo "Summary: $converted converted, $skipped skipped, $failed failed"
if [[ $converted -gt 0 && $DRY_RUN -eq 0 ]]; then
    saved_bytes=$((total_original_bytes - total_webp_bytes))
    total_pct=$(awk -v o="$total_original_bytes" -v n="$total_webp_bytes" 'BEGIN {
        if (o == 0) { printf "0.0"; exit }
        printf "%+.1f", (n/o - 1) * 100
    }')
    echo "Total size: $(human_bytes "$total_original_bytes") → $(human_bytes "$total_webp_bytes") (${total_pct}%)"
    echo "Saved: $(human_bytes "$saved_bytes")"
fi
[[ $failed -eq 0 ]]
