#!/usr/bin/env bash
set -euo pipefail

missing=()

check_cmd() {
if ! command -v "$1" >/dev/null 2>&1; then
missing+=("command not found: $1")
fi
}

check_pkgconfig() {
if ! pkg-config --exists "$1"; then
missing+=("pkg-config: missing $1")
fi
}

# Runtime program checks
check_cmd wlroots 2>/dev/null || true
check_cmd wayland-scanner 2>/dev/null || true
check_cmd wayland-info 2>/dev/null || true
check_cmd sway 2>/dev/null || true

# Libraries (via pkg-config, best effort)
deps=(
"wlroots"
"wayland-client"
"wayland-server"
"wayland-protocols"
"wayland-cursor"
"libinput"
"libevdev"
"json-c"
"pango"
"pangocairo"
"cairo"
"gdk-pixbuf-2.0"
"pixman-1"
"libxkbcommon"
"pcre2-8"
)

for d in "${deps[@]}"; do
if ! pkg-config --exists "$d" >/dev/null 2>&1; then
missing+=("pkg-config: missing ${d}")
fi
done

# Development tools (non-destructive; just report)
for cmd in meson ninja; do
if ! command -v "$cmd" >/dev/null 2>&1; then
missing+=("command not found: $cmd (build) ")
fi
done

if [ "${#missing[@]}" -eq 0]; then
echo "All common sway dependencies appear present (best-effort check)."
exit 0
else
echo "Some dependencies are missing (non-destructive check):"
for m in "${missing[@]}"; do
echo " - $m"
done
exit 1
fi
