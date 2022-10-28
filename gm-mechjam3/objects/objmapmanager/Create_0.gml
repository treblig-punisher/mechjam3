/// @description Generate the map manager
width = 9;
height = 6;

minDensity = 0.8;
maxDensity = 0.9;

//objManager.gameData.mapData = [];
tileMap = [];
traversalArray = [];

playerStartX = 0;
playerStartY = 0;

playerLastX = 0;
playerLastY = 0;

playerPawn = noone;
tileReward = "";
setNewResForFullScreen = function()
{
	//static isFullscreen = true;
	if(keyboard_check(vk_alt) && keyboard_check_pressed(vk_enter)) alarm[0] = 10;
}
display_set_gui_size(1920, 1080);
application_surface_draw_enable(false)


guiSize = {
	width: display_get_gui_width(),
	height: display_get_gui_height(),
}
windowSize =
{
	width:  window_get_width(),
	height: window_get_height(),
}
displaySize =
{
	width: display_get_width(),
	height: display_get_height(),
}
//surface_resize(application_surface, displayW, displayH);
alarm[0] = 10;

function GenerateMap()
{
	//Initialize the tile data array
	for(i = 0; i < height; i++)
	{
		objManager.gameData.mapData[i] = [width];
		traversalArray[i] = [width];
	}
	
	for(j = 0; j < height; j++)
	{
		for(k = 0; k < width; k++)
		{
			objManager.gameData.mapData[j][k] = new mapTileData();
			objManager.gameData.mapData[j][k].buff = irandom(enmBuffTypes.Length-1);
			traversalArray[j][k] = 0;
		}
	}
	
	//Give the player a starting location
	playerStartX = irandom(width-1);
	playerStartY = irandom(height-1);
	
	playerLastX = playerStartX;
	playerLastY = playerStartY;
	objManager.gameData.mapX = playerStartX;;
	objManager.gameData.mapY = playerStartY;;
	
	objManager.gameData.mapData[playerStartY][playerStartX].isLiberated = true;
	
	//Determine exclusion portion
	var exclusionCount = floor((width * height) - (random_range(minDensity, maxDensity) * width * height));
	
	while(exclusionCount > 0)
	{
		var xLoc = irandom(height-1);
		var yLoc = irandom(width-1);
		
		if(objManager.gameData.mapData[xLoc][yLoc].isLiberated == false and objManager.gameData.mapData[xLoc][yLoc].isPresent == true)
		{
			traversalArray[xLoc][yLoc] = -1;
			if(ValidateMap() == true)
			{
				objManager.gameData.mapData[xLoc][yLoc].isPresent = false;
				exclusionCount = exclusionCount - 1;
			}
			else
			{
				traversalArray[xLoc][yLoc] = 0;
			}
		}
	}
}

function ValidateMap()
{
	isValid = true;
	
	//Run fill algorithm
	for(i = 0; i < height; i++)
	{
		for(j = 0; j < width; j++)
		{
			if(traversalArray[i][j] == 0)
			{
				CanReachAdjacentCell(i, j);
				break;
			}
		}
	}
	
	//Check for unreached cells and clean up reached cells
	for(k = 0; k < height; k++)
	{
		for(l = 0; l < width; l++)
		{
			if(traversalArray[k][l] == 0)
			{
				isValid = false;
			}
			else if(traversalArray[k][l] == 1)
			{
				traversalArray[k][l] = 0;
			}
		}
	}
	
	return isValid;
}

function CanReachAdjacentCell(i, j)
{
	//North
	if(i > 0)
	{
		if(traversalArray[i-1][j] == 0)
		{
			traversalArray[i-1][j] = 1;
			CanReachAdjacentCell(i-1, j);
		}
	}
	
	//South
	if(i < height-1)
	{
		if(traversalArray[i+1][j] == 0)
		{
			traversalArray[i+1][j] = 1;
			CanReachAdjacentCell(i+1, j);
		}
	}
	
	//West
	if(j > 0)
	{
		if(traversalArray[i][j-1] == 0)
		{
			traversalArray[i][j-1] = 1;
			CanReachAdjacentCell(i, j-1);
		}
	}
	
	//East
	if(j < width-1)
	{
		if(traversalArray[i][j+1] == 0)
		{
			traversalArray[i][j+1] = 1;
			CanReachAdjacentCell(i, j+1);
		}
	}
}

function DisplayMap()
{
	//Initialize the tile array
	for(t = 0; t < height; t++)
	{
		tileMap[t] = [width];
	}
	
	for(i = 0; i < height; i++)
	{
		for(j = 0; j < width; j++)
		{
			var xLoc = (j * (sprite_get_width(sprHexTile))) + sprite_get_width(sprHexTile);
			if(i mod 2 == 0)
			{
				xLoc = xLoc + sprite_get_width(sprHexTile)/2;
			}
			xLoc = xLoc - sprite_get_width(sprHexTile)/4;
			
			var yLoc = ((i * sprite_get_height(sprHexTile)) - i * (sprite_get_height(sprHexTile))/4) + sprite_get_height(sprHexTile);
					
			tileMap[i][j] = instance_create_layer(xLoc, yLoc, "Map", objHexTile);
			tileMap[i][j].isLiberated = objManager.gameData.mapData[i][j].isLiberated;
			tileMap[i][j].buff = objManager.gameData.mapData[i][j].buff;
			tileMap[i][j].bonus = objManager.gameData.mapData[i][j].bonus;
			tileMap[i][j].isPresent = objManager.gameData.mapData[i][j].isPresent;
			tileMap[i][j].isFinalBattle = objManager.gameData.mapData[i][j].isFinalBattle;
		}
	}	
	
	playerPawn = instance_create_layer(tileMap[playerStartY][playerStartX].x, tileMap[playerStartY][playerStartX].y, "Pawns", objPlayerPawn);
	playerPawn.mapX = playerStartX;
	playerPawn.mapY = playerStartY;
}

//Tile encounter results
function PlayerVictory()
{	
	objManager.gameData.player.UpgradePlayer(objManager.gameData.mapData[playerPawn.mapY][playerPawn.mapX].buff);
	objManager.gameData.mapData[playerPawn.mapY][playerPawn.mapX].isLiberated = true;
	tileMap[playerPawn.mapY][playerPawn.mapX].isLiberated = true;
	
	playerPawn.UpdateLastLocation();
	ClearMissionStatus();
}

function PlayerFailure()
{
	show_debug_message("FAILURE");
	playerStartX = playerLastX;
	playerStartY = playerLastY;
	
	playerPawn.mapX = playerLastX;
	playerPawn.mapY = playerLastY;
	
	playerLastX = playerPawn.mapX;
	playerLastY = playerPawn.mapY;
	
	playerPawn.MoveToNewLocation();
	ClearMissionStatus();
}

function PlayerLoadFromGameData(){
	playerStartX = objManager.gameData.mapX;
	playerStartY = objManager.gameData.mapY;

	
	playerLastX = playerStartX;
	playerLastY = playerStartY;
	
	playerPawn.mapX = playerStartX;
	playerPawn.mapY = playerStartY;
	playerPawn.MoveToNewLocation();
}

function ClearMissionStatus() {
	global.missionStatus = enmMissionStatus.none;
}

ClearMissionStatus();
if (array_length(objManager.gameData.mapData) == 0) 
	GenerateMap();
	
//display_set_gui_size(room_width, room_height)