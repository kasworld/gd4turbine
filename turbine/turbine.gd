extends Node3D
class_name Turbine

func init(r :float, w :float, co :Color) -> Turbine:
	var spoke := 집중선만들기(r, 0.01, 0.99, w, 8, co)
	#spoke.rotate_y(PI/2)
	add_child( spoke )

	$Reel.mesh.material.albedo_color = co
	$Reel.mesh.inner_radius = r*0.99
	$Reel.mesh.outer_radius = r
	$Reel.scale = Vector3(1,8,1)
	#$Reel.mesh.top_radius = r
	#$Reel.mesh.bottom_radius = $Reel.mesh.top_radius
	#$Reel.mesh.height = w
	#$Reel.mesh.radial_segments = 64
	$Reel.rotate_x(PI/2)
	return self

func 집중선만들기(r :float, start:float, end:float, depth :float, count :int, co :Color ) -> MultiMeshShape:
	var 구분선 := BoxMesh.new()
	var 길이 := r*(end-start)
	구분선.size = Vector3(길이, depth/10, depth )
	var cell각도 := 2.0*PI / count
	var radius := r-길이/2
	var mms :MultiMeshShape = preload("res://multi_mesh_shape/multi_mesh_shape.tscn").instantiate().init(
		구분선, Color.WHITE, count ,Vector3.ZERO )
	for i in count:
		var rad := cell각도 *i + cell각도/2
		mms.set_inst_rotation(i, Vector3.BACK, rad)
		mms.set_inst_rotation(i, Vector3.LEFT, PI/10)
		mms.set_inst_pos(i, Vector3(cos(rad) *radius,sin(rad) *radius, 0) )
		mms.set_inst_color(i, co)
	return mms
