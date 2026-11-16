extends Node3D
var kart: CharacterBody3D
var camera: Camera3D
var hud: Label
var ui: CanvasLayer
var countdown := 0.0
var speed := 0.0
var charge := 0.0
var boost := 0.0
var elapsed := 0.0
var running := false
var paused := false
var lap := 1
var checkpoint := 1
var steer := 0.0
var touch := 0.0
var braking := false
var drifting := false
var settings = preload("res://Scripts/DrivingSettings.gd").new()
var wrong_way := false
var cooldown := 0.0
var wheels: Array[MeshInstance3D] = []
var audio: AudioStreamPlayer
const RADIUS = 65.0
func mesh(parent: Node3D, shape: Mesh, pos: Vector3, color: Color) -> MeshInstance3D:
 var m := MeshInstance3D.new()
 m.mesh = shape
 m.position = pos
 var mat := StandardMaterial3D.new()
 mat.albedo_color = color
 mat.roughness = 0.65
 m.material_override = mat
 parent.add_child(m)
 return m
func box(parent: Node3D, pos: Vector3, size: Vector3, color: Color, solid := false) -> MeshInstance3D:
 var b := BoxMesh.new()
 b.size = size
 var m := mesh(parent,b,pos,color)
 if solid:
  var body := StaticBody3D.new()
  var collision := CollisionShape3D.new()
  var shape := BoxShape3D.new()
  shape.size = size
  collision.shape = shape
  m.add_child(body)
  body.add_child(collision)
 return m
func _ready():
 settings.load_settings()
 var sun := DirectionalLight3D.new()
 sun.rotation_degrees = Vector3(-45,-25,0)
 sun.light_energy = 1.3
 add_child(sun)
 var env := WorldEnvironment.new()
 env.environment = Environment.new()
 env.environment.background_mode = Environment.BG_COLOR
 env.environment.background_color = Color("85c9ec")
 env.environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
 env.environment.ambient_light_color = Color.WHITE
 env.environment.ambient_light_energy = 0.55
 add_child(env)
 box(self,Vector3(0,-1,0),Vector3(220,1,220),Color("78b87b"),true)
 for i in range(128):
  var a := i * TAU / 128.0
  var pos := Vector3(sin(a)*RADIUS,0,cos(a)*RADIUS)
  var road := box(self,pos,Vector3(14,0.5,3.6),Color("536075"),true)
  road.rotation.y = a + PI/2
  for side in [-1,1]:
   var r: float = RADIUS + side*7.6
   var rail := box(self,Vector3(sin(a)*r,0.8,cos(a)*r),Vector3(0.6,1.4,4),Color("faf0e5") if i%2==0 else Color("e777a4"),true)
   rail.rotation.y = a + PI/2
  if i%4==0:
   var dash := box(self,pos+Vector3(0,0.28,0),Vector3(0.14,0.03,1.6),Color("f5dab0"))
   dash.rotation.y = a+PI/2
  if i%3==0:
   for side in [-1,1]:
    var r: float = RADIUS+side*14
    var base := Vector3(sin(a)*r,0,cos(a)*r)
    box(self,base+Vector3(0,2,0),Vector3(0.6,4,0.6),Color("78525f"))
    for j in range(7):
     var s := SphereMesh.new()
     s.radius = 1.7
     s.height = 2.9
     mesh(self,s,base+Vector3(sin(j*2.4)*2,4.5+(j%3)*0.7,cos(j*2.4)*1.7),Color("ffb4d1") if j%2==0 else Color("f58db7"))
 for x in range(14):
  box(self,Vector3(0,0.28,58.5+x),Vector3(2,0.04,0.9),Color.WHITE if x%2==0 else Color("17213c"))
 box(self,Vector3(0,7,65),Vector3(0.8,1.5,18),Color("132e50"))
 for z in [56,74]:
  box(self,Vector3(0,3.5,z),Vector3(0.6,7,0.6),Color("30d5f5"))
 kart = CharacterBody3D.new()
 add_child(kart)
 var col := CollisionShape3D.new()
 var shape := BoxShape3D.new()
 shape.size = Vector3(1.5,1,2.6)
 col.shape = shape
 col.position.y = 0.7
 kart.add_child(col)
 box(kart,Vector3(0,0.65,0),Vector3(1.8,0.5,2.8),Color("ff8b27"))
 box(kart,Vector3(0,0.95,-0.8),Vector3(1.4,0.35,1),Color("fff3df"))
 box(kart,Vector3(0,1.15,1),Vector3(2,0.15,0.5),Color("ff8b27"))
 var helmet := SphereMesh.new()
 helmet.radius = 0.48
 helmet.height = 0.9
 mesh(kart,helmet,Vector3(0,1.6,0.3),Color("ffc34b"))
 box(kart,Vector3(0,1.6,-0.12),Vector3(0.7,0.25,0.12),Color("193955"))
 for x in [-1,1]:
  for z in [-0.9,0.9]:
   var tire := CylinderMesh.new()
   tire.top_radius = 0.4
   tire.bottom_radius = 0.4
   tire.height = 0.35
   var w := mesh(kart,tire,Vector3(x*0.9,0.45,z),Color("222b42"))
   w.rotation.z = PI/2
   wheels.append(w)
 # Side pods, rear bumper, lights and exhaust give the kart a readable silhouette.
 for side in [-1,1]:
  box(kart,Vector3(side*0.78,0.85,0.15),Vector3(0.4,0.45,1.6),Color("e75c20"))
  box(kart,Vector3(side*0.54,0.72,1.43),Vector3(0.38,0.14,0.08),Color("ff385d"))
  box(kart,Vector3(side*0.48,0.45,1.48),Vector3(0.24,0.2,0.22),Color("47dfff"))
  box(kart,Vector3(side*0.55,0.85,-1.43),Vector3(0.4,0.13,0.08),Color("b9f7ff"))
 box(kart,Vector3(0,0.42,1.48),Vector3(1.6,0.15,0.15),Color("172638"))
 box(kart,Vector3(0,0.93,-0.9),Vector3(0.2,0.4,0.9),Color("17334e"))
 # Distant stylized hills, kept clear of the racing surface.
 for i in range(12):
  var mountain := CylinderMesh.new()
  mountain.top_radius=2
  mountain.bottom_radius=18
  mountain.height=22+float(i%3)*8
  mesh(self,mountain,Vector3(sin(i*TAU/12)*125,5,cos(i*TAU/12)*125),Color("7299ad"))
 camera = Camera3D.new()
 add_child(camera)
 camera.current = true
 camera.fov = 65
 audio = AudioStreamPlayer.new()
 add_child(audio)
 var wav := AudioStreamWAV.new()
 wav.mix_rate = 22050
 wav.format = AudioStreamWAV.FORMAT_16_BITS
 var bytes := PackedByteArray()
 bytes.resize(4410*2)
 for i in range(4410):
  bytes.encode_s16(i*2,int(sin(i*0.12)*18000*(1.0-i/4410.0)))
 wav.data = bytes
 audio.stream = wav
 ui = preload("res://Scripts/RaceUI.gd").new()
 add_child(ui)
 ui.setup(self)
 reset()
