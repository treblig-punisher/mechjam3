/// @description Insert description here
// You can write your code in this editor

//Debug functionality

setNewResForFullScreen();

if ( room == rmMap) {
	if(input_check_released("mapMenuConfirm"))
	{
		if(tileMap[playerPawn.mapY][playerPawn.mapX].isLiberated == false)
		{
			PlayerVictory();
		}
	}

	if(input_check_released("cancel"))
	{
			PlayerFailure();
	}	
	
	if(input_check_released("accept"))
	{
		if(tileMap[playerPawn.mapY][playerPawn.mapX].isLiberated == false)
		{
			objCombatManager.StartCombat(tileMap[playerPawn.mapY][playerPawn.mapX].isFinalBattle);
		}
	}	
	
	if(tileMap[playerPawn.mapY][playerPawn.mapX].isLiberated == false)
	{
		var _tileObj = tileMap[playerPawn.mapY][playerPawn.mapX];
		if (_tileObj != noone) {
			switch(_tileObj.buff){
			case 0:
				tileReward = "Health";
			break;
			case 1:
				tileReward = "Stamina";
			break;
			case 2:
				tileReward = "Speed";
			break;
			case 3:
				tileReward = "Melee Power";
			break;		
			case 4:
				tileReward = "Ranged Power";
			break;				
			}
		}
	}
		
	
}
