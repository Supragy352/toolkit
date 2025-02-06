extends CharacterBody2D

var was_in_air = false
var normal_velocity := 200
var acceleration := 100.0
var deceleration := 100.0
var acceleration_in_air := 200.0
var deceleration_in_air := 200.0
var max_speed := 200.0
var gravity := 500.0
var animation_scale := 1.5
var gravity_down := 1000.0
var enable_accel := true
var interactive_zoom := true

@onready var animated_sprite = $AnimatedSprite2D
@onready var camera = $Camera2D


const JUMP_VELOCITY = -400.0
const COYOTE_TIME  = 5.0

var coyote_timer = 0.0

func _physics_process(delta):
	var direction = Input.get_axis("left", "right")

	var accel = acceleration if enable_accel else 1
	var decel = deceleration if enable_accel else 1

	if interactive_zoom:
		if not is_on_floor():
			velocity_y_calc(gravity, delta, gravity_down)
			velocity_x_calc(direction, accel, decel, delta)
			
			if not was_in_air:
				camera.zoom = Vector2(8,8)
				was_in_air = true
				coyote_timer = COYOTE_TIME
		else:
			if was_in_air:
				camera.zoom = Vector2(4,4)
				was_in_air = false
				coyote_timer = 0.0
	else:
		velocity_y_calc(gravity, delta, gravity_down)
		velocity_x_calc(direction, accel, decel, delta)


	if Input.is_action_just_pressed("jump") and (is_on_floor() or coyote_timer > 0.0):
		velocity.y = JUMP_VELOCITY
		if interactive_zoom:
			camera.zoom = Vector2(8,8)
			was_in_air = true

	if not is_on_floor():
		if not was_in_air:
			coyote_timer = COYOTE_TIME
			coyote_timer -= delta
			coyote_timer = max(coyote_timer, 0.0)
			was_in_air = true
		else:
			was_in_air = false
			coyote_timer = 0.0

	
	velocity_x_calc(direction, accel, decel, delta)

	if direction != 0:
		animated_sprite.flip_h = direction < 0
		animated_sprite.speed_scale = animation_scale * abs(velocity.x) / max_speed
		animated_sprite.play("Run")
	else:
		animated_sprite.play("Idle")

	print(velocity.x,",",velocity.y,",",coyote_timer)
	move_and_slide()

func velocity_x_calc(direction, acceleration, deceleration, delta):
	if enable_accel:
		if direction != 0:
			velocity.x = clamp(velocity.x + direction * acceleration * delta, -max_speed, max_speed)
		else:
			var decel_amount = deceleration * delta
			velocity.x = 0 if abs(velocity.x) - decel_amount < 0 else velocity.x - sign(velocity.x) * decel_amount
	else:
		if direction != 0:
			velocity.x = normal_velocity * direction
		else:
			velocity.x = 0

func velocity_y_calc(gravity, delta, gravity_down):
	velocity.y += gravity * delta if velocity.y < 0 else gravity_down * delta

