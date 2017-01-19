package _lib {
	
	public class Street2 {
		
		public var testJSON:Object;
		
		public function Street2() {
			testJSON = {
    "tiles": [
        {
            "id": 1,
            "frames": [
                {
                    "framePosition": [24,24], "frameSize": [24,24]
                }
            ]
        },
        {
            "id": 2,
            "frames": [
                {
                    "framePosition": [48,0], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ]
        },
        {
            "id": 3,
            "frames": [
                {
                    "framePosition": [0,0], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ]
        },
        {
            "id": 4,
            "frames": [
                {
                    "framePosition": [48,24], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ]
        },
		{
            "id": 5,
            "frames": [
                {
                    "framePosition": [48,24], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [0,24],
			"slopePosition": "bottom"
        },
		{
            "id": 6,
            "frames": [
                {
                    "framePosition": [48,24], "frameSize": [24,24], "flip": true
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [24,0],
			"slopePosition": "bottom"
        },
		{
            "id": 7,
            "frames": [
                {
                    "framePosition": [24,48], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [0,12],
			"slopePosition": "bottom"
        },
		{
            "id": 8,
            "frames": [
                {
                    "framePosition": [48,48], "frameSize": [24,24]
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [12,24],
			"slopePosition": "bottom"
        },
		{
            "id": 9,
            "frames": [
                {
                    "framePosition": [24,48], "frameSize": [24, 24], "flip": true
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [12,0],
			"slopePosition": "bottom"
        },
		{
            "id": 10,
            "frames": [
                {
                    "framePosition": [48,48], "frameSize": [24,24], "flip": true
                }
            ],
            "hitbox": [
                {
                    "boxSize": [24,24], "boxPosition": [0,0]
                }
            ],
			"slope": [24,12],
			"slopePosition": "bottom"
        }
		
    ],
    "background": [
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 2, 2, 2, 2,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 2, 2, 2, 2,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 1, 1, 1, 1, 1, 1,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 1, 1, 1, 1, 1, 1, 1, 1,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,10, 9,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
    ],
	"spawns": [	{
			"location":{"x":5 * 24, "y":3*24}
		}],
					
	"objects":[
		{
			"id":1,
			"idName":"RubDummy"
		}, {
			"id":2,
			"idName":"Dummy"
		}, {
			"id":3,
			"idName":"BeachBall"
		}, {
			"id":4,
			"idName":"Door"
		}
	],
	"objectSpawns":[
		{
			"id":1,
			"location":{"x":456, "y":192}
		},{
			"id":3,
			"location":{"x":200, "y":384}
		},{
			"id":4,
			"location":{"x":1 * 24, "y":6 * 24},
			"level":"MuseumLobby",
			"position":{"x":26 * 24, "y":7 * 24}
		},{
			"id":4,
			"location":{"x":33 * 24, "y":12 * 24},
			"level":"Mall",
			"position":{"x":2 * 24, "y":7 * 24}
		}
	],
	"levels":[
	"Mall"]
					
	/*"background": [
        [0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,2,0,0,0,0,0],
		[0,0,2,0,0,2,0,0,0,0,0],
		[2,2,2,2,2,2,2,2,2,2,2]
    ],
	"spawns": [		[0,0,0,0,0,0],
					[0,0,0,0,0,0],
					[0,0,0,0,0,0],
					[0,0,0,0,0,0],
					[0,0,0,0,0,0],
					[0,1,0,0,0,0],
					[0,0,0,0,0,0]]*/
					
			}
		}

	}
	
}
