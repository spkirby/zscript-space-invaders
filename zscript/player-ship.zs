class PlayerShip : Actor {
	int minX;
	int maxX;
	int maxZ;
	int direction;
	int fireCooldown;
	PlayerMissile lastMissile;

	Default {
		Health 1;
		Radius 13;
		Height 16;
		Speed 3;
		+NoGravity;
		+Float;
		+Bright;
		+NoBlood;
		+Invulnerable;
	}
	
	States {
		Spawn:
			PLYS A 1 CheckMove();
			Loop;
	}
	
	void SetBounds(int minX, int maxX, int maxZ) {
		self.minX = minX;
		self.maxX = maxX;
		self.maxZ = maxZ;
	}
	
	void SetDirection(int newDirection) {
		direction = newDirection;
	}
	
	void Fire() {
		if (fireCooldown == 0 && (!lastMissile || lastMissile.bDestroyed)) {
			lastMissile = PlayerMissile(A_SpawnProjectile("PlayerMissile", flags: CMF_AIMDIRECTION, pitch: -90));
			
			if (lastMissile) {
				lastMissile.SetBounds(maxZ);
			}

			fireCooldown = 15;
		}
	}
	
	void CheckMove() {
		let newX = self.pos.x;
		
		if (direction == -1) {
			newX = max(self.pos.x - Speed, minX);
		}
		else if (direction == 1) {
			newX = min(self.pos.x + Speed, maxX);
		}
		
		if (newX != self.pos.x) {
			SetOrigin((newX, self.pos.y, self.pos.z), true);
		}

		if (fireCooldown > 0) {
			fireCooldown--;
		}
	}
}
