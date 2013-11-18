require "unitlists"

FactoryRegisterBehaviour = class(Behaviour)

local DebugEnabled = false

local function EchoDebug(inStr)
	if DebugEnabled then
		game:SendToConsole("FactoryRegisterBehaviour: " .. inStr)
	end
end

function FactoryRegisterBehaviour:Init()
    self.name = self.unit:Internal():Name()
    self.id = self.unit:Internal():ID()
    self.position = self.unit:Internal():GetPosition() -- factories don't move
    self.level = unitTable[self.name].techLevel
    self:KeepFactoryLanesClear()
end

function FactoryRegisterBehaviour:UnitCreated(unit)

end

function FactoryRegisterBehaviour:UnitIdle(unit)

end

function FactoryRegisterBehaviour:Update()
	-- don't add factories to factory location table until they're done
	if not self.finished then
		local f = game:Frame()
		if f % 60 == 0 then
			if self.unit ~= nil then
				local unit = self.unit:Internal()
				if unit ~= nil then
					if not unit:IsBeingBuilt() then
						self:Register()
						self.finished = true
					end
				end
			end
		end
	end
end

function FactoryRegisterBehaviour:Activate()

end

function FactoryRegisterBehaviour:Deactivate()
end

function FactoryRegisterBehaviour:Priority()
	return 0
end

function FactoryRegisterBehaviour:UnitDead(unit)
	if unit.engineID == self.unit.engineID then
		-- game:SendToConsole("factory " .. self.name .. " died")
		if self.finished then
			self:Unregster()
		end
	end
end

function FactoryRegisterBehaviour:Unregster()
	ai.factories = ai.factories - 1
	local un = self.name
    local level = self.level
   	EchoDebug("factory " .. un .. " level " .. level .. " unregistering")
   	ai.buildsitehandler:DoBuildHereNow(self.id)
   	for i, factory in pairs(ai.factoriesAtLevel[level]) do
   		if factory == self then
   			table.remove(ai.factoriesAtLevel[level], i)
   			break
   		end
   	end
    local maxLevel = 0
    -- reassess maxFactoryLevel
    for level, factories in pairs(ai.factoriesAtLevel) do
    	if #factories > 0 and level > maxLevel then
    		maxLevel = level
    	end
    end
    ai.maxFactoryLevel = maxLevel
	-- game:SendToConsole(ai.factories .. " factories")
end

function FactoryRegisterBehaviour:Register()
	if ai.factories ~= nil then
		ai.factories = ai.factories + 1
	else
		ai.factories = 1
	end
	-- register maximum factory level
    local un = self.name
    local level = self.level
	if ai.factoriesAtLevel[level] == nil then
		ai.factoriesAtLevel[level] = {}
	end
	table.insert(ai.factoriesAtLevel[level], self)
	if level > ai.maxFactoryLevel then
		-- so that it will start producing combat units
		ai.attackhandler:NeedLess()
		ai.attackhandler:NeedLess()
		ai.bomberhandler:NeedLess()
		ai.bomberhandler:NeedLess()
		ai.raidhandler:NeedMore()
		ai.raidhandler:NeedMore()
		-- set the current maximum factory level
		ai.maxFactoryLevel = level
	end
	-- game:SendToConsole(ai.factories .. " factories")
end

function FactoryRegisterBehaviour:KeepFactoryLanesClear()
 	if factoryExitSides[self.name] ~= nil and factoryExitSides[self.name] ~= 0 then
	    -- inform the build handler not to build where the units exit
	    local noBottom = api.Position()
	    noBottom.x = self.position.x
	    noBottom.z = self.position.z + 80
	    noBottom.y = self.position.y
	    ai.buildsitehandler:DontBuildHere(noBottom, 80, self.id)
	    local noBottom2 = api.Position()
	    noBottom2.x = self.position.x
	    noBottom2.z = self.position.z + 240
	    noBottom2.y = self.position.y
	    ai.buildsitehandler:DontBuildHere(noBottom2, 80, self.id)
	    if factoryExitSides[self.name] == 2 then
	    	local noTop = api.Position()
		    noTop.x = self.position.x
		    noTop.z = self.position.z - 80
		    noTop.y = self.position.y
	    	ai.buildsitehandler:DontBuildHere(noTop, 80, self.id)
	    	local noTop2 = api.Position()
		    noTop2.x = self.position.x
		    noTop2.z = self.position.z - 240
		    noTop2.y = self.position.y
	    	ai.buildsitehandler:DontBuildHere(noTop2, 80, self.id)
	    elseif factoryExitSides[self.name] == 3 or factoryExitSides[self.name] == 4 then
	    	local noLeft = api.Position()
	    	noLeft.x = self.position.x - 80
	    	noLeft.z = self.position.z
	    	noLeft.y = self.position.y
	    	ai.buildsitehandler:DontBuildHere(noLeft, 80, self.id)
	    	local noRight = api.Position()
	    	noRight.x = self.position.x + 80
	    	noRight.z = self.position.z
	    	noRight.y = self.position.y
	    	ai.buildsitehandler:DontBuildHere(noRight, 80, self.id)
	    	if factoryExitSides[self.name] == 4 then
	    		local noTop = api.Position()
			    noTop.x = self.position.x
			    noTop.z = self.position.z - 80
			    noTop.y = self.position.y
		    	ai.buildsitehandler:DontBuildHere(noTop, 80, self.id)
	    	end
	    end
	end
end