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
		"bg_chao": 0.896,
		"nevoa_chao": Color(0.28, 0.09, 0.05),
		"nome": "Prólogo — Cidade de Arashi",
		"bg": "ferreiros", "musica": "fase", "amb": "amb_rain", "particulas": "brasas",
		"chao": Color(0.16, 0.11, 0.10), "borda": Color(0.42, 0.26, 0.18),
		"largura": 6600.0, "inicio": 260.0, "luke_inicio": false,
		"ground": [[0, 3420], [3640, 6600]],
		"plats": [[3240, 190, 300], [3560, 320, 240], [4900, 200, 260]],
		"blocks": [[1560, 300, 360, 188, "viga"]],
		# a cidade de Arashi: fachadas, barracas e lanternas atrás do caminho (só cenário)
		"decor": [["casa", 760, 560], ["barris", 1260, 150], ["barraca", 2200, 235], ["cerca", 2900, 100], ["carroca", 3260, 135], ["casa", 4000, 560], ["forja", 4560, 265], ["barris", 4950, 150], ["barraca", 5250, 235], ["barraca", 5620, 235], ["cerca", 5880, 100]],
		"foes": [["oni", 3150], ["guarda", 3950], ["oni", 4980, 200], ["guarda", 4600]],
		"prompts": [
			[140, "Deslize o direcional  ◀ ▶  para andar"],
			[700, "PULAR salta. Segure para ir mais alto."],
			[1300, "Um telhado em chamas!  ▼  Agache e passe por baixo."],
			[1950, "ATACAR corta com a katana. Toque várias vezes: são 5 golpes em sequência."],
			[3050, "Pule nas plataformas. ▼ + PULAR desce delas. A katana também corta no ar e agachado."],
			[4150, "Toque DEFESA duas vezes para rolar e escapar de um golpe."],
			[5000, "Segure DEFESA para bloquear, e ande enquanto defende. No instante exato do golpe, o inimigo vacila."],
		],
		"events": [[40, "intro_ferreiros"], [2150, "cao"], [5800, "portao"]],
		"portao_x": 6250.0,
		"breakables": [[900, 120, 110, "caixa", "caixa_1"], [3080, 120, 110, "caixa", "caixa_2"], [5250, 140, 150, "caixa", "caixa_3"]],
		"pickups": [[2800, 60, "cura"], [3680, 380, "ki"], [5500, 60, "cura"]],
	},
	"torii": {
		"bg_chao": 0.857,
		"nevoa_chao": Color(0.22, 0.05, 0.12),
		"nome": "Fase 1 — Vale das Torii",
		"bg": "torii", "musica": "fase", "amb": "amb_water", "particulas": "petalas",
		"chao": Color(0.12, 0.10, 0.13), "borda": Color(0.36, 0.30, 0.34),
		"largura": 8200.0, "inicio": 200.0, "luke_inicio": true,
		"ground": [[0, 1800], [2050, 3600], [3880, 5200], [5420, 8200]],
		"plats": [[1840, 160, 170], [2400, 230, 260], [2800, 380, 260], [3620, 200, 220], [4300, 220, 300], [5240, 180, 160], [5900, 230, 280], [6200, 300, 380]],
		"blocks": [[1300, 120, 160, 120, "pedra"], [3200, 140, 180, 140, "pedra"], [6200, 110, 140, 110, "pedra"]],
		"foes": [["guarda", 900], ["oni", 1500], ["oni", 2850, 380], ["guarda", 3000], ["oni", 3400], ["guarda", 4200], ["guarda", 4600], ["oni", 4400, 220], ["oni", 5700], ["guarda", 6000], ["oni", 6400]],
		"prompts": [[150, "Fase 1 — Vale das Torii"]],
		"events": [[40, "intro_torii"]],
		"breakables": [[6250, 100, 520, "nevoa", "nevoa", 300], [2300, 110, 100, "caixa", "caixa_1"], [4700, 110, 100, "caixa", "caixa_2"], [1640, 90, 120, "jaula", "jaula_1"], [2620, 90, 120, "jaula", "jaula_2"], [6680, 90, 120, "jaula", "jaula_3"]],
		"pickups": [[2850, 470, "cura"], [4350, 300, "ki"], [6500, 60, "cura"], [6470, 300, "vida"]],
		"altares": [5480.0],
		# ritmo: começo leve, emboscada no meio (pico), respiro com o altar, trecho final, chefe
		"emboscadas": [{"x": 4300.0, "x0": 3920.0, "x1": 5180.0, "ondas": [[["guarda", 4950], ["oni", 4000]], [["oni", 4980, 0, "salto"], ["guarda", 3990]]]}],
		"decor": [["santuario_quebrado", 1150, 190], ["espadas_quebradas", 3300, 120], ["santuario_quebrado", 5650, 190], ["espadas_quebradas", 6800, 120]],
		# arranjos sorteados; "salto" = oni que ensina a pergunta de Baku
		"arranjos": [
			[["guarda", 900], ["oni", 1500, 0, "salto"], ["oni", 2850, 380], ["guarda", 3000], ["oni", 3400, 0, "salto"], ["guarda", 4200], ["guarda", 4600], ["oni", 4400, 220], ["oni", 5750, 0, "salto"], ["guarda", 6000], ["oni", 6400]],
			[["oni", 900], ["guarda", 1500], ["oni", 2850, 380], ["oni", 3100, 0, "salto"], ["guarda", 3450], ["oni", 4200, 0, "salto"], ["guarda", 4650], ["oni", 4400, 220], ["guarda", 5750], ["oni", 6000, 0, "salto"], ["guarda", 6450]],
		],
		"chefe": "baku", "arena": [7000.0, 8150.0],
	},
	"palacio": {
		"bg_chao": 0.812,
		"nevoa_chao": Color(0.22, 0.13, 0.06),
		"nome": "Fase 2 — Palácio de Xui",
		"bg": "xui", "musica": "fase", "amb": "", "particulas": "incenso",
		"chao": Color(0.10, 0.12, 0.10), "borda": Color(0.62, 0.50, 0.22),
		"largura": 8200.0, "inicio": 200.0, "luke_inicio": true,
		"ground": [[0, 2300], [2560, 4700], [4950, 8200]],
		"plats": [[2330, 200, 200], [1500, 230, 280], [3300, 210, 240], [3700, 400, 240], [4720, 200, 200], [5600, 230, 300], [5920, 300, 380]],
		# mesas de banquete na altura real (~0,85 m)
		"blocks": [[900, 78, 220, 78, "mesa"], [4200, 78, 240, 78, "mesa"], [6100, 78, 220, 78, "mesa"]],
		"foes": [["servo", 800], ["espirito", 1400, 360], ["servo", 1900], ["servo", 2900], ["espirito", 3500, 400], ["servo", 3900], ["espirito", 4500, 300], ["servo", 5300], ["servo", 5800], ["espirito", 6300, 320], ["servo", 6500]],
		"prompts": [[150, "Fase 2 — Palácio de Xui"], [3950, "Uma parede rachada... só um golpe de fúria a derruba."]],
		"events": [[40, "intro_palacio"]],
		"breakables": [[4000, 200, 300, "rachada", "segredo"], [5970, 100, 520, "selo", "selo_carmesim", 300], [2150, 90, 120, "jaula", "jaula_1"], [3550, 90, 120, "jaula", "jaula_2"], [6650, 90, 120, "jaula", "jaula_3"]],
		"pickups": [[3750, 480, "cura"], [5650, 340, "ki"], [6700, 60, "cura"], [6220, 300, "vida"]],
		"altares": [5050.0],
		"emboscadas": [{"x": 2900.0, "x0": 2600.0, "x1": 3480.0, "ondas": [[["servo", 3380], ["servo", 2680, 0, "arremesso"]], [["espirito", 3000, 300], ["servo", 3400]]]}],
		# a Gula contada pelo cenário: servos famintos acorrentados ao lado do banquete
		"decor": [["servo_acorrentado", 700, 110], ["servo_acorrentado", 1250, 110], ["servo_acorrentado", 4380, 110], ["servo_acorrentado", 6300, 110]],
		# arranjos sorteados; "arremesso" = servo que ensina a Bocarra de Jade antes de Xui
		"arranjos": [
			[["servo", 800], ["espirito", 1400, 360], ["servo", 1900, 0, "arremesso"], ["servo", 2900], ["espirito", 3500, 400], ["servo", 3900, 0, "arremesso"], ["espirito", 4500, 300], ["servo", 5300], ["servo", 5800, 0, "arremesso"], ["espirito", 6300, 320], ["servo", 6500]],
			[["servo", 800, 0, "arremesso"], ["espirito", 1400, 360], ["servo", 1900], ["servo", 2900, 0, "arremesso"], ["servo", 3250], ["espirito", 4500, 300], ["servo", 3900], ["servo", 5300, 0, "arremesso"], ["espirito", 5800, 330], ["servo", 6300], ["servo", 6550, 0, "arremesso"]],
		],
		"chefe": "xui", "arena": [7050.0, 8150.0],
	},
	"memoria": {
		"bg_chao": 0.896,
		"nevoa_chao": Color(0.30, 0.06, 0.05),
		"nome": "Memória — a noite do portão",
		"bg": "ferreiros", "chao_de": "ferreiros", "musica": "vila", "amb": "amb_rain", "particulas": "brasas",
		"chao": Color(0.16, 0.11, 0.10), "borda": Color(0.42, 0.26, 0.18),
		"largura": 3800.0, "inicio": 200.0, "luke_inicio": false, "memoria": true,
		"ground": [[0, 3800]],
		"plats": [], "blocks": [],
		"decor": [["casa", 900, 560], ["barraca", 1700, 235], ["casa", 2500, 560], ["forja", 3000, 265]],
		"foes": [],
		"prompts": [[120, "Uma lembrança... siga em frente."]],
		"events": [[650, "memoria_1"], [1500, "memoria_2"], [2350, "memoria_3"], [3050, "memoria_porta"]],
		"portao_x": 3450.0,
		"breakables": [], "pickups": [],
	},
	"vila": {
		"bg_chao": 0.896,
		"nevoa_chao": Color(0.12, 0.1, 0.15),
		"nome": "Refúgio de Arashi",
		"bg": "refugio", "musica": "vila", "amb": "amb_rain", "particulas": "chuva",
		"chao": Color(0.13, 0.11, 0.12), "borda": Color(0.40, 0.31, 0.25),
		"largura": 4800.0, "inicio": 300.0, "luke_inicio": true, "hub": true,
		"ground": [[0, 4800]],
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
			[2080, "palacio", "Palácio de Xui", "Xui — Gula"],
			[2560, "", "Mosteiro de Wu", "Wu — Preguiça"],
			[3040, "", "Porto de Qinglong", "Kairen — Avareza"],
			[3520, "", "Cidade das Lâminas", "Mei Shian — Inveja"],
			[4000, "", "Zafir, a cidade-miragem", "Shuyin — Luxúria"],
			[4480, "", "Corte da Lua Roxa", "Seiran — Soberba"],
		],
	},
}

