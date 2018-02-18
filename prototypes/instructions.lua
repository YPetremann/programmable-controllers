function DEC_HEX(IN)
	OUT = string.format("%x", IN or 0):upper()
	while #OUT<2 do OUT = "0"..OUT end
	return OUT
end
function HEX_DEC(IN)
	return tonumber(IN or 0, 16)
end

for i=0,127,1 do
	local int = DEC_HEX(i)
	local grp = "pci"..(i<80 and "0" or "")..tostring(math.floor(i/8))
	if data.raw["item-subgroup"][grp] == nil then
		data:extend({{
			type = "item-subgroup",
			group = "programmable-controllers",
			name = grp,
			order = grp
		}})
	end
	data:extend({{
		type = "virtual-signal",
		name = "pci-"..int,
		icon = "__programmable-controllers__/graphics/icons/instructions/pci-"..int..".png",
		icon_size = 32,
		subgroup = grp,
		order = int
	}})
end
