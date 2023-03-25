if (live_call()) return live_result;


ship.move();
ship.rotate();











if ( keyboard_check_released(vk_tab) )
{
	instance_create_layer(room_width / 2, room_height/2, "Instances", o_entire_game);
	instance_destroy();
}