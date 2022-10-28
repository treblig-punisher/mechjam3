/// @description Insert description here
// You can write your code in this editor

if(window_get_fullscreen())
{
	surface_resize(application_surface, displaySize.width, displaySize.height);
}
else
{
	surface_resize(application_surface, windowSize.width/3, windowSize.height/3);
}





