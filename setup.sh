#!/bin/bash
# ==============================================================================
# Script Name: setup.sh
# Description: Downloads all mods and resource packs declared in modrinth.index.json
#              into .minecraft/ directory for local developer testing.
# Usage:
#   ./setup.sh [target_directory]
# ==============================================================================

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MANIFEST_FILE="${SCRIPT_DIR}/modrinth.index.json"
OVERRIDES_DIR="${SCRIPT_DIR}/overrides"
TARGET_DIR="${1:-${SCRIPT_DIR}/.minecraft}"

if [ ! -f "${MANIFEST_FILE}" ]; then
    echo "ERROR: modrinth.index.json not found in ${SCRIPT_DIR}" >&2
    exit 1
fi

mkdir -p "${TARGET_DIR}"

if [ -d "${OVERRIDES_DIR}" ]; then
    echo "Syncing overrides into ${TARGET_DIR}..."
    cp -r "${OVERRIDES_DIR}/"* "${TARGET_DIR}/"
fi

python3 -c "
import json, os, sys, urllib.request

manifest_path = '${MANIFEST_FILE}'
target_dir = '${TARGET_DIR}'

with open(manifest_path, 'r', encoding='utf-8') as f:
    manifest = json.load(f)

files = manifest.get('files', [])
total = len(files)
print(f'Downloading {total} declared modpack assets into {target_dir}...')

for idx, item in enumerate(files, 1):
    rel_path = item.get('path')
    downloads = item.get('downloads', [])
    if not downloads:
        continue
    url = downloads[0]
    dest = os.path.join(target_dir, rel_path)
    os.makedirs(os.path.dirname(dest), exist_ok=True)

    if os.path.isfile(dest):
        print(f'  [{idx}/{total}] [OK] {rel_path} already exists.')
        continue

    print(f'  [{idx}/{total}] -> Downloading {rel_path}...')
    tmp = dest + '.tmp'
    try:
        req = urllib.request.Request(url, headers={'User-Agent': 'NAF-Modpack-Setup/1.0'})
        with urllib.request.urlopen(req) as resp, open(tmp, 'wb') as out_f:
            while chunk := resp.read(65536):
                out_f.write(chunk)
        os.replace(tmp, dest)
        print(f'  [{idx}/{total}] [+] {rel_path} downloaded.')
    except Exception as e:
        print(f'  [{idx}/{total}] [ERROR] Failed to download {rel_path}: {e}', file=sys.stderr)
        if os.path.isfile(tmp):
            os.remove(tmp)

print('\nSetup complete!')
"
