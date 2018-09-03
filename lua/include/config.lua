/*
Supply_Cost
Supply_Pickup_Length
Process_Machine_Cost
Process_Process_Length
Product_Pickup_Length
Product_Sell_Price
*/
local configs = {
	["Supply_Cost"] = 500,
	["Supply_Pickup_Length"] = 60,
	["Process_Machine_Cost"] = 1000,
	["Process_Process_Length"] = 60,
	["Product_Pickup_Length"] = 60,
	["Product_Sell_Price"] = 800
}
S_D.Configs = {}
for k,v in pairs(configs) do
	S_D.Configs[k] = v
end