if (live_call()) return live_result;


ship.move();
ship.rotate();
ship.hit_a_asteroid(asteroid_array);


if ( keyboard_check_pressed(vk_space) )
{
	ship.fire_bullet(ship);
}




if ( ast_timer >= waver_time )
{
	array_push(asteroid_array, new asteroid(ship) );
	ast_timer = 0;
}
ast_timer = ast_timer + (delta_time / 1000000);



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
		Check ship death
*/

if ( ship.is_dead == true )
{
	if ( the_score > highscore )
	{
		highscore = the_score;
	}
	//instance_create_layer(room_width / 2, room_height/2, "Instances", o_entire_game);
	//instance_destroy();
	bullet_array = [];
	ast_timer = 0;
	waver_time = 2;
	the_score 		= 0;
	lives			= 3;
	asteroid_array	= [];
	bullet_array	= [];
	ship.reset_me();
	
}
