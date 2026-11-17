extends CharacterBody2D
# Ren Arashi — sprite oficial (PixelLab, DEC-017), combo de 3 golpes, poder equipável
# que troca a roupa (estilo Mega Man), agachar, pulo variável, dano e morte.

signal died
signal hp_changed

const SPEED := 430.0
const JUMP_V := -1160.0
const GRAVITY := 2700.0
const FALL_MAX := 1500.0
const W := 44.0
const H_STAND := 138.0
const H_CROUCH := 86.0

var ctl: Node
var level: Node
var spr: AnimatedSprite2D
var mat: ShaderMaterial
var hp := 10
var ki := 40.0
var facing := 1
var state := "normal"        # normal | attack | hurt | dash | dead
var locked := false          # diálogo / cena
var combo := 0
var atk_t := 0.0
var atk_len := 0.3
var atk_from := 0.06
var atk_to := 0.16
var atk_dmg := 1
var atk_kind := "stand"      # stand | low | air
var atk_reach := 150.0
var atk_lunge := 0.0
var queued := false
var combo_window := 0.0
var hit_done := {}
var invuln := 0.0
var hurt_t := 0.0
var dash_t := 0.0
var air_jumps := 0
var crouching := false
var coyote := 0.0
var jump_buf := 0.0
var jade_t := 0.0
var jade_heals := 0
var revived := false
var step_t := 0.0
var was_floor := true
var drop_t := 0.0
var guarding := false
var _last_guard_tap := -10.0
var roll_t := 0.0
var roll_dir := 1
var guard_t := 0.0
var tired_t := 0.0
var _dodged := false
var carmesim := false
var carmesim_t := 0.0        # < 0 = sem limite (cena roteirizada)
var _shape: RectangleShape2D
var _cshape: CollisionShape2D
var _aura: CPUParticles2D

func _ready() -> void:
	collision_layer = 2
	collision_mask = 1 | 4
	floor_snap_length = 12.0
	_cshape = CollisionShape2D.new()
	_shape = RectangleShape2D.new()
	_shape.size = Vector2(W, H_STAND)
	_cshape.shape = _shape
	_cshape.position = Vector2(0, -H_STAND / 2.0)
	add_child(_cshape)
	spr = load("res://src/actor_sprite.gd").new()
	spr.setup("ren")
	mat = ShaderMaterial.new()
	mat.shader = load("res://src/outfit.gdshader")
	spr.material = mat
	add_child(spr)
	spr.play_anim("idle")
	_aura = CPUParticles2D.new()
	_aura.amount = 18
	_aura.lifetime = 0.9
	_aura.emission_shape = CPUParticles2D.EMISSION_SHAPE_RECTANGLE
	_aura.emission_rect_extents = Vector2(26, 60)
	_aura.position = Vector2(0, -70)
	_aura.direction = Vector2(0, -1)
	_aura.spread = 20
	_aura.gravity = Vector2(0, -60)
	_aura.initial_velocity_min = 20
	_aura.initial_velocity_max = 60
	_aura.scale_amount_min = 3
	_aura.scale_amount_max = 5
	_aura.emitting = false
	_aura.show_behind_parent = true
	add_child(_aura)
	add_to_group("player")
	hp = Game.hp_max()
	apply_outfit()

# Poder equipado NÃO muda a cor da roupa (pedido do dono): aparece como aura discreta
# + um elemento: Fúria = mão em chamas; Jade = três contas de jade orbitando.
var _hand_fire: CPUParticles2D
var _orb_t := 0.0

