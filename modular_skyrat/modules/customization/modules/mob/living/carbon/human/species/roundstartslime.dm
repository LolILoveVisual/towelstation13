/datum/species/jelly
	default_mutant_bodyparts = list(
		"tail" = "None",
		"snout" = "None",
		"ears" = "None",
		"wings" = "None",
		"legs" = "Normal Legs",
		"horns" = "None",
		"spines" = "None",
		"frills" = "None",
	)
	mutant_bodyparts = list()
	hair_color = "mutcolor"
	hair_alpha = 160 //a notch brighter so it blends better.
	facial_hair_alpha = 160

/datum/species/jelly/get_species_description()
	return placeholder_description

/datum/species/jelly/get_species_lore()
	return list(placeholder_lore)

/datum/species/jelly/roundstartslime
	name = "Xenobiological Slime Hybrid"
	id = SPECIES_SLIMESTART
	examine_limb_id = SPECIES_SLIMEPERSON
	coldmod = 3
	heatmod = 1
	specific_alpha = 155
	markings_alpha = 130 //This is set lower than the other so that the alpha values don't stack on top of each other so much
	mutanteyes = /obj/item/organ/internal/eyes
	mutanttongue = /obj/item/organ/internal/tongue/jelly

	bodypart_overrides = list( //Overriding jelly bodyparts
		BODY_ZONE_L_ARM = /obj/item/bodypart/arm/left/slime/roundstart,
		BODY_ZONE_R_ARM = /obj/item/bodypart/arm/right/slime/roundstart,
		BODY_ZONE_HEAD = /obj/item/bodypart/head/slime/roundstart,
		BODY_ZONE_L_LEG = /obj/item/bodypart/leg/left/slime/roundstart,
		BODY_ZONE_R_LEG = /obj/item/bodypart/leg/right/slime/roundstart,
		BODY_ZONE_CHEST = /obj/item/bodypart/chest/slime/roundstart,
	)

/datum/species/jelly/roundstartslime/create_pref_unique_perks()
	var/list/perk_descriptions = list()

	perk_descriptions += list(list(
		SPECIES_PERK_TYPE = SPECIES_POSITIVE_PERK,
		SPECIES_PERK_ICON = "biohazard",
		SPECIES_PERK_NAME = "Squishy Form",
		SPECIES_PERK_DESC = "Being made of slime, you have the ability to alter your physical form to be whatever you choose! You may grow ears, and change your hair, at the press of a button and the snap of a finger!"
	))

	return perk_descriptions

/**
 * Alter Form is the ability of slimes to edit many of their character attributes at will
 * This covers most thing about their character, from body size or colour, to adding new wings, tails, ears, etc.
 * There are some balance concerns with some of these (looking at you, body size), but nobody has abused it Yet:tm:, and it would be exceedingly obvious if they did
 */
/datum/action/innate/alter_form
	name = "Alter Form"
	check_flags = AB_CHECK_CONSCIOUS
	button_icon_state = "alter_form"
	button_icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi'
	background_icon_state = "bg_alien"
	/// Do you need to be a slime-person to use this ability?
	var/slime_restricted = TRUE
	///Is the person using this ability oversized?
	var/oversized_user = FALSE
	///What text is shown to others when the person uses the ability?
	var/shapeshift_text = "gains a look of concentration while standing perfectly still. Their body seems to shift and starts getting more goo-like."
	///List containing all of the avalible parts
	var/static/list/available_choices

/datum/action/innate/alter_form/New(Target)
	. = ..()
	if(length(available_choices))
		return

	available_choices = deep_copy_list(GLOB.sprite_accessories)
	for(var/parts_list in available_choices)
		for(var/parts in available_choices[parts_list])
			var/datum/sprite_accessory/part = available_choices[parts_list][parts]
			if(part.locked)
				available_choices[parts_list] -= parts

/datum/action/innate/alter_form/unrestricted
	slime_restricted = FALSE

/datum/action/innate/alter_form/Activate()
	var/mob/living/carbon/human/alterer = owner
	if(slime_restricted && !isjellyperson(alterer))
		return
	alterer.visible_message(
		span_notice("[owner] [shapeshift_text]"),
		span_notice("You focus intently on altering your body while standing perfectly still...")
	)
	change_form(alterer)

