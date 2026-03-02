extends Resource
class_name LevelResource

#Level Metadata
@export var uuid : String
@export var name : String
@export var description : String
@export var laps : int
@export var icon : PackedByteArray

#Level data
@export var tile_map_data : PackedByteArray
@export var entity_data : Dictionary
