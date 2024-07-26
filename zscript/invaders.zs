
class SpaceInvader : Actor abstract {
	const FireProbability = 0.05;
	int score;
	int fireCooldown;
	int animationFrame;
	property Score : score;
	
	Default {
		Health 1;
		Radius 6;
		Height 16;
		Speed 4;
		Mass 10000;
		Monster;
		+NoGravity;
		+Float;
		+Bright;
		+NoBlood;
		+NoForwardFall;
		DeathSound "invader/death";
	}
	
	States {
		Spawn:
			TNT1 A 1
			{
				fireCooldown = 3;
				SetState(ResolveState("Walk0"));
			}
			Loop;
		Walk0:
			Stop;
		Walk1:
			Stop;
		Death:
			INVX A 15
			{
				A_ScreamAndUnblock();
				bNoGravity = true;
			}
			Stop;
	}
	
	void Move(int offsetX, int offsetZ) {
		if (bSolid) {
			animationFrame = animationFrame == 0 ? 1 : 0;
			
			if (animationFrame == 0) {
				SetState(ResolveState("Walk0"));
			}
			else {
				SetState(ResolveState("Walk1"));
			}
				
			SetOrigin((self.pos.x + offsetX, self.pos.y, self.pos.z + offsetZ), true);
		}
	}

	void TryFire() {
		if (fireCooldown > 0) {
			fireCooldown--;
			return;
		}
	
		if (frandom(0, 1) < FireProbability) {
			FLineTraceData traceData;

			if (
				!LineTrace(0, 500, 90, offsetZ: -1, data: traceData) ||
				traceData.HitType != TRACE_HitActor ||
				(
					traceData.HitActor != null &&
					traceData.HitActor.GetClassName() == "PlayerShip" ||
					traceData.HitActor.GetClassName() == "PlayerMissile" ||
					traceData.HitActor.GetClassName() == "ShieldChunk"
				)
			) {
				A_SpawnProjectile("InvaderMissile", spawnHeight: -1, flags: CMF_AIMDIRECTION, pitch: 90);
				fireCooldown = 6;
			}
		}
	}
}

class SpaceInvader1 : SpaceInvader {
	Default {
		SpaceInvader.Score 30;
	}

	States {
		Walk0:
			INV1 A 10;
			Loop;
		Walk1:
			INV1 B 10;
			Loop;
	}
}

class SpaceInvader2 : SpaceInvader {
	Default {
		SpaceInvader.Score 20;
	}

	States {
		Walk0:
			INV2 A 10;
			Loop;
		Walk1:
			INV2 B 10;
			Loop;
	}
}

class SpaceInvader3 : SpaceInvader {
	Default {
		SpaceInvader.Score 10;
	}

	States {
		Walk0:
			INV3 A 10;
			Loop;
		Walk1:
			INV3 B 10;
			Loop;
	}
}
