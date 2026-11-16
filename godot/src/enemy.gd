extends "res://src/foe.gd"
# Inimigos comuns. kind: guarda | oni | servo | espirito

var kind := "guarda"
var home_x := 0.0
var state := "patrol"
var t := 0.0
var cd := 0.0
var _hit_done := false
var _bob := 0.0

func _ready() -> void:
	home_x = position.x
	match kind:
		"guarda":
			hp = 4; w = 54; h = 140; contact = 1
			setup_sprite("guarda", "walk")
		"oni":
			hp = 3; w = 50; h = 112; contact = 1
			setup_sprite("oni", "walk")
		"servo":
			hp = 5; w = 56; h = 128; contact = 1
			setup_sprite("servo", "walk")
		"espirito":
			hp = 2; w = 50; h = 110; contact = 1
			uses_gravity = false
			knock_mult = 0.6
			setup_sprite("espirito", "float")
			collision_mask = 0
			spr.modulate = Color(1, 1, 1, 0.85)
	hp_max = hp
	cd = randf_range(0.5, 1.5)

func _anim_attack() -> String:
	return "attack" if spr.has_anim("attack") else "walk"

func ai(dt: float) -> void:
	t += dt
	cd -= dt
	var p := player()
	if p == null:
		return
	var dx: float = p.global_position.x - global_position.x
	var dy: float = p.global_position.y - global_position.y
	var near := absf(dx) < 620.0 and absf(dy) < 260.0
	if state == "patrol" and near:
		state = "chase"
		Game.sfx("foe_alert", -14.0)
	match kind:
		"guarda": _guarda(dt, dx, near)
		"oni": _oni(dt, dx, near)
		"servo": _servo(dt, dx, near)
		"espirito": _espirito(dt, dx, dy)

func _walk_to(target_vx: float, dt: float) -> void:
	velocity.x = move_toward(velocity.x, target_vx, 900.0 * dt)
	if absf(target_vx) > 5.0:
		facing = 1 if target_vx > 0 else -1
		spr.set_facing(facing)
		spr.play_anim("walk")
	else:
		spr.play_anim("walk")
		spr.pause()

func _patrol(dt: float) -> void:
	if absf(position.x - home_x) > 160.0:
		facing = 1 if home_x > position.x else -1
	_walk_to(facing * 70.0, dt)
	if is_on_wall():
		facing = -facing

func _guarda(dt: float, dx: float, near: bool) -> void:
	match state:
		"patrol": _patrol(dt)
		"chase":
			if not near:
				state = "patrol"
				return
			if absf(dx) > 150.0:
				_walk_to(signf(dx) * 130.0, dt)
			else:
				face_player()
				_walk_to(0.0, dt)
				if cd <= 0.0:
					state = "windup"
					t = 0.0
					telegraph_t = 0.45
					spr.play_anim(_anim_attack(), true, 0.6)
		"windup":
			velocity.x = move_toward(velocity.x, 0.0, 1200.0 * dt)
			telegraph_t -= dt
			if t >= 0.45:
				state = "strike"
				t = 0.0
				_hit_done = false
				velocity.x = facing * 380.0
				Game.sfx("slash2", -8.0)
				spr.play_anim(_anim_attack(), false, 1.6)
		"strike":
			velocity.x = move_toward(velocity.x, 0.0, 1400.0 * dt)
			if not _hit_done and t < 0.22:
				var r := Rect2(global_position + Vector2(0 if facing > 0 else -180, -110), Vector2(180, 60))
				var pl := player()
				if pl and r.intersects(pl.hurt_rect()):
					_hit_done = true
					pl.take_damage(2, global_position.x)
			if t > 0.5:
				state = "chase"
				cd = randf_range(1.0, 1.6)

func _oni(dt: float, dx: float, near: bool) -> void:
	match state:
		"patrol": _patrol(dt)
		"chase":
			if not near:
				state = "patrol"
				return
			var want := 0.0
			if absf(dx) > 420.0:
				want = signf(dx) * 110.0
			elif absf(dx) < 220.0:
				want = -signf(dx) * 90.0
			_walk_to(want, dt)
			face_player()
			if cd <= 0.0:
				state = "windup"
				t = 0.0
				telegraph_t = 0.4
				spr.play_anim(_anim_attack(), true, 0.9)
		"windup":
			velocity.x = 0.0
			telegraph_t -= dt
			if t >= 0.4:
				var p := player()
				var tgt: Vector2 = p.global_position + Vector2(0, -60)
				var src := global_position + Vector2(facing * 30.0, -95)
				var tt := 0.85
				var v := Vector2((tgt.x - src.x) / tt, (tgt.y - src.y - 0.5 * 1400.0 * tt * tt) / tt)
				shoot(src, v, {"grav": 1400.0, "kind": "ember", "radius": 14.0, "dmg": 1})
				Game.sfx("power", -14.0)
				state = "chase"
				cd = randf_range(2.0, 2.8)

func _servo(dt: float, dx: float, near: bool) -> void:
	match state:
		"patrol": _patrol(dt)
		"chase":
			if not near:
				state = "patrol"
				return
			if absf(dx) > 120.0:
				_walk_to(signf(dx) * 150.0, dt)
			else:
				face_player()
				_walk_to(0.0, dt)
				if cd <= 0.0:
					state = "windup"
					t = 0.0
					telegraph_t = 0.5
					spr.play_anim(_anim_attack(), true, 0.55)
		"windup":
			velocity.x = 0.0
			telegraph_t -= dt
			if t >= 0.5:
				state = "strike"
				t = 0.0
				_hit_done = false
				Game.sfx("slash3", -8.0)
				spr.play_anim(_anim_attack(), false, 1.5)
		"strike":
			if not _hit_done and t < 0.2:
				var r := Rect2(global_position + Vector2(0 if facing > 0 else -150, -130), Vector2(150, 130))
				var pl := player()
				if pl and r.intersects(pl.hurt_rect()):
					_hit_done = true
					pl.take_damage(2, global_position.x)
			if t > 0.55:
				state = "chase"
				cd = randf_range(1.1, 1.7)

func _espirito(dt: float, dx: float, dy: float) -> void:
	_bob += dt
	spr.play_anim("float")
	if state == "patrol":
		position.y = position.y + sin(_bob * 2.0) * 0.6
		return
	var target := Vector2(dx, dy - 70.0)
	var v := target.normalized() * 120.0 if target.length() > 10.0 else Vector2.ZERO
	velocity = velocity.move_toward(v, 300.0 * dt)
	velocity.y += sin(_bob * 3.0) * 40.0 * dt * 10.0
	if absf(dx) > 5.0:
		facing = 1 if dx > 0 else -1
		spr.set_facing(facing)
