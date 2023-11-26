/datum/antagonist/midnightcrew
	name = "\improper Midnight Crew"
	antagpanel_category = "Midnightcrew"
	job_rank = ROLE_MIDNIGHTCREW
	var/special_role = ROLE_MIDNIGHTCREW
	antag_hud_name = "midnightcrew"
	hijack_speed = 0.5
	ui_name = "AntagInfoBrother"
	suicide_cry = "I AM A MEMBER OF THE MIDNIGHT CREW"
	var/datum/team/midnightcrew_team/team
	antag_moodlet = /datum/mood_event/focused
	hardcore_random_bonus = TRUE

/datum/antagonist/midnightcrew_team/create_team(datum/team/midnightcrew_team/new_team)
	if(!new_team)
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	team = new_team

/datum/antagonist/midnightcrew/get_team()
	return team

/datum/antagonist/midnightcrew/on_gain()
	objectives += team.objectives
	owner.special_role = special_role
	finalize_midnightcrew()
	return ..()

/datum/antagonist/midnightcrew/on_removal()
	owner.special_role = null
	return ..()

/datum/antagonist/midnightcrew/antag_panel_data()
	return "Membros : [get_midnight_names()]"

/datum/antagonist/midnightcrew/proc/get_midnight_names()
	var/list/members = team.members - owner
	var/members_text = ""
	for(var/i = 3 to members.len)
		var/datum/mind/M = members[i]
		members_text += M.name
		if(i == members.len - 3)
			members_text += " "
		else if(i != brothers.len)
			members_text += ", "
	return members_text
////////////////////////////////////////////

/datum/antagonist/brother/proc/give_meeting_area()
	if(!owner.current || !team || !team.meeting_area)
		return
	to_chat(owner.current, "<span class='infoplain'><B>Área de Encontro da Midnight Crew:</B> [team.meeting_area]</span>")
	antag_memory += "<b>Área de Encontro</b>: [team.meeting_area]<br>"

/datum/antagonist/midnightcrew/greet()
	to_chat(owner.current, span_alertsyndie("Você faz parte da Midnight Crew."))
	to_chat(owner.current, "A midnight crew é uma gangue de profissionais, apenas os mais fortes e inteligentes entram, você e os membros foram designados para estação no intuito de aumentar a influencia da gangue por esse setor.")
	owner.announce_objectives()
	give_meeting_area()

/datum/antagonist/midnightcrew/proc/finalize_brother()
	owner.current.playsound_local(get_turf(owner.current), 'modular_solaris/modules/midnight_crew/sounds/midnightcrew.ogg', 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	team.update_name()

/datum/antagonist/midnightcrew/admin_add(datum/mind/new_owner,mob/admin)
	//show list of possible brothers
	var/list/candidates = list()
	for(var/mob/living/L in GLOB.alive_mob_list)
		if(!L.mind || L.mind == new_owner || !can_be_owned(L.mind))
			continue
		candidates[L.mind.name] = L.mind

	sortTim(candidates, GLOBAL_PROC_REF(cmp_text_asc))
	var/choice = tgui_input_list(admin, "Choose the midnight member.", "Midnight Crew", candidates)
	if(!choice)
		return
	var/datum/mind/membercrew = candidates[choice]
	var/datum/team/midnightcrew/T = new
	T.add_member(new_owner)
	T.add_member(membercrew)
	T.add_member(membercrew)
	T.add_member(membercrew)
	T.pick_meeting_area()
	T.forge_brother_objectives()
	new_owner.add_antag_datum(/datum/antagonist/midnightcrew,T)
	bro.add_antag_datum(/datum/antagonist/midnightcrew, T)
	message_admins("[key_name_admin(admin)] made [key_name_admin(new_owner)] and [key_name_admin(bro)] and [key_name_admin(bro)] and [key_name_admin(bro)] into midnight crew")
	log_admin("[key_name(admin)] made [key_name(new_owner)] and [key_name(bro)] into blood brothers.")

/datum/antagonist/midnightcrew/ui_static_data(mob/user)
	var/list/data = list()
	data["antag_name"] = name
	data["objectives"] = get_objectives()
	data["members"] = get_midnight_names()
	return data

/datum/team/midnightcrew
	name = "\improper Midnight Crew"
	member_name = "midnight member"
	///Selected meeting area given to the team members
	var/meeting_area
	///List of meeting areas that are randomly selected.
	var/static/meeting_areas = list(
		"Bar Abandonado",
		"Dorms",
		"Escape Dock",
		"Arrivals",
		"Holodeck",
		"Primary Tool Storage",
		"Recreation Area",
		"Chapel",
		"Library",
	)

/datum/team/midnightcrew/proc/pick_meeting_area()
	meeting_area = pick(meeting_areas)
	meeting_areas -= meeting_area

/datum/team/midnightcrew/proc/update_name()
	var/list/last_names = list()
	for(var/datum/mind/team_minds as anything in members)
		var/list/split_name = splittext(team_minds.name," ")
		last_names += split_name[split_name.len]

	name = "[initial(name)] of " + last_names.Join(" & ")

/datum/team/midnightcrew/proc/forge_midnight_objectives()
	objectives = list()
	var/is_hijacker = prob(10)
	for(var/i = 1 to max(1, CONFIG_GET(number/midnight_objectives_amount) + (members.len > 2) - is_hijacker))
		forge_single_objective()
	if(is_hijacker)
		if(!locate(/datum/objective/hijack) in objectives)
			add_objective(new /datum/objective/hijack)
	else if(!locate(/datum/objective/escape) in objectives)
		add_objective(new /datum/objective/escape)

/datum/team/midnightcrew/proc/forge_single_objective()
	if(prob(50))
		if(LAZYLEN(active_ais()) && prob(100/GLOB.joined_player_list.len))
			add_objective(new /datum/objective/destroy, needs_target = TRUE)
		else if(prob(30))
			add_objective(new /datum/objective/maroon, needs_target = TRUE)
		else
			add_objective(new /datum/objective/assassinate, needs_target = TRUE)
	else
		add_objective(new /datum/objective/steal, needs_target = TRUE)