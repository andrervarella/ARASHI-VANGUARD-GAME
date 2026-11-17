extends RefCounted
# Histórias em quadros (storyboard). O texto só avança quando o jogador toca.
# "video": se existir res://assets/video/<id>.ogv, ele toca no lugar do quadro
# (vaga para as cutscenes do Higgsfield; a legenda continua por código).
# Linguagem épica (DEC-019, DEC-020): nada de gíria.

const S := {
	"abertura": {
		"musica": "abertura",
		"quadros": [
			{"img": "mapa", "txt": "Houve um tempo em que as trevas cobriram as Sete Terras.", "texto_tela": true},
			{"img": "ritual", "txt": "Do coração corrompido dos homens nasceu uma maldição. E da maldição nasceram demônios.", "texto_tela": true},
			{"img": "demonios", "txt": "Eram sete. Cada um trazia na carne um pecado do povo:\nIra, Gula, Preguiça, Avareza, Inveja, Luxúria e Soberba.", "texto_tela": true},
			{"img": "mapa", "txt": "Então os povos se uniram. Sacerdotes ergueram torii e cordas sagradas, ferreiros forjaram correntes de aço consagrado..."},
			{"img": "mapa", "txt": "...e sete selos aprisionaram os sete demônios, cada um numa região do mundo. Por gerações, houve paz."},
			{"img": "ritual", "txt": "Mas o poder dos selos despertou outra fome. Os mais ricos, os senhores que governavam as Sete Casas, formaram uma seita secreta."},
			{"img": "ritual", "txt": "Descobriram que, sacrificando vidas diante dos selos, bebiam a energia vital dos sacrificados: juventude, sorte, sucesso... poder."},
			{"img": "riqueza", "txt": "Quanto mais vidas ofereciam, mais ricos e temidos ficavam. E maior se tornava a sua fome."},
			{"img": "dominio", "txt": "A energia roubada lhes deu algo ainda pior: domínio sobre as mentes. O povo obedecia de olhos baixos, sem saber por quê, como se a vontade lhe tivesse sido arrancada."},
			{"img": "humildes", "txt": "Em noites sem lua, os humildes desapareciam. O povo chamava aquilo de lenda, contada à beira do fogo para assustar as crianças.\nNão era lenda."},
			{"img": "shin_sombra", "txt": "E nas trevas, acima de todos, alguém observava. Alguém mais antigo que os selos... com as marcas deles gravadas no próprio peito."},
			{"img": "aldeia", "txt": "Na cidade de Arashi, ao pé das montanhas, vivia Ren, ferreiro. Seu pai lançara as fundações da grande muralha e forjara as engrenagens dos portões."},
			{"img": "lua_vermelha", "txt": "Até que, numa noite de Lua Vermelha, a ganância das Casas não conheceu limite: decidiram oferecer ao selo da Ira uma cidade inteira.", "video": "abertura"},
			{"img": "portao_trancado", "txt": "Os portões foram fechados. Soldados arrastaram o povo para a praça, e em cada testa traçaram a marca do sacrifício."},
			{"img": "aldeia", "txt": "Ren também foi levado. Mas, naquela noite, um pequeno cão sem dono não parou de latir junto às grades..."},
		],
	},
	"cicatriz": {
		"musica": "titulo",
		"quadros": [
			{"img": "fuga", "txt": "Enquanto Ren enfrentava a Ira, o povo de Arashi fugia pelos portões abertos, rumo às montanhas."},
			{"img": "baku2", "txt": "Ren tombou ferido. A lâmina de Baku deixou em seu rosto uma marca que arde como brasa e não se apaga."},
			{"img": "lua", "txt": "Mas o pingente do pequeno cão brilhou com uma luz antiga. A Ira recuou para as trevas antes que o sol nascesse, e a cidade não foi tomada."},
			{"img": "demonios", "txt": "O sacrifício interrompido rompeu o equilíbrio dos selos. Naquela mesma noite, os sete demônios se libertaram e tomaram as Sete Terras."},
			{"img": "ren_luke_estrada", "txt": "E as Sete Casas, para esconder o próprio crime, apontaram um único culpado: Ren Arashi."},
			{"img": "ren_luke", "txt": "Para salvar o seu povo, ele libertou sete demônios. Agora, ao lado de Luke, há de caçar cada um."},
		],
	},
	"vila_chegada": {
		"musica": "vila",
		"quadros": [
			{"img": "refugio", "txt": "Nas montanhas, os sobreviventes de Arashi ergueram um refúgio entre os pinheiros."},
			{"img": "refugio", "txt": "Ali vive Tetsu, um velho mestre ferreiro. Dizem que ele conhece os selos melhor do que qualquer sacerdote... e que guarda segredos que nunca contou."},
		],
	},
	"dois_chefes": {
		"musica": "vila",
		"quadros": [
			{"img": "lua", "txt": "Dois demônios tombaram. Dois fragmentos de selo voltaram a dormir. Mas as cicatrizes de Ren começam a se espalhar."},
			{"img": "baku2", "txt": "Nas noites mais escuras, algo dentro dele anseia por sair. Algo vermelho como a lua daquela noite: a Forma Carmesim."},
			{"img": "ren_luke", "txt": "E só uma presença consegue trazê-lo de volta: o pequeno cão do pingente de jade."},
			{"img": "mapa", "txt": "FIM DA DEMONSTRAÇÃO\nFases 1 e 2 concluídas. Obrigado por jogar!", "titulo": true},
		],
	},
}
