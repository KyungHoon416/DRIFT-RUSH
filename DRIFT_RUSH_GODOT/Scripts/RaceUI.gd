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
var settings_panel: Control
var sensor_status: Label
var warning_label: Label
var minimap: Control
var steer_buttons: Array[Button] = []
var return_to_pause := false
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
 v.add_child(button("CONTROLS & SOUND",open_settings))
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
 for entry in [["◀",race.touch_left],["▶",race.touch_right]]:
  var control := button(entry[0],func(): pass,false,entry[1])
  steer_buttons.append(control)
  bottom.add_child(control)
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
 menu.add_child(button("CONTROLS & SOUND",open_settings))
 menu.add_child(button("RESTART",race.start_race))
 menu.add_child(button("BACK TO LOBBY",race.return_lobby))
 result=root_control()
 var finish := stack(result,Rect2(440,170,400,360))
 finish.add_child(label("FINISH LINE",36))
 result_label=label("",24)
 finish.add_child(result_label)
 finish.add_child(button("RACE AGAIN",race.start_race,true))
 finish.add_child(button("BACK TO LOBBY",race.return_lobby))
 minimap=preload("res://Scripts/Minimap.gd").new()
 minimap.race=race
 minimap.mouse_filter=Control.MOUSE_FILTER_IGNORE
 race_hud.add_child(minimap)
 minimap.set_anchors_and_offsets_preset(Control.PRESET_TOP_RIGHT)
 minimap.offset_left=-208
 minimap.offset_right=-28
 minimap.offset_top=104
 minimap.offset_bottom=284
 warning_label=label("",24)
 race_hud.add_child(warning_label)
 warning_label.position=Vector2(460,140)
 build_settings()
 show_lobby()
func show_lobby():
 settings_panel.hide()
 lobby.show()
 race_hud.hide()
 pause_panel.hide()
 result.hide()
func show_race():
 settings_panel.hide()
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
 minimap.queue_redraw()
 warning_label.text="WRONG WAY  •  TURN AROUND" if race.wrong_way else ""
 var show_arrows: bool = not race.settings.tilt_enabled or Input.get_gravity().length()<0.1
 for b in steer_buttons: b.visible=show_arrows
 count_label.text=str(ceili(race.countdown)) if race.countdown>0 else ""

func open_settings():
 return_to_pause=race.running
 lobby.hide()
 pause_panel.hide()
 settings_panel.show()
 sensor_status.text="Tilt your device, then calibrate.\nNo sensor? Touch arrows remain available."
func close_settings():
 var error: Error = race.settings.save_settings()
 if error!=OK:
  sensor_status.text="Could not save settings. Check device storage and retry."
  return
 settings_panel.hide()
 if return_to_pause: pause_panel.show()
 else: lobby.show()
func setting_slider(parent: VBoxContainer, title: String, value: float, minimum: float, maximum: float, change: Callable):
 var row := HBoxContainer.new()
 parent.add_child(row)
 var caption := label("%s  %.2f" % [title,value],18)
 caption.custom_minimum_size.x=260
 row.add_child(caption)
 var slider := HSlider.new()
 slider.min_value=minimum
 slider.max_value=maximum
 slider.step=0.01
 slider.value=value
 slider.custom_minimum_size=Vector2(240,38)
 row.add_child(slider)
 slider.value_changed.connect(func(v): change.call(v); caption.text="%s  %.2f" % [title,v])
func toggle(parent: VBoxContainer, title: String, value: bool, change: Callable):
 var check := CheckButton.new()
 check.text=title
 check.button_pressed=value
 check.custom_minimum_size.y=42
 check.toggled.connect(change)
 parent.add_child(check)
func build_settings():
 settings_panel=root_control()
 var v := stack(settings_panel,Rect2(335,25,610,670))
 v.add_theme_constant_override("separation",8)
 v.add_child(label("CONTROLS & SOUND",28))
 toggle(v,"Tilt steering (off = touch arrows)",race.settings.tilt_enabled,func(value): race.settings.tilt_enabled=value)
 setting_slider(v,"Tilt sensitivity",race.settings.sensitivity,0.5,2.0,func(value): race.settings.sensitivity=value)
 setting_slider(v,"Tilt dead zone",race.settings.deadzone,0,0.3,func(value): race.settings.deadzone=value)
 toggle(v,"Invert tilt direction",race.settings.invert,func(value): race.settings.invert=value)
 toggle(v,"Collision vibration",race.settings.vibration,func(value): race.settings.vibration=value)
 setting_slider(v,"Sound volume",race.settings.volume,0,1,func(value): race.settings.volume=value)
 sensor_status=label("",16)
 v.add_child(sensor_status)
 v.add_child(button("CALIBRATE CURRENT POSTURE",func():
  var success: bool = race.settings.calibrate(Input.get_gravity())
  sensor_status.text="Neutral posture calibrated." if success else "Sensor unavailable. Use A/D or touch arrows."
 ))
 v.add_child(button("SAVE & BACK",close_settings,true))