func touch_left(down: bool): touch = -1.0 if down else 0.0
func touch_right(down: bool): touch = 1.0 if down else 0.0
func brake_hold(down: bool): braking=down
func drift_hold(down: bool): drifting=down
func activate_boost():
 if charge>=1 and running and not paused:
  boost=2.5
  charge=0
func start_race():
 settings.calibrate(Input.get_gravity())
 reset()
 running=true
 countdown=3.0
 ui.show_race()
func return_lobby():
 reset()
 running=false
 ui.show_lobby()
func toggle_pause():
 if paused: settings.calibrate(Input.get_gravity())
 paused=not paused
 touch=0
 braking=false
 drifting=false
 ui.pause_panel.visible=paused
func reset():
 kart.position=Vector3(0,0.5,RADIUS)
 kart.rotation.y=-PI/2
 kart.velocity=Vector3.ZERO
 touch=0
 steer=0
 braking=false
 drifting=false
 countdown=0
 speed=0
 elapsed=0
 lap=1
 checkpoint=1
 charge=0
 boost=0
 paused=false
 wrong_way=false
 camera.position=kart.position+Vector3(-8,5,0)
func _physics_process(dt: float):
 if running and not paused and countdown>0:
  countdown=maxf(0,countdown-dt)
 if running and not paused and countdown<=0:
  elapsed+=dt
  cooldown=maxf(0,cooldown-dt)
  var input := float(Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT))-float(Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT))
  input=clampf(input+touch+settings.tilt_value(Input.get_gravity()),-1,1)
  steer=lerpf(steer,input,dt*8)
  var drift := (drifting or Input.is_physical_key_pressed(KEY_SPACE)) and absf(steer)>0.2 and speed>10
  speed=move_toward(speed,0 if braking or Input.is_physical_key_pressed(KEY_S) else (42 if boost>0 else 27),dt*12)
  kart.rotation.y-=steer*dt*(1.5 if drift else 1.0)*minf(speed/12,1)
  var target := -kart.global_basis.z*speed
  kart.velocity=kart.velocity.lerp(target,dt*(2.5 if drift else 9))
  kart.velocity.y=-2
  kart.move_and_slide()
  if kart.get_slide_collision_count()>0 and cooldown<=0:
   for i in range(kart.get_slide_collision_count()):
    if absf(kart.get_slide_collision(i).get_normal().y)<0.5:
     speed*=0.6
     cooldown=0.3
     audio.volume_db=linear_to_db(maxf(settings.volume,0.0001))
     if settings.volume>0: audio.play()
     if settings.vibration: Input.vibrate_handheld(60,0.4)
  if drift: charge=minf(1,charge+dt*0.2)
  if Input.is_physical_key_pressed(KEY_SHIFT): activate_boost()
  boost=maxf(0,boost-dt)
  var angle := fposmod(atan2(kart.position.x,kart.position.z),TAU)
  var tangent := Vector3(cos(angle),0,-sin(angle))
  wrong_way=speed>3 and (-kart.global_basis.z).dot(tangent)<-0.35
  var target_angle := checkpoint*TAU/8
  if not wrong_way and absf(Vector2(kart.position.x,kart.position.z).length()-RADIUS)<7 and absf(angle_difference(angle,fposmod(target_angle,TAU)))<0.12:
   checkpoint+=1
   if checkpoint==9:
    checkpoint=1
    lap+=1
    if lap>3:
     running=false
     ui.show_result(elapsed)
  if kart.position.y < -4: reset()
  for w in wheels: w.rotate_y(speed*dt*2)
 var desired := kart.position+kart.global_basis.z*7+Vector3.UP*4
 if not running:
  desired=kart.position+Vector3(-5,2.8,5)
 camera.position=camera.position.lerp(desired,1-exp(-5*dt))
 camera.look_at(kart.position+Vector3.UP)
 ui.update_hud()

func _notification(what: int):
 if what==NOTIFICATION_APPLICATION_FOCUS_OUT and running and not paused and is_instance_valid(ui):
  toggle_pause()
