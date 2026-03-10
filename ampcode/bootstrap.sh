#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG_FILE="${SCRIPT_DIR}/skills.json"
TARGET_DIR="${1:-.}"
SKILLS_DIR="${TARGET_DIR}/.agents/skills"

if ! command -v jq &>/dev/null; then
  echo "Error: jq is required but not installed." >&2
  exit 1
fi

if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "Error: Config file not found: ${CONFIG_FILE}" >&2
  exit 1
fi

TMPDIR_BASE="$(mktemp -d)"
trap 'rm -rf "$TMPDIR_BASE"' EXIT

repo_count=$(jq '.repos | length' "$CONFIG_FILE")

for ((i = 0; i < repo_count; i++)); do
  url=$(jq -r ".repos[$i].url" "$CONFIG_FILE")
  branch=$(jq -r ".repos[$i].branch // \"main\"" "$CONFIG_FILE")
  skills_path=$(jq -r ".repos[$i].skills_path // \".agents/skills\"" "$CONFIG_FILE")

  echo "Fetching skills from ${url} (branch: ${branch})..."

  clone_dir="${TMPDIR_BASE}/repo-${i}"
  git clone --depth 1 --branch "$branch" --filter=blob:none --sparse "$url" "$clone_dir" 2>/dev/null

  skill_count=$(jq ".repos[$i].skills | length" "$CONFIG_FILE")
  sparse_paths=()
  for ((j = 0; j < skill_count; j++)); do
    skill=$(jq -r ".repos[$i].skills[$j]" "$CONFIG_FILE")
    sparse_paths+=("${skills_path}/${skill}")
  done

  (cd "$clone_dir" && git sparse-checkout set "${sparse_paths[@]}" 2>/dev/null)

  mkdir -p "$SKILLS_DIR"

  for ((j = 0; j < skill_count; j++)); do
    skill=$(jq -r ".repos[$i].skills[$j]" "$CONFIG_FILE")
    src="${clone_dir}/${skills_path}/${skill}"
    dest="${SKILLS_DIR}/${skill}"

    if [[ -d "$src" ]]; then
      rm -rf "$dest"
      cp -R "$src" "$dest"
      echo "  ✓ ${skill}"
    else
      echo "  ✗ ${skill} (not found in repo)" >&2
    fi
  done
done

echo ""
echo "Skills installed to ${SKILLS_DIR}"
