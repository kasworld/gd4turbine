extends Node3D
class_name Turbine

func init(count :int, radius :float, ring_width :float, arm_count :int, co1 :Color, co2 :Color) -> Turbine:
	make_rings($RingsOut, count, radius, ring_width, false)
	make_rings($RingsIn, count, radius, ring_width, true)
	var blade_mesh := BoxMesh.new()
	blade_mesh.size = Vector3(radius, ring_width/10, ring_width )
	$Blades.init_with_alpha(blade_mesh, count*arm_count)

	set_transform_all()
	set_color_all(co1,co2)
	return self

func set_transform_all() -> Turbine:
	var count :int = $RingsOut.get_visible_count()
	var arm_count :int = $Blades.get_visible_count() / count
	var mesh_size :Vector3 = $Blades.multimesh.mesh.size
	var ring_width := mesh_size.z
	var radius := mesh_size.x
	for i in count:
		var rate := float(i)/float(count-1)
		var r_scale := (cos(rate*PI*2)+3)/4
		var scaled_size := Vector3(r_scale,r_scale,1)
		var ring_pos := Vector3(0,0,-count*ring_width/2 + i*ring_width)
		$RingsOut.set_inst_scale(i, scaled_size)
		$RingsOut.set_inst_position(i,ring_pos)
		$RingsOut.set_inst_rotation(i, Vector3.RIGHT, PI/2)
		$RingsIn.set_inst_scale(i, scaled_size)
		$RingsIn.set_inst_position(i,ring_pos)
		$RingsIn.set_inst_rotation(i, Vector3.RIGHT, PI/2)

		var cell각도 := 2.0*PI / arm_count
		var base_int := i*arm_count
		var blade_rot_rad := rate * PI
		for j in arm_count:
			var rad := cell각도 *j + blade_rot_rad
			$Blades.set_inst_rotation(base_int+j, Vector3.BACK, rad)
			$Blades.set_inst_rotation(base_int+j, Vector3.LEFT, PI/10)
			$Blades.set_inst_position(base_int+j, Vector3(cos(rad) *radius*r_scale/2,sin(rad) *radius*r_scale/2, ring_pos.z) )
			$Blades.set_inst_scale(base_int+j, scaled_size)
	return self

func set_color_all(co1 :Color, co2 :Color) -> Turbine:
	var count :int = $RingsOut.get_visible_count()
	var arm_count :int = $Blades.get_visible_count() / count
	for i in count:
		var rate := float(i)/float(count-1)
		var co := co1.lerp(co2, rate)
		$RingsOut.set_inst_color(i,co)
		$RingsIn.set_inst_color(i,co)
		var base_int := i*arm_count
		for j in arm_count:
			$Blades.set_inst_color(base_int+j, co)
	return self

func set_inst_color(i:int, co :Color) -> void:
	var count :int = $RingsOut.get_visible_count()
	var arm_count :int = $Blades.get_visible_count() / count
	$RingsOut.set_inst_color(i,co)
	$RingsIn.set_inst_color(i,co)
	var base_int := i*arm_count
	for j in arm_count:
		$Blades.set_inst_color(base_int+j, co)

func make_rings(rings :MultiMeshShape, count :int, radius :float, ring_width :float, flip_faces :bool) -> MultiMeshShape:
	var ring_mesh := CylinderMesh.new()
	ring_mesh.cap_bottom = false
	ring_mesh.cap_top = false
	ring_mesh.top_radius = radius
	ring_mesh.bottom_radius = radius
	ring_mesh.height = ring_width
	ring_mesh.flip_faces = flip_faces
	rings.init_with_alpha(ring_mesh, count,0.9)
	return rings
