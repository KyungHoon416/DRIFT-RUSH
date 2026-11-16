extends CanvasLayer
var race: Node3D
var lobby: Control
var race_hud: Control
var pause_panel: Control
var result: Control
var stats: Label
var velocity_label: Label
var count_label: Label
var result_label: Label
var meter: ProgressBar
func label(text: String, size: int) -> Label:
 var l := Label.new()
 l.text=text
 l.add_theme_font_size_override("font_size",size)
 return l
func style(color: Color) -> StyleBoxFlat:
 var s := StyleBoxFlat.new()
 s.bg_color=color
 s.corner_radius_top_left=14
 s.corner_radius_top_right=14
 s.corner_radius_bottom_left=14
 s.corner_radius_bottom_right=14
 s.content_margin_left=22
 s.content_margin_right=22
 s.content_margin_top=14
 s.content_margin_bottom=14
 return s
func button(text: String, fn: Callable, accent := false, hold: Callable = Callable()) -> Button:
 var b := Button.new()
 b.text=text
 b.custom_minimum_size=Vector2(112,64)
 b.add_theme_font_size_override("font_size",20)
 b.add_theme_stylebox_override("normal",style(Color("ef9b30") if accent else Color("17354f")))
 b.add_theme_stylebox_override("hover",style(Color("277592")))
 b.add_theme_stylebox_override("pressed",style(Color("1d9dbb")))
 b.pressed.connect(fn)
 if hold.is_valid():
  b.button_down.connect(func(): hold.call(true))
  b.button_up.connect(func(): hold.call(false))
 return b
func root_control() -> Control:
 var c := Control.new()
 c.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
 c.mouse_filter=Control.MOUSE_FILTER_IGNORE
 add_child(c)
 return c
func stack(parent: Control, rect: Rect2) -> VBoxContainer:
 var panel := PanelContainer.new()
 parent.add_child(panel)
 panel.position=rect.position
 panel.size=rect.size
 panel.add_theme_stylebox_override("panel",style(Color(0.035,0.075,0.14,0.94)))
 var v := VBoxContainer.new()
 v.add_theme_constant_override("separation",14)
 panel.add_child(v)
 return v
func setup(owner_race: Node3D):
 race=owner_race
 lobby=root_control()
 var v := stack(lobby,Rect2(48,80,420,550))
 v.add_child(label("DRIFT / RUSH",44))
 v.add_child(label("SAKURA VALLEY",24))
 v.add_child(label("OFFLINE TIME TRIAL · 3 LAPS",16))
 v.add_child(label("Find your line. Hold the drift.\nCharge your boost and chase the clock.",18))
 v.add_child(button("RACE NOW  →",race.start_race,true))
 v.add_child(button("CALIBRATE TILT",func(): race.neutral=Input.get_gravity().x))
 v.add_child(label("A / D  Steer     S  Brake\nSPACE  Drift     SHIFT  Boost\nTouch controls also available",17))
 v.add_child(label("Friends & item races: coming later",15))
 race_hud=root_control()
 var top := stack(race_hud,Rect2(28,24,340,100))
 top.add_child(label("SAKURA  /  TIME TRIAL",16))
 stats=label("",26)
 top.add_child(stats)
 var pause := button("Ⅱ PAUSE",race.toggle_pause)
 race_hud.add_child(pause)
 pause.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
 pause.offset_left=-175
 pause.offset_right=-28
 pause.offset_top=24
 pause.offset_bottom=88
 var bottom := HBoxContainer.new()
 race_hud.add_child(bottom)
 bottom.set_anchors_and_offsets_preset(Control.PRESET_BOTTOM_WIDE)
 bottom.offset_left=28
 bottom.offset_right=-28
 bottom.offset_top=-108
 bottom.offset_bottom=-24
 bottom.add_theme_constant_override("separation",12)
 bottom.add_child(button("◀",func(): pass,false,race.touch_left))
 bottom.add_child(button("▶",func(): pass,false,race.touch_right))
 bottom.add_child(button("BRAKE",func(): pass,false,race.brake_hold))
 var center := VBoxContainer.new()
 center.size_flags_horizontal=Control.SIZE_EXPAND_FILL
 bottom.add_child(center)
 velocity_label=label("",30)
 velocity_label.horizontal_alignment=HORIZONTAL_ALIGNMENT_CENTER
 center.add_child(velocity_label)
 meter=ProgressBar.new()
 meter.custom_minimum_size=Vector2(180,16)
 meter.show_percentage=false
 center.add_child(meter)
 bottom.add_child(button("BOOST",race.activate_boost,true))
 bottom.add_child(button("DRIFT",func(): pass,false,race.drift_hold))
 count_label=label("",76)
 race_hud.add_child(count_label)
 count_label.position=Vector2(610,260)
 pause_panel=root_control()
 var menu := stack(pause_panel,Rect2(440,170,400,360))
 menu.add_child(label("TAKE A BREATHER",28))
 menu.add_child(button("RESUME",race.toggle_pause,true))
 menu.add_child(button("RESTART",race.start_race))
 menu.add_child(button("BACK TO LOBBY",race.return_lobby))
 result=root_control()
 var finish := stack(result,Rect2(440,170,400,360))
 finish.add_child(label("FINISH LINE",36))
 result_label=label("",24)
 finish.add_child(result_label)
 finish.add_child(button("RACE AGAIN",race.start_race,true))
 finish.add_child(button("BACK TO LOBBY",race.return_lobby))
 show_lobby()
func show_lobby():
 lobby.show()
 race_hud.hide()
 pause_panel.hide()
 result.hide()
func show_race():
 lobby.hide()
 race_hud.show()
 pause_panel.hide()
 result.hide()
func show_result(time: float):
 race_hud.hide()
 result.show()
 result_label.text="3 LAPS COMPLETED\nTIME  %.2f s" % time
func update_hud():
 stats.text="LAP %d / 3    %06.2f" % [mini(race.lap,3),race.elapsed]
 velocity_label.text="%03d km/h" % int(race.speed*3.6)
 meter.value=race.charge*100
 count_label.text=str(ceili(race.countdown)) if race.countdown>0 else ""
