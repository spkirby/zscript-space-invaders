enum GameState {
	GameState_Normal = 0,
	GameState_PlayerDestroyed = 1,
	GameState_GameOver = 2
}

class SpaceInvadersGame : Actor {
	const InvaderWidth = 30;
	const InvaderHeight = 30;
	const InvaderRows = 5;
	const InvaderColumns = 11;
	const FieldWidth = 448;
	const FieldHeight = 340;
	const ShieldHeightAbovePlayer = 32;
	const ShieldHeight = 32;
	
	int nextMove;
	int direction;
	int minX;
	int maxX;
	int maxZ;
	int step;
	GameState gameState;
	int playerLives;
	PlayerShip _playerShip;

	Default {
		+Invisible;
		-Solid;
	}
	
	States {
		Spawn:
			TNT1 A 1 NoDelay Start();
			Goto GameLoop;
		GameLoop:
			TNT1 A 1 UpdateGame();
			Loop;
	}
		
	void Start() {
		minX = pos.x - (FieldWidth / 2);
		maxX = pos.x + (FieldWidth / 2);
		maxZ = self.pos.z + FieldHeight;
		
		CreateInvaders();
		_playerShip = CreatePlayerShip();
		CreateShields();
		LockPlayer();

		nextMove = 35;
		direction = 1;
		playerLives = 3;
		gameState = GameState_Normal;
	}
	
	private void CreateInvaders() {
		let invaderOrigin = (minX, self.pos.y, maxZ);
		
		for (let z = 0; z < InvaderRows; z++) {
			let type = (z == 0 ? 1 : z < 3 ? 2 : 3);
		
			for (let x = 0; x < InvaderColumns; x++) {
				let pos = (
					invaderOrigin.x + (x * InvaderWidth),
					invaderOrigin.y,
					invaderOrigin.z - ((z + 1) * InvaderHeight)
				);
				
				Actor.Spawn("SpaceInvader" .. type, pos);
			}
		}
	}
	
	private PlayerShip CreatePlayerShip() {
		let ship = PlayerShip(Actor.Spawn("PlayerShip", self.pos));
		ship.SetBounds(minX, maxX, maxZ);
		return ship;
	}

	private void CreateShields() {
		let offset = (FieldWidth - (26 * 2)) / 4;

		for (let i = 0; i < 4; i++) {
			Shield.Create((
				minX + 26 + (i * offset),
				self.pos.y,
				self.pos.z + ShieldHeight + ShieldHeightAbovePlayer
			));
		}
	}
	
	private void LockPlayer() {
		players[0].cheats |= CF_TOTALLYFROZEN;
		ChangeCamera(1, 1, 0);
	}
	
	private void UnlockPlayer() {
		players[0].cheats &= ~CF_TOTALLYFROZEN;
		ChangeCamera(0, 1, 0);
	}

	void UpdateGame() {
		if (gameState == GameState_PlayerDestroyed) {
			if (--nextMove > 0) {
				return;
			}

			_playerShip.Resurrect();
			gameState = GameState_Normal;
		}

		if (_playerShip.IsDestroyed()) {
			nextMove = 105;
			gameState = GameState_PlayerDestroyed;
			return;
		}

		UpdateInvaders();
	}

	void UpdateInvaders() {
		if (--nextMove > 0) {
			return;
		}
		
		let endOfLine = false;
		Array<SpaceInvader> invaders;
		
		foreach (SpaceInvader invader : ThinkerIterator.Create("SpaceInvader", Thinker.STAT_DEFAULT)) {
			let newX = invader.pos.x + (direction * invader.Speed);
			
			if (newX < minX || newX > maxX) {
				endOfLine = true;
			}
			
			invaders.Push(invader);
		}
		
		if (endOfLine) {
			for (let i = invaders.Size() - 1; i >= 0; i--) {
				invaders[i].Move(0, -InvaderHeight);
			}
			
			direction = -direction;
		}
		else if (direction == 1) {
			for (let i = invaders.Size() - 1; i >= 0; i--) {
				invaders[i].Move(invaders[i].Speed, 0);
			}
		}
		else {
			for (let i = 0; i < invaders.Size(); i++) {
				invaders[i].Move(-invaders[i].Speed, 0);
			}
		}
		
		nextMove = GetNextMoveDelay(invaders.Size());
		A_StartSound("invader/walk" .. step);

		if (++step > 3) {
			step = 0;
		}
	}
	
	private int GetNextMoveDelay(int invaders) {
		let x = floor((invaders / double(InvaderRows * InvaderColumns)) * 28);
		return x;
	}
}
