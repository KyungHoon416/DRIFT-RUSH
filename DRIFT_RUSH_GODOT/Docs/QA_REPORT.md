# QA
PASS on Godot 4.6.3 headless: scene construction, actual physics displacement, automatic acceleration, boost charge consumption, pause timer freeze, reset. See test.log.
NOT VERIFIED: visual rendering inspection, keyboard interaction by human, full three-lap completion, reverse-driving abuse, collision feedback on device, multi-touch, tilt axes, sensor calibration across lifecycle, FPS, Android/iOS export, Godot 4.7.2.
Implemented but not separately asserted: keyboard and touch steering, drift charging, guardrail collision slowdown, synthesized collision sound, handheld vibration call, eight sequential checkpoints and three-lap result.
Known limitations: circular flat track; primitive art; fixed virtual HUD layout; no safe-area adaptation, minimap, settings persistence, best lap, camera obstruction, AI/opponent vehicles, full garage/lobby flow. Single script architecture requires extraction into systems for further development. No items, LAN or online multiplayer.

## UI revision validation
PASS: lobby hides HUD, race transition, countdown blocks motion, reset clears touch/brake, return to lobby, result visibility, plus existing physics tests. HUD now uses anchored bottom/top-right controls; lobby/pause/result panels still target 1280x720 virtual canvas. Safe-area handling and rendered visual inspection remain unverified. Prior single-script/no-lobby limitation superseded by RaceUI separation.

## Driving assistance QA
PASS on 4.6.3 headless: simulated gravity calibration, missing-sensor fallback, deadzone, inversion, touch mode suppresses tilt, config save/load round trip, settings/lobby visibility, minimap projection, all previous smoke cases. NOT VERIFIED: actual device tilt axes/vibration, rendered minimap and settings layout, full race/manual reverse-driving. Added persistence and minimap supersede those earlier limitations. Settings save failure keeps the panel open and reports an error.

## Driving feedback revision
PASS: 24 ordered checkpoint visits injected through physics loop produce three laps and results; splits sum to total, session best is minimum. Recovery preserves time/checkpoint. Boost visible state, pause freeze, expiry and reset pass. This is deterministic integration coverage, not a human-driven three-lap or rendered-effects test. Visual quality, audio listening, CPU particle mobile performance and device input remain unverified. See DEVICE_TEST_CHECKLIST.md.

## Course guidance revision
PASS: keyboard D steering, Space drift/gauge/lean/sparks, S braking, Shift boost; manual rescue resumes without altering clock/checkpoint; next gate highlighting. All three suites run through Tests/run_tests.py with timeout, exit status and script-error checks. Rendered signs, arrow visibility and Escape UI interaction still require manual viewing; tests do not establish mobile graphics or sensor readiness.

## Frontend UI/UX revision
PASS in Godot 4.6.3 headless: all four suites including exclusive frontend navigation, available/locked modes, 1280x720 button geometry, garage orbit activation, real material recoloring, paint persistence and race/HUD transition. No display server is available in this runtime, so rendered visuals and readability are NOT verified. Godot 4.7.2 is user-reported on Mac, not independently tested here. Device safe areas, different aspect ratios, real sensors and mobile exports remain unverified.
