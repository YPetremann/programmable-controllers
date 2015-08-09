for i,v in ipairs(game.players) do
	v.force.reset_recipes()
	v.force.reset_technologies()
	local res=true
	for k,tech in ipairs(v.force.technologies["programmable-controllers"].prerequisites) do
	  if not tech.researched then
	    res=false
	    break
	  end
	end
	v.force.technologies["programmable-controllers"].enabled=res
	
	if v.force.technologies["programmable-controllers"].researched == true then
		v.force.recipes["controller-in"].enabled = true
                v.force.recipes["controller-mem"].enabled = true
                v.force.recipes["controller-cpu"].enabled = true
                v.force.recipes["controller-out"].enabled = true
	end
	
end
