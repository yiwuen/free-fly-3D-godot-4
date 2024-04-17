extends Camera3D

@onready var main_view: Node3D = get_parent()

const mouse_sens: float = 0.3

var current_speed: float
var default_speed: float = 5.0
var sprinting_speed: float = 8.5
var slower_speed: float = 3.5

var can_view: bool = false

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and can_view:
		rotate_x(deg_to_rad(-event.relative.y * mouse_sens))
		main_view.rotate_y(deg_to_rad(-event.relative.x * mouse_sens))
		rotation.x = clamp(rotation.x, deg_to_rad(-90), deg_to_rad(90))
	
	# hold down right mouse button to view around
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_RIGHT:
			if event.pressed:
				can_view = true
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			else:
				can_view = false
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
	if event.is_action_pressed("ui_cancel"):
		if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _process(delta: float) -> void:
	if Input.is_action_pressed("sprint"):
		current_speed = sprinting_speed
	elif Input.is_action_pressed("slow"):
		current_speed = slower_speed
	else:
		current_speed = default_speed
	
	var input_dir: Vector2 = Input.get_vector("left", "right", "forward", "backward")
	var direction: Vector3 = ((main_view.transform.basis * transform.basis) * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		main_view.global_position += direction * current_speed * delta
	
	if Input.is_action_pressed("up"):
		main_view.global_position += (global_transform.basis.y * main_view.global_transform.basis.y) * current_speed * delta
	if Input.is_action_pressed("down"):
		main_view.global_position -= (global_transform.basis.y * main_view.global_transform.basis.y) * current_speed * delta














