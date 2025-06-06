/**
  * Spellbooks for learning arcane points.
  * Difficult to learn by default, has multipliers for weed, gems and rituals.
  * Inherits most of it's functionality from default granters, however also has some copy paste from roguebooks for parity.
  */

/obj/item/book/granter/spellbook
	var/open = FALSE
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookbrown_0"
	slot_flags = ITEM_SLOT_HIP
	var/base_icon_state = "spellbookbrown"
	unique = TRUE
	firefuel = 2 MINUTES
	dropshrink = 0.6
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	force = 5
	associated_skill = /datum/skill/misc/reading
	name = "\improper tome of the arcane"
	desc = "A crackling, glowing book, filled with runes and symbols that hurt the mind to stare at."
	pages_to_mastery = 7
	remarks = list(\
		"Fliping through the pages, I sense myself in another time, another place...", \
		"Turning the page, I catch shrewd glimpse of another's thread on Kasmidian's grace...", \
		"Staring at the pages' contents, I catch a glimpse of another chapter ahead through the page. I flip back and forth, but it stays hidden...", \
		"This particular passage chooses it hide it's wiles, a puzzle imperceptible yet lost...", \
		"This passage seems almost to sink into the very parchment as I pour through the book...", \
		"This particular chapter illustrates the effectives of destruction magic with very - colorful - illusionary inscryption. It hurts to keep my hand near...", \
		"Huh? This page is blank, sans for a vivid picture of a rather lavish hall of the Mage's University...", \
		"This chapter goes into 'sealing' rites and magicks, speaking of a fabled stone as prime example...", \
		"The words of this page seem almost to run away from my gaze...", \
		"This page is familiar, and yet... distinct, in an unsettling fashion...", \
		"Blessed by Kasmidian, keeper of secrets beyond our realm...", \
		"By the time I realized that chapter was luring me to another, it was too late...", \
		"I sense a chill run through me as I turn the page; with no obvious source...", \
		"Silver. Blade. Mana. Blood. These are the ingredients I’ll need to imbibe the very ground with arcane abilities...", \
		"A throbbing pain overtakes my head as I flip pages, yet I press on...", \
		"Something calls to me as I mull over a page I panickedly flip, though nothing comes...", \
		"I feel attuned to the very whim of Kasmidian; and her realm at large...", \
		"Am I reading? Are these words, symbols or inane scribbles? I cannot be sure, yet with each one my eyes glaze over, I can feel the arcane pulse within me...", \
		"A mystery is revealed before my very eyes. I do not read it, yet I am aware. Gems are the Root's natural arcane energy, manifest. Perhaps I can use them to better my conceptualization..."\
	)
	oneuse = FALSE
	var/owner
	var/list/allowed_readers = list()
	var/stored_gem = FALSE
	var/picked // if the book has had it's style picked or not
	var/born_of_rock = FALSE // was a magical stone used to make it instead of a gem?

/obj/item/book/granter/spellbook/getonmobprop(tag)
	. = ..()
	if(tag)
		if(open)
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)
		else
			switch(tag)
				if("gen")
					return list("shrink" = 0.4,
	"sx" = -2,
	"sy" = -3,
	"nx" = 10,
	"ny" = -2,
	"wx" = 1,
	"wy" = -3,
	"ex" = 5,
	"ey" = -3,
	"northabove" = 0,
	"southabove" = 1,
	"eastabove" = 1,
	"westabove" = 0,
	"nturn" = 0,
	"sturn" = 0,
	"wturn" = 0,
	"eturn" = 0,
	"nflip" = 0,
	"sflip" = 0,
	"wflip" = 0,
	"eflip" = 0)
				if("onbelt")
					return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)


/obj/item/book/granter/spellbook/attack_self(mob/user)
	if(!open)
		attack_right(user)
		return
	..()
	user.update_inv_hands()

/obj/item/book/granter/spellbook/rmb_self(mob/user)
	attack_right(user)
	return

/obj/item/book/granter/spellbook/read(mob/user)
	return FALSE

