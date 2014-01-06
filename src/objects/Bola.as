package objects {
	import flash.display.Bitmap;
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
		
		public static const width:int = 24;
		public static const height:int = 24;
		
		private var _color:String = WR_BIRU;
		private var bmp:Bitmap;
		private var activeBmp:Bitmap;
		private var _linked:Boolean = false;
		private var _isFalling:Boolean = false;
		private var _fallDist:int = 0;
		private var _jadi:Boolean = false;
		
		public function Bola(bColor:String=WR_MERAH) {
			init(bColor);
		}
		
		public function registerToBoard(boards:Array):void {
			var i:Number;
			var j:Number;
			
			i = x / 24;
			j = y / 24;
			
			boards[i][j] = this;
		}
		
		public function removeFromList(lists:Array):void {
			var i:int;
			var len:int;
			
			len = lists.length;
			for (i = 0; i < len; i++) {
				if (lists[i] == this) {
					lists.splice(i, 1);
				}
			}
		}
		
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
		
		public function get isFalling():Boolean {
			return _isFalling;
		}
		
		public function set isFalling(value:Boolean):void {
			_isFalling = value;
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
	}

}