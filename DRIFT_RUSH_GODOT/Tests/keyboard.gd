extends SceneTree
func _initialize():
 call_deferred("test")
func key(code: int, down: bool):
 var event := InputEventKey.new()
 event.physical_keycode=code
 event.pressed=down
 Input.parse_input_event(event)
func test():
 var race = load("res://Scenes/Race.tscn").instantiate()
 root.add_child(race)
 await process_frame
 race.start_race()
 race.countdown=0
 race.speed=20
 var yaw: float = race.kart.rotation.y
 key(KEY_D,true)
 key(KEY_SPACE,true)
 for i in range(12): await physics_frame
 assert(race.kart.rotation.y<yaw,"D steers right through input events")
 assert(race.is_drifting and race.charge>0,"Space with steer charges drift")
 assert(race.sparks[0].emitting and absf(race.visual.rotation.z)>0,"Drift effects respond")
 key(KEY_D,false)
 key(KEY_SPACE,false)
 key(KEY_S,true)
 var speed: float = race.speed
 for i in range(10): await physics_frame
 assert(race.speed<speed,"S brakes")
 key(KEY_S,false)
 race.charge=1
 key(KEY_SHIFT,true)
 for i in range(3): await physics_frame
 key(KEY_SHIFT,false)
 assert(race.boost>0 and race.charge==0,"Shift triggers boost")
 race.toggle_pause()
 var elapsed: float = race.elapsed
 var gate: int = race.checkpoint
 race.resume_on_track()
 assert(not race.paused and race.elapsed==elapsed and race.checkpoint==gate,"Manual rescue preserves progress and resumes")
 race.guidance.show_next(3)
 assert(race.guidance.active_gate==3,"Guidance follows gate")
 assert(race.guidance.markers[2].modulate==Color("36edff"),"Next gate highlighted")
 print("PASS: keyboard steer/drift/brake/boost, drift effects, manual rescue, checkpoint guidance")
 race.queue_free()
 await process_frame
 await create_timer(0.2).timeout
 quit()
