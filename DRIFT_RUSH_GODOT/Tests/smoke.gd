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
 print("PASS: acceleration, 3D movement, boost consumption, pause, reset, lobby/race/result transitions, countdown, input clearing")
 quit()
