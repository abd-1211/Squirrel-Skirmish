extends CharacterBody2D
var is_dead := false
var has_hit := false
var chase = false
var SPEED =50
@onready var pla = get_node("../../Player/Player")
var has_hit_player := false

# Called when the node enters the scene tree for the first time.
func _physics_process(delta):
	velocity += get_gravity() * delta
	if chase ==true:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Action")
			
			
		var direction = (pla.global_position - self.global_position).normalized()
		
		if direction.x>0:
				get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
			
		velocity.x = direction.x * SPEED
	else:
		if get_node("AnimatedSprite2D").animation != "Death":
			get_node("AnimatedSprite2D").play("Idle")
		velocity.x=0
	move_and_slide()
	

func _on_playerdetection_body_entered(body):
	if body.name == "Player":
		chase = true
		


func _on_playerdetection_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		chase = false


func _on_playerdetection_2_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		death()
		Game.XP +=5


func _on_playercollisiion_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not has_hit:
		has_hit = true
		Game.playerHP -=3
		body.shake_camera()
		
		death()
			
func death():
	if is_dead:
		return
	is_dead=true
	set_physics_process(false)
	set_process(false)
	velocity=Vector2.ZERO
	collision_layer=0
	collision_mask=0
	for child in get_children():
		if child is CollisionShape2D:
			child.call_deferred("set_disabled",true)
		if child is Area2D:
			child.call_deferred("set_monitoring",false)
			child.call_deferred("set_monitoring",false)
	
	Utils.saveGame()
	chase=false
	get_node("AnimatedSprite2D").play("Death")
	$AudioStreamPlayer2D.play()
	await get_node("AnimatedSprite2D").animation_finished
	self.queue_free()
