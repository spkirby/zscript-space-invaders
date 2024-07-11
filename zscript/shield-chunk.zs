class ShieldChunk : Actor {
    Shield Shield;
    property Shield : Shield;

    Default {
        Health 1;
        Height 2;
        Radius 1;
        Mass 10000;
        +Solid;
        +Shootable;
        +NoBlood;
        +NoGravity;
        +NoForwardFall;
        +Bright;
    }

    States {
		Spawn:
            SHLD A -1;
            Goto Spawn;
        Death.Missile:
            TNT1 A 1 { Shield.ChunkDestroyed(self); }
            Stop;
	}

    void DestroyChunk() {
        if (!self.bDestroyed) {
            SetState(FindState("Death"));
        }
    }
}