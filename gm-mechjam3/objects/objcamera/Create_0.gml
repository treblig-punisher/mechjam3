#macro screenWidth 640
#macro screenHeight 360

#macro mouse_gui_x device_mouse_x_to_gui(0)
#macro mouse_gui_y device_mouse_y_to_gui(0)


window_scale = 2;
camera_destroy(view_camera[0]);
view_camera[0] = camera_create_view(0, 0, screenWidth * 1, screenHeight * 1);
room_set_view_enabled(room, true);
view_enabled = true;
view_visible[0] = true;


function SetupGameWindow(_window_scale) {
	view_width = screenWidth;
	view_height = screenHeight;

	window_set_size(view_width * _window_scale, view_height * _window_scale);
	alarm[0] = 1;
	//resize gui in the alarm after window has changed
	//surface_resize(application_surface, view_width * _window_scale, view_height * _window_scale);	
}

SetupGameWindow(window_scale);
//display_set_gui_size(screenWidth, screenHeight)