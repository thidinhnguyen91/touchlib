﻿// Added: Listener functions which should greatly simplify dealing with TUIO events.. 

// FIXME: need velocity

package whitenoise {
	import flash.events.*;
	import flash.xml.*;
	import flash.net.*
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.describeType;

	

	public class TUIOObject 
	{
		public var x:Number;
		public var y:Number;
		
		public var dX:Number;
		public var dY:Number;				
		
		public var area:Number;
		
		public var TUIOClass:String;		// cur or Obj.. 
		public var sID:int;
		public var ID:int;
		public var angle:Number;		
		public var pressure:Number;
		
		private var isNew:Boolean;
		public var isAlive:Boolean;		
		public var obj;
		public var spr:Sprite;
		
		private var color:int;
		
		var aListeners:Array;

		public function TUIOObject (cls:String, id:int, px:Number, py:Number, dx:Number, dy:Number, sid:int = -1, ang:Number = 0, o = null)
		{
			aListeners = new Array();
			TUIOClass = cls;
			ID = id;
			x = px;
			y = py;
			dX = dx;
			dY = dy;
			sID = sid;
			angle = ang;
			isAlive = true;
			
			var c = int(Math.random() * 4);
			
			if(c == 0)
				color = 0xff0000;
			else if(c == 1)
				color = 0x00ffff;
			else if(c == 2)
				color = 0x00ff00;				
			else if(c == 3)
				color = 0x0000ff;				
			
			spr = new Sprite();
			spr.graphics.beginFill( color , 1 );					
			spr.graphics.lineStyle(1.0, 0xffffffff);			
			spr.graphics.drawCircle(0,0,10);

			spr.graphics.endFill( );			
			spr.x = x;
			spr.y = y;

			try {
 	 			obj = o;
			} catch (e)
			{
				obj = null;
			}
			
			trace("Start " + ID + ", " + sID + " (" + int(px) + "," + int(py) + ")");
			

			
			isNew = true;
		}
		
		public function notifyCreated()
		{
			if(obj)
			{
				try
				{
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
					trace("Down : " + localPoint.x + "," + localPoint.y);
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.RollOverEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));													
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.DownEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));									
				} catch (e)
				{
						trace("Failed : " + e);
//					trace(obj.name);
					obj = null;
				}
			}			
		}
		
		public function setObjOver(o:DisplayObject)
		{
			try {
				
				if(obj == null)
				{
					obj = o;				
					if(obj) 
					{
						var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));				
						obj.dispatchEvent(new TUIOEvent(TUIOEvent.RollOverEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));					
					}
				} else if(obj != o) 
				{
					
					var localPoint:Point = obj.parent.globalToLocal(new Point(x, y));								
					obj.dispatchEvent(new TUIOEvent(TUIOEvent.RollOutEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));
					if(o)
					{
						localPoint = obj.parent.globalToLocal(new Point(x, y));
						o.dispatchEvent(new TUIOEvent(TUIOEvent.RollOverEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));
					}
					obj = o;								
				}
			} catch (e)
			{
//				trace("ERROR " + e);
			}
		}
		
		public function addListener(reciever:Object)
		{
			aListeners.push(reciever);
		}
		public function removeListener(reciever:Object)
		{
			for(var i:int = 0; i<aListeners.length; i++)
			{
				if(aListeners[i] == reciever)
					aListeners.splice(i, 1);
			}
		}		
		
		public function kill()
		{
			trace("Die " + ID);			
			var localPoint:Point;
			
			if(obj && obj.parent)
			{				
				localPoint = obj.parent.globalToLocal(new Point(x, y));				
				obj.dispatchEvent(new TUIOEvent(TUIOEvent.RollOutEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));				
				obj.dispatchEvent(new TUIOEvent(TUIOEvent.UpEvent, true, false, x, y, localPoint.x, localPoint.y, obj, false,false,false, true, 0, TUIOClass, ID, sID, angle));									
			}			
			obj = null;
			
			for(var i:int=0; i<aListeners.length; i++)
			{
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));				
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.UpEvent, true, false, x, y, localPoint.x, localPoint.y, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle));								
			}
		}
		
		public function notifyMoved()
		{
			var localPoint:Point;
			for(var i:int=0; i<aListeners.length; i++)
			{
				trace("Notify moved");
				localPoint = aListeners[i].parent.globalToLocal(new Point(x, y));				
				aListeners[i].dispatchEvent(new TUIOEvent(TUIOEvent.MoveEvent, true, false, x, y, localPoint.x, localPoint.y, aListeners[i], false,false,false, true, 0, TUIOClass, ID, sID, angle));								
			}			
		}
	}
}