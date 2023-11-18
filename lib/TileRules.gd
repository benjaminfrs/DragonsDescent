class_name TileRules extends Object

#Arr of tile type names
#[TileTypes.DWARF, TileTypes.FLOOR, TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL]

#TileRules is a dictionary with key value pair (TileType : str, NeighborRulesDict : dict) where 
#NeighborRulesDict is a dictionary with key value pair(Direction : str, ListOfIllegalNeighbors : array <str>)
const TileRule = {
	TileTypes.DWARF : {
		"UP" : [TileTypes.DWARF, TileTypes.UEWALL, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.URWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.BEWALL, TileTypes.WALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.BEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.WALL, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.URWALL, TileTypes.BRWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.WALL, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.ULWALL, TileTypes.BLWALL],
		"UL" : [TileTypes.DWARF, TileTypes.LEWALL, TileTypes.UEWALL, TileTypes.ULWALL],
		"UR" : [TileTypes.DWARF, TileTypes.REWALL, TileTypes.UEWALL, TileTypes.URWALL],
		"BL" : [TileTypes.DWARF, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.BLWALL],
		"BR" : [TileTypes.DWARF, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.BRWALL],
	},
	TileTypes.FLOOR : {
		"UP" : [TileTypes.DWARF, TileTypes.UEWALL, TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.BEWALL, TileTypes.WALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.WALL, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.URWALL, TileTypes.BRWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.WALL, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.UEWALL, TileTypes.ULWALL, TileTypes.BLWALL],
		"UL" : [TileTypes.DWARF, TileTypes.LEWALL, TileTypes.UEWALL, TileTypes.ULWALL],
		"UR" : [TileTypes.DWARF, TileTypes.REWALL, TileTypes.UEWALL, TileTypes.URWALL],
		"BL" : [TileTypes.DWARF, TileTypes.LEWALL, TileTypes.BEWALL, TileTypes.BLWALL],
		"BR" : [TileTypes.DWARF, TileTypes.REWALL, TileTypes.BEWALL, TileTypes.BRWALL],
	},
	TileTypes.WALL : {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BRWALL, TileTypes.BLWALL, TileTypes.REWALL, TileTypes.LEWALL, TileTypes.BEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL,  TileTypes.REWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.REWALL],
		"UL" : [TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.BLWALL, TileTypes.ULWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.URWALL, TileTypes.ULWALL, TileTypes.BRWALL, TileTypes.UEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.URWALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.UEWALL, TileTypes.LEWALL],
	},
	TileTypes.ULWALL : {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.URWALL : {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
	},
	TileTypes.BLWALL : {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.BRWALL: {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.BEWALL : {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"DOWN" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
	},
	TileTypes.UEWALL: {
		"UP" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"UR" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.LEWALL: {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL],
		"BL" : [TileTypes.WALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL],
		"BR" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.UEWALL],
	},
	TileTypes.REWALL: {
		"UP" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"DOWN" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.UEWALL],
		"RIGHT" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"LEFT" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"UL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.BEWALL, TileTypes.REWALL],
		"UR" : [TileTypes.WALL, TileTypes.ULWALL, TileTypes.BLWALL, TileTypes.URWALL, TileTypes.LEWALL, TileTypes.REWALL, TileTypes.UEWALL],
		"BL" : [TileTypes.DWARF, TileTypes.FLOOR, TileTypes.ULWALL, TileTypes.URWALL, TileTypes.BRWALL, TileTypes.REWALL, TileTypes.UEWALL],
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
