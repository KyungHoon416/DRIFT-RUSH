extends SceneTree
func _initialize():
 call_deferred("test")
func test():
 root.size=Vector2i(1280,720)
 var race = load("res://Scenes/Race.tscn").instantiate()
 root.add_child(race)
 await process_frame
 var flow = race.ui.flow
 for page in flow.pages:
  flow.navigate(page)
  for i in range(3): await process_frame
  assert(page.visible and not race.ui.lobby.visible,"Page replaces lobby")
  for other in flow.pages:
   assert(other==page or not other.visible,"Only one frontend page visible")
  for node in page.find_children("*","Button",true,false):
   var rect: Rect2 = node.get_global_rect()
   assert(rect.position.x>=0 and rect.position.y>=0 and rect.end.x<=1280 and rect.end.y<=720,"Button fits virtual canvas: "+node.text+str(rect))
 for button in flow.locked_buttons:
  assert(button.disabled,"Unavailable modes cannot launch")
 flow.navigate(flow.garage)
 assert(race.garage_view,"Garage activates orbit camera")
 var original: String = race.settings.kart_color
 race.set_kart_color("32c7e8")
 assert(not race.body_panels.is_empty(),"Kart has paintable meshes")
 for panel in race.body_panels:
  assert(panel.material_override.albedo_color==Color("32c7e8"),"Paint changes actual 3D material")
 var config = preload("res://Scripts/DrivingSettings.gd").new()
 config.kart_color="ed80b6"
 assert(config.save_settings("user://test_garage.cfg")==OK,"Paint saves")
 var restored = preload("res://Scripts/DrivingSettings.gd").new()
 restored.load_settings("user://test_garage.cfg")
 assert(restored.kart_color=="ed80b6","Paint restores")
 DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_garage.cfg"))
 race.set_kart_color(original)
 race.start_race()
 for page in flow.pages: assert(not page.visible,"Race hides frontend")
 assert(not race.garage_view and race.ui.race_hud.visible,"Race restores driving camera and HUD")
 race.return_lobby()
 assert(race.ui.lobby.visible,"Lobby navigation restored")
 print("PASS: frontend navigation, 1280x720 button bounds, locked modes, garage camera/materials/persistence, race transition")
 race.queue_free()
 await process_frame
 await create_timer(0.2).timeout
 quit()
