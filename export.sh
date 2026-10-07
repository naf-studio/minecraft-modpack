#!/bin/bash
# ==============================================================================
# Script Name: export.sh
# Description: Exports NAF Minecraft Modpack to standard .mrpack and .zip formats.
# Usage:
#   ./export.sh [output_directory]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_FILE="${SCRIPT_DIR}/modrinth.index.json"
OVERRIDES_DIR="${SCRIPT_DIR}/overrides"

if [ ! -f "${MANIFEST_FILE}" ]; then
    echo "ERROR: modrinth.index.json not found in ${SCRIPT_DIR}" >&2
    exit 1
fi

OUT_DIR="${1:-${SCRIPT_DIR}}"
mkdir -p "${OUT_DIR}"
OUT_DIR="$(cd "${OUT_DIR}" && pwd)"

VERSION=$(python3 -c "import json; print(json.load(open('${MANIFEST_FILE}', encoding='utf-8'))['versionId'])")
PACK_NAME="NAF-Minecraft-Modpack-${VERSION}"
MRPACK_TARGET="${OUT_DIR}/${PACK_NAME}.mrpack"
ZIP_TARGET="${OUT_DIR}/${PACK_NAME}.zip"

echo "Exporting Modpack: ${PACK_NAME}"

python3 -c "
import os, shutil, zipfile

manifest = '${MANIFEST_FILE}'
overrides = '${OVERRIDES_DIR}'
mrpack_out = '${MRPACK_TARGET}'
zip_out = '${ZIP_TARGET}'

if os.path.exists(mrpack_out):
    os.remove(mrpack_out)
if os.path.exists(zip_out):
    os.remove(zip_out)

with zipfile.ZipFile(mrpack_out, 'w', zipfile.ZIP_DEFLATED) as zf:
    zf.write(manifest, 'modrinth.index.json')
    if os.path.isdir(overrides):
        for root, dirs, files in os.walk(overrides):
            for f in files:
                full_path = os.path.join(root, f)
                rel_path = os.path.relpath(full_path, os.path.dirname(overrides))
                zf.write(full_path, rel_path)

shutil.copyfile(mrpack_out, zip_out)
print(f'  [+] Generated: {mrpack_out}')
print(f'  [+] Generated: {zip_out}')
"

echo -e "\nModpack export completed successfully!"
