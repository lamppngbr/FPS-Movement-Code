extends KinematicBody

# Definido as variáveis de movimentação e velocidade
# Setting the movement and speed variables
var velocity := Vector3()
var direction := Vector3()
const SPEED := 10
var acceleration := 10.0

# Definido as variáveis de gravidade e velocidade vertical
# Setting the gravity and vertical speed variables
const GRAVITY := 500
var max_fall_speed := 1000
var vertical_velocity := 0.0

# Definindo as variáveis da câmera para o Sine Wave e movimentação
# Setting the camera variables for the Sine Wave and movement
onready var _head : Spatial = $head
onready var _camera : Camera = $head/camera
var mouse_sensitivity := 0.3

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event) -> void:
	# Este código permitirá que movamos a câmera, com um limite de movimento aplicado ao eixo Y.
	# This code will allow us to move the camera, with a movement limit applied to the Y axis.
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity))
		_head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity))
		_head.rotation.x = clamp(_head.rotation.x, deg2rad(-90), deg2rad(90))

func _physics_process(delta):
	move_player(delta)

func move_player(delta : float) -> void:
	var _headrotation = global_transform.basis.get_euler().y
	direction = Vector3(Input.get_axis("move_left", "move_right"), 0, Input.get_axis("move_foward", "move_backward")).rotated(Vector3.UP, _headrotation)
	direction = direction.normalized()
	
	velocity = velocity.linear_interpolate(direction * SPEED, acceleration * delta)
	move_and_slide(velocity + Vector3.UP * vertical_velocity, Vector3.UP)
	
	if not is_on_floor():
		vertical_velocity = -GRAVITY * delta
	else:
		vertical_velocity = 0.0
