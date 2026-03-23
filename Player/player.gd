extends CharacterBody2D
var is_dead:=false
var is_running:=false
const SPEED = 300.0
const JUMP_VELOCITY = -400.0
@onready var anim = get_node("AnimatedSprite2D")
@onready var camera := $Camera2D
var shake_strength = 0.0

func shake_camera(intensity := 6.0, duration := 0.15):
	shake_strength = intensity
	var tween = get_tree().create_tween()
	tween.tween_property(self,"shake_strength",0.0,duration)

func _process(delta):
	if shake_strength >=0:
		camera.offset = Vector2(
			randf_range(-shake_strength,shake_strength),
			randf_range(-shake_strength,shake_strength)
		)
	else:
		camera.offset= Vector2.ZERO

func _physics_process(delta: float) -> void:
	

	# Add the gravity.
	if not is_on_floor():
		if is_running:
			is_running = false
			$Running.stop()
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		anim.play("Jump")
		$Running.stop()
		$Jumping.play()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction ==-1:
		get_node("AnimatedSprite2D").flip_h = true
	elif direction == 1:
		get_node("AnimatedSprite2D").flip_h = false
	if direction:
		velocity.x = direction * SPEED
		if velocity.y == 0:
			anim.play("Run")
			if is_running==false:
				is_running = true
				$Running.play()
				
			
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if velocity.y == 0:
			anim.play("Idle")
		is_running=false
		$Running.stop()
	move_and_slide()
	
	if Game.playerHP<=0 and not is_dead:
		is_dead=true
		get_tree().change_scene_to_file("res://main.tscn")
	
