if (live_call()) return live_result;

ship = {
	x : room_width / 2,
	y : room_height / 2,
	speed : 4,
	accel : 0,
	sprite : spr_space_stuff,
	direction : 0,
	move_dir : 1,
	
	
	move : function() {
		
		var _x = (lengthdir_x(1,direction) * accel) * move_dir;
		var _y = (lengthdir_y(1,direction) * accel) * move_dir;
		var _moving = false;
		
		if ( keyboard_check(vk_up) )
		{
			move_dir = 1;
			accel = accel + 0.10;
			_moving = true;
		} else if ( keyboard_check(vk_down) )
		{
			move_dir = -1;
			accel = accel + 0.10;
			_moving =  true;
		} else
		{
			accel = accel - 0.10;
		}
				
		x = x + _x;
		y = y + _y;
		
		accel = clamp(accel,0,speed);
	},
	
	rotate : function() {
		if ( keyboard_check(vk_right) )
		{
			direction = direction - 4;
		} else if ( keyboard_check(vk_left) )
		{
			direction =  direction + 4;
		}
	},
	
	
	draw_me : function() {
		draw_sprite_ext(sprite, 0, x, y, 1, 1, direction, c_white, 1);
	}
	
	
};