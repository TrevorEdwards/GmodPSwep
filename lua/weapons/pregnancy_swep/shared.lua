
if SERVER then
	AddCSLuaFile ("shared.lua")
	AddCSLuaFile ("init.lua")
	SWEP.AutoSwitchTo		= false
	SWEP.AutoSwitchFrom		= false
	SWEP.HoldType			= "rpg"
else
	SWEP.BobScale			= 2
	SWEP.SwayScale			= 3
	SWEP.DrawCrosshair		= true
	SWEP.PrintName			= "Pregnancy SWEP"
	SWEP.Slot = 1
	SWEP.SlotPos = 1
	killicon.AddFont( "pregnancy_swep", "default", " gave babies to ", Color( 225, 0, 0, 255 ) )
end


SWEP.Author			= "TB002"
SWEP.Contact		= ""
SWEP.Purpose		= "Makes NPCs Pregnant with babies."
SWEP.Instructions	= "Left click to make things pregnant.  Right click to make babies grow up.  Reload to make NPCs explode."

SWEP.Spawnable				= true
SWEP.AdminSpawnable			= true


SWEP.Category			= "TB002"

SWEP.ViewModel			= "models/Weapons/V_hands.mdl"
SWEP.WorldModel			= "models/Weapons/w_suitcase_passenger.mdl"

SWEP.Primary.ClipSize		= -1 
SWEP.Secondary.ClipSize		= -1 
SWEP.Primary.DefaultClip	= -1 
SWEP.Primary.Automatic		= true 
SWEP.Primary.Delay		=  .1
SWEP.Secondary.Delay		=  1
SWEP.Primary.Ammo			= "none" 
SWEP.Secondary.Ammo			= "none" 
SWEP.UseHands = true





function SWEP:SecondaryAttack()

	self.target = self.Owner:GetEyeTrace().Entity
	self.tracepos = self.Owner:GetEyeTrace().HitPos
	
	if(IsValid(self.target)) then
	if(self.target:GetClass() == "pregnancy_baby") then
		self.Weapon:EmitSound("Weapon_Bugbait.Splat")
		self:babyGrowUp()
	end
	
	else
	local entstoattack = ents.FindInSphere(self.tracepos,600)
	if entstoattack != nil then
		for _,v in pairs(entstoattack) do
			if(IsValid(v)) then
				if(v:GetClass() == "pregnancy_baby") then
					timer.Simple(math.random(0,5)/10, function()
					if(IsValid(v)) then
					self.Weapon:EmitSound("Weapon_Bugbait.Splat")
					self:specBabyGrowUp(v)
					end
					end)
					end
				end
			end
	end
	end
end


function SWEP:PrimaryAttack()
 
target = self.Owner:GetEyeTrace().Entity
tracepos = self.Owner:GetEyeTrace().HitPos

if(IsValid(target)) then
	
	if(target:IsNPC()) then
	self:makePregnant(self.target)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
	self.Owner:SetAnimation( PLAYER_ATTACK1 );

	self:SetNextPrimaryFire( CurTime() + self.Primary.Delay )
	self:SetNextSecondaryFire( CurTime() + self.Primary.Delay ) 
	end
	
	else

local entstoattack = ents.FindInSphere(tracepos,600)
	if entstoattack != nil then
		for _,v in pairs(entstoattack) do
			if(IsValid(v)) then
				if(v:IsNPC()) then
					timer.Simple(math.random(0,200)/100, function()
						if(IsValid(v) && IsValid(self)) then
							self:makePregnant(v)
						end
					end)
				end
			end
	end

end
end
end

function SWEP:Reload()

tracepos = self.Owner:GetEyeTrace().HitPos

local entstoattack = ents.FindInSphere(tracepos,150)
	if entstoattack != nil then
		for _,v in pairs(entstoattack) do
			if(IsValid(v)) then
				if(v:IsNPC()) then
					timer.Simple(math.random(0,20)/10, function()
						if(IsValid(v)) then
						
							local pPos = v:GetPos() + Vector(0,0, 10)
							local explode = ents.Create( "env_explosion" ) -- creates the explosion
							explode:SetPos( v:GetPos())
							explode:SetOwner( self:GetOwner() ) -- this sets you as the person who made the explosion
							explode:Spawn() --this actually spawns the explosion
							explode:SetKeyValue( "iMagnitude", "0" ) -- the magnitude
							explode:Fire( "Explode", 0, 0 )
							v:Remove()
						
						end
					end)
				end
			end
	end

end
end