/**
 * Change form is the initial proc when using the alter form action
 * It brings up a radial menu to allow you to pick what about your character it is that you want to edit
 * Each of these radial menus should be kept from being too long where possible, really
 */
/datum/action/innate/alter_form/proc/change_form(mob/living/carbon/human/alterer)
	var/selected_alteration = show_radial_menu(
		alterer,
		alterer,
		list(
			"Body Colours" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_rainbow"),
			"DNA" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "dna"),
			"Hair" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "scissors"),
			"Markings" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "rainbow_spraycan"),
		),
		tooltips = TRUE,
	)
	if(!selected_alteration)
		return
	switch(selected_alteration)
		if("Body Colours")
			alter_colours(alterer)
		if("DNA")
			alter_dna(alterer)
		if("Hair")
			alter_hair(alterer)
		if("Markings")
			alter_markings(alterer)

/**
 * Alter colours handles the changing of mutant colours
 * This affects skin tone primarily, though has the option to change hair, markings, and mutant body parts to match
 */
/datum/action/innate/alter_form/proc/alter_colours(mob/living/carbon/human/alterer)
	var/color_choice = show_radial_menu(
		alterer,
		alterer,
		list(
			"Primary" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_red"),
			"Secondary" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_green"),
			"Tertiary" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_blue"),
			"All" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "slime_rainbow"),
		),
		tooltips = TRUE,
	)
	if(!color_choice)
		return
	var/color_target
	switch(color_choice)
		if("Primary", "All")
			color_target = "mcolor"
		if("Secondary")
			color_target = "mcolor2"
		if("Tertiary")
			color_target = "mcolor3"

	var/new_mutant_colour = input(
		alterer,
		"Choose your character's new [color_choice = "All" ? "" : lowertext(color_choice)] color:",
		"Form Alteration",
		alterer.dna.features[color_target]
	) as color|null
	if(!new_mutant_colour)
		return

	var/marking_reset = tgui_alert(
		alterer,
		"Would you like to reset your markings to match your new colors?",
		"Reset markings",
		list("Yes", "No"),
	)
	var/mutant_part_reset = tgui_alert(
		alterer,
		"Would you like to reset your mutant body parts(not limbs) to match your new colors?",
		"Reset mutant parts",
		list("Yes", "No"),
	)
	var/hair_reset = tgui_alert(
		alterer,
		"Would you like to reset your hair to match your new colors?",
		"Reset hair",
		list("Hair", "Facial Hair", "Both", "None"),
	)

	if(color_choice == "All")
		alterer.dna.features["mcolor"] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.features["mcolor2"] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.features["mcolor3"] = sanitize_hexcolor(new_mutant_colour)
		alterer.dna.update_uf_block(DNA_MUTANT_COLOR_BLOCK)
		alterer.dna.update_uf_block(DNA_MUTANT_COLOR_2_BLOCK)
		alterer.dna.update_uf_block(DNA_MUTANT_COLOR_3_BLOCK)
	else
		alterer.dna.features[color_target] = sanitize_hexcolor(new_mutant_colour)
		switch(color_target)
			if("mcolor")
				alterer.dna.update_uf_block(DNA_MUTANT_COLOR_BLOCK)
			if("mcolor2")
				alterer.dna.update_uf_block(DNA_MUTANT_COLOR_2_BLOCK)
			if("mcolor3")
				alterer.dna.update_uf_block(DNA_MUTANT_COLOR_3_BLOCK)

	if(marking_reset == "Yes")
		for(var/zone in alterer.dna.species.body_markings)
			for(var/key in alterer.dna.species.body_markings[zone])
				var/datum/body_marking/iterated_marking = GLOB.body_markings[key]
				if(iterated_marking.always_color_customizable)
					continue
				alterer.dna.species.body_markings[zone][key] = iterated_marking.get_default_color(alterer.dna.features, alterer.dna.species)

	if(mutant_part_reset == "Yes")
		alterer.mutant_renderkey = "" //Just in case
		for(var/mutant_key in alterer.dna.species.mutant_bodyparts)
			var/mutant_list = alterer.dna.species.mutant_bodyparts[mutant_key]
			var/datum/sprite_accessory/changed_accessory = GLOB.sprite_accessories[mutant_key][mutant_list[MUTANT_INDEX_NAME]]
			mutant_list[MUTANT_INDEX_COLOR_LIST] = changed_accessory.get_default_color(alterer.dna.features, alterer.dna.species)

	if(hair_reset)
		switch(hair_reset)
			if("Hair")
				alterer.hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_body_parts()
			if("Facial Hair")
				alterer.facial_hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_body_parts()
			if("Both")
				alterer.hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.facial_hair_color = sanitize_hexcolor(new_mutant_colour)
				alterer.update_body_parts()

	alterer.update_body(is_creating = TRUE)

