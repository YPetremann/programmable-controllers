pci = {}
function sign(a)
	return (a+2147483648)%4294967296-2147483648
end
function unsign(a)
	return a%4294967296
end
function DEC_HEX(IN)
	OUT = string.format("%x", IN or 0):upper()
	while #OUT<4 do OUT = "0"..OUT end
	return OUT
end
local b=bit32
pci["pci-00"] = function(i, a) -- 00 nop -- : do nothing
end
pci["pci-01"] = function(i, a) -- 01 val #A : copy #A to %R
	r = peek(i, o+2)
	r.count = a
	if r.count > 0 then r.signal.name = "pci-00" end
	poke(i, o+2, r)
end
pci["pci-02"] = function(i, a) -- 02 get &A : copy @A to %R
	m = peek(i, a)
	poke(i, o+2, m)
end
pci["pci-03"] = function(i, a) -- 03 get @A : copy &A to %R
	p = peek(i, a)
	m = peek(i, p.count)
	poke(i, o+2, m)
end

pci["pci-04"] = function(i, a) -- 04 set &A : copy %R to &A
	r = peek(i, o+2)
	poke(i, a, r)
end
pci["pci-05"] = function(i, a) -- 05 set @A : copy %R to @A
	p = peek(i, a)
	r = peek(i, o+2)
	poke(i, p.count, r)
end
pci["pci-06"] = function(i, a) -- 06 swp @A : swap %R with @A
	m = peek(i, a)
	r = peek(i, o+2)
	poke(i, a, r)
	poke(i, o+2, m)
end
pci["pci-07"] = function(i, a) -- 07 swp &A : swap %R with &A
	p = peek(i, a)
	m = peek(i, p.count)
	r = peek(i, o+2)
	poke(i, p.count, r)
	poke(i, o+2, m)
end

pci["pci-08"] = function(i, a) -- 08 slp #A : wait #A processor cycles
	s = peek(i, o)
	if s.signal.name ~= "pci-08" then
		s = {signal= {type= "virtual", name= "pci-08"}, count= a, index= 1}
	end
	if s.count > 0 then
		pointer = pointer - 1
		s.count = s.count - 1
	else
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
	end
	poke(i, o, s)
end
pci["pci-09"] = function(i, a) -- 09 slp @A : wait @A processor cycles
	p = peek(i, a).count
	s = peek(i, o)
	if s.signal.name ~= "pci-08" then
		s = {signal= {type= "virtual", name= "pci-08"}, count= p, index= 1}
	end
	if s.count > 0 then
		pointer = pointer - 1
		s.count = s.count - 1
	else
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
	end
	poke(i, o, s)
end
pci["pci-0A"] = function(i, a) -- 0A yld #A : wait #A game tick
	s = peek(i, o)
	if s.signal.name ~= "pci-0A" then
		s = {signal= {type= "virtual", name= "pci-0A"}, count= a, index= 1}
	end
	if s.count > 1 then
		pointer = pointer - 1
		s.count = s.count - 1
		brk = true
	elseif s.count == 1 then
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
		brk = true
	else
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
	end
	poke(i, o, s)
end
pci["pci-0B"] = function(i, a) -- 0B yld @A : wait @A game tick
	p = peek(i, a).count
	s = peek(i, o)
	if s.signal.name ~= "pci-0A" then
		s = {signal= {type= "virtual", name= "pci-0A"}, count= p, index= 1}
	end
	if s.count > 1 then
		pointer = pointer - 1
		s.count = s.count - 1
		brk = true
	elseif s.count == 1 then
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
		brk = true
	else
		s = {signal= {type= "virtual", name= "pci-00"}, count= 1, index= 1}
	end
	poke(i, o, s)
end

pci["pci-0C"] = function(i, a) -- 0C int @A : wait for modification on @A
	s = peek(i, o)
	r = peek(i, o+2)
	c = peek(i, a)
	if m.signal.name == "pci-0C" then
		s = m
		pointer = pointer - 1
		poke(i, o, s)
	elseif s.signal.type ~= m.signal.type or s.signal.name ~= m.signal.name or s.count ~= m.count then
		pointer = pointer - 1
	end
