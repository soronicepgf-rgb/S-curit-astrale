-- LuaVault Virtual Machine v10 · Protected Script
local I0ll0l1OOO={}
I0ll0l1OOO[1]="3tzV0cXDytDU3JTa39Kl+4q3sLWBorzh6KO4ub686v79obWi+LCxrbKuvqit"
I0ll0l1OOO[2]="upKCjY2QgIiTxoqFhsOegZ2fn5uQkYWRkdWLnZnTrtOcdXNrdylkdXN6aGZu"
I0ll0l1OOO[3]="I39raWM+enZ1cWU4dXhzdTNkanBQSkpKTk1PVVxDQkJDX1pBSkRdW1pHQhhK"
I0ll0l1OOO[4]="TVBTW0lXSigmMDctMDQzID04I2M/Oyo4JTU6ISciMC0wKC8pNDk3EhUYTAMN"
I0ll0l1OOO[5]="FAkSDgMZAhcJBgIfCBQdHQQNER4SCVMaCgX15vjr4/zk7/Lz+Oz16Pz1v+Xg"
I0ll0l1OOO[6]="++bh8//x9vC+rt7s+s/Ly8vKwNLIh8zDxMbKi53zw8bb3d/Ew9DW0MnImIz8"
I0ll0l1OOO[7]="qK6oquH3hbW8o6OkpOj8jKSjuLq78OSUsLaosfnvnbePi4vG1qaOiIGDmJ/J"
I0ll0l1OOO[8]="362AipiamdHHtYWSkJWB2c+9l3JrbWttd3wiO0glTFlERl1FWEhUXE9eUF1L"
I0ll0l1OOO[9]="Q0FUWkdacntqZG18Y3Vgc21+aX9mdWV4dXZmb39if3xoYRNne2sHFAsJHgJ/"
I0ll0l1OOO[10]="Eh0AEAwWHxsGFxkXAR0PAx8fEB8JCQcZGjozNyQxLCM1MkYtOTgqJjslOCg0"
I0ll0l1OOO[11]="UUYwJS0jPTUuJzA40tvMxNHM1N3GzsPe3teh6uL24Pvg5/7j6uPg6en69vja"
I0ll0l1OOO[12]="xtfRzN/Tzs/b0MLL2NzVxd/aydzA1NXO3NjBysjZxqWjuLa9oqO9vbC8qb6o"
I0ll0l1OOO[13]="tKilqKSxsaessK2guK2muKepgoSQmYOHkIKajoidiYqXmZWIkImCgI+Sgo+P"
I0ll0l1OOO[14]="gpmHiIZlc3guKWlqayZlf2ouJCcnOQ=="
local O0IlOO0O1O1lOO=table.concat(I0ll0l1OOO)
I0ll0l1OOO=nil
local function Il00O01II0(IOOOll,IOllI0)
  local lIOII1=0
  local l0lI00=1
  while IOOOll>0 or IOllI0>0 do
    local _ba=math.floor(IOOOll%2)
    local _bb=math.floor(IOllI0%2)
    if _ba~=_bb then lIOII1=lIOII1+l0lI00 end
    IOOOll=math.floor(IOOOll/2)
    IOllI0=math.floor(IOllI0/2)
    l0lI00=l0lI00*2
  end
  return lIOII1
end
local l1OOlIIl1IIIlO="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local OIIO1lOIlOI0={}
local I1I0OIlI=1
while I1I0OIlI<=#(O0IlOO0O1O1lOO) do
  local l0I1I0O=((l1OOlIIl1IIIlO):find((O0IlOO0O1O1lOO):sub(I1I0OIlI,I1I0OIlI)) or 1)-1
  local Illl1O0=((l1OOlIIl1IIIlO):find((O0IlOO0O1O1lOO):sub(I1I0OIlI+1,I1I0OIlI+1)) or 1)-1
  local IIl1l1l=((l1OOlIIl1IIIlO):find((O0IlOO0O1O1lOO):sub(I1I0OIlI+2,I1I0OIlI+2)) or 1)-1
  local I1OIOOI=((l1OOlIIl1IIIlO):find((O0IlOO0O1O1lOO):sub(I1I0OIlI+3,I1I0OIlI+3)) or 1)-1
  local l0OIO10=l0I1I0O*262144+Illl1O0*4096+IIl1l1l*64+I1OIOOI
  OIIO1lOIlOI0[#OIIO1lOIlOI0+1]=string.char(math.floor(l0OIO10/65536)%256)
  if (O0IlOO0O1O1lOO):sub(I1I0OIlI+2,I1I0OIlI+2)~="=" then
    OIIO1lOIlOI0[#OIIO1lOIlOI0+1]=string.char(math.floor(l0OIO10/256)%256)
  end
  if (O0IlOO0O1O1lOO):sub(I1I0OIlI+3,I1I0OIlI+3)~="=" then
    OIIO1lOIlOI0[#OIIO1lOIlOI0+1]=string.char(l0OIO10%256)
  end
  I1I0OIlI=I1I0OIlI+4
end
local lI00Ol00Il=table.concat(OIIO1lOIlOI0)
OIIO1lOIlOI0=nil
local O0I1O01I=178
local OII0IlI1Ol={}
for I1I0OIlI=1,#lI00Ol00Il do
  local I1O1I1l=(lI00Ol00Il):byte(I1I0OIlI)
  local OOIIll1=(O0I1O01I+I1I0OIlI-1)%256
  OII0IlI1Ol[I1I0OIlI]=string.char(Il00O01II0(I1O1I1l,OOIIll1))
end
local O1I0OOI01lI1=table.concat(OII0IlI1Ol)
OII0IlI1Ol=nil
lI00Ol00Il=nil
local OIlOOO0l1I0l=loadstring or load
if OIlOOO0l1I0l then
  local _f,_e=OIlOOO0l1I0l(O1I0OOI01lI1)
  if _f then
    local _ok,_err=pcall(_f)
    if not _ok then warn("[LuaVault] "..(tostring(_err) or "?")) end
  else
    warn("[LuaVault] "..(tostring(_e) or "?"))
  end
end
