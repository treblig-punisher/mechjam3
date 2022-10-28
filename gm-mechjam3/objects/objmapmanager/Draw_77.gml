/// @description Insert description here
// You can write your code in this editor

gpu_set_blendenable(false)
draw_surface_ext(application_surface, 0, 0, 1, 1, 0, c_white, 1);
gpu_set_blendenable(true);
draw_sprite_stretched(spr_9slice, 0, 0, 0, window_get_width(), window_get_height());





