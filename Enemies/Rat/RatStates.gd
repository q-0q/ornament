extends EnemyStates

class_name RatStates

func _determine_new_state():
	if driver.current_state == $Idle:
		if $Die._stateless_condition(): return $Die		
		if $Aggro._stateless_condition(): return $Aggro
		if $Stun._stateless_condition(): return $Stun
		if $Fall._stateless_condition(): return $Fall		
		if driver.time_in_current_state < $Idle.max_idle_time: return $Idle
		if $Walk._stateless_condition(): return $Walk
	if driver.current_state == $Fall:
		if $Die._stateless_condition(): return $Die
		if $Idle._stateless_condition(): return $Idle
	if driver.current_state == $Walk:
		if $Die._stateless_condition(): return $Die		
		if $Aggro._stateless_condition(): return $Aggro		
		if $Stun._stateless_condition(): return $Stun
		if $Fall._stateless_condition(): return $Fall		
		if driver.time_in_current_state < $Walk.max_walk_time: return $Walk
		if $Idle._stateless_condition(): return $Idle
	if driver.current_state == $Stun:
		if $Fall._stateless_condition(): return $Fall
		if driver.current_state.is_locked: return driver.current_state
		if $Die._stateless_condition(): return $Die
		if $Aggro._stateless_condition(): return $Aggro
		if $Idle._stateless_condition(): return $Idle		
		if $Walk._stateless_condition(): return $Walk
		if $Stun._stateless_condition(): return $Stun
	if driver.current_state == $Aggro:
		if $Die._stateless_condition(): return $Die
		if $Fall._stateless_condition(): return $Fall
		if $Stun._stateless_condition(): return $Stun
		if $Aggro.player_vision_timer < 0.5: return $Aggro
		if $Aggro._stateless_condition(): return $Aggro
		if $Idle._stateless_condition(): return $Idle		
		if $Walk._stateless_condition(): return $Walk
	if driver.current_state == $Retreat:
		if $Fall._stateless_condition(): return $Fall
		if $Stun._stateless_condition(): return $Stun
		if $Retreat._stateless_condition(): return $Retreat
		if $Aggro._stateless_condition(): return $Aggro
		if $Walk._stateless_condition(): return $Walk
		if $Idle._stateless_condition(): return $Idle
		
		
	return driver.current_state
