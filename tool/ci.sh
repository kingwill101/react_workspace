#!/usr/bin/env bash
set -euo pipefail

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
repo_root="$(cd "$script_dir/.." && pwd)"
dagger_bin="${DAGGER_BIN:-dagger}"
dagger_progress="${DAGGER_PROGRESS:-plain}"
dagger_call="${1:-all}"

if ! command -v "$dagger_bin" >/dev/null 2>&1 && [[ ! -x "$dagger_bin" ]]; then
  echo "Dagger is required. Install it or set DAGGER_BIN to its path." >&2
  exit 1
fi

staged_source="$(mktemp -d "${TMPDIR:-/tmp}/react-workspace-ci.XXXXXX")"
cleanup() {
  rm -rf "$staged_source"
}
trap cleanup EXIT

cd "$repo_root"

# Send the working copy, including non-ignored new files, without local build
# products. The package:web checkout is archived from the pinned gitlink below
# so uncommitted maintainer work in the submodule never leaks into validation.
git ls-files --cached --others --exclude-standard -z \
  | while IFS= read -r -d '' path; do
      [[ "$path" == "third_party/web" ]] && continue
      [[ -e "$path" ]] && printf '%s\0' "$path"
    done \
  | tar --null --files-from=- --create \
  | tar --directory="$staged_source" --extract

web_commit="$(git ls-files -s third_party/web | awk '{print $2}')"
if [[ -z "$web_commit" ]] || \
  ! git -C third_party/web cat-file -e "${web_commit}^{commit}" 2>/dev/null; then
  echo "The pinned third_party/web commit is unavailable. Run:" >&2
  echo "  git submodule update --init third_party/web" >&2
  exit 1
fi
mkdir -p "$staged_source/third_party/web"
git -C third_party/web archive "$web_commit" \
  | tar --directory="$staged_source/third_party/web" --extract

"$dagger_bin" \
  --mod .dagger \
  call "$dagger_call" \
  --source="$staged_source" \
  --progress="$dagger_progress"