end
pci["pci-0D"] = function(i, a) -- 0D int &A : wait for modification on &A 
	s = peek(i, o)
	r = peek(i, o+2)
	p = peek(i, a).count
	c = peek(i, p)
	if m.signal.name == "pci-0C" then
		s = m
		pointer = pointer - 1
		poke(i, o, s)
	elseif s.signal.type ~= m.signal.type or s.signal.name ~= m.signal.name or s.count ~= m.count then
		pointer = pointer - 1
	end
end
pci["pci-0E"] = function(i, a) -- 0E hlt #A : halt with code #A
	poke(i, o, {signal= {type= "virtual", name= "pci-0E"}, count= a, index= 1})
	brk = true
end
pci["pci-0F"] = function(i, a) -- 0F hlt @A : halt with code @A
	m = peek(i, a).count
	poke(i, o, {signal= {type= "virtual", name= "pci-0E"}, count= m, index= 1})
	brk = true
end

pci["pci-10"] = function(i, a) -- 10 jmp @A : jump to @A
	pointer = a
	poke(i, o+1, {signal= {type= "virtual", name= "pci-10"}, count= a, index= 2})
end
pci["pci-11"] = function(i, a) -- 11 jmp &A : jump to &A
	p = peek(i, a).count
	pointer = p
	poke(i, o+1, {signal= {type= "virtual", name= "pci-10"}, count= p, index= 2})
end
pci["pci-12"] = function(i, a) -- 12 rjp #A : jump relative by #A
	p = peek(i, o+1).count
	pointer = p+a
	poke(i, o+1, {signal= {type= "virtual", name= "pci-10"}, count= p+a, index= 2})
end
pci["pci-13"] = function(i, a) -- 13 rjp @A : jump relative by @A
	p = peek(i, o+1).count
	m = peek(i, a).count
	pointer = p+m
	poke(i, o+1, {signal= {type= "virtual", name= "pci-10"}, count= p+m, index= 2})
end

pci["pci-14"] = function(i, a) -- 14 seq #A : skip if %R == #A
	if peek(i, o+2).count == a then
		pointer = pointer + 1
	end
end
pci["pci-15"] = function(i, a) -- 15 seq @A : skip if %R == @A
	p = peek(i, a).count
	if peek(i, o+2).count == p then
		pointer = pointer + 1
	end
end
pci["pci-16"] = function(i, a) -- 1A snq #A : skip if %R != #A
	if peek(i, o+2).count ~= a then
		pointer = pointer + 1
	end
end
pci["pci-17"] = function(i, a) -- 1B snq @A : skip if %R != @A
	p = peek(i, a).count
	if peek(i, o+2).count ~=p then
		pointer = pointer + 1
	end
end

pci["pci-18"] = function(i, a) -- 16 slt #A : skip if %R < #A
	if peek(i, o+2).count < a then
		pointer = pointer + 1
	end
end
pci["pci-19"] = function(i, a) -- 17 slt @A : skip if %R < @A
	p = peek(i, a).count
	if peek(i, o+2).count < p then
		pointer = pointer + 1
	end
end
pci["pci-1A"] = function(i, a) -- 18 sgt #A : skip if %R > #A
	if peek(i, o+2).count > a then
		pointer = pointer + 1
	end
end
pci["pci-1B"] = function(i, a) -- 19 sgt @A : skip if %R > @A
	p = peek(i, a).count
	if peek(i, o+2).count > p then
		pointer = pointer + 1
	end
end

pci["pci-1C"] = function(i, a) -- 1C slq #A : skip if %R <= #A
	if peek(i, o+2).count <= peek(i, a).count then
		pointer = pointer + 1
	end
end
pci["pci-1D"] = function(i, a) -- 1D slq @A : skip if %R <= @A
	p = peek(i, a).count
	if peek(i, o+2).count <= peek(i, p).count then
		pointer = pointer + 1
	end
end
pci["pci-1E"] = function(i, a) -- 1E sgq #A : skip if %R >= #A
	if peek(i, o+2).count >= peek(i, a).count then
		pointer = pointer + 1
	end
end
pci["pci-1F"] = function(i, a) -- 1F sgq @A : skip if %R >= @A
	p = peek(i, a).count
	if peek(i, o+2).count >= peek(i, p).count then
		pointer = pointer + 1
	end
