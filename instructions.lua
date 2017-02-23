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
	r.c = a
	poke(i, o+2, r)
end
pci["pci-02"] = function(i, a) -- 02 get &A : copy @A to %R
	poke(i, o+2, peek(i, a))
end
pci["pci-03"] = function(i, a) -- 03 get @A : copy &A to %R
	p = peek(i, a).c
	poke(i, o+2, peek(i, p))
end

pci["pci-04"] = function(i, a) -- 04 set &A : copy %R to &A
	poke(i, a, peek(i, o+2))
end
pci["pci-05"] = function(i, a) -- 05 set @A : copy %R to @A
	p = peek(i, a).c
	poke(i, p, peek(i, o+2))
end
pci["pci-06"] = function(i, a) -- 06 swp @A : swap %R with @A
	m = peek(i, a)
	r = peek(i, o+2)
	poke(i, a, r)
	poke(i, o+2, m)
end
pci["pci-07"] = function(i, a) -- 07 swp &A : swap %R with &A
	p = peek(i, a).c
	m = peek(i, p)
	r = peek(i, o+2)
	poke(i, p, r)
	poke(i, o+2, m)
end

pci["pci-08"] = function(i, a) -- 08 slp #A : wait #A processor cycles
	s = peek(i, o)
	if s.s ~= "pci-08" then
		s = {t = "virtual", s = "pci-08", c = a}
	end
	if s.c > 0 then
		pointer = pointer - 1
		s.c = s.c - 1
	else
		s = {t = "virtual", s = "pci-00", c = 1}
	end
	poke(i, o, s)
end
pci["pci-09"] = function(i, a) -- 09 slp @A : wait @A processor cycles
	m = peek(i, a)
	s = peek(i, o)
	if s.s ~= "pci-08" then
		s = {t = "virtual", s = "pci-08", c = m.c}
	end
	if s.c > 0 then
		pointer = pointer - 1
		s.c = s.c - 1
	else
		s = {t = "virtual", s = "pci-00", c = 1}
	end
	poke(i, o, s)
end
pci["pci-0A"] = function(i, a) -- 0A yld #A : wait #A game tick
	s = peek(i, o)
	if s.s ~= "pci-0A" then
		s = {t = "virtual", s = "pci-0A", c = a}
	end
	if s.c > 1 then
		pointer = pointer - 1
		s.c = s.c - 1
		brk = true
	elseif s.c == 1 then
		s = {t = "virtual", s = "pci-00", c = 1}
		brk = true
	else
		s = {t = "virtual", s = "pci-00", c = 1}
	end
	poke(i, o, s)
end
pci["pci-0B"] = function(i, a) -- 0B yld @A : wait @A game tick
	m = peek(i, a)
	s = peek(i, o)
	if s.s ~= "pci-0A" then
		s = {t = "virtual", s = "pci-0A", c = m.c}
	end
	if s.c > 1 then
		pointer = pointer - 1
		s.c = s.c - 1
		brk = true
	elseif s.c == 1 then
		s = {t = "virtual", s = "pci-00", c = 1}
		brk = true
	else
		s = {t = "virtual", s = "pci-00", c = 1}
	end
	poke(i, o, s)
end

pci["pci-0C"] = function(i, a) -- 0C int @A : wait for modification on @A
	s = peek(i, o)
	r = peek(i, o+2)
	c = peek(i, a)
	if m.s == "pci-0C" then
		s = m
		pointer = pointer - 1
		poke(i, o, s)
	elseif s.t ~= m.t or s.s ~= m.s or s.c ~= m.c then
		pointer = pointer - 1
	end
end
pci["pci-0D"] = function(i, a) -- 0D int &A : wait for modification on &A 
	s = peek(i, o)
	r = peek(i, o+2)
	p = peek(i, a).c
	c = peek(i, p)
	if m.s == "pci-0C" then
		s = m
		pointer = pointer - 1
		poke(i, o, s)
	elseif s.t ~= m.t or s.s ~= m.s or s.c ~= m.c then
		pointer = pointer - 1
	end
