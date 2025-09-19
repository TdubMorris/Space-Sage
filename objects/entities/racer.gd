class_name Racer
extends RigidBody2D
## Base class for all 2D racests
## 
## Contains functions for movement and steering,
## and also handles enviornment interactions
##

# Used for determining bounce angle
var last_vel : Vector2 

# Tile interactions
func _integrate_forces(state: PhysicsDirectBodyState2D) -> void:
	state.angular_velocity = clamp(state.angular_velocity, -2 * PI, 2 * PI)
	
	var tiledata
	var tilemap = get_tree().get_first_node_in_group("Tilemap")
	if state.get_contact_count() > 0:
		var directional_bias = state.get_contact_local_normal(0) * -2.0
		var collide_tile_pos = tilemap.local_to_map(tilemap.to_local(state.get_contact_collider_position(0) + directional_bias))
		tiledata = tilemap.get_cell_tile_data(collide_tile_pos)
		if tiledata: 
			tile_interactions(tiledata, state)
	
	var tile_pos = tilemap.local_to_map(tilemap.to_local(global_position))
	tiledata = tilemap.get_cell_tile_data(tile_pos)
	if tiledata:
		background_interactions(tiledata, state)
	
	last_vel = state.linear_velocity
	


func tile_interactions(tiledata: TileData, state: PhysicsDirectBodyState2D):
	var tiletype = tiledata.get_custom_data("type")
	if tiletype:
		if tiletype == "bouncer":
			state.linear_velocity = last_vel.bounce(state.get_contact_local_normal(0)) * 1.1
			rotation = state.linear_velocity.angle()

func background_interactions(tileData: TileData, state: PhysicsDirectBodyState2D):
	var tileType = tileData.get_custom_data("type")
	if tileType:
		if tileType == "booster":
			var boost_dir = tileData.get_custom_data("dir_norm")
			state.apply_central_force(boost_dir * 350)

# Functions for moving the player
func thrust(amount : float) -> void:
	apply_central_force(Vector2.RIGHT.rotated(rotation) * amount)

func steer(amount : float) -> void:
	apply_torque(amount)
