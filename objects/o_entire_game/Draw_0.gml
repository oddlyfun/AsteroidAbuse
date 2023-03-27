if (live_call()) return live_result;




for ( var i = 0; i < array_length(asteroid_array); i++ )
{
	asteroid_array[@ i].draw_me();
}

for ( var i = 0; i < array_length(bullet_array); i++ )
{
	bullet_array[@ i].draw_me();
}

//draw_text(20,20, array_length(bullet_array) );

ship.draw_me();