# Diálogos: [quem, fala]. Retratos: ren, baku, xui, luke, tetsu. Linguagem épica (DEC-019).
const D := {
	"intro_ferreiros": [
		["ren", "A marca do sacrifício... na testa de cada um de nós. As Sete Casas venderam Arashi inteira ao selo da Ira."],
		["luke", "Au! Au! Au!"],
		["ren", "Esse cão... late para a cerca desde que nos trancaram aqui. Como se quisesse me mostrar alguma coisa."],
		["ren", "A madeira está podre bem onde ele late. Pequeno, tu viste o que nenhum de nós viu."],
		["ren", "Meu pai ergueu a muralha desta cidade. Se alguém sabe abrir aqueles portões por dentro, sou eu."],
	],
	"cao": [
		["guarda", "Gente ou cachorro, tanto faz! O selo não escolhe a carne. Esta noite até os vira-latas sangram por ele. Quieto, sarnento!"],
		["luke", "Caim! Caim!... (o cãozinho chora, encolhido no chão)"],
		["ren", "Solta o animal, soldado."],
		["guarda", "Um marcado fora da praça? Melhor ainda. O selo não se importa se a oferenda chega inteira."],
	],
	"amizade_1": [
		["ren", "Pronto, pequeno. Ninguém mais vai te ferir esta noite."],
		["luke", "Au..."],
		["ren", "Foste tu quem latiu a noite inteira junto à cerca. Tu me acordaste... e me mostraste a saída."],
		["ren", "E que pingente é esse no teu pescoço? Jade antigo... com um símbolo que nunca vi em forja alguma."],
	],
	"amizade_2": [
		["ren", "Toma, meu amigo. Um pedaço da minha faixa, da cor do sangue de Arashi. Obrigado por me ajudar."],
		["ren", "De hoje em diante, ninguém vai te chamar de vira-lata sem nome. Vou te chamar de Luke."],
		["luke", "Au! Au!"],
		["ren", "Então vem, Luke. Ainda há uma cidade inteira para tirar daqui."],
	],
	"portao": [
		["ren", "Esta muralha foi a obra da vida de meu pai. Ele dizia que todo portão precisa guardar um segredo para se abrir por dentro."],
		["ren", "Ali, atrás da placa de bronze: o eixo-mestre. Se ele se partir, as engrenagens cedem."],
		["luke", "Au!"],
		["ren", "Quando a luz passar, que o povo corra para as montanhas e não olhe para trás."],
	],
	"baku_prologo": [
		["baku", "Mil anos sob a pedra... e quando enfim me oferecem um banquete de almas, um ferreiro abre as portas da mesa."],
		["baku", "Estas almas trazem a minha marca. Foram prometidas à Ira, e a Ira veio buscá-las."],
		["ren", "Ninguém aqui te pertence, demônio. Nem esta noite, nem nunca."],
		["baku", "Então ergue o teu aço, ferreiro. Mostra-me o que vale a coragem de um homem marcado."],
	],
	"baku_luz": [
		["baku", "Essa luz... a luz do primeiro selo! Quem te deu isso, cão?!"],
		["baku", "Não importa. A minha marca já está em ti, ferreiro. Onde quer que vás, a Ira te encontrará."],
		["ren", "Luke... tu me salvaste... outra vez."],
	],
	"intro_torii": [
		["ren", "Os soldados das Sete Casas caçam o demônio... ou caçam a mim."],
		["ren", "Seja como for, ninguém mais pagará pelo portão que eu abri."],
	],
	"chefe_baku": [
		["baku", "O ferreiro marcado... e o cão da luz maldita. Vieste morrer no meu vale?"],
		["ren", "Vim buscar o fragmento do teu selo. O mestre Tetsu disse que ele dorme dentro de ti."],
		["baku", "Então arranca-o da minha carne, se puderes! A Ira jamais se curva!"],
	],
	"fim_baku": [
		["baku", "Impossível... a Ira... não se apaga..."],
		["baku", "Essa marca nas engrenagens do selo... é marca de ferreiro. Igual à tua."],
		["baku", "Pergunta ao velho... quem forjou a nossa prisão..."],
		["ren", "Fala, demônio! O que sabes do meu sangue?"],
	],
	"intro_vila": [
		["tetsu", "Bem-vindo ao Refúgio de Arashi, filho. Aproxima-te quando puderes; há coisas que precisas ouvir."],
	],
	"tetsu_1": [
		["tetsu", "Então és tu o ferreiro que abriu os portões de Arashi."],
		["ren", "Abri. E por minha causa sete demônios andam livres pelo mundo."],
		["tetsu", "Não, filho. Por causa das Sete Casas. Tu apenas devolveste ao povo o direito de fugir."],
		["tetsu", "Escuta. Quando a maldição caiu sobre as Sete Terras, os povos selaram os demônios com aço, fé e sangue oferecido de livre vontade."],
		["tetsu", "Mas os senhores das Casas aprenderam a alimentar os selos com sangue que ninguém ofereceu. E quanto mais bebiam, mais famintos ficavam os demônios lá dentro."],
		["tetsu", "Os sete selos estão ligados uns aos outros. Quando a oferenda de Arashi se rompeu pela metade, todos racharam na mesma noite."],
		["ren", "Então ainda há um jeito de prendê-los outra vez?"],
		["tetsu", "Há. Cada demônio carrega dentro de si o fragmento do próprio selo. Derrota-o, e o fragmento volta a dormir. Sete fragmentos, e o mundo terá uma chance."],
		["tetsu", "Baku, a Ira, recuou para o Vale das Torii. A luz daquele pingente o feriu, mas não o venceu."],
		["ren", "O pingente de Luke... o que é ele, mestre?"],
		["tetsu", "...Uma pergunta para outro dia. Guarda bem esse cão. Ele te escolheu antes que tu o escolhesses."],
		["tetsu", "Antes de partires, lembra: segura DEFESA diante do golpe; no instante exato, o inimigo vacila. Toca DEFESA duas vezes para rolar."],
		["tetsu", "Cada aparo perfeito e cada esquiva no limite alimentam a tua Ruptura, a força do espírito. É ela que desperta os poderes."],
		["tetsu", "Vai. A torii do Vale das Torii já está aberta. E volta com vida."],
	],
	"tetsu_2": [
		["tetsu", "Sentes isto? A ira de Baku agora corre em tua mão. Toca no nome do poder, no alto, para empunhá-la; o botão PODER a desperta quando a Ruptura bastar."],
		["tetsu", "Cada poder que tomas deixa uma marca em ti. Cuida do que carregas, filho."],
		["ren", "Mestre... Baku disse que a marca nas engrenagens do selo é marca de ferreiro. Igual à minha."],
		["tetsu", "...Os selos foram forjados, filho. E todo aço tem um ferreiro. Hoje não. Primeiro, sobrevive."],
		["tetsu", "O Palácio de Xui abriu as portas. Lá a Gula serve banquetes, enquanto o povo do lado de fora morre de fome."],
	],
	"tetsu_r1": [
		["tetsu", "O Vale das Torii te espera, filho. Baku não perdoa hesitação."],
	],
	"tetsu_r2": [
		["tetsu", "O Palácio de Xui fica além da torii dourada. Não comas nada que te oferecerem lá dentro."],
	],
	"tetsu_3": [
		["tetsu", "Dois demônios tombaram. As cicatrizes já sobem pelo teu braço."],
		["tetsu", "Quando a dor arder demais, fica junto do cão. Ele conhece o caminho de volta."],
	],
	"intro_palacio": [
		["ren", "Cheiro de banquete... em terras onde o povo morre de fome."],
	],
	"chefe_xui": [
		["xui", "Um convidado tão magro! Que desperdício para a minha mesa."],
		["xui", "Senta-te e come. Aqui ninguém passa fome... desde que eu coma primeiro."],
		["ren", "O teu banquete é feito da vida do meu povo."],
	],
	"fim_xui": [
		["xui", "Ainda... tenho... fome..."],
		["ren", "Agora sabes o que eles sentiram."],
	],
	# ---- v0.13: o vilão observa (Shin-Oni ainda sem nome) ----
	"sussurro_baku": [
		["shin", "Ouvi a Ira cair, ferreiro. Ouvi também o teu coração... bateu mais forte quando ela entrou na tua marca."],
		["ren", "Quem está aí?! Mostra-te!"],
		["shin", "Continua. Traz-me os sete, um por um. Cada pecado que derrubas fica contigo... como ficou comigo."],
	],
	"sussurro_xui": [
		["shin", "A fome também é tua agora. Sentiste-a rasgar-te o peito, não sentiste?"],
		["shin", "O vermelho dos teus olhos é o mesmo da minha lua. Já estás a ficar parecido comigo."],
		["luke", "Grrr... Au! Au!"],
		["shin", "...Esse cão. Esse pingente. Não pode ser."],
	],
	# ---- v0.13: a origem da Forma Carmesim (Tetsu explica no Refúgio) ----
	"tetsu_carmesim": [
		["tetsu", "Vi o vermelho nos teus olhos quando voltaste, Ren. Senta-te. É hora de saberes o que te marcou."],
		["tetsu", "Naquela noite, a lâmina de Baku não trazia só a Ira. Trazia o sacrifício inteiro de Arashi: a vida que as Casas iam oferecer ao selo."],
		["tetsu", "Abriste o portão e o ritual parou no meio. Aquela vida roubada ficou sem dono... e entrou em ti pela ferida. Por isso a marca arde. Por isso é vermelha como aquela lua."],
		["tetsu", "E cada demônio que derrubas deixa um resto de si nessa marca, como cinza no fundo da forja. A Ira que já carregavas encontrou a fome de Xui... e o fogo pegou."],
		["ren", "Então a Forma Carmesim... é a força do meu povo? Dos que quase morreram naquela praça?"],
		["tetsu", "É. Por isso te obedece quando lutas com cabeça fria: o aparo certo, a esquiva no último instante. E te devora quando lutas por ódio."],
		["tetsu", "Os antigos tinham um nome para quem guardava pecados no próprio corpo: recipiente. Nenhum terminou bem."],
		["ren", "Então não serei recipiente. Serei ferreiro. Enquanto Luke estiver ao meu lado, eu volto."],
	],
	# ---- v0.13: memória jogável — a noite do portão ----
	"memoria_porta": [
		["ren", "(Outra vez este sonho.) O eixo-mestre... foi aqui. Meu pai o forjou para nunca ceder."],
		["ren", "Eu sabia que, se o rompesse, as engrenagens dos selos girariam juntas. Sabia... e rompi assim mesmo."],
	],
	"memoria_fim": [
		["ren", "O povo passou. E atrás dele, saindo das sombras, sete vozes riram ao mesmo tempo."],
		["ren", "As Casas mentem sobre muita coisa. Mas não mentem sobre isto: fui eu que abri as jaulas."],
		["luke", "Au! Au!"],
		["ren", "...Luke. Estou acordado. Vamos. Cada demônio que eu soltei, eu mesmo vou buscar."],
	],
	"carmesim_desperta": [
		["ren", "Meu sangue... queima. As cicatrizes da Ira estão se abrindo!"],
		["xui", "Que fome é essa nos teus olhos, menino? Ela... se parece com a minha!"],
		["ren", "Algo vermelho como a lua daquela noite rasga-me por dentro... Gula, eu vou devorar-te por inteiro."],
	],
	"dica_baku": [
		["tetsu", "(A voz do mestre, na memória) A Ira salta e desce com golpes pesados... e então respira."],
		["tetsu", "Rola quando ele cair do alto. Fere-o enquanto ofega, filho. Não antes."],
	],
	"dica_xui": [
		["tetsu", "(A voz do mestre, na memória) O vapor da Gula, a Bocarra de Jade o engole e te devolve o vigor."],
		["tetsu", "Quando ela saltar com o ventre, pula a onda. Depois ela arqueja: é a tua hora."],
	],
	"segredo_nevoa": [
		["ren", "A Bocarra de Jade engoliu a névoa... e atrás dela dormia um fragmento de selo esquecido."],
	],
	"segredo_selo": [
		["ren", "O selo carmesim cedeu ao meu sangue. Que poder é este, que abre o que nem a fúria abria?"],
	],
	"tetsu_refugio": [
		["tetsu", "Olha à tua volta, filho. Cada rosto aqui é uma noite que as Sete Casas não tiveram."],
	],
	"tetsu_lenda_1": [
		["tetsu", "Dizem que a Lua Carmesim nasce quando o mundo derrama sangue demais numa só noite."],
		["tetsu", "Naquela noite em Arashi, ela nasceu. E algo dela ficou em ti, filho."],
	],
	"tetsu_lenda_2": [
		["tetsu", "Os velhos falam de um senhor num trono de chifres, que um dia reuniu os sete pecados num só corpo."],
		["tetsu", "Chamam-no Senhor dos Sete Pecados. Rezo para que seja só uma lenda... como dizíamos dos selos."],
	],
	"tetsu_lenda_3": [
		["tetsu", "Já reparaste como os demônios evitam o cão? Nem a Ira ousou tocá-lo."],
		["tetsu", "Há coisas que a lâmina não explica, filho. O afeto é uma delas."],
	],
	"carmesim_calma_1": [
		["ren", "Ainda não basta... Preciso de mais. Mais sangue. Mais selos."],
		["luke", "Au! Au! Auuu!"],
	],
	"carmesim_calma_2": [
		["ren", "Luke... a tua luz, outra vez. Eu quase me perdi naquela escuridão vermelha."],
		["ren", "Esse poder nasceu na noite da Lua Carmesim. Se eu não o dominar, ele me dominará."],
		["ren", "Fica ao meu lado, amigo. Enquanto ouvires meu nome, eu sempre voltarei."],
	],
	"segredo": [
		["ren", "Uma câmara oculta... e um fragmento de selo, ainda morno."],
	],
}

# Prisioneiros libertados: a história contada jogando. Cada terra prende o povo do jeito do seu pecado.
const RESGATE := {
	"torii": {
		"grito": "Os soldados das Sete Casas nos prenderam aqui para a Ira!",
		"falas": [
			"Íamos ser executados por gritar de fome diante dos soldados. Tu nos deste outra noite de vida.",
			"Meu irmão ficou no Vale. Se o vires... diz-lhe que eu esperei.",
			"A Ira deles era maior que a nossa culpa. Obrigado, ferreiro.",
		],
	},
	"palacio": {
		"grito": "Trancados na despensa... sentindo o cheiro do banquete!",
		"falas": [
			"Servíamos banquetes de olhos baixos. Nunca provamos uma migalha.",
			"Ela comia enquanto nossos filhos choravam lá fora. Agora divido o pão com eles.",
			"Guardei este bolinho de arroz do banquete... é para o teu cão.",
		],
	},
}
