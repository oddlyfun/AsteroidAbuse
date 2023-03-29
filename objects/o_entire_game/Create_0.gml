randomize();

audio_play_sound(music_space_battle,1,true);

game_timer 		= 0;
ast_timer 		= 0;
waver_time 		= 4;
repeat_times 	= 1;

the_score 		= 0;
highscore		= 0;
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
	
	reset_me : function()
	{
		x = room_width / 2;
		y = room_height / 2;
		accel = 0;
		direction = 0;
		move_dir = 1;
		is_dead = false;
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

	hit_a_asteroid : function(_ast_list) {
		for ( var i = array_length(_ast_list) - 1; i >= 0; i--)
		{
			var _ast = _ast_list[@ i];
			var _x = _ast.posX - sprite_get_xoffset(_ast.sprite); 
			var _y = _ast.posY - sprite_get_yoffset(_ast.sprite);
			
			var _bbox_left		= _x + sprite_get_bbox_left(_ast.sprite);
			var _bbox_right		= _x + sprite_get_bbox_right(_ast.sprite);
			var _bbox_top		= _y + sprite_get_bbox_top(_ast.sprite);
			var _bbox_bottom	= _y + sprite_get_bbox_bottom(_ast.sprite);
			
			if ( x >= _bbox_left and x <= _bbox_right and y >= _bbox_top and y <= _bbox_bottom )
			{
				is_dead = true;
			}
		}
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
	


function asteroid (player_ship, _posX = 0, _posY = 0) constructor
{
	posX = _posX;
	posY = _posY;
	is_blown = false;
	is_dead = false;
	img_index = 0;
	max_frames = 60;
	
	
	if ( posX == 0 and posY == 0 )
	{
		posX = irandom_range(-50,room_width + 50);
		if ( random(1) > 0.5 ) 
		{
			posY = irandom_range(-50,-25);
		} else
		{
			posY = irandom_range(room_height+50, room_height+80);
		}
	}
		
	move_speed = random_range(1,3);
	sprite = spr_LARGE;
	level = 1;
	point_dir = point_direction(posX,posY, 
		irandom_range(player_ship.x - 50, player_ship.x + 50), 
		irandom_range(player_ship.y - 50, player_ship.y + 50));
	
		
		
	static draw_me = function()
	{
		draw_sprite_ext(sprite,img_index,posX,posY,1,1,0,c_white,1);
		if ( is_blown == true )
		{
			img_index = img_index + 1;
			if ( img_index >= max_frames)
			{
				is_dead = true;
				img_index = max_frames;
			}
		}
	}
	
	static move = function()
	{
		
		if ( is_blown == false )
		{
			var _x = (lengthdir_x(1,point_dir) * move_speed);
			var _y = (lengthdir_y(1,point_dir) * move_speed);

			posX = posX + _x;
			posY = posY + _y;
		}

	}
	
	static bullet_collider = function (_blt_list)
	{
		if ( is_blown == false ) 
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
					is_blown = true;
					audio_play_sound(sfx_explode,1,false);
					blown_up(posX, posY, level);				
				}
			}
		}
	}
	
	static blown_up = function(_curX, _curY, _level)
	{
		with(other)
		{
			var _spr = noone;
			var _repeat_amount = 0;
			the_score = the_score + 10;
			
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
				var _smaller_toid = new asteroid(ship, _curX, _curY);
				//_smaller_toid.posX = _curX;
				//_smaller_toid.posY = _curY;
				_smaller_toid.sprite = _spr;
				_smaller_toid.level = _level;
				array_push(asteroid_array,_smaller_toid);
			}
		}
	}
}
