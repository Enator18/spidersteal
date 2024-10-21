extends Node3D

# Reference to the object to orbit around
@export var target: Node3D

# Distance from the target
@export var distance: float = 10.0

# Mouse sensitivity for rotation
var sensitivity: float = 0.3

# Current rotation around the object
var yaw: float = 0.0
var pitch: float = 0.0

# Limits for vertical rotation (pitch)
var pitch_limit: float = 85.0

# Minimum and maximum zoom distances
@export var min_distance: float = 3.0
@export var max_distance: float = 20.0

func _ready() -> void:
	# Capture the mouse
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_update_orbit_rotation(event.relative)

	# Zooming in/out using the mouse wheel
	if event is InputEventKey:
		if event.keycode == KEY_UP:
			_zoom(-1)
		elif event.keycode == KEY_DOWN:
			_zoom(1)

func _update_orbit_rotation(mouse_delta: Vector2) -> void:
	# Adjust yaw and pitch based on mouse movement
	yaw -= mouse_delta.x * sensitivity
	pitch -= mouse_delta.y * sensitivity

	# Clamp pitch to prevent camera from flipping
	pitch = clamp(pitch, -pitch_limit, pitch_limit)

	# Update the rotation of the parent node (this node)
	rotation_degrees = Vector3(0, yaw, -pitch)

	# Update the camera's position relative to the target
	_update_camera_position()

func _update_camera_position() -> void:
	if target:
		# Calculate the camera's new position relative to the target
		var camera_pos = Vector3(0, 0, distance)
		# Apply the parent node's rotation to the camera position
		camera_pos = global_transform.basis * camera_pos
		# Set the camera's global position to orbit around the target
		get_child(0).global_transform.origin = target.global_transform.origin + camera_pos
		# Ensure the camera is always looking at the target
		get_child(0).look_at(target.global_transform.origin, Vector3.UP)

func _zoom(delta: float) -> void:
	# Zoom in/out by adjusting the distance from the target
	distance += delta
	distance = clamp(distance, min_distance, max_distance)
	_update_camera_position()

func _input(event: InputEvent) -> void:
	# Release or capture mouse when pressing escape
	if event is InputEventKey and event.is_pressed() and event.keycode == KEY_ESCAPE:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
