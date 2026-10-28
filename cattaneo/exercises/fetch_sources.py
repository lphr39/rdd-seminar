"""Fetch or verify the pinned third-party files in sources.lock.json.

Existing files must pass SHA-256 verification. The manifest chooses the data
and cache locations. No global Stata installation changes. Standard library only.
"""
from pathlib import Path
import argparse
import hashlib
import json
import urllib.request

ROOT = Path(__file__).resolve().parent


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--check', action='store_true', help='verify cache offline')
    args = parser.parse_args()
    manifest = json.loads((ROOT / 'sources.lock.json').read_text(encoding='utf-8'))
    for entry in manifest['files']:
        target = ROOT / entry['path']
        if target.is_file():
            content = target.read_bytes()
        elif args.check:
            raise FileNotFoundError(target)
        else:
            print('Downloading', entry['path'], flush=True)
            request = urllib.request.Request(entry['url'], headers={'User-Agent': 'rdd-seminar'})
            with urllib.request.urlopen(request, timeout=90) as response:
                content = response.read()
        digest = hashlib.sha256(content).hexdigest()
        if digest != entry['sha256']:
            raise ValueError(f"Checksum mismatch: {target}. Preserve and inspect this file before replacing it.")
        if not target.exists():
            target.parent.mkdir(parents=True, exist_ok=True)
            target.write_bytes(content)
    print(f"Verified {len(manifest['files'])} pinned source/package files.")


if __name__ == '__main__':
    main()