func apply_outfit() -> void:
	var p: String = Game.data["equipado"]
	var info: Dictionary = Game.POWERS[p]
	mat.set_shader_parameter("amount", 0.0)
	mat.set_shader_parameter("cloth", 0.0)
	_aura.amount = 10
	_aura.scale_amount_min = 2
	_aura.scale_amount_max = 3
	_aura.emission_rect_extents = Vector2(30, 70)
	_aura.emitting = p != "" or carmesim
	_aura.color = Color(info["cor"].r, info["cor"].g, info["cor"].b, 0.45)
	if carmesim:
		_aura.amount = 26
		_aura.scale_amount_min = 3
		_aura.scale_amount_max = 6
		_aura.color = Color(1.0, 0.12, 0.18, 0.6)
	if _hand_fire == null:
		_hand_fire = CPUParticles2D.new()
		_hand_fire.amount = 22
		_hand_fire.lifetime = 0.45
		_hand_fire.local_coords = false
		_hand_fire.emission_shape = CPUParticles2D.EMISSION_SHAPE_SPHERE
		_hand_fire.emission_sphere_radius = 6.0
		_hand_fire.direction = Vector2(0, -1)
		_hand_fire.spread = 18
		_hand_fire.gravity = Vector2(0, -260)
		_hand_fire.initial_velocity_min = 20
		_hand_fire.initial_velocity_max = 50
		_hand_fire.scale_amount_min = 3
		_hand_fire.scale_amount_max = 6
		var g := Gradient.new()
		g.set_color(0, Color(1, 0.95, 0.6, 1))
		g.add_point(0.4, Color(1, 0.5, 0.1, 0.9))
		g.set_color(g.get_point_count() - 1, Color(0.6, 0.05, 0.05, 0))
		_hand_fire.color_ramp = g
		_hand_fire.z_index = 1
		add_child(_hand_fire)
	_hand_fire.emitting = p == "furia"
	queue_redraw()

func _process(dt: float) -> void:
	if carmesim and carmesim_t > 0.0 and not locked:
		carmesim_t -= dt
		if carmesim_t <= 0.0:
			set_carmesim(false, 0.0, true)
	if _hand_fire and _hand_fire.emitting:
		var hand := Vector2(facing * 26.0, -96.0)
		if crouching:
			hand.y = -60.0
		_hand_fire.position = hand
	if Game.data["equipado"] == "jade":
		_orb_t += dt
		queue_redraw()

# Ruptura (DEC-022): enche jogando bem — aparo, esquiva no limite, combo completo.
# Quase nada sozinha; levar dano tira. O Sino do Templo acelera os ganhos.
func gain_ki(v: float) -> void:
	if v > 0.0 and Game.has_item("sino"):
		v *= 1.5
	ki = clampf(ki + v, 0.0, 100.0)

func dmg_bonus() -> int:
	return (1 if Game.has_item("fio") else 0) + (2 if carmesim else 0)

func speed() -> float:
	return SPEED * (1.15 if Game.has_item("sandalia") else 1.0) * (1.2 if carmesim else 1.0)

# ---------------- Forma Carmesim ----------------
func set_carmesim(on: bool, dur := 12.0, tire := false) -> void:
	if on == carmesim:
		if on:
			carmesim_t = dur
		return
	carmesim = on
	carmesim_t = dur if on else 0.0
	var an: String = spr.animation
	var fr: int = spr.frame
	spr.setup("ren_carmesim" if on else "ren")
	spr.play_anim(an if spr.has_anim(an) else "idle", true)
	if spr.animation == an:
		spr.frame = mini(fr, spr.sprite_frames.get_frame_count(an) - 1)
	spr.set_facing(facing)
	if tire and not on and state in ["normal", "attack"]:
		# o preço do sangue carmesim: Ren fica ofegante e exposto por um instante
		state = "tired"
		tired_t = 1.5
		guarding = false
		_set_crouch(false)
		spr.play_anim("tired" if spr.has_anim("tired") else "crouch", true)
		level.toast("O sangue carmesim cobra seu preço...")
	Game.flash(Color(1, 0.1, 0.15, 0.7) if on else Color(1, 1, 1, 0.5), 0.35)
	load("res://src/fx.gd").spawn(self, "ring", Vector2(0, -80), {"col": Color(1, 0.15, 0.2) if on else Color(1, 0.95, 0.8), "r": 130.0, "life": 0.5})
	apply_outfit()

func hurt_rect() -> Rect2:
	var h := H_CROUCH if crouching else H_STAND
	return Rect2(global_position + Vector2(-W / 2.0, -h), Vector2(W, h))

