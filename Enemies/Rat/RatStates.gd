extends EnemyStates

class_name RatStates

func _determine_new_state():
	if driver.current_state == $Idle:
		if $Stun._stateless_condition(): return $Stun
		if $Fall._stateless_condition(): return $Fall		
		if driver.time_in_current_state < $Idle.max_idle_time: return $Idle
		if $Walk._stateless_condition(): return $Walk
	if driver.current_state == $Fall:
		if $Idle._stateless_condition(): return $Idle
	if driver.current_state == $Walk:
		if $Stun._stateless_condition(): return $Stun
		if $Fall._stateless_condition(): return $Fall		
		if driver.time_in_current_state < $Walk.max_walk_time: return $Walk
		if $Idle._stateless_condition(): return $Idle
	if driver.current_state == $Stun:
		if driver.current_state.is_locked: return driver.current_state
		if $Fall._stateless_condition(): return $Fall
		if $Walk._stateless_condition(): return $Walk
		if $Stun._stateless_condition(): return $Stun
		if $Idle._stateless_condition(): return $Idle
		
	return driver.current_state
