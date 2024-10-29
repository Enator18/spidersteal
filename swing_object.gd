extends Node3D

@onready var spider  = get_parent()
@onready var camera: Camera3D = spider.get_node("PivotPoint/Camera3D")
@onready var shoot_point = $shootPoint
@onready var line_mesh_instance = ImmediateMesh.new()

@export var shoot_length = 1000

func _physics_process(delta: float) -> void:
	# get ray origin and direction of the camera's view
	RayCast3D
	var viewport_center = Vector2(camera.get_viewport().size / 2)
	var ray_origin = camera.project_ray_origin(viewport_center)
	var ray_direction = camera.project_ray_normal(viewport_center)
	
	# cast ray
	var ray_query = PhysicsRayQueryParameters3D.new()
	ray_query.from = ray_origin
	ray_query.to = ray_origin + ray_direction * shoot_length
	ray_query.collide_with_areas = false
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(ray_query)
	
	if result:
		var hit_position = result.position
		draw_line(shoot_point.global_position, hit_position)
		


func draw_line(start_point: Vector3, end_point: Vector3):
	#convert 3d points to 2d points
	pass
