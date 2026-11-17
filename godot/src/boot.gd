extends Node
# Cena inicial. Para testes: godot -- --go level torii  |  --go story abertura

func _ready() -> void:
	var a := OS.get_cmdline_user_args()
	var i := a.find("--go")
	if i != -1 and a.size() > i + 2:
		if a.has("--power"):
			Game.data["poderes"] = ["furia", "jade", "carmesim"]
			Game.data["equipado"] = a[a.find("--power") + 1]
		if a.has("--resgatados"):
			Game.data["resgatados"] = ["torii:jaula_1", "torii:jaula_2", "torii:jaula_3", "palacio:jaula_1", "palacio:jaula_2", "palacio:jaula_3"]
		if a.has("--x"):
			Game.data["cp"] = {"fase": a[i + 2], "x": float(a[a.find("--x") + 1])}
		Game.goto.call_deferred(a[i + 1], a[i + 2])
		if a.has("--testcarmesim"):
			_test_carmesim()
		if a.has("--testcurativo"):
			_test_curativo()
		if a.has("--halfboss"):
			_half_boss_later()
		if a.has("--killboss"):
			_kill_boss_later(16.0 if a.has("--halfboss") else 4.0)
	else:
		Game.goto.call_deferred("title")

# teste: derruba o chefe alguns segundos depois de a arena começar
func _half_boss_later() -> void:
	await get_tree().create_timer(4.0).timeout
	for f in get_tree().get_nodes_in_group("foes"):
		if f.get("is_boss"):
			f.take_hit(int(f.hp - f.hp_max / 2), 1, "teste")

func _kill_boss_later(t := 4.0) -> void:
	await get_tree().create_timer(t).timeout
	for f in get_tree().get_nodes_in_group("foes"):
		if f.get("is_boss"):
			f.take_hit(999, 1, "teste")

# teste: Forma Carmesim curta (2 s) para ver o cansaço ao terminar
func _test_carmesim() -> void:
	await get_tree().create_timer(2.5).timeout
	for p in get_tree().get_nodes_in_group("player"):
		p.set_carmesim(true, 2.0)


# teste: pula a luta com o soldado do cão e mostra o curativo do Luke
func _test_curativo() -> void:
	await get_tree().create_timer(1.0).timeout
	var lv = null
	for n in get_tree().root.find_children("*", "Node2D", true, false):
		if n.has_method("_cao_scene"):
			lv = n
			break
	if lv:
		lv._fence_wall.queue_free() if lv._fence_wall else null
		lv._fence_wall = null
		lv.player.global_position.x = 2200.0
		await lv._cao_scene()
		await get_tree().create_timer(0.5).timeout
		for f in get_tree().get_nodes_in_group("foes"):
			f.take_hit(999, 1, "teste")
