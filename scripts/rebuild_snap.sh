#!/usr/bin/env bash
set -euo pipefail

SNAP_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SNAP_NAME="scrcpy-buddy"

echo "==> Working directory: $SNAP_DIR"
cd "$SNAP_DIR"

# 1. Remove installed snaps
echo ""
echo "==> [1/5] Removing installed snaps..."
sudo snap remove --purge "$SNAP_NAME" || true
sudo snap remove --purge scrcpy-runtime-2404 || true

# 2. Clean snapcraft build artifacts
echo ""
echo "==> [2/5] Cleaning snapcraft build..."
snapcraft clean --use-lxd

# 3. Build the snap
echo ""
echo "==> [3/5] Building snap with LXD..."
snapcraft pack --use-lxd

# 4. Install the freshly built snap
SNAP_FILE=$(ls -t "${SNAP_DIR}"/*.snap | head -1)
echo ""
echo "==> [4/5] Installing snap: $SNAP_FILE"
sudo snap install --dangerous "$SNAP_FILE"

# 5. Connect interfaces
echo ""
echo "==> [5/5] Connecting snap interfaces..."
sudo snap disconnect "$SNAP_NAME:gnome-46-2404" || true
sudo snap connect "$SNAP_NAME:gnome-46-2404" gnome-46-2404:gnome-46-2404
sudo snap connect "$SNAP_NAME:scrcpy-runtime-2404" scrcpy-runtime-2404:scrcpy-runtime-2404

echo ""
echo "==> Done! You can now launch: snap run $SNAP_NAME"
