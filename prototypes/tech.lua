if data.raw.technology["advanced-electronics"].effects == nil then
   data.raw.technology["advanced-electronics"].effects = {}
end
table.insert(data.raw.technology["advanced-electronics"].prerequisites, "circuit-network")
