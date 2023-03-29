draw_sprite_part(spr_stars01, 0, 0, 0, room_width, room_height, 0, 0);
draw_sprite_part(spr_stars02, 0, 0, 0, room_width, room_height, 0, 0);

ship.draw_me();

for ( var i = 0; i < array_length(asteroid_array); i++ )
{
	asteroid_array[@ i].draw_me();
}

for ( var i = 0; i < array_length(bullet_array); i++ )
{
	bullet_array[@ i].draw_me();
}

draw_text(20,20, "Score: " + string(the_score));
var _hs_string = "Best Score: " + string(highscore);
draw_text(room_width - string_width(_hs_string) - 10 , 20, _hs_string);
