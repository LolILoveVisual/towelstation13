/datum/weather/rain
	/// name of weather
	name = "raining"
	/// description of weather
	desc = "chuva"
	/// The message displayed in chat to foreshadow the weather's beginning
	telegraph_message = "<span class='warning'>Você sente algo caindo do céu...</span>"
	/// In deciseconds, how long from the beginning of the telegraph until the weather begins
	telegraph_duration = 300
	/// The sound file played to everyone on an affected z-level
	telegraph_sound = 'modular_solaris/modules/dungeon_highrock/sound/acidrain_start.ogg'
	/// The overlay applied to all tiles on the z-level
	telegraph_overlay = "rain"

	/// Displayed in chat once the weather begins in earnest
	weather_message = "<span class='userdanger'>Começa a chuver!</span>"
	/// In deciseconds, how long the weather lasts once it begins
	weather_duration = 1200
	/// See above - this is the lowest possible duration
	weather_duration_lower = 1200
	/// See above - this is the highest possible duration
	weather_duration_upper = 1500
	/// Looping sound while weather is occuring
	weather_sound = 'modular_solaris/modules/dungeon_highrock/sound/acidrain_mid.ogg'
	/// Area overlay while the weather is occuring
	weather_overlay = "storm"
	/// Color to apply to the area while weather is occuring
	weather_color = null

	/// Displayed once the weather is over
	end_message = "<span class='danger'>The wind relents its assault.</span>"
	end_duration = 300
	end_sound = 'modular_solaris/modules/dungeon_highrock/sound/acidrain_end.ogg'
	end_overlay = "rain"
	area_type = /area
	protect_indoors = TRUE
	barometer_predictable = TRUE