end

pci["pci-20"] = function(i, a) -- 20 add @A : add %R to @A
	r = peek(i, o+2).count
	m = peek(i, a)
	m.count = sign(unsign(m.count) + unsign(r))
	poke(i, a, m)
end
pci["pci-21"] = function(i, a) -- 21 add &A : add %R to &A
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) + r
	poke(i, p, m)
end
pci["pci-22"] = function(i, a) -- 22 sub @A : sub %R to @A
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = unsign(m.count) - r
	poke(i, a, m)
end
pci["pci-23"] = function(i, a) -- 23 sub &A : sub %R to &A
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) + r
	poke(i, p, m)
end

pci["pci-24"] = function(i, a) -- 24 inc @A : increase @A by 1
	m = peek(i, a)
	m.count = sign(unsign(m.count) + 1)
	poke(i, a, m)
end
pci["pci-25"] = function(i, a) -- 25 inc &A : increase &A by 1
	p = peek(i, a).count
	m = peek(i, p)
	m.count = sign(unsign(m.count) + 1)
	poke(i, p, m)
end
pci["pci-26"] = function(i, a) -- 26 dec @A : decrease @A by 1
	m = unsign(peek(i, a).count)
	m.count = unsign(m.count) - 1
	poke(i, a, m)
end
pci["pci-27"] = function(i, a) -- 27 dec &A : decrease &A by 1
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) - 1
	poke(i, p, m)
end

pci["pci-28"] = function(i, a) -- 40 mul @A : multiply by %R in @A
	r = peek(i, o+2)
	m = peek(i, a)
	m.count = sign(m.count * r.count)
	poke(i, a, m)
end
pci["pci-29"] = function(i, a) -- 41 mul &A : multiply by %R in &A
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) * r
	poke(i, p, m)
end
pci["pci-2A"] = function(i, a) -- 42 dvf @A : floor division @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = math.floor(m / r)
	poke(i, a, m)
end
pci["pci-2B"] = function(i, a) -- 43 dvf &A : floor division &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = math.floor(m / r)
	poke(i, p, m)
end

pci["pci-2C"] = function(i, a) -- 44 dvc @A : ceil division @A by %R
	r = peek(i, o+2)
	m = peek(i, a)
	m.count = sign(math.ceil(m.count / r.count))
	poke(i, a, m)
end
pci["pci-2D"] = function(i, a) -- 45 dvc &A : ceil division &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = sign(math.ceil(unsign(m.count) / unsign(r)))
	poke(i, p, m)
end
pci["pci-2E"] = function(i, a) -- 46 mod @A : modulo @A by %R
	r = peek(i, o+2)
	m = peek(i, a)
	m.count = sign(unsign(m.count) % unsign(r.count))
	poke(i, a, m)
end
pci["pci-2F"] = function(i, a) -- 47 mod &A : modulo &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) % r
	poke(i, p, m)
end

pci["pci-30"] = function(i, a) -- 2C neg @A : negate @A
	m = unsign(peek(i, a).count)
	m.count = -m
	poke(i, a, m)
end
pci["pci-31"] = function(i, a) -- 2D neg &A : negate &A
	p = peek(i, a).count
	m = peek(i, p)
	m.count = -m
	poke(i, p, m)
end
pci["pci-32"] = function(i, a) -- 2E not @A : bitwise not @A
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = -r-1
	poke(i, a, m)
end
pci["pci-33"] = function(i, a) -- 2F not &A : bitwise not &A
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = -r-1
	poke(i, p, m)
end

pci["pci-34"] = function(i, a) -- 28 lsh @A : left shift @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = unsign(m.count) *2^ r
	poke(i, a, m)
end
pci["pci-35"] = function(i, a) -- 29 lsh &A : left shift &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = unsign(m.count) *2^ r
	poke(i, p, m)
end
pci["pci-36"] = function(i, a) -- 2A rsh @A : right shift @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = math.floor(m /2^ r)
	poke(i, a, m)
end
pci["pci-37"] = function(i, a) -- 2B rsh &A : right shift &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = math.floor(m /2^ r)
	poke(i, p, m)
end

