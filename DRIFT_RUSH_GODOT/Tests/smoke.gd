extends SceneTree
func _initialize():
 call_deferred("test")
func test():
 var race = load("res://Scenes/Race.tscn").instantiate()
 root.add_child(race)
 await process_frame
 assert(race.ui.lobby.visible and not race.ui.race_hud.visible,"Lobby hides race controls")
 race.start_race()
 assert(not race.ui.lobby.visible and race.ui.race_hud.visible,"Start switches UI")
 var before: Vector3 = race.kart.position
 for i in range(30): await physics_frame
 assert(race.kart.position==before,"Countdown prevents movement")
 race.countdown=0
 var initial: Vector3 = race.kart.position
 for i in range(120): await physics_frame
 assert(race.speed>15,"Automatic acceleration")
 assert(race.kart.position.distance_to(initial)>5,"Real 3D movement")
 race.charge=1
 race.activate_boost()
 assert(race.boost>2 and race.charge==0,"Boost consumption")
 race.paused=true
 var time: float = race.elapsed
 for i in range(10): await physics_frame
 assert(race.elapsed==time,"Pause")
 race.touch=1
 race.braking=true
 race.reset()
 assert(race.touch==0 and not race.braking,"Reset clears held inputs")
 race.return_lobby()
 assert(not race.running and race.ui.lobby.visible,"Return to lobby")
 race.ui.show_result(12.5)
 assert(race.ui.result.visible and not race.ui.race_hud.visible,"Result screen")
 assert(race.lap==1 and race.checkpoint==1,"Reset")
 var settings = preload("res://Scripts/DrivingSettings.gd").new()
 assert(not settings.calibrate(Vector3.ZERO),"Missing sensor rejected")
 assert(settings.calibrate(Vector3(1,-9,0)),"Calibration accepts gravity")
 assert(is_zero_approx(settings.tilt_value(Vector3(1,-9,0))),"Calibrated neutral")
 assert(is_zero_approx(settings.tilt_value(Vector3(1.1,-9,0))),"Deadzone suppresses jitter")
 assert(settings.tilt_value(Vector3(4,-9,0))>0,"Tilt right")
 settings.invert=true
 assert(settings.tilt_value(Vector3(4,-9,0))<0,"Invert tilt")
 settings.sensitivity=1.7
 settings.volume=0
 settings.vibration=false
 var path := "user://test_driving_settings.cfg"
 assert(settings.save_settings(path)==OK,"Settings saved")
 var restored = preload("res://Scripts/DrivingSettings.gd").new()
 restored.load_settings(path)
 assert(is_equal_approx(restored.sensitivity,1.7) and restored.invert and not restored.vibration and restored.volume==0,"Settings round trip")
 restored.tilt_enabled=false
 assert(restored.tilt_value(Vector3(4,-9,0))==0,"Touch mode disables tilt")
 DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
 race.ui.show_lobby()
 race.ui.open_settings()
 assert(race.ui.settings_panel.visible and not race.ui.lobby.visible,"Settings panel replaces lobby")
 race.ui.show_lobby()
 var projected: Vector2 = race.ui.minimap.project_point(Vector3.ZERO)
 assert(projected.is_equal_approx(race.ui.minimap.size*0.5),"Minimap projects track origin")
 print("PASS: tilt calibration, sensor fallback, deadzone, inversion, settings persistence, touch mode, settings UI, minimap")
 print("PASS: acceleration, 3D movement, boost consumption, pause, reset, lobby/race/result transitions, countdown, input clearing")
 quit()
