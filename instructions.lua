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
pci["pci-00"] = function(G, A) -- 00 NOP -- : do nothing
end
pci["pci-01"] = function(G, A) -- 01 VAL# A : copy #A to %R
	R = peek(G, register)
	R.count = A
	if R.signal.name == "" then
		R.signal.type = "virtual"
		R.signal.name = "pci-00"
	end
	poke(G, register, R)
end
pci["pci-02"] = function(G, A) -- 02 GET@ A : copy @A to %R
	R = peek(G, register)
	C = peek(G, A)
	R.signal.type = C.signal.type
	R.signal.name = C.signal.name
	R.count       = C.count
	poke(G, register, R)
end
pci["pci-03"] = function(G, A) -- 03 GET& A : copy &A to %R
	R = peek(G, register)
	P = peek(G, A).count
	C = peek(G, P)
	R.signal.type = C.signal.type
	R.signal.name = C.signal.name
	R.count       = C.count
	poke(G, register, R)
end

pci["pci-04"] = function(G, A) -- 04 SET@ A : copy %R to @A
	R = peek(G, register)
	C = peek(G, A)
	C.signal.type = R.signal.type
	C.signal.name = R.signal.name
	C.count       = R.count
	poke(G, A, C)
end
pci["pci-05"] = function(G, A) -- 05 SET& A : copy %R to &A
	R = peek(G, register)
	P = peek(G, A).count
	C = peek(G, P)
	C.signal.type = R.signal.type
	C.signal.name = R.signal.name
	C.count       = R.count
	poke(G, P, C)
end
pci["pci-06"] = function(G, A) -- 06 swp @A : swap %R with @A
	R = peek(G, register)
	C = peek(G, A)
	poke(G, A, R)
	poke(G, register, C)
end
pci["pci-07"] = function(G, A) -- 07 swp &A : swap %R with &A
	R = peek(G, register)
	P = peek(G, A).count
	C = peek(G, P)
	poke(G, P, R)
	poke(G, register, C)
end

pci["pci-08"] = function(G, A) -- 08 slp #A : wait #A processor cycles
	S = peek(G, control)
	if S.signal.name ~= "pci-08" then
		S.signal.type = "virtual"
		S.signal.name = "pci-08"
		S.count = A
	end
	if S.count > 0 then
		pointer = pointer - 1
		S.count = S.count - 1
	else
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
	end
	poke(G, control, S)
end
pci["pci-09"] = function(G, A) -- 09 slp @A : wait @A processor cycles
	P = peek(G, A).count
	S = peek(G, control)
	if S.signal.name ~= "pci-08" then
		S.signal.type = "virtual"
		S.signal.name = "pci-08"
		S.count = P
	end
	if S.count > 0 then
		pointer = pointer - 1
		S.count = S.count - 1
	else
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
	end
	poke(G, control, S)
end
pci["pci-0A"] = function(G, A) -- 0A yld #A : wait #A game tick
	S = peek(G, control)
	if S.signal.name ~= "pci-0A" then
		S.signal.type = "virtual"
		S.signal.name = "pci-0A"
		S.count = A
	end
	if S.count > 1 then
		pointer = pointer - 1
		S.count = S.count - 1
		brk = true
	elseif S.count == 1 then
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
		brk = true
	else
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
	end
	poke(G, control, S)
end
pci["pci-0B"] = function(G, A) -- 0B yld @A : wait @A game tick
	P = peek(G, A).count
	S = peek(G, control)
	if S.signal.name ~= "pci-0A" then
		S.signal.type = "virtual"
		S.signal.name = "pci-0A"
		S.count = P
	end
	if S.count > 1 then
		pointer = pointer - 1
		S.count = S.count - 1
		brk = true
	elseif s.count == 1 then
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
		brk = true
	else
		S.signal.type = "virtual"
		S.signal.name = "pci-00"
		S.count = 1
	end
	poke(G, control, S)
end

pci["pci-0C"] = function(G, A) -- 0C int @A : wait for modification on @A
	s = peek(G, origin)
	R = register
	c = peek(G, A)
	if C.signal.name == "pci-0C" then
		s = C
		pointer = pointer - 1
		poke(G, origin, s)
	elseif s.signal.type ~= C.signal.type or s.signal.name ~= C.signal.name or s.count ~= C.count then
		pointer = pointer - 1
	end
