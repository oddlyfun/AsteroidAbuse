if (live_call()) return live_result;

ship = {
	x : room_width / 2,
	y : room_height / 2,
	velocity : 2,
	sprite : spr_space_stuff,
	direction : 0,
	
	
	
	move : function() {
		if ( keyboard_check(vk_up) )
		{
			x = x + velocity;
		}
	},
	
	
	
	rotate : function() {
		if ( keyboard_check(vk_right) )
		{
			direction = direction - 2;
		} else if ( keyboard_check(vk_left) )
		{
			direction =  direction + 2;
		}
	},
	
	
	
	draw_me : function() {
		draw_sprite_ext(sprite, 0, x, y, 1, 1, direction, c_white, 1);
	}
	
	
};