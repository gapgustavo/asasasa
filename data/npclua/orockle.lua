local internalNpcName = "Orockle"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 13418
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

--[[
	if MsgContains(message, "fight") then
		npcHandler:say("You can help in the fight against the hive. There are several missions available to destabilise the hive. Just ask for them if you want to learn more. After completing many missions you might be worthy to get a reward.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "mission") then
		npcHandler:say("You could try to blind the hive, you might disrupt its digestion, you could gather acid or you can disable the swarm pores. ...", npc, creature)
		npcHandler:setTopic(playerId, 2)

	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("So be it. Now you are a member of the inquisition. You might ask me for a mission to raise in my esteem.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
--]]
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

npcConfig.shop = {
	{ itemName = "blob bomb", clientId = 13976, buy = 150 },
	{ itemName = "flask of chitin dissolver", clientId = 14052, buy = 150 },
	{ itemName = "gooey substance", clientId = 14051, buy = 150 },
	{ itemName = "reagent flask", clientId = 14054, buy = 200 },
	{ itemName = "strange powder", clientId = 13974, buy = 150 },
	{ itemName = "swarmer drum", clientId = 14255, buy = 200 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, inBackpacks, name, totalCost)
	npc:sellItem(player, itemId, amount, subType, true, inBackpacks, 2854)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Bought %ix %s for %i %s.", amount, name, totalCost, ItemType(npc:getCurrency()):getPluralName():lower()))
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, clientId, subtype, amount, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
