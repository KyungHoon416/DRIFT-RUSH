extends RefCounted
## Local front-end navigation. Online and item modes never enter a pretend session.
var ui: CanvasLayer
var race: Node3D
var pages: Array[Control] = []
var modes: Control
var maps: Control
var garage: Control
var tutorial: Control
var tutorial_meter: ProgressBar
var tutorial_status: Label
var paint_status: Label
var color_buttons: Array[Button] = []
var locked_buttons: Array[Button] = []
func page() -> Control:
 var c: Control = ui.root_control()
 pages.append(c)
 return c
func hide_pages():
 for p in pages: p.hide()
func navigate(target: Control):
 hide_pages()
 ui.lobby.hide()
 race.garage_view=target==garage
 target.show()
func unavailable(parent: VBoxContainer, title: String):
 var b: Button = ui.button(title,func(): pass)
 b.disabled=true
 parent.add_child(b)
 locked_buttons.append(b)
func setup(owner_ui: CanvasLayer, owner_race: Node3D):
 ui=owner_ui
 race=owner_race
 build_lobby()
 build_modes()
 build_maps()
 build_garage()
 build_tutorial()
 hide_pages()
func build_lobby():
 var v: VBoxContainer = ui.stack(ui.lobby,Rect2(40,38,380,640))
 v.add_theme_constant_override("separation",12)
 var badge: Label = ui.label("OFFLINE  /  DRIVER 01",15)
 badge.modulate=Color("5cdeef")
 v.add_child(badge)
 v.add_child(ui.label("DRIFT RUSH",40))
 v.add_child(ui.label("SAKURA SEASON",18))
 v.add_child(ui.button("PLAY   →",func(): navigate(modes),true))
 v.add_child(ui.button("GARAGE",func(): navigate(garage)))
 v.add_child(ui.button("HOW TO DRIVE",func(): navigate(tutorial)))
 v.add_child(ui.button("SETTINGS",ui.open_settings))
 unavailable(v,"FRIENDS  ·  COMING LATER")
 v.add_child(ui.label("3D TIME TRIAL\nYour kart. Your line. Your best lap.",17))
 var info: VBoxContainer = ui.stack(ui.lobby,Rect2(885,510,350,165))
 info.add_child(ui.label("01 / SAKURA VALLEY",21))
 info.add_child(ui.label("3 laps  ·  8 checkpoints\nDrift to charge. Boost to break away.",16))
func build_modes():
 modes=page()
 var v: VBoxContainer = ui.stack(modes,Rect2(410,55,470,610))
 v.add_child(ui.label("01  /  SELECT MODE",30))
 v.add_child(ui.label("OFFLINE TIME TRIAL",23))
 v.add_child(ui.label("Auto acceleration. Three timed laps.\nNo opponents — focus on your racing line.",18))
 v.add_child(ui.button("SELECT TRACK   →",func(): navigate(maps),true))
 unavailable(v,"ITEM RACE  ·  IN DEVELOPMENT")
 unavailable(v,"FRIEND RACE  ·  IN DEVELOPMENT")
 v.add_child(ui.button("BACK TO LOBBY",ui.show_lobby))
func build_maps():
 maps=page()
 var v: VBoxContainer = ui.stack(maps,Rect2(410,45,470,630))
 v.add_child(ui.label("02  /  SELECT TRACK",30))
 var preview := preload("res://Scripts/TrackPreview.gd").new()
 preview.custom_minimum_size=Vector2(400,160)
 v.add_child(preview)
 v.add_child(ui.label("SAKURA VALLEY",26))
 v.add_child(ui.label("%.0f m / lap  ·  3 laps  ·  Beginner\nCherry blossoms and sweeping turns." % (TAU*race.RADIUS),17))
 v.add_child(ui.button("START RACE   →",race.start_race,true))
 unavailable(v,"NEON CITY  ·  IN DEVELOPMENT")
 v.add_child(ui.button("BACK",func(): navigate(modes)))
func build_garage():
 garage=page()
 var v: VBoxContainer = ui.stack(garage,Rect2(40,55,390,610))
 v.add_child(ui.label("GARAGE / 01",32))
 v.add_child(ui.label("RUSH KART",24))
 v.add_child(ui.label("Choose your signature color.\nAll colors have identical performance.",17))
 for index in range(race.settings.COLORS.size()):
  var hex: String = race.settings.COLORS[index]
  var names := ["SOLAR ORANGE","ARCTIC BLUE","SAKURA PINK","MINT GREEN"]
  var b: Button = ui.button(names[index],func(): choose_color(hex))
  b.add_theme_color_override("font_color",Color(hex))
  v.add_child(b)
  color_buttons.append(b)
 paint_status=ui.label("",16)
 v.add_child(paint_status)
 v.add_child(ui.button("BACK TO LOBBY",ui.show_lobby))
 var controls: VBoxContainer = ui.stack(garage,Rect2(875,535,355,140))
 var rotate := HBoxContainer.new()
 controls.add_child(rotate)
 rotate.add_child(ui.button("↶ ROTATE",func(): race.preview_angle-=PI/4))
 rotate.add_child(ui.button("ROTATE ↷",func(): race.preview_angle+=PI/4))
 mark_color()
func mark_color():
 for i in range(color_buttons.size()):
  color_buttons[i].disabled=race.settings.COLORS[i]==race.settings.kart_color
 paint_status.text="SELECTED  /  %s" % race.settings.kart_color.to_upper()
func choose_color(hex: String):
 var previous: String = race.settings.kart_color
 race.set_kart_color(hex)
 if race.settings.save_settings()!=OK:
  race.set_kart_color(previous)
  paint_status.text="Save failed. Previous color restored."
  return
 mark_color()
func build_tutorial():
 tutorial=page()
 var v: VBoxContainer = ui.stack(tutorial,Rect2(350,40,580,640))
 v.add_child(ui.label("FIND YOUR RACING LINE",30))
 v.add_child(ui.label("01  STEER\nPhone: tilt left / right. PC: A / D or arrows.\nAcceleration is automatic after the countdown.",18))
 v.add_child(ui.label("02  DRIFT & BOOST\nHold DRIFT + steer at speed to fill the gauge.\nPress BOOST when ready. S / BRAKE slows down.",18))
 tutorial_meter=ProgressBar.new()
 tutorial_meter.min_value=-1
 tutorial_meter.max_value=1
 tutorial_meter.show_percentage=false
 tutorial_meter.custom_minimum_size.y=28
 v.add_child(tutorial_meter)
 tutorial_status=ui.label("",17)
 v.add_child(tutorial_status)
 v.add_child(ui.button("CALIBRATE TILT",func(): race.settings.calibrate(Input.get_gravity())))
 v.add_child(ui.button("TRY ON TRACK   →",race.start_race,true))
 v.add_child(ui.button("BACK TO LOBBY",ui.show_lobby))
func update():
 if not tutorial.visible: return
 var gravity := Input.get_gravity()
 tutorial_meter.value=race.settings.tilt_value(gravity)
 tutorial_status.text="Sensor unavailable. Use keyboard or touch arrows." if gravity.length()<0.1 else "Tilt: %+.2f  /  calibrate at a comfortable posture." % tutorial_meter.value
