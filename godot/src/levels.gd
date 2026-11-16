extends RefCounted
# Dados das fases. Unidades do mundo: personagens ~150 px de altura; chão em GY.
# ground: trechos de chão [x0, x1] (o resto é abismo)
# plats: plataformas atravessáveis [x, y_acima_do_chão, largura]
# blocks: blocos sólidos [x, y_topo_acima_do_chão, largura, altura, estilo]
# foes: [tipo, x] ou [tipo, x, altura]
# prompts: [x, texto] dicas do tutorial
# events: [x, id_do_dialogo]
# breakables: [x, largura, altura, tipo, id]

const GY := 900.0

const L := {
	"ferreiros": {
		"nome": "Prólogo — Distrito dos Ferreiros",
		"bg": "ferreiros", "musica": "fase", "amb": "amb_rain", "particulas": "brasas",
		"chao": Color(0.16, 0.11, 0.10), "borda": Color(0.42, 0.26, 0.18),
		"largura": 6600.0, "inicio": 220.0, "luke_inicio": false,
		"ground": [[0, 3420], [3640, 6600]],
		"plats": [[3240, 190, 300], [3560, 320, 240], [4900, 200, 260]],
		"blocks": [[960, 110, 120, 110, "caixas"], [1560, 300, 360, 188, "viga"], [5300, 150, 140, 150, "caixas"]],
		"foes": [["oni", 2500], ["oni", 2950], ["guarda", 3950], ["oni", 4980, 200], ["guarda", 5600]],
		"prompts": [
			[120, "Deslize o direcional  ◀ ▶  para andar"],
			[700, "PULAR salta. Segure para ir mais alto."],
			[1300, "Uma viga em chamas!  ▼  Agache e passe por baixo."],
			[2150, "ATACAR corta com a katana. Toque 3 vezes seguidas para o combo."],
			[3100, "Plataformas: pule nelas. ▼ + PULAR desce. A katana corta no ar e agachado."],
			[4250, "Algo se mexe nos escombros... Quebre as caixas com a katana."],
		],
		"events": [[60, "intro_ferreiros"], [6000, "baku_prologo"]],
		"breakables": [[4480, 150, 120, "caixa", "luke"]],
		"pickups": [[2800, 60, "cura"], [3680, 380, "ki"]],
	},
	"torii": {
		"nome": "Fase 1 — Vale das Torii",
		"bg": "torii", "musica": "fase", "amb": "amb_water", "particulas": "petalas",
		"chao": Color(0.12, 0.10, 0.13), "borda": Color(0.36, 0.30, 0.34),
		"largura": 8200.0, "inicio": 200.0, "luke_inicio": true,
		"ground": [[0, 1800], [2050, 3600], [3880, 5200], [5420, 8200]],
		"plats": [[1840, 160, 170], [2400, 230, 260], [2800, 380, 260], [3620, 200, 220], [4300, 220, 300], [5240, 180, 160], [5900, 230, 280]],
		"blocks": [[1300, 120, 160, 120, "pedra"], [3200, 140, 180, 140, "pedra"], [6200, 110, 140, 110, "pedra"]],
		"foes": [["guarda", 900], ["oni", 1500], ["oni", 2850, 380], ["guarda", 3000], ["oni", 3400], ["guarda", 4200], ["guarda", 4600], ["oni", 4400, 220], ["oni", 5700], ["guarda", 6000], ["oni", 6400]],
		"prompts": [[150, "Fase 1 — Vale das Torii"]],
		"events": [[40, "intro_torii"]],
		"breakables": [],
		"pickups": [[2850, 470, "cura"], [4350, 300, "ki"], [6500, 60, "cura"]],
		"chefe": "baku", "arena": [6900.0, 8200.0],
	},
	"palacio": {
		"nome": "Fase 2 — Palácio de Xui",
		"bg": "xui", "musica": "fase", "amb": "", "particulas": "incenso",
		"chao": Color(0.10, 0.12, 0.10), "borda": Color(0.62, 0.50, 0.22),
		"largura": 8200.0, "inicio": 200.0, "luke_inicio": true,
		"ground": [[0, 2300], [2560, 4700], [4950, 8200]],
		"plats": [[2330, 200, 200], [1500, 230, 280], [3300, 210, 240], [3700, 400, 240], [4720, 200, 200], [5600, 230, 300]],
		"blocks": [[900, 120, 200, 120, "mesa"], [4200, 130, 220, 130, "mesa"], [6100, 120, 200, 120, "mesa"]],
		"foes": [["servo", 800], ["espirito", 1400, 360], ["servo", 1900], ["servo", 2900], ["espirito", 3500, 400], ["servo", 3900], ["espirito", 4500, 300], ["servo", 5300], ["servo", 5800], ["espirito", 6300, 320], ["servo", 6500]],
		"prompts": [[150, "Fase 2 — Palácio de Xui"], [3950, "Uma parede rachada... só um golpe de fúria a derruba."]],
		"events": [[40, "intro_palacio"]],
		"breakables": [[4000, 200, 300, "rachada", "segredo"]],
		"pickups": [[3750, 480, "cura"], [5650, 340, "ki"], [6700, 60, "cura"]],
		"chefe": "xui", "arena": [6900.0, 8200.0],
	},
	"vila": {
		"nome": "Vila de Arashi",
		"bg": "vila", "musica": "vila", "amb": "amb_rain", "particulas": "chuva",
		"chao": Color(0.13, 0.11, 0.12), "borda": Color(0.40, 0.31, 0.25),
		"largura": 4200.0, "inicio": 300.0, "luke_inicio": true, "hub": true,
		"ground": [[0, 4200]],
		"plats": [],
		"blocks": [],
		"foes": [],
		"prompts": [],
		"events": [[40, "intro_vila"]],
		"breakables": [],
		"pickups": [],
		"npcs": [["tetsu", 900]],
		"portas": [
			[1600, "torii", "Vale das Torii", "Baku — Ira"],
			[2000, "palacio", "Palácio de Xui", "Xui — Gula"],
			[2400, "", "Mosteiro de Wu", "Wu — Preguiça"],
			[2800, "", "Porto de Qinglong", "Kairen — Avareza"],
			[3200, "", "Cidade das Lâminas", "Mei Shian — Inveja"],
			[3600, "", "Zafir, a cidade-miragem", "Shuyin — Luxúria"],
			[4000, "", "Corte da Lua Roxa", "Seiran — Soberba"],
		],
	},
}