end
pci["pci-0D"] = function(G, A) -- 0D int &A : wait for modification on &A 
	s = peek(G, origin)
	R = register
	P = peek(G, A).count
	c = peek(G, P)
	if C.signal.name == "pci-0C" then
		s = C
		pointer = pointer - 1
		poke(G, origin, s)
	elseif s.signal.type ~= C.signal.type or s.signal.name ~= C.signal.name or s.count ~= C.count then
		pointer = pointer - 1
	end
end
pci["pci-0E"] = function(G, A) -- 0E hlt #A : halt with code #A
	poke(G, origin, {signal= {type= "virtual", name= "pci-0E"}, count= A, index= 1})
	brk = true
end
pci["pci-0F"] = function(G, A) -- 0F hlt @A : halt with code @A
	C = peek(G, A).count
	poke(G, origin, {signal= {type= "virtual", name= "pci-0E"}, count= C, index= 1})
	brk = true
end

pci["pci-10"] = function(G, A) -- 10 jmp @A : jump to @A
	pointer = A
	poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= A, index= 2})
end
pci["pci-11"] = function(G, A) -- 11 jmp &A : jump to &A
	P = peek(G, A).count
	pointer = P
	poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= P, index= 2})
end
pci["pci-12"] = function(G, A) -- 12 rjp #A : jump relative by #A
	P = peek(G, origin+1).count
	pointer = P+A
	poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= P+A, index= 2})
end
pci["pci-13"] = function(G, A) -- 13 rjp @A : jump relative by @A
	P = peek(G, origin+1).count
	C = peek(G, A).count
	pointer = P+C
	poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= P+C, index= 2})
end

pci["pci-14"] = function(G, A) -- 14 seq #A : skip if %R == #A
	if register.count == A then
		pointer = pointer + 1
	end
end
pci["pci-15"] = function(G, A) -- 15 seq @A : skip if %R == @A
	P = peek(G, A).count
	if register.count == P then
		pointer = pointer + 1
	end
end
pci["pci-16"] = function(G, A) -- 1A snq #A : skip if %R != #A
	if register.count ~= A then
		pointer = pointer + 1
	end
end
pci["pci-17"] = function(G, A) -- 17 snq @A : skip if %R != @A
	P = peek(G, A).count
	if register.count ~=P then
		pointer = pointer + 1
	end
end

pci["pci-18"] = function(G, A) -- 16 slt #A : skip if %R < #A
	if register.count < A then
		pointer = pointer + 1
		poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= pointer, index= 2})
	end
end
pci["pci-19"] = function(G, A) -- 17 slt @A : skip if %R < @A
	P = peek(G, A).count
	if register.count < P then
		pointer = pointer + 1
	end
end
pci["pci-1A"] = function(G, A) -- 1A sgt #A : skip if %R > #A
	if register.count > A then
		pointer = pointer + 1
		poke(G, origin+1, {signal= {type= "virtual", name= "pci-10"}, count= pointer, index= 2})
	end
end
pci["pci-1B"] = function(G, A) -- 19 sgt @A : skip if %R > @A
	P = peek(G, A).count
	if register.count > P then
		pointer = pointer + 1
	end
end

pci["pci-1C"] = function(G, A) -- 1C slq #A : skip if %R <= #A
	if register.count <= peek(G, A).count then
		pointer = pointer + 1
	end
end
pci["pci-1D"] = function(G, A) -- 1D slq @A : skip if %R <= @A
	P = peek(G, A).count
	if register.count <= peek(G, P).count then
		pointer = pointer + 1
	end
end
pci["pci-1E"] = function(G, A) -- 1E sgq #A : skip if %R >= #A
	if register.count >= peek(G, A).count then
		pointer = pointer + 1
	end
end
pci["pci-1F"] = function(G, A) -- 1F sgq @A : skip if %R >= @A
	P = peek(G, A).count
	if register.count >= peek(G, P).count then
		pointer = pointer + 1
	end
end

pci["pci-20"] = function(G, A) -- 20 add @A : add %R to @A
	R = register
	C = peek(G, A)
	C.count = sign(unsign(C.count) + unsign(R.count))
	poke(G, A, C)
end
pci["pci-21"] = function(G, A) -- 21 add &A : add %R to &A
	R = register
	P = peek(G, A)
	C = peek(G, P.count)
	C.count = unsign(C.count) + R.count
	poke(G, P, C)
