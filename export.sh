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

VERSION=$(python3 -c "import json; print(json.load(open('${MANIFEST_FILE}', encoding='utf-8'))['versionId'])")
PACK_NAME="NAF-Minecraft-Modpack-${VERSION}"
OUT_DIR="${1:-${SCRIPT_DIR}}"

mkdir -p "${OUT_DIR}"

MRPACK_TARGET="${OUT_DIR}/${PACK_NAME}.mrpack"
ZIP_TARGET="${OUT_DIR}/${PACK_NAME}.zip"

echo "Exporting Modpack: ${PACK_NAME}"

STAGING_DIR=$(mktemp -d)
trap 'rm -rf "${STAGING_DIR}"' EXIT

cp "${MANIFEST_FILE}" "${STAGING_DIR}/modrinth.index.json"

if [ -d "${OVERRIDES_DIR}" ]; then
    cp -r "${OVERRIDES_DIR}" "${STAGING_DIR}/overrides"
fi

# Package .mrpack (standard zip archive)
(cd "${STAGING_DIR}" && zip -qr "${MRPACK_TARGET}" modrinth.index.json overrides/)
echo "  [+] Generated: ${MRPACK_TARGET}"

cp "${MRPACK_TARGET}" "${ZIP_TARGET}"
echo "  [+] Generated: ${ZIP_TARGET}"

echo -e "\nModpack export completed successfully!"
