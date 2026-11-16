# QA
PASS on Godot 4.6.3 headless: scene construction, actual physics displacement, automatic acceleration, boost charge consumption, pause timer freeze, reset. See test.log.
NOT VERIFIED: visual rendering inspection, keyboard interaction by human, full three-lap completion, reverse-driving abuse, collision feedback on device, multi-touch, tilt axes, sensor calibration across lifecycle, FPS, Android/iOS export, Godot 4.7.2.
Implemented but not separately asserted: keyboard and touch steering, drift charging, guardrail collision slowdown, synthesized collision sound, handheld vibration call, eight sequential checkpoints and three-lap result.
Known limitations: circular flat track; primitive art; fixed virtual HUD layout; no safe-area adaptation, minimap, settings persistence, best lap, camera obstruction, AI/opponent vehicles, full garage/lobby flow. Single script architecture requires extraction into systems for further development. No items, LAN or online multiplayer.

## UI revision validation
PASS: lobby hides HUD, race transition, countdown blocks motion, reset clears touch/brake, return to lobby, result visibility, plus existing physics tests. HUD now uses anchored bottom/top-right controls; lobby/pause/result panels still target 1280x720 virtual canvas. Safe-area handling and rendered visual inspection remain unverified. Prior single-script/no-lobby limitation superseded by RaceUI separation.
