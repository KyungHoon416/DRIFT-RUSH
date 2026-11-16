"""Run headless Godot tests with timeouts and detect assertion/script failures."""
import os
import pathlib
import subprocess
import sys

root = pathlib.Path(__file__).resolve().parents[1]
engine = os.environ.get("GODOT_BIN", "godot")
for name in ("smoke", "race_flow", "keyboard"):
    try:
        result = subprocess.run(
            [engine, "--headless", "--path", str(root), "--script", f"Tests/{name}.gd"],
            capture_output=True, text=True, timeout=30,
        )
    except (OSError, subprocess.TimeoutExpired) as error:
        print(f"FAIL {name}: {error}")
        sys.exit(1)
    output = result.stdout + result.stderr
    print(output, end="")
    if result.returncode or "ERROR:" in output or "PASS:" not in output:
        sys.exit(1)
print("ALL 3 SUITES PASSED")
