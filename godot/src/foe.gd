extends CharacterBody2D
# Base de inimigos e chefes: vida, dano, brilho de acerto, contato, morte.

signal defeated

var level: Node
var spr: AnimatedSprite2D
var mat: ShaderMaterial
var hp := 3
var hp_max := 3
var dead := false
var facing := -1
var contact := 1
var w := 60.0
var h := 130.0
var uses_gravity := true
var knock_mult := 1.0
var flash_t := 0.0
var display_name := ""
var is_boss := false
const GRAVITY := 2700.0

func setup_sprite(set_name: String, first_anim: String) -> void:
	spr = load("res://src/actor_sprite.gd").new()
	spr.setup(set_name)
	mat = ShaderMaterial.new()
	mat.shader = load("res://src/flash.gdshader")
	spr.material = mat
	add_child(spr)
	spr.play_anim(first_anim)
	spr.set_facing(facing)
	collision_layer = 8
	collision_mask = 1 | 4
	var cs := CollisionShape2D.new()
	var rs := RectangleShape2D.new()
	rs.size = Vector2(w, h)
	cs.shape = rs
	cs.position = Vector2(0, -h / 2.0)
	add_child(cs)
	add_to_group("foes")

func hurt_rect() -> Rect2:
	return Rect2(global_position + Vector2(-w / 2.0, -h), Vector2(w, h))

func player() -> Node:
	return level.player if level else null

func face_player() -> void:
	var p := player()
	if p:
		facing = 1 if p.global_position.x > global_position.x else -1
		spr.set_facing(facing)

func dist_x() -> float:
	var p := player()
	return absf(p.global_position.x - global_position.x) if p else 9999.0

func damage_mult() -> float:
	return 1.0

func take_hit(dmg: int, dir: int, _kind: String) -> void:
	if dead:
		return
	var d := int(ceil(dmg * damage_mult()))
	hp -= d
	flash_t = 0.12
	Game.sfx("hit1" if randf() < 0.5 else "hit2", -3.0)
	load("res://src/fx.gd").spawn(level, "text", global_position + Vector2(randf_range(-20, 20), -h - 10), {"txt": str(d), "col": Color(1, 0.85, 0.5) if d < 3 else Color(1, 0.4, 0.2), "life": 0.6})
	if knock_mult > 0.0:
		velocity.x = dir * 320.0 * knock_mult
		if uses_gravity and is_on_floor():
			velocity.y = -200.0 * knock_mult
	if hp <= 0:
		hp = 0
		die()
	else:
		on_hurt()

var stun_t := 0.0

# chamado quando o Ren apara o golpe no instante exato
func parried() -> void:
	stun_t = 0.9
	velocity.x = -facing * 200.0

func on_hurt() -> void:
	pass

func die() -> void:
	dead = true
	remove_from_group("foes")
	Game.sfx("foe_die", -6.0)
	load("res://src/fx.gd").spawn(level, "ring", global_position + Vector2(0, -h / 2.0), {"col": Color(1, 0.3, 0.2), "r": 90.0, "life": 0.4})
	var r := randf()
	if r < 0.28:
		level.spawn_pickup("cura", global_position + Vector2(0, -40))
	elif r < 0.45:
		level.spawn_pickup("ki", global_position + Vector2(0, -40))
	var tw := create_tween()
	tw.tween_property(spr, "modulate", Color(1, 0.3, 0.3, 0.0), 0.4)
	tw.tween_callback(queue_free)
	defeated.emit()

func _physics_process(dt: float) -> void:
	if flash_t > 0.0:
		flash_t -= dt
	mat.set_shader_parameter("flash", 0.85 if flash_t > 0.0 else _telegraph())
	if dead:
		return
	if level == null or level.frozen:
		return
	if stun_t > 0.0:
		stun_t -= dt
		telegraph_t = 0.0
		velocity.x = move_toward(velocity.x, 0.0, 2000.0 * dt)
		if uses_gravity:
			velocity.y = minf(velocity.y + GRAVITY * dt, 1500.0)
		move_and_slide()
		spr.pause()
		if stun_t <= 0.0:
			spr.play()
		return
	ai(dt)
	if uses_gravity:
		velocity.y = minf(velocity.y + GRAVITY * dt, 1500.0)
	move_and_slide()
	var p := player()
	if p and contact > 0 and hurt_rect().grow(-8).intersects(p.hurt_rect()):
		p.take_damage(contact, global_position.x, self)

var telegraph_t := 0.0
func _telegraph() -> float:
	if telegraph_t <= 0.0:
		mat.set_shader_parameter("flash_color", Color(1, 1, 1))
		return 0.0
	mat.set_shader_parameter("flash_color", Color(1, 0.15, 0.1))
	return 0.25 + 0.25 * sin(Time.get_ticks_msec() * 0.03)

func ai(_dt: float) -> void:
	pass

func hit_player(rect: Rect2, dmg: int) -> void:
	var p := player()
	if p and rect.intersects(p.hurt_rect()):
		p.take_damage(dmg, global_position.x, self)

func shoot(pos: Vector2, vel: Vector2, opts := {}) -> Node:
	var s = load("res://src/shot.gd").new()
	s.position = pos
	s.vel = vel
	for k in opts:
		s.set(k, opts[k])
	s.level = level
	level.add_child(s)
	return s