/**
 * Alter hair lets you adjust both the hair on your head as well as your facial hair
 * You can adjust the style of either
 */
/datum/action/innate/alter_form/proc/alter_hair(mob/living/carbon/human/alterer)
	var/target_hair = show_radial_menu(
		alterer,
		alterer,
		list(
			"Hair" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "scissors"),
			"Facial Hair" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "straight_razor"),
			"Hair Color" = image(icon = 'modular_skyrat/master_files/icons/mob/actions/actions_slime.dmi', icon_state = "rainbow_spraycan")
		),
		tooltips = TRUE,
	)
	if(!target_hair)
		return
	switch(target_hair)
		if("Hair")
			var/new_style = tgui_input_list(owner, "Select a hair style", "Hair Alterations", GLOB.hairstyles_list)
			if(new_style)
				alterer.set_hairstyle(new_style, update = TRUE)
		if("Facial Hair")
			var/new_style = tgui_input_list(alterer, "Select a facial hair style", "Hair Alterations", GLOB.facial_hairstyles_list)
			if(new_style)
				alterer.set_facial_hairstyle(new_style, update = TRUE)
		if("Hair Color")
			var/hair_area = tgui_alert(alterer, "Select which color you would like to change", "Hair Color Alterations", list("Hairstyle", "Facial Hair", "Both"))
			if(!hair_area)
				return
			var/new_hair_color = input(alterer, "Select your new hair color", "Hair Color Alterations", alterer.dna.features["mcolor"]) as color|null
			if(!new_hair_color)
				return

			switch(hair_area)

				if("Hairstyle")
					alterer.set_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)
				if("Facial Hair")
					alterer.set_facial_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)
				if("Both")
					alterer.set_haircolor(sanitize_hexcolor(new_hair_color), update = FALSE)
					alterer.set_facial_haircolor(sanitize_hexcolor(new_hair_color), update = TRUE)

/**
 * Alter DNA is an intermediary proc for the most part
 * It lets you pick between a few options for DNA specifics
 */
/datum/action/innate/alter_form/proc/alter_dna(mob/living/carbon/human/alterer)
	var/list/key_list = list("Body Size", "Mutant Parts")
	var/dna_alteration = tgui_input_list(
		alterer,
		"Select what part of your DNA you'd like to alter",
		"DNA Alteration",
		key_list,
	)
	if(!dna_alteration)
		return
	switch(dna_alteration)
		if("Body Size")
			if(oversized_user && !HAS_TRAIT(alterer, TRAIT_OVERSIZED))
				var/reset_size = tgui_alert(alterer, "Do you wish to return to being oversized?", "Size Change", list("Yes", "No"))
				if(reset_size == "Yes")
					alterer.add_quirk(/datum/quirk/oversized)
					return

			var/new_body_size = tgui_input_number(
				alterer,
				"Choose your desired sprite size: ([BODY_SIZE_MIN * 100]% to [BODY_SIZE_MAX * 100]%). Warning: May make your character look distorted",
				"Size Change",
				default = min(alterer.dna.features["body_size"] * 100, BODY_SIZE_MAX * 100),
				max_value = BODY_SIZE_MAX * 100,
				min_value = BODY_SIZE_MIN * 100,
			)
			if(!new_body_size)
				return

			if(HAS_TRAIT(alterer, TRAIT_OVERSIZED))
				oversized_user = TRUE
				alterer.remove_quirk(/datum/quirk/oversized)

			new_body_size = new_body_size * 0.01
			alterer.dna.features["body_size"] = new_body_size
			alterer.dna.update_body_size()

		if("Mutant Parts")
			alter_parts(alterer)

	alterer.mutant_renderkey = "" //Just in case
	alterer.update_mutant_bodyparts()

