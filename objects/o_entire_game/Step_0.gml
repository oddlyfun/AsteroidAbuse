ship.move();
ship.rotate();
ship.hit_a_asteroid(asteroid_array);

if ( keyboard_check_pressed(vk_space) )
{
	ship.fire_bullet(ship);
	audio_play_sound(sfx_weapon,1,false);
}

/*
	Wave timers and scaling difficulty
*/

if ( ast_timer >= waver_timer )
{
	repeat(repeat_amount)
	{
		array_push(asteroid_array, new asteroid(ship) );
		ast_timer = 0;
	}
}

ast_timer = ast_timer + (delta_time / 1000000);
repeat_timer = repeat_timer + (delta_time / 1000000);

// every 15 seconds change how ofter asteroids are spawned and eventually how many per wave
if ( repeat_timer >= 10 )
{
	waver_timer = clamp(waver_timer - 0.5, 1, 4);
	repeat_amount = clamp(repeat_amount + 1, 1, 10);
	repeat_timer = 0;
}

/*
		Asteroid Array
*/
for ( var i = array_length(asteroid_array) - 1; i >= 0; i-- )
{
	var _aster = asteroid_array[@ i];
	_aster.move();
	_aster.bullet_collider(bullet_array);
	
	if ( _aster.posX > 600 or _aster.posX < -600 or _aster.posY > 600 or _aster.posY < -600 or _aster.is_dead == true)
	{
		delete _aster;
		array_delete(asteroid_array,i,1);
	}
	
}

/*
		Bullet Array
*/
for ( var i = array_length(bullet_array) - 1; i >= 0; i-- )
{
	var _bult = bullet_array[@ i];
	_bult.move_me();
	
	if ( _bult.posX > 600 or _bult.posX < -600 or _bult.posY > 600 or _bult.posY < -600 or _bult.is_dead == true)
	{
		array_delete(bullet_array,i,1);
	}
	
}

/*
		Ship Checks
*/

if ( ship.x > room_width )
{
	ship.x = 0;
}

if ( ship.x < 0 )
{
	ship.x = room_width;
}

if ( ship.y > room_height )
{
	ship.y = 0;
}

if ( ship.y < 0 )
{
	ship.y = room_height;
}



if ( ship.is_dead == true )
{
	if ( the_score > highscore )
	{
		highscore = the_score;
	}
	bullet_array	= [];
	ast_timer 		= 0;
	waver_timer		= 5;
	repeat_timer	= 0;
	repeat_amount	= 1; 
	the_score 		= 0;
	lives			= 3;
	asteroid_array	= [];
	bullet_array	= [];
	ship.reset_me();
}