end
pci["pci-22"] = function(G, A) -- 20 add @A : add %R to @A
	R = register.count
	C = peek(G, A)
	C.count = sign(unsign(C.count) + unsign(R))
	poke(G, A, C)
end
pci["pci-23"] = function(G, A) -- 21 add &A : add %R to &A
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) + R
	poke(G, P, C)
end

pci["pci-22"] = function(G, A) -- 22 sub @A : sub @A to %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = unsign(C.count) - R
	poke(G, A, C)
end
pci["pci-23"] = function(G, A) -- 23 sub &A : sub &A to %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) + R
	poke(G, P, C)
end
pci["pci-22"] = function(G, A) -- 22 sub @A : sub @A to %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = unsign(C.count) - R
	poke(G, A, C)
end
pci["pci-23"] = function(G, A) -- 23 sub &A : sub &A to %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) + R
	poke(G, P, C)
end

pci["pci-24"] = function(G, A) -- 24 inc @A : increase @A by 1
	C = peek(G, A)
	C.count = sign(unsign(C.count) + 1)
	poke(G, A, C)
end
pci["pci-25"] = function(G, A) -- 25 inc &A : increase &A by 1
	P = peek(G, A).count
	C = peek(G, P)
	C.count = sign(unsign(C.count) + 1)
	poke(G, P, C)
end
pci["pci-26"] = function(G, A) -- 26 dec @A : decrease @A by 1
	C = unsign(peek(G, A).count)
	C.count = unsign(C.count) - 1
	poke(G, A, C)
end
pci["pci-27"] = function(G, A) -- 27 dec &A : decrease &A by 1
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) - 1
	poke(G, P, C)
end

pci["pci-28"] = function(G, A) -- 40 mul @A : multiply by %R in @A
	R = register
	C = peek(G, A)
	C.count = sign(C.count * R.count)
	poke(G, A, C)
end
pci["pci-29"] = function(G, A) -- 41 mul &A : multiply by %R in &A
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) * R
	poke(G, P, C)
end
pci["pci-2A"] = function(G, A) -- 42 dvf @A : floor division @A by %R
	R = register.count
	C = peek(G, A)
	C.count = math.floor(unsign(C.count) / R)
	poke(G, A, C)
end
pci["pci-2B"] = function(G, A) -- 43 dvf &A : floor division &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = math.floor(C / R)
	poke(G, P, C)
end

pci["pci-2C"] = function(G, A) -- 44 dvc @A : ceil division @A by %R
	R = register
	C = peek(G, A)
	C.count = sign(math.ceil(C.count / R.count))
	poke(G, A, C)
end
pci["pci-2D"] = function(G, A) -- 45 dvc &A : ceil division &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = sign(math.ceil(unsign(C.count) / unsign(R)))
	poke(G, P, C)
end
pci["pci-2E"] = function(G, A) -- 46 mod @A : modulo @A by %R
	R = register
	C = peek(G, A)
	C.count = sign(unsign(C.count) % unsign(R.count))
	poke(G, A, C)
end
pci["pci-2F"] = function(G, A) -- 47 mod &A : modulo &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) % R
	poke(G, P, C)
end

pci["pci-30"] = function(G, A) -- 2C neg @A : negate @A
	C = peek(G, A)
	C.count = -C.count
	poke(G, A, C)
end
pci["pci-31"] = function(G, A) -- 2D neg &A : negate &A
	P = peek(G, A)
	C = peek(G, P.count)
	C.count = -C.count
	poke(G, P, C)
end
pci["pci-32"] = function(G, A) -- 2E not @A : bitwise not @A
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = -R-1
	poke(G, A, C)
end
pci["pci-33"] = function(G, A) -- 2F not &A : bitwise not &A
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = -R-1
	poke(G, P, C)
end

pci["pci-34"] = function(G, A) -- 28 lsh @A : left shift @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = unsign(C.count) *2^ R
	poke(G, A, C)
end
pci["pci-35"] = function(G, A) -- 29 lsh &A : left shift &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = unsign(C.count) *2^ R
	poke(G, P, C)
end
pci["pci-36"] = function(G, A) -- 2A rsh @A : right shift @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = math.floor(C /2^ R)
	poke(G, A, C)
end
pci["pci-37"] = function(G, A) -- 2B rsh &A : right shift &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = math.floor(C /2^ R)
	poke(G, P, C)
