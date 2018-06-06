Behaviour = class(AIBase, function( b, ai, unit )
	b.ai = ai
	b.game = ai.game
	b.map = ai.map
	b.unit = unit
	b.owner = unit:Internal()
	b.engineID = unit.engineID
	b.active = false
	b.priority = 0
end)

function Behaviour:init()
end

function Behaviour:Update()
end

function Behaviour:GameEnd()
end

function Behaviour:UnitCreated(unit)
end

function Behaviour:UnitBuilt(unit)
end

function Behaviour:OwnerBuilt()
end

function Behaviour:UnitDead(unit)
end

function Behaviour:OwnerDead()
end

function Behaviour:UnitDamaged(unit,attacker,damage)
end

function Behaviour:OwnerDamaged(attacker,damage)
end

function Behaviour:UnitIdle(unit)
end

function Behaviour:OwnerIdle()
end

function Behaviour:UnitMoveFailed(unit)
	self:UnitIdle(unit)
end

function Behaviour:OwnerMoveFailed()
	self:OwnerIdle()
end

function Behaviour:Owner()
	return self.owner
end


function Behaviour:IsActive()
	return self.active
end

-- yields control of the unit, note that this may not result in deactivation,
-- there may be no other behaviours to take control
function Behaviour:YieldControlOfUnit()
	self.unit:ElectBehaviour()
end

function Behaviour:RequestControlOfUnit()
	self.unit:ElectBehaviour()
end

function Behaviour:SetPriority(new_priority)
	self.priority = new_priority
end

function Behaviour:PreActivate()
	self.active = true
end

function Behaviour:Activate()
end

function Behaviour:PreDeactivate()
	self.active = false
end

function Behaviour:Deactivate()
end

function Behaviour:Priority()
	return self.priority
end

function Behaviour:RecalculatePriority()
	self:SetPriority(0)
end

function Behaviour:IsActive()
	return self.active
end

function Behaviour:Name()
	return 'Behaviour'
end

function Behaviour:EchoDebug(...)
	if self.DebugEnabled then
		self.game:SendToConsole(self.game:GetTeamID(), self:Name(), self.unit:Internal():Name(), self.unit:Internal():ID(), ...)
	end
end