# Diálogos: [quem, fala]. Retratos: ren, baku, xui, luke, tetsu.
const D := {
	"intro_ferreiros": [
		["ren", "As famílias trancaram a gente aqui dentro... e o distrito está pegando fogo."],
		["ren", "Luke! Cadê você, parceiro?!"],
	],
	"luke": [
		["luke", "Au! Au!"],
		["ren", "Te achei. Fica colado em mim, Luke. Vamos tirar todo mundo daqui."],
	],
	"baku_prologo": [
		["baku", "Séculos no escuro... e quem abre a jaula é um ferreiro."],
		["ren", "Eu só queria salvar o meu povo."],
		["baku", "Você abriu a jaula, ferreiro. Agora aguente o que saiu."],
	],
	"intro_torii": [
		["ren", "Os guardas das famílias estão caçando o Baku também... ou caçando a mim."],
		["ren", "Tanto faz. Ninguém mais paga pelo que eu abri."],
	],
	"chefe_baku": [
		["baku", "Voltou pra apanhar de novo, ferreiro? Essa marca no seu rosto ainda arde?"],
		["ren", "Arde. E vai me lembrar de te prender de novo."],
		["baku", "Então venha! A Ira não se ajoelha!"],
	],
	"fim_baku": [
		["baku", "Essa marca... nas engrenagens do selo... é marca de ferreiro..."],
		["baku", "Pergunte ao velho... quem forjou a nossa jaula..."],
		["ren", "...O que você quer dizer?"],
	],
	"intro_vila": [
		["tetsu", "Vila de Arashi. Aqui ninguém pergunta de onde você veio, garoto."],
	],
	"tetsu_1": [
		["tetsu", "Então é você o ferreiro que abriu o portão."],
		["ren", "Eu precisava tirar o povo de lá, mestre Tetsu."],
		["tetsu", "Eu sei. Por isso ainda estou falando com você."],
		["tetsu", "Seis demônios andam soltos. Escolha um portal ali adiante e traga a força dele de volta."],
		["tetsu", "E o que você arrancou do Baku é seu agora. Toque no nome do poder, lá em cima, para trocar. Botão PODER para usar."],
	],
	"tetsu_2": [
		["tetsu", "Cada poder que você toma muda você um pouco. Cuidado com o que veste, garoto."],
		["ren", "Mestre... o Baku falou de uma marca de ferreiro no selo."],
		["tetsu", "...Hoje não. Primeiro sobreviva."],
	],
	"tetsu_3": [
		["tetsu", "Dois caídos. As cicatrizes estão subindo pelo seu braço."],
		["tetsu", "Quando arder demais, fique perto do cachorro. Ele sabe o caminho de volta."],
	],
	"intro_palacio": [
		["ren", "Cheiro de banquete... no meio de uma cidade que passa fome."],
	],
	"chefe_xui": [
		["xui", "Um convidado magro! Que desperdício de prato."],
		["xui", "Senta, come. Aqui ninguém passa fome... desde que eu coma primeiro."],
		["ren", "O seu banquete é feito do meu povo."],
	],
	"fim_xui": [
		["xui", "Ainda... estou... com fome..."],
		["ren", "Agora sabe como eles se sentem."],
	],
	"segredo": [
		["ren", "Uma sala escondida... e um fragmento de selo ainda quente."],
	],
}