end

pci["pci-38"] = function(G, A) -- 30 and @A : bitwise and @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.band(C, R)
	poke(G, A, C)
end
pci["pci-39"] = function(G, A) -- 31 and &A : bitwise and &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.band(C, R)
	poke(G, P, C)
end
pci["pci-3A"] = function(G, A) -- 32 adn @A : bitwise and @A by not %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.band(C, b.bnot(R))
	poke(G, A, C)
end
pci["pci-3B"] = function(G, A) -- 33 adn &A : bitwise and &A by not %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.band(C, b.bnot(R))
	poke(G, P, C)
end

pci["pci-3C"] = function(G, A) -- 34 nad @A : bitwise nand @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bnot(b.band(C, R))
	poke(G, A, C)
end
pci["pci-3D"] = function(G, A) -- 35 nad &A : bitwise nand &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bnot(b.band(C, R))
	poke(G, P, C)
end
pci["pci-3E"] = function(G, A) -- 36 ndn @A : bitwise nand @A by not %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bnot(b.band(C, b.bnot(R)))
	poke(G, A, C)
end
pci["pci-3F"] = function(G, A) -- 37 ndn &A : bitwise nand &A by not %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bnot(b.band(C, b.bnot(R)))
	poke(G, P, C)
end

pci["pci-40"] = function(G, A) -- 38 ior @A : bitwise or @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = unsign(C.count) - R
	poke(G, A, C)
end
pci["pci-41"] = function(G, A) -- 39 ior &A : bitwise or &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bor(unsign(C.count), R)
	poke(G, P, C)
end
pci["pci-42"] = function(G, A) -- 3A orn @A : bitwise or @A by not %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bor(unsign(C.count), b.bnot(R))
	poke(G, A, C)
end
pci["pci-43"] = function(G, A) -- 3B orn &A : bitwise or &A by not %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bor(unsign(C.count), b.bnot(R))
	poke(G, P, C)
end

pci["pci-44"] = function(G, A) -- 3C nor @A : bitwise nor @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bnot(b.bor(unsign(C.count), R))
	poke(G, A, C)
end
pci["pci-45"] = function(G, A) -- 3D nor &A : bitwise nor &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bnot(b.bor(unsign(C.count), R))
	poke(G, P, C)
end
pci["pci-46"] = function(G, A) -- 3E nrn @A : bitwise nor @A by not %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bnot(b.bor(unsign(C.count), b.bnot(R)))
	poke(G, A, C)
end
pci["pci-47"] = function(G, A) -- 3F nrn &A : bitwise nor &A by not %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bnot(b.bor(unsign(C.count), b.bnot(R)))
	poke(G, P, C)
end

pci["pci-48"] = function(G, A) -- 48 xor @A : bitwise xor @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bxor(unsign(C.count), R)
	poke(G, A, C)
end
pci["pci-49"] = function(G, A) -- 49 xor &A : bitwise xor &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bxor(unsign(C.count), R)
	poke(G, P, C)
end
pci["pci-4A"] = function(G, A) -- 4A nxr @A : bitwise nxor @A by %R
	R = register.count
	C = unsign(peek(G, A).count)
	C.count = b.bxor(unsign(C.count), b.bnot(R))
	poke(G, A, C)
end
pci["pci-4B"] = function(G, A) -- 4B xrn &A : bitwise nxor &A by %R
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = b.bxor(unsign(C.count), b.bnot(R))
	poke(G, P, C)
end

pci["pci-4C"] = function(G, A) -- 4C rnd @A : random in @A
	C = peek(G, A)
	C.count = math.random(-2147483648,2147483647)
	poke(G, A, C)
end
pci["pci-4D"] = function(G, A) -- 4D rnd &A : random in &A
	P = peek(G, A).count
	C = peek(G, P)
	C.count = math.random(-2147483648,2147483647)
	poke(G, P, C)
end
pci["pci-4E"] = function(G, A) -- 4E rnd @A : random in @A in %R range
	R = register.count
	C = peek(G, A)
	C.count = math.random(0,R)
	poke(G, A, C)
end
pci["pci-4F"] = function(G, A) -- 4F rnd &A : random in &A in %R range
	R = register.count
	P = peek(G, A).count
	C = peek(G, P)
	C.count = math.random(0,R)
	poke(G, P, C)
end