function SWEP:Initialize()
	if ( SERVER ) then 
 		self:SetWeaponHoldType( self.HoldType ) 
 	end 
	self.ActivityTranslate = {}
	self.ActivityTranslate[ACT_HL2MP_IDLE] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK] = ACT_HL2MP_WALK_MELEE
	self.ActivityTranslate[ACT_HL2MP_RUN] = ACT_HL2MP_RUN_MELEE
	self.ActivityTranslate[ACT_HL2MP_IDLE_CROUCH] = ACT_HL2MP_IDLE_MELEE
	self.ActivityTranslate[ACT_HL2MP_WALK_CROUCH] = ACT_HL2MP_WALK_CROUCH_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RANGE_ATTACK] = ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE
	self.ActivityTranslate[ACT_HL2MP_GESTURE_RELOAD] = ACT_HL2MP_GESTURE_RELOAD_MELEE
	self.ActivityTranslate[ACT_HL2MP_JUMP] = ACT_HL2MP_JUMP_MELEE
	self.ActivityTranslate[ACT_RANGE_ATTACK1] = ACT_RANGE_ATTACK_MELEE
	--util.PrecacheSound("vo/heavy_battlecry0"..(math.random(1,7))..".wav")
end

function SWEP:babyGrowUp()
local trace = self.trace
local target = self.target
local tracepos = self.tracepos

	if (IsValid(self) && IsValid(target) && target != nil && self.target:GetClass() == "pregnancy_baby") then
		local tpos = target:GetPos()
				target:EmitSound("vo/heavy_thanks0".. math.random(1,3) ..".wav")
				
				local vPoint = target:GetPos()
					local effectdata = EffectData()
					effectdata:SetStart( vPoint ) 
					effectdata:SetOrigin( vPoint )
					effectdata:SetScale( 6 )
					util.Effect( "cball_bounce", effectdata )	
				local ent = ents.Create(target.Adult)
				ent:SetPos(tpos)
				ent:SetModel(target.Model)
				ent:SetSkin(target.Skin)
				target:Remove()
				ent:Spawn()
				ent:Activate()
				ent:SetModel(target.Model)
				ent:SetSkin(target.Skin)
				ent.pregnant = true
				timer.Simple(4, function()
				ent.pregnant = false
				end)
				cleanup.Add(self:GetOwner(), "NPCs", ent )
				undo.Create( "Grown Up Baby" )
				undo.AddEntity( ent )
				undo.SetPlayer( self:GetOwner() )
				undo.SetCustomUndoText( "Undone Grown Up Baby" )
				undo.Finish()
	end
end

function SWEP:specBabyGrowUp( target )

	if (IsValid(self) && IsValid(target) && target != nil && target:GetClass() == "pregnancy_baby") then
		local tpos = target:GetPos()
				target:EmitSound("vo/heavy_thanks0".. math.random(1,3) ..".wav")
				
				local vPoint = target:GetPos()
					local effectdata = EffectData()
					effectdata:SetStart( vPoint ) 
					effectdata:SetOrigin( vPoint )
					effectdata:SetScale( 6 )
					util.Effect( "cball_bounce", effectdata )	
				local ent = ents.Create(target.Adult)
				ent:SetPos(tpos)
				ent:SetModel(target.Model)
				ent:SetSkin(target.Skin)
				target:Remove()
				ent:Spawn()
				ent:Activate()
				ent:SetModel(target.Model)
				ent:SetSkin(target.Skin)
				ent.pregnant = true
				timer.Simple(4, function()
				ent.pregnant = false
				end)
				cleanup.Add(self:GetOwner(), "NPCs", ent )
				undo.Create( "Grown Up Baby" )
				undo.AddEntity( ent )
				undo.SetPlayer( self:GetOwner() )
				undo.SetCustomUndoText( "Undone Grown Up Baby" )
				undo.Finish()
	end
end

function SWEP:makePregnant(anEnt)

