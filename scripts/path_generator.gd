extends Node3D

@export var segment_length = 10
@export var x_variance = 3

@export var box: Node3D
@export var path: Path3D

var rng = RandomNumberGenerator.new()
var curve_pos: float = 0
var curve := Curve3D.new()

func _ready() -> void:
	
	var last_point := Vector3(0,0,0)
	curve.add_point(last_point)
	for i in 10:
		last_point = generate_curve(curve, last_point)
	path.curve = curve
	generate_mesh()

func generate_curve(curve: Curve3D, last_point: Vector3):
	
	var mid_x = rng.randf_range(-x_variance,x_variance)
	var mid_z = last_point.z + segment_length/2
	var mid_point = Vector3(mid_x, 0, mid_z)
	
	var end_x = rng.randf_range(-x_variance,x_variance)
	var end_z = last_point.z + segment_length
	var end_point = Vector3(end_x, 0, end_z)
	
	curve.add_point(mid_point)
	curve.add_point(end_point)
	
	return end_point

@export var road_width = 5.0
@export var road_thickness = 0.1
var road_profile = [
	Vector3(-road_width / 2, 0, 0),  # Left edge
	Vector3(road_width / 2, 0, 0)    # Right edge
]

func generate_mesh():
	var surface_tool = SurfaceTool.new()
	surface_tool.begin(Mesh.PRIMITIVE_TRIANGLES)

	var num_steps = 20  # Number of segments along the curve
	var road_width = road_profile.size()  # Number of points in the road profile

	for i in range(num_steps - 1):
		var t0 = float(i) / (num_steps - 1)  # Start position
		var t1 = float(i + 1) / (num_steps - 1)  # End position

		# Sample the curve positions and tangents for two consecutive segments
		var position0 = curve.sample_baked(t0)
		var position1 = curve.sample_baked(t1)
		var tangent0 = (curve.sample_baked(t0 + 0.05) - position0).normalized()
		var tangent1 = (curve.sample_baked(t1 + 0.05) - position1).normalized()

		# Create bases for both segments
		var up = Vector3.UP
		var right0 = up.cross(tangent0).normalized()
		var right1 = up.cross(tangent1).normalized()
		var basis0 = Basis(right0, up, tangent0)
		var basis1 = Basis(right1, up, tangent1)

		# Add vertices for the road profile at both positions
		for j in range(road_width - 1):
			# Current and next points in the road profile
			var point0 = road_profile[j]
			var point1 = road_profile[j + 1]

			# Transform points for the current segment
			var v0 = position0 + basis0 * point0
			var v1 = position0 + basis0 * point1

			# Transform points for the next segment
			var v2 = position1 + basis1 * point0
			var v3 = position1 + basis1 * point1

			# Create two triangles (v0-v1-v2 and v1-v3-v2)
			surface_tool.add_vertex(v0)
			surface_tool.add_vertex(v1)
			surface_tool.add_vertex(v2)

			surface_tool.add_vertex(v1)
			surface_tool.add_vertex(v3)
			surface_tool.add_vertex(v2)

	# Commit the surface to a mesh
	var mesh = surface_tool.commit()
	var road_instance = MeshInstance3D.new()
	road_instance.mesh = mesh
	add_child(road_instance)