/**
 * Alter parts lets you adjust mutant bodyparts
 * This can be adding (or removing) things like ears, tails, wings, et cetera.
 */
/datum/action/innate/alter_form/proc/alter_parts(mob/living/carbon/human/alterer)
	var/list/key_list = alterer.dna.mutant_bodyparts
	var/chosen_key = tgui_input_list(
		alterer,
		"Select the part you want to alter",
		"Body Part Alterations",
		key_list,
	)
	if(!chosen_key)
		return

	var/choice_list = available_choices[chosen_key]
	var/chosen_name_key = tgui_input_list(
		alterer,
		"What do you want the part to become?",
		"Body Part Alterations",
		choice_list,
	)
	if(!chosen_name_key)
		return

	var/datum/sprite_accessory/selected_sprite_accessory = GLOB.sprite_accessories[chosen_key][chosen_name_key]
	alterer.mutant_renderkey = "" //Just in case
	if(!selected_sprite_accessory.factual)
		if(selected_sprite_accessory.organ_type)
			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)
		else
			alterer.dna.species.mutant_bodyparts -= chosen_key
	else
		if(selected_sprite_accessory.organ_type)
			var/robot_organs = HAS_TRAIT(alterer, TRAIT_ROBOTIC_DNA_ORGANS)

			var/obj/item/organ/organ_path = selected_sprite_accessory.organ_type
			var/slot = initial(organ_path.slot)
			var/obj/item/organ/got_organ = alterer.get_organ_slot(slot)
			if(got_organ)
				got_organ.Remove(alterer)
				qdel(got_organ)

			var/obj/item/organ/replacement_organ = SSwardrobe.provide_type(selected_sprite_accessory.organ_type)
			replacement_organ.sprite_accessory_flags = selected_sprite_accessory.flags_for_organ
			replacement_organ.relevant_layers = selected_sprite_accessory.relevent_layers

			var/list/new_acc_list = list()
			new_acc_list[MUTANT_INDEX_NAME] = selected_sprite_accessory.name
			new_acc_list[MUTANT_INDEX_COLOR_LIST] = selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			alterer.dna.mutant_bodyparts[chosen_key] = new_acc_list.Copy()

			if(robot_organs)
				replacement_organ.organ_flags |= ORGAN_ROBOTIC
			replacement_organ.build_from_dna(alterer.dna, chosen_key)
			replacement_organ.Insert(alterer, special = TRUE, drop_if_replaced = FALSE)
		else
			var/list/new_acc_list = list()
			new_acc_list[MUTANT_INDEX_NAME] = selected_sprite_accessory.name
			new_acc_list[MUTANT_INDEX_COLOR_LIST] = selected_sprite_accessory.get_default_color(alterer.dna.features, alterer.dna.species)
			alterer.dna.species.mutant_bodyparts[chosen_key] = new_acc_list
			alterer.dna.mutant_bodyparts[chosen_key] = new_acc_list.Copy()
		alterer.dna.update_uf_block(GLOB.dna_mutant_bodypart_blocks[chosen_key])
	alterer.update_mutant_bodyparts()
	alterer.update_clothing(ALL) // for any clothing that has alternate versions (e.g. muzzled masks)

/**
 * Alter markings lets you add a particular body marking
 */
/datum/action/innate/alter_form/proc/alter_markings(mob/living/carbon/human/alterer)
	var/list/candidates = GLOB.body_marking_sets
	var/chosen_name = tgui_input_list(
		alterer,
		"Select which set of markings would you like to change into",
		"Marking Alterations",
		candidates,
	)
	if(!chosen_name)
		return
	var/datum/body_marking_set/marking_set = GLOB.body_marking_sets[chosen_name]
	alterer.dna.species.body_markings = assemble_body_markings_from_set(marking_set, alterer.dna.features, alterer.dna.species)
	alterer.update_body(is_creating = TRUE)
