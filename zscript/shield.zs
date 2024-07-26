class Shield : Thinker {
    const ChunkRows = 16;
    const ChunkCols = 22;
    static const String shape[] = {
        "....##############....",
        "...################...",
        "..##################..",
        ".####################.",
        "######################",
        "######################",
        "######################",
        "######################",
        "######################",
        "######################",
        "######################",
        "######################",
        "#######........#######",
        "######..........######",
        "#####............#####",
        "#####............#####"
    };
    
    ShieldChunk chunks[ChunkRows][ChunkCols];
    
    static Shield Create(vector3 origin) {
        let controller = New("Shield");
        controller.Init(origin);
        return controller;
    }

    private void Init(vector3 origin) {
        let pos = origin;

        for (let z = 0; z < ChunkRows; z++) {
        	for (let x = 0; x < ChunkCols; x++) {
                if (shape[z].ByteAt(x) == "#") {
		    	    let chunk = ShieldChunk(Actor.Spawn("ShieldChunk", pos));
                    chunk.Shield = self;
                    chunks[z][x] = chunk;
                }
                else {
                    chunks[z][x] = null;
                }

                pos.x += 2;
			}
            
            pos.x = origin.x;
            pos.z -= 2;
		}
    }

    void ChunkDestroyed(ShieldChunk chunk) {
        for (let z = 0; z < ChunkRows; z++) {
            for (let x = 0; x < ChunkCols; x++) {
                if (chunk == chunks[z][x]) {
                    DestroyNearbyChunks(x, z);
                }
            }
        }
    }

    private void DestroyNearbyChunks(int x, int z) {
        DestroyChunk(x, z-2);

        DestroyChunk(x-1, z-1);
        DestroyChunk(x, z-1);
        DestroyChunk(x+1, z-1);

        DestroyChunk(x-2, z);
        DestroyChunk(x-1, z);
        DestroyChunk(x, z);
        DestroyChunk(x+1, z);
        DestroyChunk(x+2, z);

        DestroyChunk(x-1, z+1);
        DestroyChunk(x, z+1);
        DestroyChunk(x+1, z+1);
        
        DestroyChunk(x, z+2);
    }

    private void DestroyChunk(int x, int z) {
        if (x < 0 || x >= ChunkCols || z < 0 || z >= ChunkRows) {
            return;
        }

        let chunk = chunks[z][x];

        if (chunk) {
            chunk.DestroyChunk();
        }
    }
}