func attack_rect() -> Rect2:
	var reach := atk_reach
	var x0 := 6.0 if facing > 0 else -6.0 - reach
	match atk_kind:
		"low": return Rect2(global_position + Vector2(x0, -84), Vector2(reach, 80))
		"air": return Rect2(global_position + Vector2(x0, -165), Vector2(reach, 160))
	if combo == 2:
		return Rect2(global_position + Vector2(x0, -210), Vector2(reach, 200))
	return Rect2(global_position + Vector2(x0, -150), Vector2(reach, 128))

# ---------------- entrada ----------------
func _inp(k: String):
	if locked or ctl == null or state == "dead":
		return 0.0 if k == "move" else false
	return ctl.get(k)

func _physics_process(dt: float) -> void:
	invuln = maxf(0.0, invuln - dt)
	combo_window = maxf(0.0, combo_window - dt)
	drop_t = maxf(0.0, drop_t - dt)
	set_collision_mask_value(3, drop_t <= 0.0)
	if not carmesim:
		gain_ki(1.0 * dt)
	if jade_t > 0.0:
		jade_t -= dt
		queue_redraw()
		if jade_t <= 0.0:
			queue_redraw()
	var on_floor := is_on_floor()
	if on_floor:
		coyote = 0.1
		air_jumps = 1 if Game.has_item("pena") else 0
	else:
		coyote -= dt
	if _inp("jump_pressed"):
		jump_buf = 0.12
	else:
		jump_buf -= dt
	match state:
		"dead":
			velocity.x = move_toward(velocity.x, 0.0, 1500.0 * dt)
			velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
			move_and_slide()
			return
		"hurt":
			hurt_t -= dt
			velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
			velocity.x = move_toward(velocity.x, 0.0, 900.0 * dt)
			move_and_slide()
			spr.play_anim("hurt")
			if hurt_t <= 0.0:
				state = "normal"
			_blink()
			return
		"tired":
			tired_t -= dt
			velocity.x = move_toward(velocity.x, 0.0, 2000.0 * dt)
			velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
			move_and_slide()
			if tired_t <= 0.0:
				state = "normal"
			_blink()
			return
		"roll":
			roll_t -= dt
			velocity.x = roll_dir * 640.0 * (0.4 + 0.6 * clampf(roll_t / 0.4, 0.0, 1.0))
			velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
			move_and_slide()
			spr.play_anim("roll" if spr.has_anim("roll") else "crouch")
			if roll_t <= 0.0:
				state = "normal"
				_set_crouch(false)
				if not _can_stand():
					_set_crouch(true)
			return
		"dash":
			dash_t -= dt
			velocity = Vector2(facing * 1150.0, 0.0)
			move_and_slide()
			_hit_check(4 + dmg_bonus(), Rect2(global_position + Vector2(-70, -150), Vector2(140, 150)), "furia")
			if Engine.get_physics_frames() % 2 == 0:
				var f = load("res://src/fx.gd").spawn(level, "aura", global_position + Vector2(0, -70), {"col": Color(1, 0.4, 0.05), "r": 70.0, "life": 0.3})
			if dash_t <= 0.0:
				state = "normal"
				velocity.x = facing * 300.0
			return
	var dir: float = _inp("move")
	# esquiva: tocar DEFESA duas vezes rápido = rolamento
	if _inp("guard_pressed") and is_on_floor() and state == "normal":
		var now := Time.get_ticks_msec() / 1000.0
		if now - _last_guard_tap < 0.32:
			_start_roll(dir)
			_last_guard_tap = -10.0
			return
		_last_guard_tap = now
	# defesa: segurar DEFESA no chão
	if _inp("guard_down") and is_on_floor() and state == "normal":
		if not guarding:
			guarding = true
			guard_t = 0.0
			_set_crouch(false)
			spr.play_anim("guard", true, 1.6)
		guard_t += dt
		if dir != 0.0 and guard_t < 0.05:
			facing = 1 if dir > 0.0 else -1
			spr.set_facing(facing)
		# anda devagar defendendo, sem virar de costas (recuar mantém a guarda)
		velocity.x = move_toward(velocity.x, dir * speed() * 0.45, 2400.0 * dt)
		velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
		move_and_slide()
		spr.position.y = -absf(sin(Time.get_ticks_msec() * 0.012)) * 3.0 if absf(velocity.x) > 30.0 else 0.0
		_blink()
		return
	guarding = false
	spr.position.y = 0.0
	# agachar
	var want_crouch: bool = _inp("crouch_down") and on_floor
	if want_crouch:
		_set_crouch(true)
	elif crouching and _can_stand():
		_set_crouch(false)
	# ataque
	if _inp("attack_pressed"):
		if level and level.try_interact():
			pass
		elif state == "attack":
			queued = true
		else:
			_start_attack(on_floor)
	if _inp("power_pressed"):
		_use_power()
	if state == "attack":
		atk_t += dt
		var mult := 0.0 if on_floor and atk_kind != "air" else 0.8
		if atk_lunge > 0.0 and atk_t < atk_from + 0.06 and on_floor:
			velocity.x = facing * atk_lunge
		else:
			velocity.x = move_toward(velocity.x, dir * speed() * mult, 3000.0 * dt)
		if atk_t >= atk_from and atk_t <= atk_to:
			_hit_check(atk_dmg, attack_rect(), "katana")
		if atk_t >= atk_len:
			state = "normal"
			combo_window = 0.25
			if queued and combo < COMBO.size():
				queued = false
				_start_attack(is_on_floor())
			else:
				queued = false
	else:
		if dir != 0.0:
			facing = 1 if dir > 0.0 else -1
			spr.set_facing(facing)
		var sp := speed() * (0.4 if crouching else 1.0)
		velocity.x = move_toward(velocity.x, dir * sp, 3400.0 * dt)
	# pulo
	if jump_buf > 0.0 and not crouching and state != "attack":
		if coyote > 0.0:
			_jump()
		elif air_jumps > 0:
			air_jumps -= 1
			_jump()
			load("res://src/fx.gd").spawn(level, "ring", global_position + Vector2(0, -10), {"col": Color(0.6, 0.55, 0.8), "r": 60.0, "life": 0.3})
	elif jump_buf > 0.0 and crouching and on_floor and _on_platform():
		drop_t = 0.25
		jump_buf = 0.0
		position.y += 4
	if not _inp("jump_down") and velocity.y < -300.0:
		velocity.y = -300.0
	velocity.y = minf(velocity.y + GRAVITY * dt, FALL_MAX)
	move_and_slide()
	if is_on_floor() and not was_floor:
		Game.sfx("land", -10.0)
		load("res://src/fx.gd").spawn(level, "dust", global_position, {"r": 60.0, "life": 0.35})
	was_floor = is_on_floor()
	_animate(dt)
	_blink()

