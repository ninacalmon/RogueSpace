extends Node

@warning_ignore("unused_signal")
signal player_out_of_bounds

@warning_ignore("unused_signal")
signal player_almost_out_of_bounds
@warning_ignore("unused_signal")
signal player_back_in_bounds

@warning_ignore("unused_signal")
signal fuel_used
@warning_ignore("unused_signal")
signal burst_fuel_used
@warning_ignore("unused_signal")
signal almost_out_of_fuel
@warning_ignore("unused_signal")
signal out_of_fuel

@warning_ignore("unused_signal")
signal damage_taken(damaged: RigidBody2D, amount: float)

@warning_ignore("unused_signal")
signal cutscene_on
@warning_ignore("unused_signal")
signal cutscene_off

@warning_ignore("unused_signal")
signal space_resource_collected

@warning_ignore("unused_signal")
signal mothership_entrance_entered

@warning_ignore("unused_signal")
signal mothership_entrance_exited

@warning_ignore("unused_signal")
signal player_wants_to_enter_mothership

@warning_ignore("unused_signal")
signal not_enough_resources

@warning_ignore("unused_signal")
signal resources_used
