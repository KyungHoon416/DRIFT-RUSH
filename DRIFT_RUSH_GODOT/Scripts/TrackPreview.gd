extends Control
## Vector overview of the actual circular starter course, not a gameplay screenshot.
func _draw():
 draw_style_box(_panel(),Rect2(Vector2.ZERO,size))
 var center := size*0.5
 for i in range(24):
  var a := i*TAU/24
  draw_circle(center+Vector2(sin(a)*160,cos(a)*64),5,Color("ef9fc9"))
 var road := PackedVector2Array()
 for i in range(97):
  var a := i*TAU/96
  road.append(center+Vector2(sin(a)*125,cos(a)*48))
 draw_polyline(road,Color("536b81"),14,true)
 draw_polyline(road,Color("e7d4a0"),1,true)
 draw_rect(Rect2(center+Vector2(-4,40),Vector2(8,16)),Color.WHITE)
 draw_circle(center+Vector2(12,48),5,Color("39deed"))
func _panel() -> StyleBoxFlat:
 var p := StyleBoxFlat.new()
 p.bg_color=Color("122c41")
 p.set_corner_radius_all(12)
 return p
