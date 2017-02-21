package _lib {
	
	public class Street1 {
		
		public var testJSON:Object;
		
		public function Street1() {
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
                    "framePosition": [24,72], "frameSize": [24,24]
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
                    "framePosition": [24,0], "frameSize": [24,24]
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
        }
		
    ],
    "background": [
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
		[1, 2, 2, 6,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 5, 2, 2, 1], 
		[1, 1, 1, 1, 2, 2, 4, 4, 4, 4, 4, 4, 2, 2, 2, 4, 4, 4, 4, 4, 4, 2, 2, 1, 1, 1, 1]
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
			"location":{"x":7*24, "y":6*24}
		},{
			"id":1,
			"location":{"x":21*24, "y":6*24}
		},{
			"id":4,
			"location":{"x":2 * 24, "y":6 * 24},
			"level":"Mall",
			"position":{"x":25 * 24, "y":7 * 24}
		},{
			"id":4,
			"location":{"x":25 * 24, "y":6 * 24},
			"level":"Appartments",
			"position":{"x":2 * 24, "y":15 * 24}
		}
	],
	"levels":[
	"Mall",
	"Appartments"]
					
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
