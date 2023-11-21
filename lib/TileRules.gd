class_name TileRules extends Object

#Arr of tile type names
#[TileTypes.DWARF, TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL]

#TileRules is a dictionary with key value pair (TileType : str, NeighborRulesDict : dict) where 
#NeighborRulesDict is a dictionary with key value pair(Direction : str, ListOfIllegalNeighbors : array <str>)
const TileRule = {
	TileTypes.FLOOR : {
		"UP" : [TileTypes.UEWALL, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.BEWALL, TileTypes.WALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.URWALL, TileTypes.BRWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.ULWALL, TileTypes.BLWALL],
		"UL" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.UEWALL, TileTypes.ULWALL],
		"UR" : [TileTypes.WALL, TileTypes.REWALL, TileTypes.UEWALL, TileTypes.URWALL],
		"BL" : [TileTypes.WALL, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.BLWALL],
		"BR" : [TileTypes.WALL, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.BRWALL],
	},
	TileTypes.WALL : {
		"UP" : [TileTypes.FLOOR, TileTypes.BRWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.ULWALL, TileTypes.REWALL, TileTypes.LEWALL, TileTypes.BEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.BRWALL, TileTypes.BLWALL, TileTypes.ULWALL, TileTypes.URWALL,  TileTypes.REWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL, TileTypes.BEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.REWALL, TileTypes.UEWALL, TileTypes.BEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.ULWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.URWALL, TileTypes.ULWALL, TileTypes.BRWALL, TileTypes.UEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.URWALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.UEWALL, TileTypes.LEWALL],
	},
	TileTypes.ULWALL : {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.URWALL : {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
	},
	TileTypes.BLWALL : {
		"UP" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.BRWALL: {
		"UP" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.BEWALL : {
		"UP" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.UEWALL: {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.LEWALL: {
		"UP" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.REWALL: {
		"UP" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
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
