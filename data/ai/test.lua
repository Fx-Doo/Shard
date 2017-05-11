function dump(o)
   if type(o) == 'table' then
      local s = '{ '
      for k,v in pairs(o) do
         if type(k) ~= 'number' then k = '"'..k..'"' end
         s = s .. '['..k..'] = ' .. dump(v) .. ','
      end
      return s .. '} '
   else
      return tostring(o)
   end
end
require "boot"
shard_include "ai"
shard_include "unithandler"
ai = ShardAI()
ai:Init()
print( dump( ai ) )
u = UnitHandler()

print( dump( u ) )
u:SetAI(ai)