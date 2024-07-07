class SpaceInvaderGame : Actor {
	Default {
		+Invisible;
		-Solid;
	}
	
	const InvaderWidth = 30;
	const InvaderHeight = 30;
	const InvaderRows = 5;
	const InvaderColumns = 11;
	const FieldWidth = 448;
	const FieldHeight = 340;
	
	int nextMove;
	int direction;
	int minX;
	int maxX;
	int maxZ;
		
	void Start() {
		minX = pos.x - (FieldWidth / 2);
		maxX = pos.x + (FieldWidth / 2);
		maxZ = self.pos.z + FieldHeight;
		
		CreateInvaders();
		CreatePlayerShip();
		LockPlayer();

        for (let x = 0; x < 20; x++) {
		    Actor.Spawn("ShieldChunk", (self.pos.x + (x * 2), self.pos.y, self.pos.z + 64));
		}
		
		nextMove = GetNextMoveDelay(InvaderRows * InvaderColumns);
		direction = 1;
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
	
	private void CreatePlayerShip() {
		let ship = PlayerShip(Actor.Spawn("PlayerShip", self.pos));
		ship.SetBounds(minX, maxX, maxZ);
	}
	
	private void LockPlayer() {
		players[0].cheats |= CF_TOTALLYFROZEN;
		ChangeCamera(1, 1, 0);
	}
	
	private void UnlockPlayer() {
		players[0].cheats &= ~CF_TOTALLYFROZEN;
		ChangeCamera(0, 1, 0);
	}
	
	States {
		Spawn:
			TNT1 A 1 NoDelay Start();
			Goto GameLoop;
		GameLoop:
			TNT1 A 1 UpdateGame();
			Loop;
	}
	
	void UpdateGame() {
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
	}
	
	int GetNextMoveDelay(int invaders) {
		let x = floor((invaders / double(InvaderRows * InvaderColumns)) * 18);
		return x;
	}
}
