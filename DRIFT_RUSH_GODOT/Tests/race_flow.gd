extends SceneTree
func _initialize():
 call_deferred("test")
func test():
 var race = load("res://Scenes/Race.tscn").instantiate()
 root.add_child(race)
 await process_frame
 race.start_race()
 race.countdown=0
 # Exercise the real physics-loop checkpoint logic, injecting positions at gates.
 for lap_index in range(3):
  for gate in range(1,9):
   var a := gate*TAU/8.0
   race.kart.position=Vector3(sin(a)*race.RADIUS,0.6,cos(a)*race.RADIUS)
   race.kart.rotation.y=a-PI/2
   race.kart.velocity=Vector3.ZERO
   race.speed=12
   await physics_frame
   await physics_frame
 assert(race.lap_times.size()==3,"Three ordered laps recorded")
 assert(not race.running and race.ui.result.visible,"Finish stops race and opens result")
 var total := 0.0
 for value in race.lap_times:
  assert(value>0,"Positive lap duration")
  total+=value
 assert(is_equal_approx(total,race.elapsed),"Lap sum equals race total")
 assert(is_equal_approx(race.best_lap,race.lap_times.min()),"Best lap computed")
 race.start_race()
 race.countdown=0
 race.elapsed=32
 race.checkpoint=4
 race.safe_angle=PI/2
 race.kart.position=Vector3(160,-5,0)
 await physics_frame
 await physics_frame
 assert(race.kart.position.distance_to(Vector3(65,0.6,0))<1,"Recovery returns to safe location")
 assert(race.elapsed>=32 and race.checkpoint==4,"Recovery preserves timer and progress")
 race.charge=1
 race.activate_boost()
 await physics_frame
 await physics_frame
 assert(race.flames[0].visible,"Boost effect enabled")
 race.toggle_pause()
 var remaining: float = race.boost
 for i in range(5): await physics_frame
 assert(is_equal_approx(race.boost,remaining) and not race.flames[0].visible,"Pause freezes boost and hides effect")
 race.toggle_pause()
 for i in range(165): await physics_frame
 assert(race.boost==0 and not race.flames[0].visible,"Boost expires and effect stops")
 race.return_lobby()
 assert(race.lap_times.is_empty() and race.best_lap==0,"New race resets lap stats")
 print("PASS: 3 ordered laps, results, lap sum/best, recovery, preserved progress, boost effects/pause/expiry, reset")
 race.queue_free()
 await process_frame
 await create_timer(0.2).timeout
 quit()
