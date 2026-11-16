extends "res://src/foe.gd"
# XUI — O Falso Paraíso (Gula). Ciclo: bebe → sopro de vapor (projéteis lentos, a Bocarra
# de Jade engole) → salto com barrigada → ondas de choque nos dois lados (pule!) →
# ofegante (vulnerável, dano dobrado). Fase 2 (≤50%): mais vapor, comida chovendo e
# chama Espíritos do Incenso.

var state := "intro"
var t := 0.0
var phase := 1
var _did := false
var _cycle := 0
var _rain_t := 0.0

func _ready() -> void:
	hp = 44
	hp_max = 44
	w = 130
	h = 190
	contact = 1
	knock_mult = 0.0
	is_boss = true
	display_name = "XUI — O Falso Paraíso"
	setup_sprite("xui", "idle")

func start() -> void:
	state = "idle"
	t = 0.0

func damage_mult() -> float:
	return 2.0 if state == "tired" else 1.0

func on_hurt() -> void:
	if phase == 1 and hp <= hp_max / 2:
		phase = 2
		Game.sfx("xui_laugh", 0.0)
		level.toast("Xui está faminto!")
		level.shake(8.0)

func ai(dt: float) -> void:
	t += dt
	if phase == 2 and state != "intro":
		_rain_t -= dt
		if _rain_t <= 0.0:
			_rain_t = 1.6
			var x := randf_range(level.arena_x0 + 80.0, level.arena_x1 - 80.0)
			shoot(Vector2(x, level.ground_y - 900.0), Vector2(0, 120), {"grav": 900.0, "kind": "food", "radius": 16.0, "dmg": 1, "col": [Color(0.8, 0.2, 0.2), Color(0.9, 0.6, 0.1), Color(0.5, 0.75, 0.2)].pick_random()})
	match state:
		"intro":
			spr.play_anim("idle")
		"idle":
			spr.play_anim("idle")
			face_player()
			velocity.x = move_toward(velocity.x, 0.0, 2000.0 * dt)
			if t > (0.9 if phase == 1 else 0.55):
				_cycle += 1
				t = 0.0
				_did = false
				if _cycle % 2 == 1:
					state = "breath"
					spr.play_anim("breath", true, 1.0)
					Game.sfx("xui_laugh", -6.0)
				else:
					state = "slam_wind"
					spr.play_anim("slam", true, 0.8)
				if phase == 2 and _cycle % 4 == 0 and get_tree().get_nodes_in_group("foes").size() < 4:
					level.spawn_enemy("espirito", global_position.x + randf_range(-300, 300), level.ground_y - 300.0)
		"breath":
			telegraph_t = 1.0 if spr.frame < 4 else 0.0
			if spr.frame >= 5 and not _did:
				_did = true
				var p := player()
				var src := global_position + Vector2(facing * 70.0, -150)
				var base: float = (p.global_position + Vector2(0, -70) - src).angle()
				var n := 3 if phase == 1 else 5
				for i in range(n):
					var ang: float = base + (i - (n - 1) / 2.0) * 0.28
					shoot(src, Vector2(cos(ang), sin(ang)) * 250.0, {"kind": "vapor", "radius": 22.0, "dmg": 1, "life": 3.5, "col": Color(0.6, 0.82, 0.3)})
				Game.sfx("whisper", -6.0)
			if not spr.is_playing() or t > 1.6:
				telegraph_t = 0.0
				state = "idle"
				t = 0.0
		"slam_wind":
			telegraph_t = 1.0
			velocity.x = 0.0
			if spr.frame > 1:
				spr.pause()
			if t > 0.5:
				telegraph_t = 0.0
				state = "slam_air"
				t = 0.0
				var p := player()
				var lx := clampf(p.global_position.x, level.arena_x0 + 150.0, level.arena_x1 - 150.0)
				var air := 0.8
				velocity = Vector2((lx - global_position.x) / air, -0.5 * GRAVITY * air)
				Game.sfx("boss_effort", -2.0)
		"slam_air":
			spr.pause()
			if is_on_floor() and t > 0.15:
				velocity.x = 0.0
				spr.frame = 3
				spr.play()
				Game.sfx("slam", 2.0)
				level.shake(16.0)
				for d in [-1, 1]:
					shoot(global_position + Vector2(d * 80.0, 0), Vector2(d * 480.0, 0), {"kind": "wave", "ground_wave": true, "radius": 28.0, "dmg": 2, "life": 1.6, "col": Color(0.75, 0.25, 0.35), "absorbable": false})
				load("res://src/fx.gd").spawn(level, "wave", global_position, {"r": 240.0, "col": Color(0.9, 0.5, 0.3), "life": 0.45})
				state = "tired"
				t = 0.0
		"tired":
			if not spr.is_playing() or spr.animation != "slam":
				spr.play_anim("idle", false, 0.35)
			if t > (2.0 if phase == 1 else 1.5):
				state = "idle"
				t = 0.0

func die() -> void:
	dead = true
	remove_from_group("foes")
	telegraph_t = 0.0
	Game.sfx("boss_death", 0.0)
	level.shake(16.0)
	for s in get_tree().get_nodes_in_group("enemy_shot"):
		s.queue_free()
	var tw := create_tween()
	for i in range(6):
		tw.tween_callback(func():
			load("res://src/fx.gd").spawn(level, "spark", global_position + Vector2(randf_range(-70, 70), randf_range(-180, -30)), {"r": 90.0, "col": Color(0.6, 1, 0.4)})
			Game.sfx("hit_big", -4.0))
		tw.tween_interval(0.22)
	tw.tween_property(spr, "modulate", Color(0.4, 1, 0.5, 0.0), 1.0)
	tw.tween_callback(func(): defeated.emit())