end
pci["pci-0E"] = function(i, a) -- 0E hlt #A : halt with code #A
	poke(i, o, {t = "virtual", s = "pci-0E", c = a})
	brk = true
end
pci["pci-0F"] = function(i, a) -- 0F hlt @A : halt with code @A
	m = peek(i, a)
	poke(i, o, {t = "virtual", s = "pci-0E", c = m.c})
	brk = true
end

pci["pci-10"] = function(i, a) -- 10 jmp @A : jump to @A
	pointer = a
	poke(i, o+1, {t = "virtual", s = "pci-10", c = a})
end
pci["pci-11"] = function(i, a) -- 11 jmp &A : jump to &A
	p = peek(i, a).c
	pointer = p
	poke(i, o+1, {t = "virtual", s = "pci-10", c = p})
end
pci["pci-12"] = function(i, a) -- 12 rjp #A : jump relative by #A
	p = peek(i, o+1)
	pointer = p+a
	poke(i, o+1, {t = "virtual", s = "pci-10", c = p+a})
end
pci["pci-13"] = function(i, a) -- 13 rjp @A : jump relative by @A
	p = peek(i, o+1)
	m = peek(i, a)
	pointer = p+m.c
	poke(i, o+1, {t = "virtual", s = "pci-10", c = p+m.c})
end

pci["pci-14"] = function(i, a) -- 14 seq #A : skip if %R == #A
	if peek(i, o+2).c == a then
		pointer = pointer + 1
	end
end
pci["pci-15"] = function(i, a) -- 15 seq @A : skip if %R == @A
	p = peek(i, a).c
	if peek(i, o+2).c == p then
		pointer = pointer + 1
	end
end
pci["pci-16"] = function(i, a) -- 1A snq #A : skip if %R != #A
	if peek(i, o+2).c ~= a then
		pointer = pointer + 1
	end
end
pci["pci-17"] = function(i, a) -- 1B snq @A : skip if %R != @A
	p = peek(i, a).c
	if peek(i, o+2).c ~=p then
		pointer = pointer + 1
	end
end

pci["pci-18"] = function(i, a) -- 16 slt #A : skip if %R < #A
	if peek(i, o+2).c < a then
		pointer = pointer + 1
	end
end
pci["pci-19"] = function(i, a) -- 17 slt @A : skip if %R < @A
	p = peek(i, a).c
	if peek(i, o+2).c < p then
		pointer = pointer + 1
	end
end
pci["pci-1A"] = function(i, a) -- 18 sgt #A : skip if %R > #A
	if peek(i, o+2).c > a then
		pointer = pointer + 1
	end
end
pci["pci-1B"] = function(i, a) -- 19 sgt @A : skip if %R > @A
	p = peek(i, a).c
	if peek(i, o+2).c > p then
		pointer = pointer + 1
	end
end

pci["pci-1C"] = function(i, a) -- 1C slq #A : skip if %R <= #A
	if peek(i, o+2).c <= peek(i, a).c then
		pointer = pointer + 1
	end
end
pci["pci-1D"] = function(i, a) -- 1D slq @A : skip if %R <= @A
	p = peek(i, a).c
	if peek(i, o+2).c <= peek(i, p).c then
		pointer = pointer + 1
	end
end
pci["pci-1E"] = function(i, a) -- 1E sgq #A : skip if %R >= #A
	if peek(i, o+2).c >= peek(i, a).c then
		pointer = pointer + 1
	end
end
pci["pci-1F"] = function(i, a) -- 1F sgq @A : skip if %R >= @A
	p = peek(i, a).c
	if peek(i, o+2).c >= peek(i, p).c then
		pointer = pointer + 1
	end
end

pci["pci-20"] = function(i, a) -- 20 add @A : add %R to @A
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m + r
	poke(i, a, sign(m.c))
