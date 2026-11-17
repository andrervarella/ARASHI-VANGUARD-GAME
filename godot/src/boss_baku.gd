extends "res://src/foe.gd"
# BAKU — General da Fúria (Ira). Ciclo fixo e legível (docs/10):
# aproxima → 2 cortes (3 na fase 2) com aviso ≥0,4 s → ofegante (vulnerável, dano dobrado)
# longe demais → salto com onda de choque. Fase 2 (≤50%): onda de brasa pelo chão.

var state := "intro"
var t := 0.0
var slashes_left := 2
var phase := 1
var _hit_done := false
var _land_x := 0.0
var _jump_from := Vector2.ZERO
var _cycle := 0
var prologo := false

func _ready() -> void:
	hp = 36
	hp_max = 36
	w = 96
	h = 220
	push_share = 0.8
	knock_mult = 0.0
	is_boss = true
	display_name = "BAKU — General da Fúria"
	setup_sprite("baku", "idle")

func start() -> void:
	state = "idle"
	t = 0.0

func parried() -> void:
	if state in ["slash", "breath", "approach"]:
		state = "tired"
		t = 0.0
		telegraph_t = 0.0
		spr.play_anim("tired" if spr.has_anim("tired") else "idle")

func damage_mult() -> float:
	if prologo:
		return 0.0
	return 2.0 if state == "tired" else 1.0

func on_hurt() -> void:
	if phase == 1 and hp <= hp_max / 2:
		phase = 2
		Game.sfx("baku_laugh", -2.0)
		level.toast("A ira de Baku transborda!")
		level.shake(10.0)
		load("res://src/fx.gd").spawn(level, "ring", global_position + Vector2(0, -120), {"col": Color(1, 0.2, 0.1), "r": 220.0, "life": 0.6})
	elif randf() < 0.3:
		Game.sfx("boss_hurt", -6.0)

func ai(dt: float) -> void:
	t += dt
	match state:
		"intro":
			spr.play_anim("idle")
			velocity.x = 0.0
		"idle":
			spr.play_anim("idle")
			velocity.x = move_toward(velocity.x, 0.0, 2000.0 * dt)
			face_player()
			if t > (0.7 if phase == 1 else 0.45):
				_cycle += 1
				if dist_x() > 520.0 or _cycle % 3 == 0:
					_begin_leap()
				else:
					slashes_left = 2 if phase == 1 else 3
					_begin_approach()
		"approach":
			face_player()
			spr.play_anim("walk")
			velocity.x = facing * (170.0 if phase == 1 else 230.0)
			if dist_x() < 210.0 or t > 1.4:
				_begin_slash()
		"slash":
			velocity.x = move_toward(velocity.x, 0.0, 2000.0 * dt)
			# quadros 0-4: preparo (aviso); 5-6: golpe; 7: recuperação
			telegraph_t = 1.0 if spr.frame <= 4 else 0.0
			if spr.frame == 4 and not _hit_done and t > 0.1:
				velocity.x = facing * 260.0
			if spr.frame in [5, 6] and not _hit_done:
				var r := Rect2(global_position + Vector2(-30 if facing > 0 else -240, -210), Vector2(270, 210))
				var p := player()
				if p and r.intersects(p.hurt_rect()):
					_hit_done = true
					p.take_damage(2, global_position.x, self)
				if spr.frame == 5 and t > 0.05 and not get_meta("swung", false):
					set_meta("swung", true)
					Game.sfx("slash3", 0.0)
					level.shake(5.0)
			if not spr.is_playing() or t > 1.4:
				slashes_left -= 1
				if slashes_left > 0:
					_begin_slash()
				else:
					if phase == 2:
						_ember_wave()
					state = "tired"
					t = 0.0
					Game.sfx("boss_effort", -6.0)
		"tired":
			spr.play_anim("tired")
			velocity.x = 0.0
			if int(t * 4) % 2 == 0 and fmod(t, 0.5) < dt:
				load("res://src/fx.gd").spawn(level, "dust", global_position + Vector2(facing * 30.0, -170), {"r": 50.0, "life": 0.5})
			if t > (1.8 if phase == 1 else 1.3):
				state = "idle"
				t = 0.0
		"landed":
			velocity.x = 0.0
			if t > 0.45:
				state = "idle"
				t = 0.0
		"leap_wind":
			velocity.x = 0.0
			telegraph_t = 1.0
			spr.play_anim("leap_wind")
			if t > 0.5:
				telegraph_t = 0.0
				spr.play_anim("leap_air")
				state = "leap"
				t = 0.0
				var p := player()
				_land_x = clampf(p.global_position.x, level.arena_x0 + 120.0, level.arena_x1 - 120.0)
				var air := 0.75
				velocity = Vector2((_land_x - global_position.x) / air, -0.5 * GRAVITY * air)
				Game.sfx("jump", 0.0)
		"leap":
			if is_on_floor() and t > 0.15:
				state = "landed"
				t = 0.0
				velocity.x = 0.0
				spr.play_anim("land", true)
				Game.sfx("slam", 0.0)
				level.shake(14.0)
				# pisão: cair em cima de Ren é um golpe (com aviso no preparo), não "contato"
				hit_player(Rect2(global_position + Vector2(-w * 0.5 - 20.0, -h * 0.55), Vector2(w + 40.0, h * 0.55)), 2)
				for d in [-1, 1]:
					shoot(global_position + Vector2(d * 60.0, 0), Vector2(d * 520.0, 0), {"kind": "wave", "ground_wave": true, "radius": 26.0, "dmg": 2, "life": 1.4, "col": Color(1, 1, 1), "absorbable": false})
				load("res://src/fxsprite.gd").play(level, "choque", global_position, {"scale_px": 2.6})

func _landed_tick() -> void:
	pass

func _begin_approach() -> void:
	state = "approach"
	t = 0.0

func _begin_slash() -> void:
	state = "slash"
	t = 0.0
	_hit_done = false
	set_meta("swung", false)
	face_player()
	var spd := 1.0 if phase == 1 else 1.25
	spr.play_anim("slash", true, spd)
	if slashes_left == (2 if phase == 1 else 3):
		Game.sfx("boss_effort", -4.0)

func _begin_leap() -> void:
	state = "leap_wind"
	if level.has_method("luke_alert"):
		level.luke_alert()
	t = 0.0

func _ember_wave() -> void:
	shoot(global_position + Vector2(facing * 80.0, 0), Vector2(facing * 600.0, 0), {"kind": "wave", "ground_wave": true, "radius": 30.0, "dmg": 1, "life": 2.0, "col": Color(1, 0.85, 0.7)})
	Game.sfx("power", -6.0)

func die() -> void:
	if dead:
		return
	boss_death_sequence(Color(1.0, 0.35, 0.08))
