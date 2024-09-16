local function characterStatusSet()
	return {
		hp = 0,		--Health Points
		sp = 0,		--Special Points
		atk = 0,	--Attack Points (physical attack)
		def = 0,	--Defense Points (physical defense)
		int = 0,		--Intelligence Points (magical attack)
		men = 0,	--Mentality Points (magical defense)
		xp = 0,		--Experience Points
		lvl = 0		--Level Points
	}
end

local function AkaneSets()
	local akane = characterStatusSet()
	
	--Level 0, the initial Level value
	
	--Level fixed values
	
	akane.hp_max = 100
	akane.sp_max = 80
	akane.atk_ogv = 10
	akane.def_ogv = 8
	akane.int_ogv = 5
	akane.men_ogv = 3
		
	--Interchangeable values
		
	akane.hp = akane.hp_max
	akane.sp = akane.sp_max
	akane.atk = akane.atk_ogv
	akane.def = akane.def_ogv
	akane.int = akane.int_ogv
	akane.men = akane.men_ogv
	akane.xp = 0
	akane.lvl = 0
		
	--Akane's standard movements
		
	akane.s_sword = function(self)	--s_sword is Short Sword
		self.atk = self.atk + 18
	end
	akane.defend = function(self) --defend is Defend (skips turn)
		self.def = self.def + 3
	end

	return akane
end

local function WormSets()
	local worm = characterStatusSet()
	
	--Fixed values
	
	worm.hp_max = 170
	worm.sp_max = 100
	worm.atk_ogv = 5
	worm.def_ogv = 3
	worm.int_ogv = 2
	worm.men_ogv = 0
	
	--Interchangeable values
	
	worm.hp = worm.hp_max
	worm.sp = worm.sp_max
	worm.atk = worm.atk_ogv
	worm.def = worm.def_ogv
	worm.int = worm.int_ogv
	worm.men = worm.men_ogv
	worm.xp = 1
	
	--Worm's movements
	
	worm.bite = function(self) --bite is Bite
		self.atk = self.atk + 8
	end
	worm.defend = function(self)
		self.def = self.def + 1
	end
	
	return worm
end

local function FlytrapSets()
	local flytrap = characterStatusSet()
	
	--Fixed values
	
	flytrap.hp_max = 300
	flytrap.sp_max = 120
	flytrap.atk_ogv = 10
	flytrap.def_ogv = 2
	flytrap.int_ogv = 3
	flytrap.men_ogv = 0
	
	--Interchangeable values
	
	flytrap.hp = flytrap.hp_max
	flytrap.sp = flytrap.sp_max
	flytrap.atk = flytrap.atk_ogv
	flytrap.def = flytrap.def_ogv
	flytrap.int = flytrap.int_ogv
	flytrap.men = flytrap.men_ogv
	flytrap.xp = 4
	
	--Flytrap's movements
	
	flytrap.v_whip = function(self) --v_whip is Vine Whip
		self.atk = self.atk + 11
	end
	flytrap.swallow = function(self) --swallow is Swallow
		self.hp = self.hp + 15
		self.sp = self.sp - 20
	end
	flytrap.defend = function(self)
		self.def = self.def + 2
	end

	return flytrap
end

local function BeastSets()
	local beast = characterStatusSet()
	
	--Fixed values
	
	beast.hp_max = 400
	beast.sp_max = 160
	beast.atk_ogv = 8
	beast.def_ogv = 4
	beast.int_ogv = 4
	beast.men_ogv = 1
	
	--Interchangeable values
	
	beast.hp = beast.hp_max
	beast.sp = beast.sp_max
	beast.atk = beast.atk_ogv
	beast.def = beast.def_ogv
	beast.int = beast.int_ogv
	beast.men = beast.men_ogv
	beast.xp = 9
	
	--Beast's movements
	
	beast.claw_sl = function(self) --claw_sl is Claw Slash
		self.atk = self.atk + 14
	end
	beast.claw_st = function(self) --claw_st is Claw Stab
		self.atk = self.atk + 21
		self.sp = self.sp - 14
	end
	beast.c_fang = function(self) --c_fang is Crusher Fang
		self.atk = self.atk + 29
		self.sp = self.sp - 22
	end
	beast.defend = function(self)
		self.def = self.def + 3
	end

	return beast
