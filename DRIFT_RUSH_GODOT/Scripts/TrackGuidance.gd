extends Node3D
## Physical landmarks share the same radius and ordered gates as race logic.
var markers: Array[Label3D] = []
var active_gate := -1
func setup(radius: float):
 for gate in range(1,9):
  var angle := gate*TAU/8.0
  for side in [-1,1]:
   var r: float = radius+side*8.5
   var post := MeshInstance3D.new()
   var shape := BoxMesh.new()
   shape.size=Vector3(0.18,3,0.18)
   post.mesh=shape
   post.position=Vector3(sin(angle)*r,1.5,cos(angle)*r)
   add_child(post)
  var marker := Label3D.new()
  marker.position=Vector3(sin(angle)*radius,4.5,cos(angle)*radius)
  marker.text="FINISH" if gate==8 else "CP %02d" % gate
  marker.font_size=64
  marker.pixel_size=0.015
  marker.outline_size=12
  marker.billboard=BaseMaterial3D.BILLBOARD_ENABLED
  marker.no_depth_test=false
  add_child(marker)
  markers.append(marker)
 # Painted directional chevrons point along increasing track angle.
 var material := StandardMaterial3D.new()
 material.albedo_color=Color("f6d590")
 for i in range(32):
  var angle := (i+0.5)*TAU/32.0
  var arrow := Node3D.new()
  arrow.position=Vector3(sin(angle)*radius,0.29,cos(angle)*radius)
  arrow.rotation.y=angle-PI/2
  add_child(arrow)
  for side in [-1,1]:
   var stroke := MeshInstance3D.new()
   var shape := BoxMesh.new()
   shape.size=Vector3(0.15,0.025,1.1)
   stroke.mesh=shape
   stroke.material_override=material
   stroke.position=Vector3(side*0.35,0,0)
   stroke.rotation.y=side*PI/4
   arrow.add_child(stroke)
func show_next(gate: int):
 if active_gate==gate: return
 active_gate=gate
 for i in range(markers.size()):
  markers[i].modulate=Color("36edff") if i+1==gate else Color("a2afbd")
