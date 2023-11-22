///A ideia é que o player consiga tocar aquele som de respiração do darth vader em um tipo de máscara, eu queria fazer
/// ser automatico o som mas eu sou muito burro - Caveirinha
/obj/item/clothing/mask/gas/sechailer/vader
	name = "realistic security gas mask"
	desc = "OOOOOO PIUUHHHH"

/obj/item/clothing/mask/gas/sechailer/vader/equipped(mob/user, slot)
    . = ..()
    if (slot & ITEM_SLOT_MASK)
        RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))
        playsound(src.loc, 'sound/items/deconstruct.ogg', 50, TRUE)
    else
        UnregisterSignal(M, COMSIG_MOB_SAY)