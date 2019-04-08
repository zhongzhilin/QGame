
local StateEvent = {}

-- [流程]
----------------------------------------
--city
StateEvent.BUILDER =
{
	EVENT = {
		IDLE = "IDLE",
		BUSY = "BUSY",
		CANFREE = "CANFREE",
		NOTOPEN = "NOTOPEN",
	},
	STATE = {
		IDLE = "IDLE",
		BUSY = "BUSY",
		CANFREE = "CANFREE",
		NOTOPEN = "NOTOPEN",
	},
}

StateEvent.BUILDING =
{
	EVENT = {
		BLANK = "BLANK",
		UNOPEN = "UNOPEN",
		OPERATE = "OPERATE",
	},
	STATE = {
		BLANK = "0",
		UNOPEN = "1",
		OPERATE = "2",
	},
}

StateEvent.FARM =
{
	EVENT = {
		HARVEST = "HARVEST",
		MAXHARVEST = "MAXHARVEST",
	},
	STATE = {
		HARVEST = "HARVEST",
		MAXHARVEST = "MAXHARVEST",
	},
}

StateEvent.CAMP =
{
	EVENT = {
		SLEEP = "SLEEP",
		TRAIN = "TRAIN",
		DONE  = "DONE",
	},
	STATE = {
		SLEEP = "SLEEP",
		TRAIN = "TRAIN",
		DONE  = "DONE",
	},
}

StateEvent.WALL =  
{
	EVENT = {
		SLEEP = "SLEEP",
		TRAIN = "BUILD",
		FINISH = "FINISH",
	},
	STATE = {
		SLEEP = "SLEEP",
		TRAIN = "BUILD",
		FINISH = "FINISH",
	},
}

----------------训练----------------->>
StateEvent.TRAIN =
{
	EVENT = {
		IDLE 		= "IDLE",
		TRAINING 	= "TRAINING",
		DONE        = "DONE",
		WAITING 	= "WAITING",
	},
	STATE = {
		IDLE 		= "IDLE",
		TRAINING 	= "TRAINING",
		DONE        = "DONE",
		WAITING 	= "WAITING",
	},
}

----------------部队----------------->>
StateEvent.TROOP =
{
	STATE = {
		STATION 	= "STATION", 
		WAITORDER 	= "WAITORDER",
		FIGHT 		= "FIGHT",
		WALK 		= "WALK",
		BACK 		= "BACK",
		STATION_OTHER = "STATION_OTHER",
		REVOLT = "REVOLT",
	},
	EVENT = {
		STATION 	= "10",
		WAITORDER 	= "6",
		FIGHT 		= "11",
		WALK 		= "1",
		BACK 		= "2",
		STATION_OTHER = "5",
		REVOLT = "12",
	},
}

global.stateEvent = StateEvent