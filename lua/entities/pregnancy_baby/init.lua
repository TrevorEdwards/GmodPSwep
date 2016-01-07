AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )
include('shared.lua')


local schedJump = ai_schedule.New( "Jump" ) 
schedJump:EngTask( "TASK_PLAY_SEQUENCE", ACT_JUMP )


ENT.adult = "npc_citizen"
ENT.model = "models/Humans/Group01/Female_01.mdl"

function ENT:SpawnFunction(ply, tr)

	if (!tr.Hit) then return end
	
	local SpawnPos = tr.HitPos + tr.HitNormal * -1
	
	local ent = ents.Create("pregnancy_baby")
	ent:SetPos(SpawnPos + Vector(0,0,10))
	ent:Spawn()
	ent:Activate()
	
	return ent
end




function ENT:Initialize()
	self.Entity.Destructed = false
	self.Entity:SetModel("models/props_c17/doll01.mdl")
	self.Entity:PhysicsInit(SOLID_VPHYSICS)
	self.Entity:SetSolid(SOLID_VPHYSICS)

    local phys = self.Entity:GetPhysicsObject()
	local ranNum = math.random(1,3)
	if(ranNum == 1) then
	self:EmitSound("vo/heavy_award0"..math.random(1,9)..".wav")
	elseif(ranNum == 2) then
	self:EmitSound("vo/heavy_battlecry0"..math.random(1,6)..".wav")
	else
	self:EmitSound("vo/heavy_cheers0"..math.random(1,8)..".wav")
	end
	self:beABaby()
	
end


function ENT:beABaby()

for i=0,64 do
timer.Simple(i / 4, function()
if(IsValid(self)) then
	local mini = -5 * i
	local maxi = 5 * i

	self:GetPhysicsObject():AddVelocity( Vector(math.random(mini,maxi), math.random(mini,maxi), math.random(mini,maxi)) )
end
end)
end

for i=2,3 do

timer.Simple(4 * i, function()

	if(IsValid(self)) then
	
		local ranNum = math.random(1,3)
	if(ranNum == 1) then
	self:EmitSound("vo/heavy_award0"..math.random(1,9)..".wav")
	elseif(ranNum == 2) then
	self:EmitSound("vo/heavy_battlecry0"..math.random(1,6)..".wav")
	else
	self:EmitSound("vo/heavy_cheers0"..math.random(1,8)..".wav")
	end
	
	end

end)

end

timer.Simple(19,function()
if(IsValid(self)) then
	self:EmitSound("pregnancygiggle.wav")
end
end)

timer.Simple(20,function()
if(IsValid(self)) then


local explode = ents.Create( "env_explosion" ) -- creates the explosion
	explode:SetPos( self:GetPos())
	-- this creates the explosion through your self.Owner:GetEyeTrace, which is why I put eyetrace in front
	explode:SetOwner( self.Owner ) -- this sets you as the person who made the explosion
	explode:Spawn() --this actually spawns the explosion
	explode:SetKeyValue( "iMagnitude", "50" ) -- the magnitude
	explode:Fire( "Explode", 0, 0 )


self:Remove()
end
end)

end


function ENT:OnRemove()
end

function ENT:Use()
end