/obj/item/book/granter/spellbook/attack_right(mob/user)
	if(!picked)
		var/list/designlist = list("green", "yellow", "brown")
		var/mob/living/carbon/human/gamer = user
		if(gamer.job == "Court Magician")
			designlist = list("steel", "gem", "skin", "mimic")
		var/the_time = world.time
		var/design = input(user, "Select a design.","Spellbook Design") as null|anything in designlist
		if(!design)
			return
		if(world.time > (the_time + 30 SECONDS))
			return
		base_icon_state = "spellbook[design]"
		update_icon()
		picked = TRUE
		return
	if(!open)
		slot_flags &= ~ITEM_SLOT_HIP
		open = TRUE
		playsound(loc, 'sound/items/book_open.ogg', 100, FALSE, -1)
	else
		slot_flags |= ITEM_SLOT_HIP
		open = FALSE
		playsound(loc, 'sound/items/book_close.ogg', 100, FALSE, -1)
	curpage = 1
	update_icon()
	user.update_inv_hands()

/obj/item/book/granter/spellbook/update_icon()
	icon_state = "[base_icon_state]_[open]"

/obj/item/book/granter/spellbook/on_reading_start(mob/user)
	to_chat(user, span_notice("Arcane mysteries abound in this enigmatic tome, gift of Kasmidian..."))

/obj/item/book/granter/spellbook/on_reading_finished(mob/user)
	var/mob/living/carbon/human/gamer = user
	if(gamer != owner && !allowed_readers.Find(gamer))
		to_chat(user, span_notice("What was that gibberish? Even for the arcane it was completely illegible!"))
		return
	user.mind?.has_studied = TRUE
	var/mob/living/reader = user
	var/chance2learn = (reader.STAINT*2 + (user.mind?.get_skill_level(/datum/skill/misc/reading)*2) + (user.mind?.get_skill_level(/datum/skill/magic/arcane)*2))
	if(reader.has_status_effect(/datum/status_effect/buff/weed))
		to_chat(user, span_smallgreen("Swampweed truly does open one's third eye to the secrets of the arcane..."))
		chance2learn += 3.5
	var/obj/effect/roguerune/rune = (locate(/obj/effect/roguerune) in range(1, user))
	if(rune)
		to_chat(user, span_cultsmall("The rune beneath my feet glows..."))
		chance2learn += rune.spellbonus
		rune.do_invoke_glow()
	if(stored_gem)
		to_chat(user, span_smallnotice("I can feel the magical energies imbued within the crystaline dust scattered upon my tome resonate with the arcane..."))
		chance2learn += stored_gem
		stored_gem = FALSE
	if(!isarcane(user))
		if (gamer != owner) // if you didn't make this book, get fucked.
			chance2learn = 1
		else
			chance2learn *= 0.5
			chance2learn = min(chance2learn, 15) 
	if (born_of_rock)
		// the rock tomes are a *lot* easier to make, so we make them worse by them reducing your chances by 20%
		chance2learn *= 0.8
	testing("chance to learn is [chance2learn]")
	if(prob(chance2learn))
		user.visible_message(span_warning("[user] is filled with arcane energy! You witness [user.p_their()] body convulse and spark brightly."), \
			span_notice("Kasmidian blesses me. I have been granted knowledge and wisdom beyond my years, this tome's mysteries unveiled one at a time."))
		var/currentlevel = user.mind?.get_skill_level(/datum/skill/magic/arcane)
		var/expgain = get_arcane_exp(currentlevel)
		testing("exp to be gained is [expgain]")
		user.mind?.add_sleep_experience(/datum/skill/magic/arcane, expgain, TRUE)
		user.log_message("successfully studied their spellbook and gained a spell point", LOG_ATTACK, color="orange")
		onlearned(user)
	else
		if(prob(55))
			to_chat(user, span_notice("Confounded arcane mysteries, what fool wrote this drivel!? I must sleep before I can bring myself to open this damned thing again..."))
			to_chat(user, span_small("Some of those words I've heard before, but never read. I must meditate on their meaning..."))
			user.mind?.add_sleep_experience(/datum/skill/misc/reading, reader.STAINT*10)
		else
			to_chat(user, span_phobia("THIS KNOWLEDGE IS NOT FOR ME IT PERVADES MY MIND MY THOUGHTS MY WILL I AM NOT WORTHY I AM NOT WORTHY I AM NOT"))
			var/mob/living/carbon/freaky = user
			freaky.freak_out()
		return
	
/obj/item/book/granter/spellbook/onlearned(mob/user)
	used = FALSE

/obj/item/book/granter/spellbook/recoil(mob/user)
	user.visible_message(span_warning("[src] shoots out a spark of angry, arcane energy at [user]!"))
	var/mob/living/gamer = user
	gamer.electrocute_act(5, src)

