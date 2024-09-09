local function characterStatusSet(hp, sp, atk, def)
	return {
		hp = 0,
		sp = 0,
		atk = 0,
		def = 0
	}
end

local function AkaneSets(hp, sp, atk, def)
	local akane = characterStatusSet(hp, sp, atk, def)
	
	akane.hp = 100
	akane.sp = 80
	akane.atk = 12
	akane.def = 7
	
	akane.s_sword = function(self)				--Short Sword
		self.atk = self.atk + 15
	end
	akane.l_slicer = function(self)				--Lethal Slicer
		self.atk = self.atk + 28
		self.sp = self.sp - 20
	end
	akane.heal = function(self)					--Heal
		self.hp = self.hp + 40
		if self.hp > 100 then
			self.hp = 100
			self.sp = self.sp - 12
		elseif self.hp <= 100 then
			self.sp = self.sp - 12
		end
	end
	akane.defend = function(self)				--Defend (skips turn)
		self.def = self.def + 3
	end
	
	return akane
end

local function BeastSets(hp, sp, atk, def)
	local beast = characterStatusSet(hp, sp, atk, def)
	
	beast.hp = 350
	beast.sp = 140
	beast.atk = 5
	beast.def = 2
	
	beast.claw_sl = function(self)				--Claw Slash
		self.atk = self.atk + 10
	end
	beast.claw_st = function(self)				--Claw Stab
		self.atk = self.atk + 17
		self.sp = self.sp - 10
	end
	beast.c_fang = function(self)					--Crusher Fang
		self.atk = self.atk + 25
		self.sp = self.sp - 18
	end
	beast.defend = function(self)
		self.def = self.def + 1
	end
	
	return beast
end

local akane = AkaneSets(hp, sp, atk, def)
local beast = BeastSets(hp, sp, atk, def)
print("BATTLE!")
repeat
	local a_uses = "Akane uses"
	local a_has = "Akane has"
	local b_uses = "Beast uses"
	local b_has = "Beast has"
	local not_sp = "Not enough SP!"
	local set_hp_zero = 0
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
	print("### AKANE'S TURN! ###\nDecide your movement!\nType '1' to Attack, '2' to Special or anything else to Defend")
	local function akaneNormalMoveConfig()
		local dec1 = io.read()
		if tonumber(dec1) == 1 then
			print("".. a_uses .." Short Sword!")
			akane:s_sword()
			beast.hp = beast.hp - (akane.atk - beast.def)
			beastSetHpZero()
			print("".. b_has .." ".. beast.hp .."HP!")
			akane.atk = 12
			beast.def = 2
		elseif tonumber(dec1) == 2 then
			print("Decide your special movement!\nType '1' to Special Attack, '2' to Heal or anything else to Back")
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
						akane.atk = 12
						beast.def = 2
					end
				elseif tonumber(dec2) == 2 then
					if akane.hp == 100 then
						if akane.sp < 12 then
							print(not_sp)
							akaneSpecialMoveConfig()
						elseif akane.sp >= 12 then
							print("Your HP is already at max!")
							akaneSpecialMoveConfig()
						end
					elseif akane.hp < 100 and akane.sp < 12 then
						print(not_sp)
						akaneSpecialMoveConfig()
					elseif akane.hp < 100 and akane.sp >= 12 then
						print("".. a_uses .." Heal!")
						akane:heal()
						print("".. a_has .." ".. akane.hp .."HP!\n".. a_has .." ".. akane.sp .."SP!")
						beast.def = 2
					end
				else
					print("Decide your movement!\nType '1' to Attack, '2' to Special or anything else to Defend")
					akaneNormalMoveConfig()
				end
			end
			akaneSpecialMoveConfig()
		else
			print("".. a_uses .." Defend!")
			akane:defend()
			print("".. a_has .." ".. akane.def .."DEF!")
			beast.def = 2
		end
	end
	akaneNormalMoveConfig()
	if beast.hp == 0 then
		break
	end
	
	print("### BEAST'S TURN! ###")
	math.randomseed(os.time())
	local function beastMoveConfig()
		local b_move = math.random(1, 4)
		if b_move == 1 then
			print("".. b_uses .." Claw Slash!")
			beast:claw_sl()
			akane.hp = akane.hp - (beast.atk - akane.def)
			akaneSetHpZero()
			print("".. a_has .." ".. akane.hp .."HP!")
			beast.atk = 5
			akane.def = 7
		elseif b_move == 2 then
			if beast.sp < 10 then
				beastMoveConfig()
			elseif beast.sp >= 10 then
				print("".. b_uses .." Claw Stab!")
				beast:claw_st()
				akane.hp = akane.hp - (beast.atk - akane.def)
				akaneSetHpZero()
				print("".. a_has .." ".. akane.hp .."HP!\n".. b_has .." ".. beast.sp .."SP!")
				beast.atk = 5
				akane.def = 7
			end
		elseif b_move == 3 then
			if beast.sp < 18 then
				beastMoveConfig()
			elseif beast.sp >= 18 then
				print("".. b_uses .." Crusher Fang!")
				beast:c_fang()
				akane.hp = akane.hp - (beast.atk - akane.def)
				akaneSetHpZero()
				print("".. a_has .." ".. akane.hp .."HP!\n".. b_has .." ".. beast.sp .."SP!")
				beast.atk = 5
				akane.def = 7
			end
		elseif b_move == 4 then
			print("".. b_uses .." Defend!")
			beast:defend()
			print("".. b_has .." ".. beast.def .."DEF!")
			akane.def = 7
		end
	end
	beastMoveConfig()
	local set_hp_zero = 0
	if akane.hp < 0 then
		set_hp_zero = 0
		if set_hp_zero == 0 then
			akane.hp = 0
		end
	end
	if beast.hp < 0 then
		set_hp_zero = 0
		if set_hp_zero == 0 then
			beast.hp = 0
		end
	end
until akane.hp == 0 or beast.hp == 0
if akane.hp == 0 then
	print("GAME OVER")
elseif beast.hp == 0 then
	print("VICTORY!")
end