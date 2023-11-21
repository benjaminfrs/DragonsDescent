class_name BasicTileRules extends Object

#Arr of tile type names
#[TileTypes.FLOOR, TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL]

#TileRules is a dictionary with key value pair (TileType : str, NeighborRulesDict : dict) where 
#NeighborRulesDict is a dictionary with key value pair(Direction : str, ListOfIllegalNeighbors : array <str>)
const TileRule = {
	TileTypes.FLOOR : {
		"UP" : [TileTypes.UEWALL, TileTypes.WALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.BEWALL, TileTypes.WALL, TileTypes.LEWALL, TileTypes.REWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.LEWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.LEWALL, TileTypes.BEWALL],
		"BR" : [TileTypes.REWALL, TileTypes.BEWALL],
	},
	TileTypes.WALL : {
		"UP" : [TileTypes.FLOOR, TileTypes.REWALL, TileTypes.LEWALL, TileTypes.BEWALL],
		"DOWN" : [TileTypes.FLOOR,  TileTypes.REWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.LEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.REWALL],
		"UL" : [TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.UEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.UEWALL, TileTypes.LEWALL],
	},
	TileTypes.BEWALL : {
		"UP" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.UEWALL: {
		"UP" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"UL" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"UR" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.LEWALL: {
		"UP" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.REWALL: {
		"UP" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
	},
}
const Directions = {
	"UP" : Vector2i(0, -1),
	"DOWN" : Vector2i(0, 1),
	"RIGHT" : Vector2i(1, 0),
	"LEFT" : Vector2i(-1, 0),
#Up left
	"UL" : Vector2i(-1, -1),
#Up left
	"UR" : Vector2i(1, -1),
#Down left
	"BL" : Vector2i(-1, 1),
#Up left
	"BR" : Vector2i(1, 1),
}
