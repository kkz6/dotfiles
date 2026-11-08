#!/usr/bin/env python3
"""Merge only the managed Terminal profile; preserve all other preferences."""
import pathlib
import plistlib
import subprocess
import sys
import tempfile
profile = pathlib.Path(sys.argv[1])
backup = pathlib.Path(sys.argv[2])
result = subprocess.run(['defaults', 'export', 'com.apple.Terminal', '-'], capture_output=True)
current = plistlib.loads(result.stdout) if result.returncode == 0 else {}
if result.returncode == 0:
    (backup / 'Terminal.plist').write_bytes(result.stdout)
current.setdefault('Window Settings', {})['Mocha'] = plistlib.loads(profile.read_bytes())
current['Default Window Settings'] = 'Mocha'
current['Startup Window Settings'] = 'Mocha'
with tempfile.TemporaryDirectory() as directory:
    merged = pathlib.Path(directory) / 'Terminal.plist'
    merged.write_bytes(plistlib.dumps(current))
    subprocess.run(['defaults', 'import', 'com.apple.Terminal', str(merged)], check=True)
print('Mocha profile configured. Quit and reopen Terminal to apply it.')
