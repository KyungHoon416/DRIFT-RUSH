extends SceneTree
func _initialize():
 call_deferred("test")
func test():
 var race = load("res://Scenes/Race.tscn").instantiate()
 root.add_child(race)
 await process_frame
 race.running=true
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
 race.reset()
 assert(race.lap==1 and race.checkpoint==1,"Reset")
 print("PASS: acceleration, 3D movement, boost consumption, pause, reset")
 quit()
