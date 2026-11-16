# Manual test checklist — driving feedback
Mac / Godot 4.6.3:
1. RACE NOW, wait for countdown. Hold A/D + SPACE above 36 km/h: kart leans, sparks appear, boost fills.
2. At BOOST READY press SHIFT: cyan exhaust and wider view appear, boost sound plays; after 2.5 seconds effects stop.
3. Pause while boosting: time and boost freeze; resume continues. Volume 0 must mute collision and boost sounds.
4. Complete three forward laps: result has three lap durations, total and best. Total equals sum (rounding can differ by 0.01 s).
5. Restart: no previous race lap times remain. If stuck, restart currently remains available; automatic recovery triggers outside road bounds or on falling.

Physical iPhone/Android (not verified):
- Landscape: hold comfortable neutral posture at start, tilt left/right. If reversed, toggle inversion. Check 0.5/1/2 sensitivity and deadzone.
- Hold DRIFT while tilting, then BOOST. No unintended touch steering in tilt mode.
- Hit guardrail with vibration on/off; confirm sound volume control. iOS haptic support may require native integration.
- Switch away and back: game pauses, resume re-centers sensor; no stuck brake/drift.
- Check controls fit device safe area and note FPS/heat. Send device model, OS, screenshot/video, expected vs actual behavior.

## Course guidance revision
Course guidance update: follow gold road arrows; confirm next CP label is cyan and changes after passing. ESC pauses/resumes outside settings. Try PAUSE > RETURN TO TRACK after hitting a wall; race time/checkpoints must remain. Check the expanded pause menu fits on your screen.

## Frontend UI/UX revision
Frontend: PLAY → SELECT TRACK → START RACE; BACK returns to previous page. GARAGE: choose each color, rotate both directions, return and start race; selected color must appear on the kart and survive restart. HOW TO DRIVE: sensor unavailable on desktop is expected; phone tilt should move the bar after calibration. Check text/buttons fit in 4.7.2 and report any parser errors verbatim. Friends/item race/Neon City must remain disabled.
