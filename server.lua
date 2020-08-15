roleList = {
  -- {id, "name"}
  -- {523428056807456, "Owner"}
}

function GetRole(roleName)
  for k, v in ipairs(roleList) do
    if v[2] == roleName then
      return v[1]
    end
  end
end

acePerms = {
  -- {GetRole("name"), "aceperm"}
  -- {GetRole("Owner"), "group.owner"}
}

local function has_value (tab, val)
    for index, value in ipairs(tab) do
        if value == val then
            return true
        end
    end

    return false
end

function PlayerIdentifier(type, id)
    local identifiers = {}
    local numIdentifiers = GetNumPlayerIdentifiers(id)

    for a = 0, numIdentifiers do
        table.insert(identifiers, GetPlayerIdentifier(id, a))
    end

    for b = 1, #identifiers do
        if string.find(identifiers[b], type, 1) then
            return identifiers[b]
        end
    end
    return false
end

roles = {}

function hasRank(hex, rank)
  if not roles[hex] then return end
  for i = 1, #roles[hex] do
    if tonumber(GetRole(rank)) == tonumber(roles[hex][i]) then
      return true
    end
  end
  return false
end

AddEventHandler('onResourceStart', function(resourceName)
  if (GetCurrentResourceName() ~= resourceName) then
    return
  end
end)

AddEventHandler("playerConnecting", function()
  local src = source
  local steamid = string.sub(tostring(PlayerIdentifier("steam", src)), 7)
  roles[steamid] = {}
  for k, v in ipairs(GetPlayerIdentifiers(src)) do
			if string.sub(v, 1, string.len("discord:")) == "discord:" then
				identifierDiscord = v
			end
	end

  if identifierDiscord then
			local roleIDs = exports.discord_perms:GetRoles(src)
			if not (roleIDs == false) then
        for i = 1, #acePerms do
					for j = 1, #roleIDs do
            table.insert(roles[steamid], roleIDs[j])
						if (tostring(acePerms[i][1]) == tostring(roleIDs[j])) then
							ExecuteCommand("add_principal identifier.steam:" .. steamid .. " " .. acePerms[i][2])
						end
					end
				end
			end
		end
end)