end
pci["pci-21"] = function(i, a) -- 21 add &A : add %R to &A
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m + r
	poke(i, p, sign(m.c))
end
pci["pci-22"] = function(i, a) -- 22 sub @A : sub %R to @A
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m - r
	poke(i, a, sign(m.c))
end
pci["pci-23"] = function(i, a) -- 23 sub &A : sub %R to &A
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m + r
	poke(i, p, sign(m.c))
end

pci["pci-24"] = function(i, a) -- 24 inc @A : increase @A by 1
	m = unsign(peek(i, a).c)
	m = m + 1
	poke(i, a, sign(m.c))
end
pci["pci-25"] = function(i, a) -- 25 inc &A : increase &A by 1
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m + 1
	poke(i, p, sign(m.c))
end
pci["pci-26"] = function(i, a) -- 26 dec @A : decrease @A by 1
	m = unsign(peek(i, a).c)
	m = m - 1
	poke(i, a, sign(m.c))
end
pci["pci-27"] = function(i, a) -- 27 dec &A : decrease &A by 1
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m - 1
	poke(i, p, sign(m.c))
end

pci["pci-28"] = function(i, a) -- 40 mul @A : multiply by %R in @A
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m * r
	poke(i, a, sign(m.c))
end
pci["pci-29"] = function(i, a) -- 41 mul &A : multiply by %R in &A
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m * r
	poke(i, p, sign(m.c))
end
pci["pci-2A"] = function(i, a) -- 42 dvf @A : floor division @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = math.floor(m / r)
	poke(i, a, sign(m.c))
end
pci["pci-2B"] = function(i, a) -- 43 dvf &A : floor division &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = math.floor(m / r)
	poke(i, p, sign(m.c))
end

pci["pci-2C"] = function(i, a) -- 44 dvc @A : ceil division @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = math.ceil(m / r)
	poke(i, a, sign(m.c))
end
pci["pci-2D"] = function(i, a) -- 45 dvc &A : ceil division &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = math.ceil(m / r)
	poke(i, p, sign(m.c))
end
pci["pci-2E"] = function(i, a) -- 46 mod @A : modulo @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m % r
	poke(i, a, sign(m.c))
end
pci["pci-2F"] = function(i, a) -- 47 mod &A : modulo &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m % r
	poke(i, p, sign(m.c))
end

pci["pci-30"] = function(i, a) -- 2C neg @A : negate @A
	m = unsign(peek(i, a).c)
	m = -m
	poke(i, a, sign(m.c))
end
pci["pci-31"] = function(i, a) -- 2D neg &A : negate &A
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = -m
	poke(i, p, sign(m.c))
end
pci["pci-32"] = function(i, a) -- 2E not @A : bitwise not @A
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = -r-1
	poke(i, a, sign(m.c))
end
pci["pci-33"] = function(i, a) -- 2F not &A : bitwise not &A
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = -r-1
	poke(i, p, sign(m.c))
end

pci["pci-34"] = function(i, a) -- 28 lsh @A : left shift @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m *2^ r
	poke(i, a, sign(m.c))
end
pci["pci-35"] = function(i, a) -- 29 lsh &A : left shift &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = m *2^ r
	poke(i, p, sign(m.c))
end
pci["pci-36"] = function(i, a) -- 2A rsh @A : right shift @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = math.floor(m /2^ r)
	poke(i, a, sign(m.c))
end
pci["pci-37"] = function(i, a) -- 2B rsh &A : right shift &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = math.floor(m /2^ r)
	poke(i, p, sign(m.c))
end

pci["pci-38"] = function(i, a) -- 30 and @A : bitwise and @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.band(m, r)
	poke(i, a, sign(m.c))
end
pci["pci-39"] = function(i, a) -- 31 and &A : bitwise and &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.band(m, r)
	poke(i, p, sign(m.c))
end
pci["pci-3A"] = function(i, a) -- 32 adn @A : bitwise and @A by not %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.band(m, b.bnot(r))
	poke(i, a, sign(m.c))