/obj/item/book/granter/spellbook/attack(mob/living/M, mob/living/carbon/human/user)
	var/mob/living/carbon/human/gamer = user
	if(gamer != owner)
		return
	if (M.stat != DEAD)
		if(user == M)
			to_chat(user, span_warning("I'm already chained to this tome!"))
			return
		if(ishuman(M))
			M.visible_message(span_danger("[user] beats [M] over the head with [src]!"), \
								span_danger("[user] beats [M] over the head with [src]!"))
			if(src.allowed_readers.len <= 2 && !src.allowed_readers.Find(user))
				src.allowed_readers += M
			else
				to_chat(user, span_smallnotice("I can't change this pleboid to my tome..."))
			playsound(src.loc, "punch", 25, TRUE, -1)
			log_combat(user, M, "attacked", src)
	else
		M.visible_message(span_danger("[user] smacks [M]'s lifeless corpse with [src]."))
		playsound(src.loc, "punch", 25, TRUE, -1)

/// Book slapcrafting

/obj/item/spellbook_unfinished
	var/pages_left = 4
	name = "bound scrollpaper"
	dropshrink = 0.6
	icon = 'icons/roguetown/items/books.dmi'
	icon_state ="basic_book_0"
	desc = "Thick scroll paper bound at the spine. It lacks pages."
	throw_speed = 1
	throw_range = 5
	w_class = WEIGHT_CLASS_NORMAL		 //upped to three because books are, y'know, pretty big. (and you could hide them inside eachother recursively forever)
	attack_verb = list("bashed", "whacked", "educated")
	resistance_flags = FLAMMABLE
	drop_sound = 'sound/foley/dropsound/book_drop.ogg'
	pickup_sound =  'sound/blank.ogg'

/obj/item/spellbook_unfinished/pre_arcane
	name = "tome in waiting"
	icon_state = "spellbook_unfinished"
	desc = "A fully bound tome of scroll paper. It's lacking a certain arcane energy."
	grid_width = 32
	grid_height = 64