func _start_roll(dir: float) -> void:
	state = "roll"
	_dodged = false
	roll_t = 0.4
	guarding = false
	spr.position.y = 0.0
	roll_dir = int(signf(dir)) if dir != 0.0 else facing
	if dir != 0.0:
		facing = roll_dir
		spr.set_facing(facing)
	invuln = maxf(invuln, 0.42)
	_set_crouch(true)
	spr.play_anim("roll" if spr.has_anim("roll") else "crouch", true, 1.6)
	Game.sfx("jump", -6.0, 0.15)
	load("res://src/fxsprite.gd").play(level, "choque", global_position, {"scale_px": 0.9})

func _jump() -> void:
	velocity.y = JUMP_V
	coyote = 0.0
	jump_buf = 0.0
	Game.sfx("jump", -8.0)

func _on_platform() -> bool:
	for i in get_slide_collision_count():
		var c := get_slide_collision(i)
		var o := c.get_collider()
		if o is CollisionObject2D and o.collision_layer & 4:
			return true
	return false

func _set_crouch(v: bool) -> void:
	if v == crouching:
		return
	crouching = v
	var h := H_CROUCH if v else H_STAND
	_shape.size = Vector2(W, h)
	_cshape.position = Vector2(0, -h / 2.0)

func _can_stand() -> bool:
	var q := PhysicsShapeQueryParameters2D.new()
	var r := RectangleShape2D.new()
	r.size = Vector2(W - 4.0, H_STAND - 6.0)
	q.shape = r
	q.collision_mask = 1
	q.transform = Transform2D(0.0, global_position + Vector2(0, -H_STAND / 2.0 - 2.0))
	q.exclude = [get_rid()]
	return get_world_2d().direct_space_state.intersect_shape(q, 1).is_empty()

