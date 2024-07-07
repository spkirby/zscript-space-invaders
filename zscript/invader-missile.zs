class InvaderMissile : Actor {
	int minZ;
	
	Default {
		Radius 1;
		Height 8;
		Speed 5;
		DamageFunction 1;
		Projectile;
		+Bright;
	}
	
	States {
		Spawn:
			INVM ABCDCB 1 CheckPosition();
			Loop;
	}
	
	void SetBounds(int minZ) {
		self.minZ = minZ;
	}
	
	void CheckPosition() {
		if (pos.z < minZ) {
			Destroy();
		}
	}
}
