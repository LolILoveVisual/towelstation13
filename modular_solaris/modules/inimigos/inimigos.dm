//Esqueleto risadinha
/mob/living/simple_animal/hostile/blackmesa/blackops/esqueleto
	name = "esqueleto reanimado"
	desc = "como que ele ri?"
	icon = 'icons/mob/simple/simple_human.dmi'
	icon_state = "skeleton"
	icon_living = "skeleton"
	icon_dead = "gibs"
	icon_gib = "gibs"
	mob_biotypes = MOB_UNDEAD|MOB_HUMANOID
	sentience_type = SENTIENCE_HUMANOID
	speak_chance = 10
	speak = list("HAHAHAHAHA!")
	turns_per_move = 5
	speed = 0
	stat_attack = HARD_CRIT
	robust_searching = 1
	maxHealth = 40
	health = 40
	harm_intent_damage = 25
	melee_damage_lower = 30
	melee_damage_upper = 30
	attack_verb_continuous = "slash"
	attack_verb_simple = "slash"
	attack_sound = 'sound/weapons/slash.ogg'
	combat_mode = TRUE
	loot = list(/obj/effect/gibspawner/human)
	faction = list(FACTION_SKELETON)
	check_friendly_fire = 1
	status_flags = CANPUSH
	del_on_death = 1
	dodging = TRUE
	rapid_melee = 2
	footstep_type = FOOTSTEP_MOB_SKELETON
	alert_sounds = list(
		'modular_solaris/modules/inimigos/sounds/skele01.wav',
		'modular_solaris/modules/inimigos/sounds/skele02.wav',
		'modular_solaris/modules/inimigos/sounds/skele03.mp3',
		'modular_solaris/modules/inimigos/sounds/skele04.ogg'
	)