local trace = self.trace
local target = anEnt
local tracepos = self.tracepos
local owner = self:GetOwner()

	if (IsValid(self) && IsValid(target) && target != nil && target.pregnant != true && target:IsNPC()) then
				self.Weapon:EmitSound("Grenade.Blip")
				target.pregnant = true
				target:EmitSound("vo/npc/female01/ohno.wav")
				
				
				local vPoint = target:GetPos()
					local effectdata = EffectData()
					effectdata:SetStart( vPoint ) 
					effectdata:SetOrigin( vPoint )
					effectdata:SetScale( 6 )
					util.Effect( "cball_bounce", effectdata )	
				
				for i = 1, 28 do
				timer.Simple((i/2), function()
				
						if(IsValid(target)) then
						b1 = target:LookupBone("ValveBiped.Bip01_Pelvis")
						b2 = target:LookupBone("ValveBiped.Bip01_Spine1")
						b3 = target:LookupBone("ValveBiped.Bip01_Spine2")
						b4 = target:LookupBone("ValveBiped.Bip01_Spinebut")
						b5 = target:LookupBone("ValveBiped.Bip01_Spine")
						
						
						if(b1) then ScaleBone( target, b1, .3 )	end
						if(b2) then ScaleBone( target, b2, .2 )	end
						if(b3) then ScaleBone( target, b3, .15)	end
						if(b4) then ScaleBone( target, b4, .2)	end
						if(b5) then ScaleBone( target, b5, .2)	end
						end
						
						
						-------------------------
						
				end)
				end
				for i = 1, 7 do
				timer.Simple((2*i), function()
					if(IsValid(target)) then
						target:SetColor(Color(target:GetColor().r * .95, target:GetColor().g, target:GetColor().b * .95, target:GetColor().a))
						
						
						
						
						
						
						
						
						
						
						
						
						
						if(math.random(1,2) == 2) then
						target:SetSchedule( SCHED_COWER )
						target:EmitSound("vo/npc/female01/pain0"..(math.random(1,9))..".wav")
						end
					end
				end)
				end
				
				timer.Simple((15), function()
					if(IsValid(target)) then
						target:EmitSound("vo/npc/Alyx/gasp03.wav")
						
				for i = 1, 48 do
					timer.Simple((i/16), function()
					if(IsValid(target)) then
					local vPoint = target:GetPos() + Vector(0,0,40)
					local effectdata = EffectData()
					effectdata:SetStart( vPoint ) 
					effectdata:SetOrigin( vPoint )
					effectdata:SetScale( 4 )
					util.Effect( "BloodImpact", effectdata )	
					end
					end)
				end
						
						
						local traceworld = {}
						traceworld.start = target:GetPos() // The center of Source's world, is unlikely to be the actual center of the map however.
						traceworld.endpos = traceworld.start + (Vector(0,0,-1) * 8000) 
						local trw = util.TraceLine(traceworld) 
						local worldpos1 = trw.HitPos + trw.HitNormal // Set worldpos 1. Add to the hitpos the world normal.
						local worldpos2 = trw.HitPos - trw.HitNormal // Set worldpos 2. Subtract from the hitpos the world normal.
						util.Decal("Blood",worldpos1,worldpos2)

						
						
						
					end
				end)
				
				timer.Simple(18, function()
				if(IsValid(target) ) then
				target:TakeDamage( 10000, owner, self)
				local tpos = target:GetPos() + Vector(0,0,10)
				local tclass = target:GetClass()
				local tmod = target:GetModel()
				local tskin = target:GetSkin()
				
				for i = 0, math.random(1,4) do
				timer.Simple((i/2), function()
				local vPoint = tpos
					local effectdata = EffectData()
					effectdata:SetStart( vPoint ) 
					effectdata:SetOrigin( vPoint )
					effectdata:SetScale( 6 )
					util.Effect( "cball_bounce", effectdata )
				local ent = ents.Create("pregnancy_baby")
				ent.Adult = tclass
				ent.Model = tmod
				ent.Skin = tskin
				ent:SetPos(tpos)
				ent:Spawn()
				ent:Activate()
				if(IsValid(self)) then
				cleanup.Add(self:GetOwner(), "NPCs", ent )
				end
				undo.Create( "Baby" )
				undo.AddEntity( ent )
				undo.SetPlayer( owner )
				undo.SetCustomUndoText( "Murdered a poor baby." )
				undo.Finish()
				end)
				
				end
				
				end
				end)
	
			
	end
end





function SWEP:Holster() 
	if SERVER then


	end
	return true
end

function SWEP:Deploy()
	if SERVER then


	end
	return true
end



ScaleBone = function( Entity, Bone, Scale, type )

	--local Bone, BonePos = Entity:FindNearestBone( Pos )
	if ( !Bone ) then return false end

	-- Some bones are scaled only in certain directions (like legs don't scale on length)
	--local v = GetNiceBoneScale( Entity:GetBoneName( Bone ), Scale ) * 0.1
	local v = Vector(.5,1,1) * Scale
	local TargetScale = Entity:GetManipulateBoneScale( Bone ) + v * 0.15;

	if ( TargetScale.x < 0 ) then TargetScale.x = 0; end
	if ( TargetScale.y < 0 ) then TargetScale.y = 0; end
	if ( TargetScale.z < 0 ) then TargetScale.z = 0; end

	Entity:ManipulateBoneScale( Bone, TargetScale )


end

local ScaleYZ = { "ValveBiped.Bip01_L_UpperArm", 
						  "ValveBiped.Bip01_L_Forearm", 
						  "ValveBiped.Bip01_L_Thigh",
						  "ValveBiped.Bip01_L_Calf",
						  "ValveBiped.Bip01_R_UpperArm",
						  "ValveBiped.Bip01_R_Forearm",
						  "ValveBiped.Bip01_R_Thigh",
						  "ValveBiped.Bip01_R_Calf",
						  "ValveBiped.Bip01_Spine2",
						  "ValveBiped.Bip01_Spine1",
						  "ValveBiped.Bip01_Spine",
						  "ValveBiped.Bip01_Spinebut" }

local ScaleXZ = { "ValveBiped.Bip01_pelvis" }

local function ScaleNeighbourBones( Entity, Bone, Scale, type )

	if ( type == nil || type == 2 ) then

		local parent = Entity:GetBoneParent( Bone )
		if ( parent && parent >= 0 && parent != Bone ) then
			ScaleBone( Entity, Pos, parent, Scale, 2 )
		end

	end

	if ( type == nil || type == 1 ) then

		local children = Entity:GetChildBones( Bone )

		for k, v in pairs( children ) do

			ScaleBone( Entity, Pos, v, Scale, 1 )

		end

	end

end