/obj/item/natural/hide/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				playsound(loc, 'sound/items/book_close.ogg', 100, TRUE)
				to_chat(user, span_notice("I add the first few pages to the leather cover..."))
				new /obj/item/spellbook_unfinished(loc)
				qdel(P)
				qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/paper/scroll))
		if(isturf(loc)&& (found_table))
			var/crafttime = (60 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(pages_left > 0)
					playsound(loc, 'sound/items/book_page.ogg', 100, TRUE)
					pages_left -= 1
					to_chat(user, span_notice("[pages_left+1] left..."))
					qdel(P)
				else
					playsound(loc, 'sound/items/book_open.ogg', 100, TRUE)
					if(isarcane(user))
						to_chat(user, span_notice("The book is bound. I must find a catalyst to channel the arcane into it now."))
					else
						to_chat(user, span_notice("I've made an empty book of thick, useless scroll paper. I can't even thumb through it!"))
					new /obj/item/spellbook_unfinished/pre_arcane(loc)
					qdel(P)
					qdel(src)
		else
			to_chat(user, "<span class='warning'>You need to put the [src] on a table to work on it.</span>")
	else
		return ..()

/obj/item/spellbook_unfinished/pre_arcane/attackby(obj/item/P, mob/living/carbon/human/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(istype(P, /obj/item/roguegem))
		if(isturf(loc)&& (found_table))
			var/crafttime = (100 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				if(isarcane(user))
					playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
					user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
						span_notice("I run my arcane energy into the crystal. It shatters and seeps into the cover of the tome! Runes and symbols of an unknowable language cover its pages now..."))
					var/obj/item/book/granter/spellbook/newbook = new /obj/item/book/granter/spellbook(loc)
					newbook.owner = user
					newbook.desc += " Traces of [P] dust linger in its margins."
					qdel(P)
					qdel(src)
				else
					if(prob(1))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("By the Nine! That gem just exploded -- and my useless tome is filled with gleaming energy and strange letters!"))
						var/obj/item/book/granter/spellbook/newbook = new /obj/item/book/granter/spellbook(loc)
						newbook.owner = user
						newbook.desc += " Traces of [P] dust linger in its margins."
						qdel(P)
						qdel(src)
					else
						playsound(loc, 'modular_azurepeak/sound/spellbooks/icicle.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder just kind of sits on top of the [src]. Awkward."), \
							span_notice("... why and how did I just crush this gem into a worthless scroll-book? What a WASTE of sunmarks!"))
						qdel(P)
					return ..()
		else
			to_chat(user, "<span class='warning'>You need to put [src] on a table to work on it.</span>")
	else if (istype(P, /obj/item/natural/stone))
		var/obj/item/natural/stone/the_rock = P
		if (the_rock.magic_power)
			if(isturf(loc) && (found_table))
				var/crafttime = ((130 - the_rock.magic_power) - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
				if(do_after(user, crafttime, target = src))
					if (isarcane(user))
						playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
						user.visible_message(span_warning("[user] crushes [user.p_their()] [P]! Its powder seeps into the [src]."), \
							span_notice("I join my arcane energy with that of the magical stone in my hands, which shudders briefly before dissolving into motes of ash. Runes and symbols of an unknowable language cover its pages now..."))
						to_chat(user, span_notice("...yet even for an enigma of the arcane, these characters are unlike anything I've seen before. They're going to be -much- harder to understand..."))
						var/obj/item/book/granter/spellbook/newbook = new /obj/item/book/granter/spellbook(loc)
						newbook.owner = user
						newbook.born_of_rock = TRUE
						newbook.desc += " Traces of multicolored stone limn its margins."
						qdel(P)
						qdel(src)
					else
						if (prob(the_rock.magic_power)) // for reference, this is never higher than 15 and usually significantly lower
							playsound(loc, 'modular_azurepeak/sound/spellbooks/crystal.ogg', 100, TRUE)
							user.visible_message(span_warning("[user] carefully sets down [the_rock] upon [src]. Nothing happens for a moment or three, then suddenly, the glow surrounding the stone becomes as liquid, seeps down and soaks into the tome!"), \
							span_notice("I knew this stone was special! Its colourful magick has soaked into my tome and given me gift of mystery!"))
							to_chat(user, span_notice("...what in the world does any of this scribbling possibly mean?"))
							var/obj/item/book/granter/spellbook/newbook = new /obj/item/book/granter/spellbook(loc)
							newbook.owner = user
							newbook.born_of_rock = TRUE
							newbook.desc += " Traces of multicolored stone limn its margins."
							qdel(P)
							qdel(src)
						else
							user.visible_message(span_warning("[user] sets down [the_rock] upon the surface of [src] and watches expectantly. Without warning, the rock violently pops like a squashed gourd!"), \
							span_notice("No! My precious stone! It musn't have wanted to share its mysteries with me..."))
							user.electrocute_act(5, src)
							qdel(P)
		else
			to_chat(user, span_notice("This is a mere rock - it has no arcane potential. Bah!"))
			return ..()
	else
		return ..()

// chance2learn buff shit

/obj/item/roguegem
	var/arcane_potency = 20

/obj/item/roguegem/yellow
	arcane_potency = 5

/obj/item/roguegem/green
	arcane_potency = 7

/obj/item/roguegem/violet
	arcane_potency = 10

/obj/item/roguegem/blue
	arcane_potency = 15

/obj/item/roguegem/diamond
	arcane_potency = 25

/obj/item/roguegem/amethyst
	name = "amythortz"
	icon_state = "amethyst"
	sellprice = 18
	arcane_potency = 25
	desc = "A deep lavender crystal, it surges with magical energy, yet it's artificial nature means it is worth little."

/obj/item/book/granter/spellbook/attackby(obj/item/P, mob/living/carbon/human/user, params)
	if(istype(P, /obj/item/roguegem))
		if(!stored_gem)
			if(isarcane(user))
				var/obj/item/roguegem/gem = P
				var/crafttime = (60 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
				if(do_after(user, crafttime, target = src))
					playsound(loc, 'modular_azurepeak/sound/spellbooks/glass.ogg', 100, TRUE)
					to_chat(user, span_notice("Running my arcane energy through this crystal, I imbue the tome with my natural essence, attuning it to my state of mind..."))
					stored_gem = gem.arcane_potency
					qdel(P)
			else
				to_chat(user, span_notice("Why am I jamming a gem into a book? I must look like a fool!"))
		else
			to_chat(user, span_notice("This tome is already coursing with arcane energies..."))
	else
		return ..()

/obj/effect/roguerune/
	name = "arcane rune"
	desc = "Strange symbols pulse upon the ground..."
	anchored = TRUE
	icon = 'icons/obj/rune.dmi'
	icon_state = "6"
	resistance_flags = FIRE_PROOF | UNACIDABLE | ACID_PROOF
	layer = SIGIL_LAYER
	color = "#3A0B61"
	var/spellbonus = 15
	var/scribe_damage = 10

/obj/item/rogueweapon/huntingknife/idagger/silver/arcane
	name = "glowing purple silver dagger"
	desc = "This dagger glows a faint purple. Powder runs across its blade."
	var/is_bled = FALSE
	var/rune_to_scribe = /obj/effect/roguerune/

/obj/item/rogueweapon/huntingknife/idagger/silver/attackby(obj/item/M, mob/user, params)
	var/mob/living/carbon/gamer = user
	if(istype(M, /obj/item/alch/golddust))
		if(isarcane(gamer))
			var/crafttime = (60 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
			if(do_after(user, crafttime, target = src))
				playsound(loc, 'modular_azurepeak/sound/spellbooks/scrapeblade.ogg', 100, TRUE)
				to_chat(user, span_notice("I scrape the arcane powder into the blade, and it throbs in a deep purple..."))
				var/obj/arcane_knife = new /obj/item/rogueweapon/huntingknife/idagger/silver/arcane
				qdel(M)
				qdel(src)
				user.put_in_active_hand(arcane_knife)
	else 
		return ..()

/obj/item/rogueweapon/huntingknife/idagger/silver/arcane/attack_self(mob/living/carbon/human/user)
	if(!isarcane(user))
		return
	if(!is_bled)
		playsound(loc, get_sfx("genslash"), 100, TRUE)
		user.visible_message(span_warning("[user] cuts open [user.p_their()] palm!"), \
							span_cult("I slice open my palm!"))
		if(user.blood_volume)
			var/obj/effect/roguerune/rune = rune_to_scribe
			user.apply_damage(initial(rune.scribe_damage), BRUTE, pick(BODY_ZONE_L_ARM, BODY_ZONE_R_ARM))
		is_bled = TRUE
		return
	var/turf/Turf = get_turf(user)
	if(locate(/obj/effect/roguerune) in Turf)
		to_chat(user, span_cult("There is already a rune here."))
		return
	var/crafttime = (100 - ((user.mind?.get_skill_level(/datum/skill/magic/arcane))*5))
	if(do_after(user, crafttime, target = src))
		playsound(loc, 'modular_azurepeak/sound/spellbooks/bladescrape.ogg', 100, TRUE)
		user.visible_message(span_warning("[user] carves an arcane rune with [user.p_their()] [src]!"), \
							span_notice("I drag the blade in symbols and circles, the manna powder falling into the crevices as I trace arcane patterns. A rune now carved before me in iridiscent purple."))
		new rune_to_scribe(Turf)
		var/obj/silver_knife = new /obj/item/rogueweapon/huntingknife/idagger/silver/
		qdel(src)
		user.put_in_active_hand(silver_knife)
	
// helper proc
/proc/isarcane(mob/living/carbon/human/A)
	return istype(A) && A.mind && (A.mind?.get_skill_level(/datum/skill/magic/arcane) > SKILL_LEVEL_NONE)

/obj/effect/roguerune/proc/do_invoke_glow()
	set waitfor = FALSE
	animate(src, transform = matrix()*2, alpha = 0, time = 5, flags = ANIMATION_END_NOW) //fade out
	sleep(5)
	animate(src, transform = matrix(), alpha = 255, time = 0, flags = ANIMATION_END_NOW)
	qdel(src)

/obj/item/book/granter/spellbook/magician/Initialize()
	. = ..()
	var/mob/living/carbon/human/L = loc
	owner = L
	
/proc/get_arcane_exp(level_amount)
	var/returnval
	switch(level_amount)
		if(SKILL_LEVEL_NONE)
			returnval = SKILL_EXP_NOVICE
		if(SKILL_LEVEL_NOVICE)
			returnval = SKILL_EXP_APPRENTICE - SKILL_EXP_NOVICE
		if(SKILL_LEVEL_APPRENTICE)
			returnval = SKILL_EXP_JOURNEYMAN - SKILL_EXP_APPRENTICE
		if(SKILL_LEVEL_JOURNEYMAN)
			returnval = SKILL_EXP_EXPERT - SKILL_EXP_JOURNEYMAN
		if(SKILL_LEVEL_EXPERT)
			returnval = SKILL_EXP_MASTER - SKILL_EXP_EXPERT
		if(SKILL_LEVEL_MASTER)
			returnval = SKILL_EXP_LEGENDARY - SKILL_EXP_MASTER
	return returnval
