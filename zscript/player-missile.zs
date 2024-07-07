class PlayerMissile : Actor {
	int maxZ;
	
	Default {
		Radius 1;
		Height 8;
		Speed 10;
		DamageFunction 1;
		Projectile;
		+Bright;
		SeeSound "player/shoot";
	}
	
	States {
		Spawn:
			PLYM A 1 CheckPosition();
			Loop;
	}
	
	void SetBounds(int maxZ) {
		self.maxZ = maxZ;
	}
	
	void CheckPosition() {
		if (pos.z > maxZ) {
			Destroy();
		}
	}
}
