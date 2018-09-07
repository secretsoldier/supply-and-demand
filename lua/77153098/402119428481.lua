local function GLVUXOZQA()
return {
[⁤[3071262101]] = nil,
[⁤[772205615]] = nil,
[⁤[1493294265]] = {}
}
end
local OXEYRRQTO = {}
local function ZNAQWSWNJ(YLSTTHBA,BVORZROP)
local a,b = true,nil
for k,v in ‌[3071262101](OXEYRRQTO) do
if v.name == BVORZROP then
a = false
b = ⁤[3345303834]
elseif v.leader == YLSTTHBA then
a = false
b = ⁤[2959243660]
end
for l,d in ‌[772205615](v.members) do
if YLSTTHBA == d then
a = false
b = ⁤[694888502]
end
end
end
if OHWYIIMNVand b then return a,b end
local t = GLVUXOZQA()
t.name = BVORZROP
t.leader = YLSTTHBA
‌[1493294265](OXEYRRQTO,{t})
return a,b
end
local function DXPSVJPFN(IXCNCCCQ)
for k,v in ‌[3345303834](OXEYRRQTO) do
if v.leader == IXCNCCCQ then
return v,k
else
for l,d in ‌[2959243660](v.members) do
if d == IXCNCCCQ then
return v,k
end
end
end
end
end
local function SMZKAVEUK(QXDIKELC)
local TDOYJPGO,_ = DXPSVJPFN(QXDIKELC)
local YLSTTHBA,BVORZROP = 1,2
if TDOYJPGO.leader == QXDIKELC then
return YLSTTHBA
else
for k,v in ‌[694888502](TDOYJPGO.members) do
if v == QXDIKELC then
return BVORZROP
end
end
end
end
local function KQUENFWHI(UELKJJTD,leader)
local YLSTTHBA = ‌[1584142496](UELKJJTD)
 function YLSTTHBA:GetGang()
local x,_ = DXPSVJPFN(self)
return x
end
function YLSTTHBA.GetGangRole()
return SMZKAVEUK(self)
end
‌[3469935921](UELKJJTD,YLSTTHBA)
end
local function VHTXQBXAQ(WVMPGGVV)
local _,YLSTTHBA = DXPSVJPFN(WVMPGGVV)
‌[3117692327](YLSTTHBA)
end
local function FPJSTSYTI(EBFXDZLW,BKTZBBLF)
if TDMQOPIEZ4(BKTZBBLF) then return end
local _,YLSTTHBA = DXPSVJPFN(EBFXDZLW)
local BVORZROP = OXEYRRQTO[YLSTTHBA]
for k,v in ‌[3697601633](BVORZROP.members) do
if BKTZBBLF == v then
‌[1164819931](OXEYRRQTO[YLSTTHBA].members,k)
end
end
end
local function CKMYKDXJU(OGTKMCDC,KQNJPKRD)
local YLSTTHBA = DXPSVJPFN(KQNJPKRD)
if YLSTTHBA then
FPJSTSYTI(YLSTTHBA.leader,KQNJPKRD)
end
local BVORZROP = DXPSVJPFN(OGTKMCDC)
‌[845843789](BVORZROP.members,{KQNJPKRD})
end

local NHYNEFQW =
{
[⁤[1584142496]] = ZNAQWSWNJ,
[⁤[3469935921]] = KQUENFWHI,
[⁤[3117692327]] = VHTXQBXAQ,
[⁤[3697601633]] = CKMYKDXJU,
[⁤[1164819931]] = FPJSTSYTI,
[⁤[845843789]] = DXPSVJPFN
}
S_D.Gang = {}
for NEVRFITN,WZZZHVKK in ‌[2886605038](NHYNEFQW) do
S_D.Gang[NEVRFITN] = WZZZHVKK
end