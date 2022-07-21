if (room == rmMap) {
	UpdateStrongestRival();
}

if (room == rmCombat) {
	nextRoom = noone;
	
	CreatePlayer(87, 108, objManager.gameData.player);
	
	if(isFinalBattle)
	{
		SetAlarm(2, 20);
	}
	else
	{
		var budget = objManager.gameData.player.buffLevel;
		enemyPool = undefined;
		enemyPool = ds_list_create();
		enemyPool = GetEnemiesForLevel();
		spawnList = ds_list_create();
		var manualSpawn = false;
		if (enemyPool != undefined) && (!manualSpawn) {
			while (budget >= 0) {
					//add enemies to spawn list	
					_enemy = enemyPool[| irandom(ds_list_size(enemyPool) - 1)];
					ds_list_add(spawnList, _enemy);
					budget -= _enemy.cost;
				}
	
			for (var i = 0; i < ds_list_size(spawnList); i++) {
				var _enemyStruct = spawnList[| i];
				var _rx, _ry;
				do {
					_rx = random(screenWidth);
					_ry = random(screenHeight);
				} until (!place_meeting(_rx, _ry, objPlayer));
			
				ds_list_add(enemyList, AddEnemyFromCatalog(_rx, _ry, _enemyStruct)); 
			
			}
		}
		else {
			//ds_list_add(enemyList, AddEnemyFromData(448, 128, "Drone", objDrone, ["beamGun"]));
			//ds_list_add(enemyList, AddEnemyFromData(448, 288, "Drone", objDrone, ["bazooka"]));
			ds_list_add(enemyList, AddEnemyFromData(540, 160, "Mech", objMech, ["bazooka"]));
		}
	}

	if !layer_sequence_exists("Instances",seqRivalAppears)
	{
		seqRivalAppears = layer_sequence_create("Instances", room_width/2, room_height/2, sqRivalAppears);
		layer_sequence_pause(seqRivalAppears);
	}
	
	if !layer_sequence_exists("GUI",seqRivalDialog)
	{
		seqRivalDialog = layer_sequence_create("GUI", room_width/2, room_height/2, sqRivalDialog);
		layer_sequence_pause(seqRivalDialog);
	}
	
	
}