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
var contact := 0            # KOF (DEC-025): encostar não fere; só golpes ferem
var push_share := 0.5       # quanto do empurrão o jogador sofre (chefes são mais pesados)
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
	if damage_mult() <= 0.0:
		# imune (Baku no prólogo): a lâmina ricocheteia
		Game.sfx("clash", -4.0)
		load("res://src/fxsprite.gd").play(level, "aparo", global_position + Vector2(-dir * w * 0.4, -h * 0.55), {"scale_px": 1.4})
		load("res://src/fx.gd").spawn(level, "text", global_position + Vector2(0, -h - 10), {"txt": "IMUNE", "col": Color(0.85, 0.85, 0.9), "life": 0.6})
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
		_push_bodies()
		return
	ai(dt)
	if uses_gravity:
		velocity.y = minf(velocity.y + GRAVITY * dt, 1500.0)
	move_and_slide()
	_push_bodies()

# Caixas de empurrão (estilo KOF): corpos não se atravessam, mas encostar não causa dano.
# O rolamento passa por baixo do inimigo; pulos passam por cima.
func _push_bodies() -> void:
	var p := player()
	if p == null or dead or not uses_gravity:
		return
	if p.state in ["roll", "dead"] or p.locked:
		return
	if absf(global_position.y - p.global_position.y) > 60.0:
		return
	var dx: float = p.global_position.x - global_position.x
	var ov: float = (w * 0.5 + p.W * 0.5 - 8.0) - absf(dx)
	if ov <= 0.0:
		return
	var dir: float = signf(dx) if absf(dx) > 1.0 else float(-p.facing)
	var mp: float = ov * push_share
	var motion := Vector2(dir * mp, 0.0)
	if p.test_move(p.global_transform.translated(Vector2(0, -2)), motion):
		mp = 0.0
	else:
		p.global_position.x += dir * mp
	var mf: float = ov - mp
	if mf > 0.0 and not test_move(global_transform.translated(Vector2(0, -2)), Vector2(-dir * mf, 0.0)):
		global_position.x -= dir * mf

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


# Morte de chefe: câmera lenta, explosões pelo corpo, o selo reabsorve o demônio
# (rastro de luz) e o corpo se desfaz em brasas. Vaga para cutscene futura: "fim_<chefe>".
func boss_death_sequence(col: Color) -> void:
	dead = true
	remove_from_group("foes")
	telegraph_t = 0.0
	velocity = Vector2.ZERO
	for s in get_tree().get_nodes_in_group("enemy_shot"):
		s.queue_free()
	Game.stop_music()
	Game.sfx("boss_death", 0.0)
	Game.flash(Color(1, 1, 1, 0.9), 0.5)
	Engine.time_scale = 0.35
	level.shake(18.0)
	spr.pause()
	var base := spr.position
	var FS = load("res://src/fxsprite.gd")
	for i in range(8):
		spr.position = base + Vector2(randf_range(-6, 6), randf_range(-3, 3))
		flash_t = 0.07 if i % 2 == 0 else 0.0
		FS.play(level, "aparo" if i % 2 == 0 else "acerto", global_position + Vector2(randf_range(-w * 0.6, w * 0.6), randf_range(-h, -20)), {"scale_px": 2.6, "tint": col.lightened(0.3)})
		Game.sfx("hit_big", -4.0)
		await get_tree().create_timer(0.14, true, false, true).timeout
	Engine.time_scale = 1.0
	spr.position = base
	FS.play(level, "choque", global_position, {"scale_px": 3.4, "tint": col.lightened(0.4)})
	level.shake(22.0)
	Game.sfx("impact", 0.0)
	# o corpo se desfaz
	var dm := ShaderMaterial.new()
	dm.shader = load("res://src/dissolve.gdshader")
	dm.set_shader_parameter("edge_color", col)
	spr.material = dm
	var embers := CPUParticles2D.new()
	embers.amount = 70
	embers.lifetime = 1.6
	embers.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	embers.emission_rect_extents = Vector2(w * 0.6, h * 0.5)
	embers.position = Vector2(0, -h * 0.5)
	embers.direction = Vector2(0, -1)
	embers.spread = 30
	embers.gravity = Vector2(0, -120)
	embers.initial_velocity_min = 40
	embers.initial_velocity_max = 140
	embers.scale_amount_min = 3
	embers.scale_amount_max = 7
	embers.color = col
	embers.z_index = 21
	add_child(embers)
	var tw := create_tween()
	tw.tween_method(func(v): dm.set_shader_parameter("progress", v), 0.0, 1.15, 2.2)
	await get_tree().create_timer(0.9).timeout
	# a essência volta para o selo
	load("res://src/fx.gd").spawn(level, "streak", global_position + Vector2(0, -h * 0.6), {"r": -PI / 2.0, "col": col, "life": 1.4})
	Game.sfx("chains", -2.0)
	await tw.finished
	embers.emitting = false
	await get_tree().create_timer(0.8).timeout
	defeated.emit()
