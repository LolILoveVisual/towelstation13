/obj/item/clothing/mask/gas/sechailer/vader
	name = "realistic security gas mask"
	desc = "OOOOOO PIUUHHHH"

/obj/item/clothing/mask/gas/sechailer/vader/equipped(mob/user, slot)
	. = ..()
	if (slot & ITEM_SLOT_MASK)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
		var/timer/vader_sound_timer = 0  // Adiciona um timer para controlar a reprodução do som
	else
		UnregisterSignal(M, COMSIG_MOB_SAY)

	// Adiciona um timer que toca o som a cada 30 segundos
	..()  // Chama o código original do procedimento
	vader_sound_timer = new/timer(30, 1)
	vader_sound_timer.SetProc(PLAY_VADER_SOUND)
	return

/proc/PLAY_VADER_SOUND()
	// Toque o som do Darth Vader
	playsound(src.loc, 'modular_solaris/sound/darth_vader.ogg', 50, TRUE)
	return