end

local akane = AkaneSets()
local a_turn, a_bk_norm = "### AKANE'S TURN! ###\nDecide your movement!\nType '1' to Short Sword, '2' to Special or anything else to Defend", "Decide your movement!\nType '1' to Attack, '2' to Special or anything else to Defend"
local a_uses, a_has, a_hp_max, a_sp_max = "Akane uses", "Akane has", "Akane's HP is already at max!", "Akane's SP is already at max!"
local worm = WormSets()
local flytrap = FlytrapSets()
local beast = BeastSets()
local w_uses, w_has, w_turn = "Worm uses", "Worm has", "### WORM'S TURN! ###"
local ft_uses, ft_has, ft_turn = "Flytrap uses", "Flytrap has", "### FLYTRAP'S TURN! ###"
local b_uses, b_has, b_turn = "Beast uses", "Beast has", "### BEAST'S TURN! ###"
local not_sp = "Not enough SP!"
local set_hp_zero = 0
local vic = "VICTORY!"
local g_o = "GAME OVER"

--variable settings for abilities that last multiple turns...

local hexacap = false --detects the existence of variable for ability (becomes true once ability is activated)
local hexacap_stop = - 1 --variable that counts how many turns have passed since activation (used to turn the designated ability back to false once conditions don't meet)

--leveling up

local function levelUp()

	--Level 1 bonuses

	if akane.xp >= 1 and akane.xp <= 4 then
		akane.lvl = 1
		if akane.lvl >= 1 then
	
			--Level fixed values
			
			akane.hp_max = akane.hp_max + 50
			akane.sp_max = akane.sp_max + 35
			akane.atk_ogv = akane.atk_ogv + 5
			akane.def_ogv = akane.def_ogv + 3
			akane.int_ogv = akane.int_ogv + 4
			akane.men_ogv = akane.men_ogv + 3
			
			--Interchangeable values

			akane.hp = akane.hp_max
			akane.sp = akane.sp_max
			akane.atk = akane.atk_ogv
			akane.def = akane.def_ogv
			akane.int = akane.int_ogv
			akane.men = akane.men_ogv
			
			--Abilities unlocked in this Level:
			
			akane.l_slicer = function(self) --l_slicer is Lethal Slicer
				self.atk = self.atk + 38
				self.sp = self.sp - 20
			end
			akane.heal = function(self) --heal is Heal
				self.hp = self.hp + 30
				if self.hp > self.hp_max then
					self.hp = self.hp_max
					self.sp = self.sp - 12
				elseif self.hp <= self.hp_max then
					self.sp = self.sp - 12
				end
			end
		end
		
		local new_abl1, new_abl2 = "Lethal Slicer (ATK+38 / SP-20) [Offense]", "Heal (HP+30 / SP-12) [Support]"
		print("# LEVEL UP! #\nAkane is at Level ".. akane.lvl .."!\n# NEW ABILITIES UNLOCKED! #\n".. new_abl1 .." and ".. new_abl2 .."!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl)
	
	--Level 2 bonuses	
		
	elseif akane.xp >= 5 and akane.xp <= 9 then
		akane.lvl = 2
		if akane.lvl >= 2 then

			--Level fixed values
		
			akane.hp_max = akane.hp_max + 50
			akane.sp_max = akane.sp_max + 35
			akane.atk_ogv = akane.atk_ogv + 5
			akane.def_ogv = akane.def_ogv + 3
			akane.int_ogv = akane.int_ogv + 4
			akane.men_ogv = akane.men_ogv + 2
			
			--Interchangeable values
			
			akane.hp = akane.hp_max
			akane.sp = akane.sp_max
			akane.atk = akane.atk_ogv
			akane.def = akane.def_ogv
			akane.int = akane.int_ogv
			akane.men = akane.men_ogv
			
			--Abilities unlocked in this Level:
			
			akane.imp = function(self) --imp is Implosion
				self.int = self.int + 10
				self.sp = self.sp - 17
			end
			akane.h_cap = function(self)	--h_cap is Hexa Cap
				self.def = self.def + 11
				self.sp = self.sp - 25
			end
		end
		
		local new_abl1, new_abl2 = "Implosion (INT+10 / SP-17) [Offense]", "Hexa Cap (DEF+11 / SP-25) [Support]"
		print("# LEVEL UP! #\nAkane is at Level ".. akane.lvl .."!\n# NEW ABILITIES UNLOCKED! #\n".. new_abl1 .." and ".. new_abl2 .."!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl)
		
	--Level 3 bonuses
		
	elseif akane.xp >= 10 and akane.xp <= 15 then
		akane.lvl = 3
		if akane.lvl >= 3 then
		
			--Level fixed values
			
			akane.hp_max = akane.hp_max + 50
			akane.sp_max = akane.sp_max + 35
			akane.atk_ogv = akane.atk_ogv + 5
			akane.def_ogv = akane.def_ogv + 3
			akane.int_ogv = akane.int_ogv + 4
			akane.men_ogv = akane.men_ogv + 2
			
			--Interchangeable values
			
			akane.hp = akane.hp_max
			akane.sp = akane.sp_max
			akane.atk = akane.atk_ogv
			akane.def = akane.def_ogv
			akane.int = akane.int_ogv
			akane.men = akane.men_ogv
			
			--No abilities unlocked in this Level
			
			print("# LEVEL UP! #\nAkane is at Level ".. akane.lvl .."!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl)
		end
	end
end

--Battle versus Worm

print("BATTLE!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl .."\n# WORM'S STATUS #\nHP: ".. worm.hp .."\nSP: ".. worm.sp .."\nATK: ".. worm.atk .."\nDEF: ".. worm.def .."\nINT: ".. worm.int .."\nMEN: ".. worm.men)
repeat
	local function wormSetHpZero()
		if worm.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				worm.hp = 0
			end
		end
	end
	local function akaneSetHpZero()
		if akane.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				akane.hp = 0
			end
		end
	end
	print(a_turn)
	local function akaneNormalMoveConfig()
		local dec1 = io.read()
		if tonumber(dec1) == 1 then
			print("".. a_uses .." Short Sword!")
			akane:s_sword()
			worm.hp = worm.hp - (akane.atk - worm.def)
			wormSetHpZero()
			print("".. w_has .." ".. worm.hp .."HP!")
			akane.atk = akane.atk_ogv
			worm.def = worm.def_ogv
		elseif tonumber(dec1) == 2 then
			print("You still don't have any special movements!")
			akaneNormalMoveConfig()
		else
			print("".. a_uses .." Defend!")
			akane:defend()
			print("".. a_has .." ".. akane.def .."DEF!")
			worm.def = worm.def_ogv
		end
	end
	akaneNormalMoveConfig()
	if worm.hp == 0 then break end
	
	print(w_turn)
	math.randomseed(os.time())
	local function wormMoveConfig()
		local w_move = math.random(1, 2)
		if w_move == 1 then
			print("".. w_uses .." Bite!")
			worm:bite()
			akane.hp = akane.hp - (worm.atk - akane.def)
			akaneSetHpZero()
			print("".. a_has .." ".. akane.hp .."HP!")
			worm.atk = worm.atk_ogv
			akane.def = akane.def_ogv
		elseif w_move == 2 then
			print("".. w_uses .." Defend!")
			worm:defend()
			print("".. w_has .." ".. worm.def .."DEF!")
			akane.def = akane.def_ogv
		end
	end
	wormMoveConfig()
until akane.hp == 0 or worm.hp == 0
if akane.hp == 0 then
	print(g_o)
	return
elseif worm.hp == 0 then
	print(vic)
	akane.xp = akane.xp + worm.xp
	print("Akane has ".. akane.xp .."EXP!")
	levelUp()	
end

--Battle versus Flytrap

print("BATTLE!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl .."\n# FLYTRAP'S STATUS #\nHP: ".. flytrap.hp .."\nSP: ".. flytrap.sp .."\nATK: ".. flytrap.atk .."\nDEF: ".. flytrap.def .."\nINT: ".. flytrap.int .."\nMEN: ".. flytrap.men)
repeat
	local function flytrapSetHpZero()
		if flytrap.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				flytrap.hp = 0
			end
		end
	end
	local function akaneSetHpZero()
		if akane.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				akane.hp = 0
			end
		end
	end
	print(a_turn)
	local function akaneNormalMoveConfig()
		local dec1 = io.read()
		if tonumber(dec1) == 1 then
			print("".. a_uses .." Short Sword!")
			akane:s_sword()
			flytrap.hp = flytrap.hp - (akane.atk - flytrap.def)
			flytrapSetHpZero()
			print("".. ft_has .." ".. flytrap.hp .."HP!")
			akane.atk = akane.atk_ogv
			flytrap.def = flytrap.def_ogv
		elseif tonumber(dec1) == 2 then
			print("Decide your special movement!\nType '1' to Lethal Slicer, '2' to Heal or anything else to Back")
			local function akaneSpecialMoveConfig()
				local dec2 = io.read()
				if tonumber(dec2) == 1 then
					if akane.sp < 20 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.sp >= 20 then
						print("".. a_uses .." Lethal Slicer!")
						akane:l_slicer()
						flytrap.hp = flytrap.hp - (akane.atk - flytrap.def)
						flytrapSetHpZero()
						print("".. ft_has .." ".. flytrap.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						akane.atk = akane.atk_ogv
						flytrap.def = flytrap.def_ogv
					end
				elseif tonumber(dec2) == 2 then
					if akane.hp == akane.hp_max then
						if akane.sp < 12 then
							print(not_sp)
							akaneSpecialMoveConfig()
						elseif akane.sp >= 12 then
							print(a_hp_max)
							akaneSpecialMoveConfig()
						end
					elseif akane.hp < akane.hp_max and akane.sp < 12 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.hp < akane.hp_max and akane.sp >= 12 then
						print("".. a_uses .." Heal!")
						akane:heal()
						print("".. a_has .." ".. akane.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						flytrap.def = flytrap.def_ogv
					end
				else
					print(a_bk_norm)
					akaneNormalMoveConfig()
				end
			end
			akaneSpecialMoveConfig()
		else
			print("".. a_uses .." Defend!")
			akane:defend()
			print("".. a_has .." ".. akane.def .."DEF!")
			flytrap.def = flytrap.def_ogv
		end
	end
	akaneNormalMoveConfig()
	if flytrap.hp == 0 then break end

	print(ft_turn)
	math.randomseed(os.time())
	local function flytrapMoveConfig()
		local ft_move = math.random(1, 3)
		if ft_move == 1 then
			print("".. ft_uses .." Vine Whip!")
			flytrap:v_whip()
			akane.hp = akane.hp - (flytrap.atk - akane.def)
			akaneSetHpZero()
			print("".. a_has .." ".. akane.hp .."HP!")
			flytrap.atk = flytrap.atk_ogv
			akane.def = akane.def_ogv
		elseif ft_move == 2 then
			if flytrap.sp < 20 then
				flytrapMoveConfig()
			elseif flytrap.sp >= 20 then
				print("".. ft_uses .." Swallow!")
				flytrap:swallow()
				akane.hp = akane.hp - 15
				akaneSetHpZero()
				print("".. ft_has .." ".. flytrap.hp .."HP!\n".. ft_has .." ".. flytrap.sp .."SP!\n".. a_has .." ".. akane.hp .."HP!")
				akane.def = akane.def_ogv
			end
		elseif ft_move == 3 then
			print("".. ft_uses .." Defend!")
			flytrap:defend()
			print("".. ft_has .." ".. flytrap.def .."DEF!")
			akane.def = akane.def_ogv
		end
	end
	flytrapMoveConfig()
until akane.hp == 0 or flytrap.hp == 0
if akane.hp == 0 then
	print(g_o)
elseif flytrap.hp == 0 then
	print(vic)
	akane.xp = akane.xp + flytrap.xp
	print("Akane has ".. akane.xp .."EXP!")
	levelUp()	
end

--Battle versus Beast

print("BATTLE!\n# AKANE'S STATUS #\nHP: ".. akane.hp .."\nSP: ".. akane.sp .."\nATK: ".. akane.atk .."\nDEF: ".. akane.def .."\nINT: ".. akane.int .."\nMEN: ".. akane.men .."\nEXP: ".. akane.xp .."\nLVL: ".. akane.lvl .."\n# BEAST'S STATUS #\nHP: ".. beast.hp .."\nSP: ".. beast.sp .."\nATK: ".. beast.atk .."\nDEF: ".. beast.def .."\nINT: ".. beast.int .."\nMEN: ".. beast.men)
repeat
	local function beastSetHpZero()
		if beast.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				beast.hp = 0
			end
		end
	end
	local function akaneSetHpZero()
		if akane.hp < 0 then
			set_hp_zero = 0
			if set_hp_zero == 0 then
				akane.hp = 0
			end
		end
	end
	print(a_turn)
	local function akaneNormalMoveConfig()
		local dec1 = io.read()
		if tonumber(dec1) == 1 then
			print("".. a_uses .." Short Sword!")
			akane:s_sword()
			beast.hp = beast.hp - (akane.atk - beast.def)
			beastSetHpZero()
			print("".. b_has .." ".. beast.hp .."HP!")
			akane.atk = akane.atk_ogv
			beast.def = beast.def_ogv
		elseif tonumber(dec1) == 2 then
			print("Decide your special movement!\nType '1' to Lethal Slicer, '2' to Heal, '3' to Implosion, '4' to Hexa Cap or anything else to Back")
			local function akaneSpecialMoveConfig()
				local dec2 = io.read()
				if tonumber(dec2) == 1 then
					if akane.sp < 20 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.sp >= 20 then
						print("".. a_uses .." Lethal Slicer!")
						akane:l_slicer()
						beast.hp = beast.hp - (akane.atk - beast.def)
						beastSetHpZero()
						print("".. b_has .." ".. beast.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						akane.atk = akane.atk_ogv
						beast.def = beast.def_ogv
					end
				elseif tonumber(dec2) == 2 then
					if akane.hp == akane.hp_max then
						if akane.sp < 12 then
							print(not_sp)
							akaneSpecialMoveConfig()
						elseif akane.sp >= 12 then
							print(a_hp_max)
							akaneSpecialMoveConfig()
						end
					elseif akane.hp < akane.hp_max and akane.sp < 12 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.hp < akane.hp_max and akane.sp >= 12 then
						print("".. a_uses .." Heal!")
						akane:heal()
						print("".. a_has .." ".. akane.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						beast.def = beast.def_ogv
					end
				elseif tonumber(dec2) == 3 then
					if akane.sp < 17 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.sp >= 17 then
						print("".. a_uses .." Implosion!")
						akane:imp()
						beast.hp = beast.hp - (akane.int - beast.men)
						beastSetHpZero()
						print("".. b_has .." ".. beast.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						akane.int = akane.int_ogv
						beast.def = beast.def_ogv
					end
				elseif tonumber(dec2) == 4 then
					if akane.sp < 25 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.sp >= 25 then
						print("".. a_uses .." Hexa Cap!")
						akane:h_cap()
						hexacap_stop = - 1
						hexacap = true
						print("".. a_has .." ".. akane.def .."DEF!\n".. a_has .." ".. akane.sp .."SP!")
						beast.def = beast.def_ogv
					end
				else
					print(a_bk_norm)
					akaneNormalMoveConfig()
				end
			end
			akaneSpecialMoveConfig()
		else
			print("".. a_uses .." Defend!")
			akane:defend()
			print("".. a_has .." ".. akane.def .."DEF!")
			beast.def = beast.def_ogv
		end
	end
	akaneNormalMoveConfig()
	if hexacap == true then
		hexacap_stop = hexacap_stop + 1
		if hexacap_stop == 5 then
			hexacap = false
			akane.def = akane.def_ogv
			print("".. a_has .." ".. akane.def .."DEF! Hexa Cap buff ceased!")
		end
	end	
	if beast.hp == 0 then break end
	
	print(b_turn)
	math.randomseed(os.time())
	local function beastMoveConfig()
		local b_move = math.random(1, 4)
		local a_hp_psv = akane.hp --a_hp_psv is Akane HP Previously Set Value
		if b_move == 1 then
			print("".. b_uses .." Claw Slash!")
			beast:claw_sl()
			akane.hp = akane.hp - (beast.atk - akane.def)
			if akane.hp > a_hp_psv then
				akane.hp = a_hp_psv
			end
			akaneSetHpZero()
			print("".. a_has .." ".. akane.hp .."HP!")
			beast.atk = beast.atk_ogv
			if hexacap == true then
				akane.def = akane.def
			elseif hexacap == false then
				akane.def = akane.def_ogv			
			end
		elseif b_move == 2 then
			if beast.sp < 14 then
				beastMoveConfig()
			elseif beast.sp >= 14 then
				print("".. b_uses .." Claw Stab!")
				beast:claw_st()
				akane.hp = akane.hp - (beast.atk - akane.def)
				if akane.hp > a_hp_psv then
					akane.hp = a_hp_psv
				end
				akaneSetHpZero()
				print("".. a_has .." ".. akane.hp .."HP!\n".. b_has .." ".. beast.sp .."SP!")
				beast.atk = beast.atk_ogv
				if hexacap == true then
					akane.def = akane.def
				elseif hexacap == false then
					akane.def = akane.def_ogv	
				end
			end
		elseif b_move == 3 then
			if beast.sp < 22 then
				beastMoveConfig()
			elseif beast.sp >= 22 then
				print("".. b_uses .." Crusher Fang!")
				beast:c_fang()
				akane.hp = akane.hp - (beast.atk - akane.def)
				if akane.hp > a_hp_psv then
					akane.hp = a_hp_psv
				end
				akaneSetHpZero()
				print("".. a_has .." ".. akane.hp .."HP!\n".. b_has .." ".. beast.sp .."SP!")
				beast.atk = beast.atk_ogv
				if hexacap == true then
					akane.def = akane.def
				elseif hexacap == false then
					akane.def = akane.def_ogv
				end
			end
		elseif b_move == 4 then
			print("".. b_uses .." Defend!")
			beast:defend()
			print("".. b_has .." ".. beast.def .."DEF!")
			if hexacap == true then
				akane.def = akane.def
			elseif hexacap == false then
				akane.def = akane.def_ogv
			end
		end
	end
	beastMoveConfig()
until akane.hp == 0 or beast.hp == 0
if akane.hp == 0 then
	print(g_o)
elseif beast.hp == 0 then
	print(vic)
	akane.xp = akane.xp + beast.xp
	print("Akane has ".. akane.xp .."EXP!")
	levelUp()	
end