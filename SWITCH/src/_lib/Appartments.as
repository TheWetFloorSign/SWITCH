package _lib {
	
	public class Appartments {
		
		public var testJSON:Object;
		
		public function Appartments() {
			testJSON = {
				"tiles": [
					{
						"id": 1,
						"frames": [
							{
								"framePosition": [4*24,1*24], "frameSize": [24,24]
							}
						]
					},
					{
						"id": 2,
						"frames": [
							{
								"framePosition": [8*24,0], "frameSize": [24,24]
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
								"framePosition": [9*24,1*24], "frameSize": [24,24]
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
					}
					
				],
				"background": [
					[3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  ,  ,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  ,  ,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6,  ,  , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  , 6,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  ,  ,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3],
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 5,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 5,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 6,  ,  , 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 3], 
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  , 6,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3,  ,  ,  , 3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 5,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 5,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  ,  , 3], 
					[3, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2, 2]
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
					/*{
						"id":1,
						"location":{"x":456, "y":192}
					},{
						"id":2,
						"location":{"x":200, "y":3*24}
					},*/{
						"id":4,
						"location":{"x":1 * 24, "y":15 * 24},
						"level":"Street1",
						"position":{"x":25 * 24, "y":6 * 24}
					}
				],
				"levels":[
				"Street1",
				"Level3"]					
			}
		}
	}	
}
