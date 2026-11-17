extends Node2D
# Luke — cão do Ren. Segue o dono, late de vez em quando.

var target: Node2D
var level: Node
var spr: AnimatedSprite2D
var _bark := 4.0
var vx := 0.0
var skin := "luke"
# faro: Luke fareja paredes que escondem segredos (mistério do faro dele, doc 13)
var _sniff_target: Node2D
var _sniff_t := 0.0
var _sniff_scan := 0.0
var _sniffed := {}

func _ready() -> void:
	spr = load("res://src/actor_sprite.gd").new()
	var sk := skin if FileAccess.file_exists("res://assets/sprites/%s/%s.json" % [skin, skin]) else "luke"
	spr.setup(sk)
	add_child(spr)
	spr.play_anim("idle")
	z_index = 1

func set_skin(sk: String) -> void:
	skin = sk
	if FileAccess.file_exists("res://assets/sprites/%s/%s.json" % [sk, sk]):
		var f: int = spr.facing
		spr.setup(sk)
		spr.play_anim("idle", true)
		spr.set_facing(f)

func _scan_secrets(dt: float) -> void:
	_sniff_scan -= dt
	if _sniff_scan > 0.0 or _sniff_target != null or level.frozen:
		return
	_sniff_scan = 0.3
	for b in get_tree().get_nodes_in_group("breakable"):
		if not is_instance_valid(b) or _sniffed.has(b) or not (b.get("kind") in ["rachada", "nevoa", "selo"]):
			continue
		if absf(b.global_position.x - global_position.x) < 420.0:
			_sniffed[b] = true
			_sniff_target = b
			_sniff_t = 2.6
			return

func _physics_process(dt: float) -> void:
	if target == null or level == null:
		return
	_scan_secrets(dt)
	if _sniff_target != null:
		if not is_instance_valid(_sniff_target):
			_sniff_target = null
		else:
			_sniff_t -= dt
			var sx: float = _sniff_target.global_position.x - 70.0 * signf(_sniff_target.global_position.x - target.global_position.x + 0.01)
			var sdx := sx - global_position.x
			if absf(sdx) > 20.0 and _sniff_t > 1.6:
				vx = move_toward(vx, signf(sdx) * 520.0, 2400.0 * dt)
				global_position.x += vx * dt
				spr.play_anim("run", false, 1.2)
				spr.set_facing(1 if vx > 0 else -1)
			else:
				vx = 0.0
				spr.play_anim("idle")
				spr.set_facing(1 if _sniff_target.global_position.x > global_position.x else -1)
				spr.position.y = -absf(sin(Time.get_ticks_msec() * 0.02)) * 3.0
				if _sniff_t <= 1.6 and _sniff_t + dt > 1.6:
					Game.sfx("bark", -10.0)
					load("res://src/fx.gd").spawn(level, "text", global_position + Vector2(0, -90), {"txt": "?!", "col": Color(1, 0.9, 0.5), "life": 1.0})
					if not Game.seen("dica_faro"):
						Game.mark("dica_faro")
						level.toast("Luke fareja algo atrás desta parede...")
			if _sniff_t <= 0.0:
				_sniff_target = null
				spr.position.y = 0.0
			return
	var tx: float = target.global_position.x - 90.0 * target.get("facing")
	var dx: float = tx - global_position.x
	if absf(dx) > 900.0:
		global_position.x = tx
		dx = 0.0
	var want := 0.0
	if absf(dx) > 40.0:
		want = signf(dx) * minf(560.0, absf(dx) * 3.0)
	vx = move_toward(vx, want, 2400.0 * dt)
	global_position.x += vx * dt
	var gy: float = level.ground_at(global_position.x)
	if gy > 5000.0:
		gy = target.global_position.y
	global_position.y = move_toward(global_position.y, gy, 1400.0 * dt)
	if absf(vx) > 30.0:
		spr.play_anim("run", false, clampf(absf(vx) / 400.0, 0.7, 1.4))
		spr.set_facing(1 if vx > 0 else -1)
	else:
		spr.play_anim("idle")
		spr.set_facing(1 if target.global_position.x > global_position.x else -1)
	_bark -= dt
	if _bark <= 0.0:
		_bark = randf_range(9.0, 18.0)
		if not level.frozen:
			Game.sfx("bark", -16.0)
