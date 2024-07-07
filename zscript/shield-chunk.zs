class ShieldChunk : Actor {
    int mChunks;
    property Chunks : mChunks;

    Default {
        Health 4;
        Height 8;
        Radius 1;
        Mass 10000;
        PainChance 256;
        ShieldChunk.Chunks 15;
        +Solid;
        +Shootable;
        +NoBlood;
        +NoGravity;
        +NoForwardFall;
    }

    States {
		Spawn:
            Goto Chunks15;
        Pain:
            TNT1 A 1 HitByPlayer();
            Loop;
        Chunks15:
            SHLD A -1;
            Loop;
        Chunks7:
            SHLD B -1;
            Loop;
        Chunks3:
            SHLD C -1;
            Loop;
        Chunks1:
            SHLD D -1;
            Loop;
        Chunks14:
            SHLD E -1;
            Loop;
        Chunks12:
            SHLD F -1;
            Loop;
        Chunks8:
            SHLD G -1;
            Loop;
        Chunks6:
            SHLD H -1;
            Loop;
        Chunks2:
            SHLD I -1;
            Loop;
        Chunks4:
            SHLD J -1;
            Loop;
	}

    /*state HitByInvader() {

    }*/

    state HitByPlayer() {
        if (mChunks > 0) {
            let bit = 1;

            while (!(mChunks & bit)) {
                bit *= 2;
            }

            mChunks = mChunks & (15 - bit);
        }

        return UpdateState();
    }

    state UpdateState() {
        console.printf("Chunks%d", mChunks);
        return FindStateByString("Chunks" .. mChunks);
    }
}