# Combo de 5 golpes no chão: corte, corte ascendente, estocada, corte rápido, golpe final.
# [animação, velocidade, duração, início do acerto, fim do acerto, dano, alcance, avanço]
const COMBO := [
	["attack", 1.3, 0.27, 0.05, 0.15, 1, 150.0, 0.0],
	["rising", 1.2, 0.26, 0.06, 0.18, 1, 140.0, 120.0],
	["thrust", 1.3, 0.30, 0.07, 0.20, 1, 205.0, 420.0],
	["attack", 1.7, 0.22, 0.04, 0.13, 1, 150.0, 0.0],
	["finisher", 1.0, 0.46, 0.24, 0.36, 3, 190.0, 260.0],
]

func _start_attack(on_floor: bool) -> void:
	combo = combo + 1 if combo_window > 0.0 and combo < COMBO.size() else 1
	state = "attack"
	atk_t = 0.0
	hit_done = {}
	atk_kind = "low" if crouching else ("stand" if on_floor else "air")
	if atk_kind != "stand":
		combo = 1
	var c: Array = COMBO[combo - 1]
	atk_dmg = int(c[5]) + dmg_bonus()
	atk_len = c[2]
	atk_from = c[3]
	atk_to = c[4]
	atk_reach = c[6]
	atk_lunge = c[7] if atk_kind == "stand" else 0.0
	spr.play_anim(c[0] if atk_kind == "stand" else "attack", true, c[1])
	Game.sfx(["slash1", "slash2", "slash3", "slash1", "slash3"][combo - 1], -4.0)
	if combo >= 3:
		Game.sfx("ren_effort", -8.0)
	var col: Color = Game.POWERS[Game.data["equipado"]]["cor"].lightened(0.25)
	var FX = load("res://src/fx.gd")
	if atk_kind == "low":
		FX.spawn(self, "slash", Vector2(facing * 40.0, -40.0), {"dir": facing, "col": col, "r": 100.0, "life": 0.16, "low": true})
	elif atk_kind == "air":
		FX.spawn(self, "slash", Vector2(facing * 40.0, -90.0), {"dir": facing, "col": col, "r": 100.0, "life": 0.16})
	else:
		match combo:
			2: FX.spawn(self, "rise", Vector2(facing * 50.0, -60.0), {"dir": facing, "col": col, "r": 120.0, "life": 0.2})
			3: FX.spawn(self, "thrust", Vector2(facing * 30.0, -92.0), {"dir": facing, "col": col, "r": 200.0, "life": 0.18})
			5: FX.spawn(self, "slash", Vector2(facing * 50.0, -80.0), {"dir": facing, "col": col.lightened(0.2), "r": 165.0, "life": 0.3})
			_: FX.spawn(self, "slash", Vector2(facing * 40.0, -80.0), {"dir": facing, "col": col, "r": 100.0, "life": 0.16})

func _hit_check(dmg: int, rect: Rect2, kind: String) -> void:
	for f in get_tree().get_nodes_in_group("foes"):
		if hit_done.has(f) or not is_instance_valid(f) or not f.has_method("hurt_rect"):
			continue
		if f.get("dead"):
			continue
		if rect.intersects(f.hurt_rect()):
			hit_done[f] = true
			f.take_hit(dmg, facing, kind)
			gain_ki(3.0)
			if combo == COMBO.size() and atk_kind == "stand":
				gain_ki(10.0)
			var c: Rect2 = f.hurt_rect()
			load("res://src/fxsprite.gd").play(level, "acerto" if dmg < 3 else "aparo", Vector2(clampf(rect.get_center().x, c.position.x, c.end.x), rect.get_center().y), {"scale_px": 2.2 if dmg < 3 else 1.8})
			level.hitstop(0.05 if dmg < 3 else 0.11)
			level.shake(4.0 if dmg < 3 else 11.0)
	for b in get_tree().get_nodes_in_group("breakable"):
		if hit_done.has(b):
			continue
		if rect.intersects(b.get_rect()):
			hit_done[b] = true
			b.hit_by(kind)

