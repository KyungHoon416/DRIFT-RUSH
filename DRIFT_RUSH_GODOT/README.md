# DRIFT RUSH — offline prototype
Godot/GDScript native 3D project. Open project.godot and press F6/F5, then PLAY.
Target requested: Godot 4.7.2 Stable. Actual validation: 4.6.3 stable; 4.7.2 NOT verified.

Controls: A/D or arrows steer, S brake, Space drift, Shift boost when charged.
Touch buttons support steering, brake and drift. CALIBRATE samples gravity X as neutral.
Three laps through eight ordered angular checkpoints finish the practice race.
RESET restarts; PAUSE stops race simulation. Procedural meshes are generated at scene startup.

Linux sandbox: set XDG_DATA_HOME, XDG_CONFIG_HOME and XDG_CACHE_HOME to writable directories.
Run: godot --path .
Tests: godot --headless --path . --script Tests/smoke.gd

Android: install matching Godot export templates, Android SDK and JDK required by that engine; create an Android export preset in Project > Export, set package identifier, landscape orientation and VIBRATE permission. Export a debug APK and test on device. Release signing belongs in secure local settings.
iOS: use macOS, matching templates and Xcode; create an iOS export preset, set bundle/team identifiers, export and sign in Xcode. Neither mobile export has been performed here.

This is an early offline prototype, not the complete specification. See Docs/QA_REPORT.md.

UI revision: RACE NOW starts a three-second countdown. PAUSE offers resume, restart and return to lobby. HUD is hidden in lobby/results.

Driving assistance revision: open CONTROLS & SOUND from lobby or pause. Tilt steering defaults on; desktop/sensorless devices retain touch arrows and keyboard. Choose touch mode to always show arrows. Sensitivity, deadzone, inversion, vibration and SFX volume persist in user://driving_settings.cfg. Neutral posture is runtime-only and recalibrated at race start/resume. Hold the device comfortably when starting. Minimap shows the kart (cyan), next checkpoint (gold) and finish (white). WRONG WAY indicates opposite heading; checkpoint acceptance now requires on-track forward heading. This is a local practice safeguard, not authoritative anti-cheat.

Driving feedback: drift to charge, SHIFT/BOOST at full gauge; boost lasts 2.5 seconds. Results include lap splits and session best. Automatic off-track recovery preserves time and checkpoint progress. Run Tests/race_flow.gd for deterministic race integration tests; see Docs/DEVICE_TEST_CHECKLIST.md for manual checks.

Course guidance: gold road chevrons indicate forward direction; cyan CP marker indicates the next gate. ESC toggles pause. RETURN TO TRACK in pause rescues a stuck kart without resetting progress. Run all checks: `python3 Tests/run_tests.py` (set GODOT_BIN to your Godot executable if needed).
