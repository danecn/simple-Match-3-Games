package objects {
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class Bola extends Sprite {
	
		[Embed(source = "../../lib/bolaBiru.png")]
		private var bolaBiru:Class;
		
		[Embed(source = "../../lib/bolaHijau.png")]
		private var bolaHijau:Class;
		
		[Embed(source = "../../lib/bolaMerah.png")]
		private var bolaMerah:Class;
		
		[Embed(source = "../../lib/select.png")]
		private var Select:Class;
		
		public static const WR_MERAH:String = 'wr_merah';
		public static const WR_HIJAU:String = 'wr_hijau';
		public static const WR_BIRU:String = 'wr_biru';
		
		public static const WIDTH:int = 40;
		public static const HEIGHT:int = 40;
		
		private var _color:String = WR_BIRU;
		private var bmp:Bitmap;
		private var activeBmp:Bitmap;
		private var _linked:Boolean = false;
		private var _fallIsActive:Boolean = false;
		private var _fallDist:int = 0;
		private var _fallDistCr:int = 0;
		private var _fallOldY:int = 0;
		private var _fallSpeed:int = 1;
		private var _jadi:Boolean = false;
		private var _active:Boolean = false;
		
		public function Bola(bColor:String=WR_MERAH) {
			init(bColor);
		}
		
		public function registerToBoard(boards:Array):void {
			var i:Number;
			var j:Number;
			
			i = Math.floor(x / WIDTH);
			j = Math.floor(y / HEIGHT);
			
			boards[i][j] = this;
		}
		
		public function reset():void {
			fallStatusReset();
		}
		
		public function fallStatusReset():void {
			_fallIsActive = false;
			_fallDistCr = 0;
			_fallDist = 0;
			_fallOldY = y;
		}
		
		public function update():void {
			
			if (_fallIsActive) {
				_fallDistCr += _fallSpeed;
				if (_fallDistCr >= _fallDist) {
					_fallDistCr = _fallDist;
					_fallIsActive = false;
					y = _fallOldY + _fallDistCr;
					fallStatusReset();
					return;
				}
				y = _fallOldY + _fallDistCr;
			}
		}
		
		//public function removeFromList(lists:Array):void {
			//var i:int;
			//var len:int;
			//
			//len = lists.length;
			//for (i = 0; i < len; i++) {
				//if (lists[i] == this) {
					//lists.splice(i, 1);
				//}
			//}
		//}
		
		private function init(bColor:String):void {
			if (bColor == WR_MERAH) {
				bmp = new bolaMerah();
			} else if (bColor == WR_HIJAU) {
				bmp = new bolaHijau();
			} else if (bColor == WR_BIRU) {
				bmp = new bolaBiru();
			}
			addChild(bmp);
			activeBmp = new Select();
			activeBmp.visible = false;
			addChild(activeBmp);
			_color = bColor;
		}
		
		public function get color():String {
			return _color;
		}
		
		public function set color(value:String):void {
			_color = value;
		}
		
		public function get linked():Boolean {
			return _linked;
		}
		
		public function set linked(value:Boolean):void {
			_linked = value;
			
			if (value) {
				activeBmp.visible = true;
			} else {
				activeBmp.visible = false;
			}
		}
		
		public function get fallIsActive():Boolean {
			return _fallIsActive;
		}
		
		public function set fallIsActive(value:Boolean):void {
			_fallIsActive = value;
		}
		
		public function get fallDist():int {
			return _fallDist;
		}
		
		public function set fallDist(value:int):void {
			_fallDist = value;
		}
		
		public function get jadi():Boolean {
			return _jadi;
		}
		
		public function set jadi(value:Boolean):void {
			_jadi = value;
		}
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set active(value:Boolean):void {
			_active = value;
			
			if (_active == false) {
				if (parent) parent.removeChild(this);
			}
		}
	}

}