pci["pci-38"] = function(i, a) -- 30 and @A : bitwise and @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.band(m, r)
	poke(i, a, m)
end
pci["pci-39"] = function(i, a) -- 31 and &A : bitwise and &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.band(m, r)
	poke(i, p, m)
end
pci["pci-3A"] = function(i, a) -- 32 adn @A : bitwise and @A by not %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.band(m, b.bnot(r))
	poke(i, a, m)
end
pci["pci-3B"] = function(i, a) -- 33 adn &A : bitwise and &A by not %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.band(m, b.bnot(r))
	poke(i, p, m)
end

pci["pci-3C"] = function(i, a) -- 34 nad @A : bitwise nand @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bnot(b.band(m, r))
	poke(i, a, m)
end
pci["pci-3D"] = function(i, a) -- 35 nad &A : bitwise nand &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bnot(b.band(m, r))
	poke(i, p, m)
end
pci["pci-3E"] = function(i, a) -- 36 ndn @A : bitwise nand @A by not %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bnot(b.band(m, b.bnot(r)))
	poke(i, a, m)
end
pci["pci-3F"] = function(i, a) -- 37 ndn &A : bitwise nand &A by not %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bnot(b.band(m, b.bnot(r)))
	poke(i, p, m)
end

pci["pci-40"] = function(i, a) -- 38 ior @A : bitwise or @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = unsign(m.count) - r
	poke(i, a, m)
end
pci["pci-41"] = function(i, a) -- 39 ior &A : bitwise or &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bor(unsign(m.count), r)
	poke(i, p, m)
end
pci["pci-42"] = function(i, a) -- 3A orn @A : bitwise or @A by not %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bor(unsign(m.count), b.bnot(r))
	poke(i, a, m)
end
pci["pci-43"] = function(i, a) -- 3B orn &A : bitwise or &A by not %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bor(unsign(m.count), b.bnot(r))
	poke(i, p, m)
end

pci["pci-44"] = function(i, a) -- 3C nor @A : bitwise nor @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bnot(b.bor(unsign(m.count), r))
	poke(i, a, m)
end
pci["pci-45"] = function(i, a) -- 3D nor &A : bitwise nor &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bnot(b.bor(unsign(m.count), r))
	poke(i, p, m)
end
pci["pci-46"] = function(i, a) -- 3E nrn @A : bitwise nor @A by not %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bnot(b.bor(unsign(m.count), b.bnot(r)))
	poke(i, a, m)
end
pci["pci-47"] = function(i, a) -- 3F nrn &A : bitwise nor &A by not %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bnot(b.bor(unsign(m.count), b.bnot(r)))
	poke(i, p, m)
end

pci["pci-48"] = function(i, a) -- 48 xor @A : bitwise xor @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bxor(unsign(m.count), r)
	poke(i, a, m)
end
pci["pci-49"] = function(i, a) -- 49 xor &A : bitwise xor &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bxor(unsign(m.count), r)
	poke(i, p, m)
end
pci["pci-4A"] = function(i, a) -- 4A nxr @A : bitwise nxor @A by %R
	r = peek(i, o+2).count
	m = unsign(peek(i, a).count)
	m.count = b.bxor(unsign(m.count), b.bnot(r))
	poke(i, a, m)
end
pci["pci-4B"] = function(i, a) -- 4B xrn &A : bitwise nxor &A by %R
	r = peek(i, o+2).count
	p = peek(i, a).count
	m = peek(i, p)
	m.count = b.bxor(unsign(m.count), b.bnot(r))
	poke(i, p, m)
end

pci["pci-4C"] = function(i, a) -- 4C rnd @A : random in @A
	poke(i, a, math.random(-2147483648,2147483647))
end
pci["pci-4D"] = function(i, a) -- 4D rnd &A : random in &A
	p = peek(i, a).count
	poke(i, p, math.random(-2147483648,2147483647))
end
pci["pci-4E"] = function(i, a) -- 4E rnd @A : random in @A in %R range
	r = peek(i, o+2).count
	poke(i, a, math.random(0,r))
end
pci["pci-4F"] = function(i, a) -- 4F rnd &A : random in &A in %R range
	r = peek(i, o+2).count
	p = peek(i, a).count
	poke(i, p, math.random(0,r))
end