func _use_power() -> void:
	var p: String = Game.data["equipado"]
	if p == "" or state in ["dash", "hurt", "dead", "tired"]:
		if p == "":
			level.toast("Ainda não tens uma técnica de demônio em mãos.")
		return
	if p == "carmesim" and carmesim:
		return
	var cost: float = Game.POWERS[p]["custo"]
	if ki < cost:
		Game.sfx("ui_back", -6.0)
		level.toast("A Ruptura ainda não basta.")
		return
	ki -= cost
	Game.sfx("power", -2.0)
	match p:
		"furia":
			state = "dash"
			dash_t = 0.26
			hit_done = {}
			invuln = maxf(invuln, 0.35)
			spr.play_anim("attack", true, 1.6)
			level.shake(6.0)
			load("res://src/fx.gd").spawn(self, "slash", Vector2(facing * 50.0, -80.0), {"dir": facing, "col": Color(1, 0.45, 0.05), "r": 150.0, "life": 0.3})
		"carmesim":
			Game.sfx("evil_laugh", -8.0)
			level.shake(10.0)
			set_carmesim(true, 12.0)
		"jade":
			jade_t = 1.8
			jade_heals = 0
			load("res://src/fx.gd").spawn(self, "ring", Vector2(0, -70), {"col": Color(0.2, 0.9, 0.5), "r": 150.0, "life": 0.4})

# chamado pelos projéteis inimigos
func absorbs(p: Vector2) -> bool:
	if jade_t <= 0.0:
		return false
	if p.distance_to(global_position + Vector2(0, -70)) > 150.0:
		return false
	Game.sfx("absorb", -6.0)
	if jade_heals < 3 and hp < Game.hp_max():
		jade_heals += 1
		hp += 1
		hp_changed.emit()
	gain_ki(8.0)
	return true

func _draw() -> void:
	if Game.data["equipado"] == "jade" and state != "dead":
		# três contas de jade orbitando, discretas
		for i in range(3):
			var ang := _orb_t * 2.2 + i * TAU / 3.0
			var c := Vector2(cos(ang) * 42.0, -82.0 + sin(ang) * 14.0)
			var front := sin(ang) > 0.0
			var col := Color(0.25, 0.85, 0.55, 0.95 if front else 0.45)
			draw_circle(c, 7.0, Color(0.05, 0.25, 0.15, col.a))
			draw_circle(c, 5.5, col)
			draw_circle(c + Vector2(-2, -2), 1.8, Color(0.85, 1, 0.9, col.a))
	if jade_t > 0.0:
		var a := clampf(jade_t, 0.0, 0.6)
		draw_circle(Vector2(0, -70), 150.0, Color(0.15, 0.85, 0.5, 0.12 * a / 0.6))
		draw_arc(Vector2(0, -70), 150.0, 0, TAU, 64, Color(0.6, 1.0, 0.75, 0.7 * a / 0.6), 4.0)