end
pci["pci-3B"] = function(i, a) -- 33 adn &A : bitwise and &A by not %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.band(m, b.bnot(r))
	poke(i, p, sign(m.c))
end

pci["pci-3C"] = function(i, a) -- 34 nad @A : bitwise nand @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bnot(b.band(m, r))
	poke(i, a, sign(m.c))
end
pci["pci-3D"] = function(i, a) -- 35 nad &A : bitwise nand &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bnot(b.band(m, r))
	poke(i, p, sign(m.c))
end
pci["pci-3E"] = function(i, a) -- 36 ndn @A : bitwise nand @A by not %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bnot(b.band(m, b.bnot(r)))
	poke(i, a, sign(m.c))
end
pci["pci-3F"] = function(i, a) -- 37 ndn &A : bitwise nand &A by not %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bnot(b.band(m, b.bnot(r)))
	poke(i, p, sign(m.c))
end

pci["pci-40"] = function(i, a) -- 38 ior @A : bitwise or @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = m - r
	poke(i, a, sign(m.c))
end
pci["pci-41"] = function(i, a) -- 39 ior &A : bitwise or &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bor(m, r)
	poke(i, p, sign(m.c))
end
pci["pci-42"] = function(i, a) -- 3A orn @A : bitwise or @A by not %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bor(m, b.bnot(r))
	poke(i, a, sign(m.c))
end
pci["pci-43"] = function(i, a) -- 3B orn &A : bitwise or &A by not %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bor(m, b.bnot(r))
	poke(i, p, sign(m.c))
end

pci["pci-44"] = function(i, a) -- 3C nor @A : bitwise nor @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bnot(b.bor(m, r))
	poke(i, a, sign(m.c))
end
pci["pci-45"] = function(i, a) -- 3D nor &A : bitwise nor &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bnot(b.bor(m, r))
	poke(i, p, sign(m.c))
end
pci["pci-46"] = function(i, a) -- 3E nrn @A : bitwise nor @A by not %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bnot(b.bor(m, b.bnot(r)))
	poke(i, a, sign(m.c))
end
pci["pci-47"] = function(i, a) -- 3F nrn &A : bitwise nor &A by not %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bnot(b.bor(m, b.bnot(r)))
	poke(i, p, sign(m.c))
end

pci["pci-48"] = function(i, a) -- 48 xor @A : bitwise xor @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bxor(m, r)
	poke(i, a, sign(m.c))
end
pci["pci-49"] = function(i, a) -- 49 xor &A : bitwise xor &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bxor(m, r)
	poke(i, p, sign(m.c))
end
pci["pci-4A"] = function(i, a) -- 4A nxr @A : bitwise nxor @A by %R
	r = unsign(peek(i, o+2).c)
	m = unsign(peek(i, a).c)
	m = b.bxor(m, b.bnot(r))
	poke(i, a, sign(m.c))
end
pci["pci-4B"] = function(i, a) -- 4B xrn &A : bitwise nxor &A by %R
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	m = unsign(peek(i, p).c)
	m = b.bxor(m, b.bnot(r))
	poke(i, p, sign(m.c))
end

pci["pci-4C"] = function(i, a) -- 4C rnd @A : random in @A
	poke(i, a, math.random(-2147483648,2147483647))
end
pci["pci-4D"] = function(i, a) -- 4D rnd &A : random in &A
	p = peek(i, a).c
	poke(i, p, math.random(-2147483648,2147483647))
end
pci["pci-4E"] = function(i, a) -- 4E rnd @A : random in @A in %R range
	r = peek(i, o+2).c
	poke(i, a, math.random(0,r))
end
pci["pci-4F"] = function(i, a) -- 4F rnd &A : random in &A in %R range
	r = unsign(peek(i, o+2).c)
	p = peek(i, a).c
	poke(i, p, math.random(0,r))
end

