﻿package app.core.utl {
   
    import flash.display.Sprite;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
    import flash.utils.Timer;
    import flash.system.*;
   
    public class FPS extends Sprite {
       
        private var _tf:TextField;
        private var _fmt:TextFormat;
        private var _timer:Timer;
        private var _frameNum:int;
        private var _mem:String;
        
        public function FPS() {
            _fmt = new TextFormat("_sans", 10, 0xFFFFFF);
            _frameNum = 0;
            _mem = 0;
            init();      
           
        }
       
        private function init():void {
            _tf = createText();
            addChild(_tf);
            _timer = new Timer(1000);
            _timer.addEventListener(TimerEvent.TIMER, displayFPS, false, 0, true);
            this.addEventListener(Event.ENTER_FRAME, increaseFrame, false, 0, true);
            _timer.start();
        }
       
        private function displayFPS(te:TimerEvent):void {
            _mem = Number( System.totalMemory / 1024 / 1024 ).toFixed( 2 ) + 'MB'; 
            _tf.text = _frameNum + " FPS" + "  \n"+  ""+ _mem+ " \n"+ Capabilities.version;         
              _frameNum = 0;
            _mem = 0;
        }
       
        private function increaseFrame(e:Event):void {
            ++ _frameNum;
        }
       
        private function createText():TextField {   
      
		
            var t:TextField = new TextField();
            t.width = 0;
            t.height = 0;
            t.autoSize = TextFieldAutoSize.LEFT;
            t.selectable = false;
            t.defaultTextFormat = _fmt;
            t.x = 60;
            t.y = 5;
            return t;        
         
        }
       
        public function set textColor(col:uint):void {
            _tf.textColor = col;
        }
    }
}