ShardAI = class(AIBase, function(self)
	self.api = shard_include("preload/api")
	self.game = self.api.game
	self.map = self.api.map
	self.game.ai = self
	self.map.ai = self
	self.game.map = self.map
	self.game:SendToConsole("Shard by AF - playing: "..self.game:GameName().." on: "..self.map:MapName())
end)

function ShardAI:Init()
	self:include("behaviourfactory")
	self:include("unit")
	self:include("modules")

	self.modules = {}
	if next(modules) ~= nil then
		for i,m in ipairs(modules) do
			newmodule = m( self )
			self.game:SendToConsole("Shard: Adding "..newmodule:Name().." module")
			local internalname = newmodule:internalName()
			self[internalname] = newmodule
			table.insert(self.modules,newmodule)
			newmodule:Init()
		end
	end
end

function ShardAI:include( file )
	return self.api.include( file )
end

function ShardAI:require( file )
	return self:include( file )
end

function ShardAI:Update()
	if self.gameend == true then
		return
	end
	for i,m in ipairs(self.modules) do
		if m == nil then
			self.game:SendToConsole("nil module!")
		else
			m:Update()
		end
	end
end

function ShardAI:GameMessage(text)
	if self.gameend == true then
		return
	end
	for i,m in ipairs(self.modules) do
		if m == nil then
			self.game:SendToConsole("nil module!")
		else
			m:GameMessage(text)
		end
	end
end

function ShardAI:UnitCreated(engineunit)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		self.game:SendToConsole("shard found nil engineunit")
		return
	end
	for i,m in ipairs(self.modules) do
		m:UnitCreated(engineunit)
	end
end

function ShardAI:UnitBuilt(engineunit)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		self.game:SendToConsole("shard-warning: unitbuilt engineunit nil ")
		return
	end
	for i,m in ipairs(self.modules) do
		m:UnitBuilt(engineunit)
	end
end

function ShardAI:UnitDead(engineunit)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		return
	end
	for i,m in ipairs(self.modules) do
		m:UnitDead(engineunit)
	end
end

function ShardAI:UnitIdle(engineunit)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		self.game:SendToConsole("shard-warning: idle engineunit nil")
		return
	end
	
	for i,m in ipairs(self.modules) do
		m:UnitIdle(engineunit)
	end
end

function ShardAI:UnitDamaged(engineunit,engineattacker,enginedamage)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		return
	end
	-- self.game:SendToConsole("UnitDamage for " .. enginedamage:Damage())
	for i,m in ipairs(self.modules) do
		m:UnitDamaged(engineunit,engineattacker,enginedamage)
	end
end

function ShardAI:UnitMoveFailed(engineunit)
	if self.gameend == true then
		return
	end
	if engineunit == nil then
		return
	end
	for i,m in ipairs(self.modules) do
		m:UnitMoveFailed(engineunit)
	end
end

function ShardAI:GameEnd()
	self.gameend = true
	for i,m in ipairs(self.modules) do
		m:GameEnd()
	end
end

function ShardAI:AddModule( newmodule )
	local internalname = newmodule:internalName()
	self[internalname] = newmodule
	table.insert(self.modules,newmodule)
	newmodule:Init()
end
