extends Control
var race: Node3D
func project_point(point: Vector3) -> Vector2:
 return size*0.5+Vector2(point.x,point.z)*(size.x*0.36/race.RADIUS)
func _draw():
 if race==null: return
 draw_style_box(_background(),Rect2(Vector2.ZERO,size))
 var points := PackedVector2Array()
 for i in range(129):
  var a := i*TAU/128.0
  points.append(project_point(Vector3(sin(a)*race.RADIUS,0,cos(a)*race.RADIUS)))
 draw_polyline(points,Color("5c7896"),12,true)
 draw_polyline(points,Color("bdd4dc"),2,true)
 var angle: float = race.checkpoint*TAU/8.0
 draw_circle(project_point(Vector3(sin(angle)*race.RADIUS,0,cos(angle)*race.RADIUS)),5,Color("f6bb42"))
 draw_circle(project_point(Vector3(0,0,race.RADIUS)),4,Color.WHITE)
 var player := project_point(race.kart.position)
 draw_circle(player,6,Color("32e5ff"))
 var forward: Vector3 = -race.kart.global_basis.z
 draw_line(player,player+Vector2(forward.x,forward.z)*14,Color.WHITE,3,true)
func _background() -> StyleBoxFlat:
 var s := StyleBoxFlat.new()
 s.bg_color=Color(0.03,0.07,0.13,0.85)
 s.set_corner_radius_all(16)
 return s