func take_damage(n: int, src_x: float, src: Node = null, heavy := false) -> void:
	if state == "roll" and not _dodged and not locked:
		# esquiva no limite: o golpe passou pelo rolamento
		_dodged = true
		gain_ki(15.0)
		Game.sfx("esquiva", -2.0)
		level.hitstop(0.12)
		load("res://src/fx.gd").spawn(level, "text", global_position + Vector2(0, -170), {"txt": "Esquiva perfeita!", "col": Color(0.85, 0.95, 1.0), "life": 0.7})
		return
	if invuln > 0.0 or state == "dead" or locked:
		return
	if guarding and (src_x - global_position.x) * facing >= 0.0:
		var front := global_position + Vector2(facing * 34.0, -78.0)
		if guard_t < 0.2:
			# aparo perfeito: sem custo, inimigo vacila
			Game.sfx("clash", 0.0)
			Game.sfx("hit_big", -6.0)
			load("res://src/fxsprite.gd").play(level, "aparo", front, {"scale_px": 2.0})
			gain_ki(25.0)
			Game.sfx("sino", -2.0, 0.02)
			level.hitstop(0.14)
			level.shake(6.0)
			load("res://src/fx.gd").spawn(level, "ring", front, {"col": Color(1, 0.85, 0.35), "r": 90.0, "life": 0.35})
			level.toast("Aparo perfeito!")
			if src and src.has_method("parried"):
				src.parried()
			invuln = 0.25
			return
		var cost := 20.0 if heavy else 10.0
		if ki >= cost:
			ki -= cost
			Game.sfx("clash", -3.0)
			load("res://src/fxsprite.gd").play(level, "defesa", global_position + Vector2(facing * 22.0, -80.0), {"scale_px": 1.6, "flip": facing < 0})
			velocity.x = -facing * 260.0
			level.shake(3.0)
			invuln = 0.2
			return
		# guarda quebrada: metade do dano
		level.toast("Guarda quebrada!")
		n = int(ceil(n / 2.0))
		guarding = false
	hp -= n
	gain_ki(-10.0)
	if level and level.get("no_death") and hp < 2:
		hp = 2
	hp_changed.emit()
	Game.sfx("ren_hurt", -4.0)
	Game.sfx("hit2", -6.0)
	level.shake(8.0)
	level.hitstop(0.06)
	if hp <= 0:
		if Game.has_item("omamori") and not revived:
			revived = true
			hp = int(Game.hp_max() / 2)
			hp_changed.emit()
			invuln = 2.0
			Game.flash(Color(1, 0.2, 0.25, 0.7), 0.6)
			level.toast("O Omamori Vermelho te protegeu!")
			return
		_die()
		return
	state = "hurt"
	hurt_t = 0.35
	invuln = 1.1
	var away := -1.0 if src_x > global_position.x else 1.0
	velocity = Vector2(away * 420.0, -380.0)
	_set_crouch(false)

func heal(n: int) -> void:
	hp = mini(Game.hp_max(), hp + n)
	hp_changed.emit()

func _die() -> void:
	if carmesim:
		set_carmesim(false)
	hp = 0
	state = "dead"
	# cai de costas no chão (animação própria, sem girar o sprite)
	spr.play_anim("fall" if spr.has_anim("fall") else "hurt", true)
	Game.sfx("ren_death", -2.0)
	var tw := create_tween()
	tw.tween_interval(1.3)
	tw.tween_callback(func(): died.emit())

func _blink() -> void:
	if state == "dead":
		spr.modulate.a = 1.0
		return
	spr.modulate.a = 0.35 if invuln > 0.0 and state != "roll" and int(invuln * 16.0) % 2 == 0 else 1.0

func _animate(dt: float) -> void:
	if state == "dead" or (posing and locked):
		return
	posing = false
	if state == "attack":
		if crouching:
			spr.play_anim("crouch")
			spr.pause()
			spr.frame = 1
		return
	if not is_on_floor():
		spr.play_anim("jump_up" if velocity.y < 0.0 else "jump_down")
	elif crouching:
		spr.play_anim("crouch")
		spr.pause()
		spr.frame = 1 if absf(velocity.x) < 20.0 else (int(Time.get_ticks_msec() / 200) % 2)
	elif absf(velocity.x) > 40.0:
		spr.play_anim("run", false, clampf(absf(velocity.x) / SPEED, 0.6, 1.3))
		step_t -= dt
		if step_t <= 0.0:
			step_t = 0.3
			Game.sfx("step1" if randf() < 0.5 else "step2", -18.0, 0.12)
	else:
		spr.play_anim("idle")

# usado nas cenas roteirizadas: segura a pose até pose("idle")
var posing := false
func pose(an: String) -> void:
	posing = an != "idle"
	spr.play_anim(an, true)
