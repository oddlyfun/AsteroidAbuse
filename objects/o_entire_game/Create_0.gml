if (live_call()) return live_result;
randomize();

ast_timer = 0;
waver_time = 2;

asteroid_array	= [];
bullet_array	= [];



ship = {
	x : room_width / 2,
	y : room_height / 2,
	speed : 4,
	accel : 0,
	sprite : spr_space_stuff,
	direction : 0,
	move_dir : 1,
	is_dead : false,
	
	
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
	},
	
	fire_bullet : function(the_ship) {
		var _bullet = {
			posX : the_ship.x,
			posY : the_ship.y,
			is_dead : false,
			shoot_dir : the_ship.direction,
			shoot_speed : 6,
			draw_me : function() {
				draw_sprite(spr_weapon,0,posX,posY);
			},
			move_me : function() {
				var _x = (lengthdir_x(1,shoot_dir) * shoot_speed);
				var _y = (lengthdir_y(1,shoot_dir) * shoot_speed);

				posX = posX + _x;
				posY = posY + _y;
			}
		};
				
		with(other)
		{
			array_push(bullet_array, _bullet);
		}
	},
	
	
};
	


function asteroid () constructor
{
	posX = 0;
	posY = 0;
	
	posX = irandom_range(-50,room_width + 50);
		
	if ( random(1) > 0.5 ) 
	{
		posY = irandom_range(-50,-25);
	} else
	{
		posY = irandom_range(room_height+50, room_height+80);
	}
		
		
	move_speed = random_range(1,3);
	sprite = spr_LARGE;
	is_dead = false;
	level = 1;
	point_dir = point_direction(posX,posY, irandom_range(25,room_width-25), 250);
	
		
		
	static draw_me = function()
	{
		draw_sprite_ext(sprite,0,posX,posY,1,1,0,c_white,1);	
	}
	
	static move = function()
	{
		
		var _x = (lengthdir_x(1,point_dir) * move_speed);
		var _y = (lengthdir_y(1,point_dir) * move_speed);

		posX = posX + _x;
		posY = posY + _y;

	}
	
	static bullet_collider = function (_blt_list)
	{
		for ( var i = array_length(_blt_list) - 1; i >= 0; i--)
		{
			var _blt = _blt_list[@ i];
			var _x = posX - sprite_get_xoffset(sprite); 
			var _y = posY - sprite_get_yoffset(sprite);
			
			var _bbox_left		= _x + sprite_get_bbox_left(sprite);
			var _bbox_right		= _x + sprite_get_bbox_right(sprite);
			var _bbox_top		= _y + sprite_get_bbox_top(sprite);
			var _bbox_bottom	= _y + sprite_get_bbox_bottom(sprite);
			
			if ( _blt.posX >= _bbox_left and _blt.posX <= _bbox_right and _blt.posY >= _bbox_top and _blt.posY <= _bbox_bottom )
			{
				_blt.is_dead = true;
				is_dead = true;
				
				blown_up(posX, posY, level);				
			}
		}
	}
	
	static blown_up = function(_curX, _curY, _level)
	{
		with(other)
		{
			var _spr = noone;
			var _repeat_amount = 0;
			
			if ( _level == 1 )
			{
				_spr = spr_MEDIUM;
				_level = _level + 1;
				_repeat_amount = 2;
			} else if ( _level == 2 )
			{
				_spr = spr_SMALL;
				_level = _level + 1;
				_repeat_amount = 4;
			}
			
			repeat(_repeat_amount)
			{
				var _smaller_toid = new asteroid();
				_smaller_toid.posX = _curX;
				_smaller_toid.posY = _curY;
				_smaller_toid.sprite = _spr;
				_smaller_toid.level = _level;
				array_push(asteroid_array,_smaller_toid);
			}
		}
	}
}