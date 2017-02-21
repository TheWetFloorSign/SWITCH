package  _blitEngine{
	import _blitEngine.BitPoint;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import _lib._gameObjects._components.HitBox;
	
	/**
	 * ...
	 * @author Ben
	 */
	public class QuadTree 
	{
		private var m_maxObjectCount:int;
		private var m_storedObjects:Array;
		private var m_bounds:Rectangle;
		private var cells:Array;
		private var _maxDepth:int;
		public var depth:int = 1;
		
		private var obHit:HitBox;
		private var refOb:Object;

		public function QuadTree(maxSize:int, maxDepth:int, bounds:Rectangle){
			m_bounds = bounds;
			m_maxObjectCount = maxSize;
			cells = new Array();
			m_storedObjects = new Array();
			_maxDepth = maxDepth;
		}
		
		public function overlap(group1:Array, group2:Array = null):void
		{
			if (group2 == null) group2 = group1;
			for (var i:int = group2.length - 1; i >= 0; i--)
			{
				obHit = group2[i].getComponent(HitBox);
				if(obHit != null)insert(obHit);
			}
			obHit = null;
			for (var j:int = group1.length - 1; j >= 0; j--)
			{
				obHit = group1[j].getComponent(HitBox);
				if (obHit == null) continue;
				refOb = group1[j];
				retrieveObjectsInCollision(obHit);
			}
			clear();
		}

		public function insert(objectToInsert:HitBox):void{
			var iCell:uint;
			if (cells[0] != null){
				iCell = getCellsToInsertObject(new Rectangle(objectToInsert.parent.x + objectToInsert.left,
															objectToInsert.parent.y + objectToInsert.top,
															objectToInsert.size.x,
															objectToInsert.size.y));
				if (!(iCell & 0x0000)){
					if (iCell & 0x1000)cells[0].insert(objectToInsert);
					if (iCell & 0x0100)cells[1].insert(objectToInsert);
					if (iCell & 0x0010)cells[2].insert(objectToInsert);
					if (iCell & 0x0001) cells[3].insert(objectToInsert);
					return;
				}
				
			}

			m_storedObjects.push(objectToInsert);
			

			if(m_storedObjects.length > m_maxObjectCount && cells[0] == null && depth < _maxDepth){
				if(cells[0] == null && depth <= _maxDepth){
					var subWidth:Number = (m_bounds.width / 2);
					var subHeight:Number = (m_bounds.height /2);
					var x:Number = m_bounds.x;
					var y:Number = m_bounds.y;

					cells[0] = new QuadTree(m_maxObjectCount, _maxDepth, new Rectangle(x + subWidth, y, subWidth, subHeight));
					cells[1] = new QuadTree(m_maxObjectCount, _maxDepth, new Rectangle(x, y, subWidth, subHeight));
					cells[2] = new QuadTree(m_maxObjectCount, _maxDepth, new Rectangle(x, y + subHeight, subWidth, subHeight));
					cells[3] = new QuadTree(m_maxObjectCount, _maxDepth, new Rectangle(x + subWidth, y + subHeight, subWidth, subHeight));
					cells[0].depth = cells[1].depth = cells[2].depth = cells[3].depth = depth++;
				}
				var i:int = m_storedObjects.length - 1;
				while(i>=0){
					iCell = getCellsToInsertObject(new Rectangle(m_storedObjects[i].parent.x + m_storedObjects[i].left,
																m_storedObjects[i].parent.y + m_storedObjects[i].top,
																m_storedObjects[i].size.x,
																m_storedObjects[i].size.y));
					if (!(iCell & 0x0000)){
						if (iCell & 0x1000)cells[0].insert(m_storedObjects[i]);
						if (iCell & 0x0100)cells[1].insert(m_storedObjects[i]);
						if (iCell & 0x0010)cells[2].insert(m_storedObjects[i]);
						if (iCell & 0x0001) cells[3].insert(m_storedObjects[i]);
						m_storedObjects.splice(i, 1);
					}					
					i--;
				}
			}
		}
	
		public function remove(objectToRemove:HitBox):void{
			if(rectOverlap(m_bounds, new Rectangle(objectToRemove.parent.x + objectToRemove.left,
										objectToRemove.parent.y + objectToRemove.top,
										objectToRemove.size.x,
										objectToRemove.size.y))){
				for (var l:int = m_storedObjects.length - 1; l >= 0; l--)
				{
					if (m_storedObjects[l] == objectToRemove)
					{
						m_storedObjects.splice(l, 1);
						break;
					}
				}
				if(cells[0] != null){
					for(var i:int=0; i<4;i++){
						cells[i].remove(objectToRemove);
					}
				}
			}
		}

		public function retrieveObjectsInArea(area:Rectangle):Array{
			if (rectOverlap(m_bounds, area)) {
				var returnedObjects:Array = [];
				for (var i:int = m_storedObjects.length -1; i >= 0; i--) {
					returnedObjects.push(m_storedObjects[i]);
				}
				if (cells [0] != null) {
					for (var j:int = 0; j < 4; j++) {
						var cellObjects:Array = cells[j].retrieveObjectsInArea(area);
						if (cellObjects != null) {
							returnedObjects = returnedObjects.concat(cellObjects);
						}
					}
				}
				return returnedObjects;
			}
			return null;
		}
		
		public function retrieveObjectsInCollision(area:HitBox):void{
			if (rectOverlap(m_bounds, ExtraFunctions.broadPhaseRect(area))) {
				for (var i:int = m_storedObjects.length -1; i >= 0; i--) {
					if (area.parent != m_storedObjects[i].parent && ExtraFunctions.broadCollision(area, m_storedObjects[i]))
					{
						m_storedObjects[i].collisionResolution(area.parent);
						area.collisionResolution(m_storedObjects[i].parent);
					}
					//if (rectOverlap(area, ExtraFunctions.broadPhaseRect(m_storedObjects[i])) && refOb != m_storedObjects[i].parent)
						
				}
				if (cells [0] != null) {
					for (var j:int = 0; j < 4; j++) {
						cells[j].retrieveObjectsInCollision(area);
					}
				}
			}
		}

		public function clear():void{
			m_storedObjects = new Array();

			for (var i:int = 0; i < cells.length; i++) {
				if (cells[i] != null) {
					cells[i].clear();
					cells[i] = null;
				}
			}
		}

		private function containsLocation(location:Point):Boolean{
			return m_bounds.containsPoint(location);
		}
		
		private function containsArea(location:Rectangle):Boolean{
			return rectOverlap(m_bounds, location);
			//return rectContains(m_bounds,location);
		}

		private function getCellToInsertObject(location:Rectangle):int{
			var temp:uint = 0x0000;
			for (var i:int = 0; i < 4; i++) {
				if (cells[i].rectOverlap(cells[i].m_bounds, location)) {
					switch(i){
						case 0:
							temp |= 0x1000;
							break;
						case 1:
							temp |= 0x0100;
							break;
						case 2:
							temp |= 0x0010;
							break;
						case 3:
							temp |= 0x0001;
							break;
					}
				}
			}
			return temp;
		}
		
		private function getCellsToInsertObject(location:Rectangle):uint{
			var temp:uint = 0x0000;
			for (var i:int = 0; i < 4; i++) {
				if (cells[i].rectOverlap(cells[i].m_bounds, location)) {
					switch(i){
						case 0:
							temp |= 0x1000;
							break;
						case 1:
							temp |= 0x0100;
							break;
						case 2:
							temp |= 0x0010;
							break;
						case 3:
							temp |= 0x0001;
							break;
					}
					
				}
			}
			return temp;
		}

		private function valueInRange(value:Number, min:Number, max:Number):Boolean{
			return (value >= min) && (value <= max);
		}

		private function rectOverlap(A:Rectangle, B:Rectangle):Boolean{
			return((A.right > B.left) && (B.right > A.left) && (A.bottom > B.top) && (B.bottom > A.top));
		}
		
		private function rectContains(A:Rectangle, B:Rectangle):Boolean{
			return((B.left >= A.left) && (A.right >= B.right) && (A.bottom >= B.bottom) && (B.top >= A.top));
		}
	}
	
}