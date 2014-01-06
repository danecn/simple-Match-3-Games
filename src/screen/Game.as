package screen {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import objects.Bola;
	
	public final class Game extends Sprite {	
		private const boardHeight:int = 20;
		private const boardWidth:int = 10;
		
		private var boards:Array = new Array(boardWidth);
		private var bolas:Array = [];
		private var bolaLinkeds:Array = [];
		private var bolaCurrent:Bola;
		private var overlay:Bitmap;
		
		private var mouseIsDown:Boolean = false;
		
		public function Game() {
			init();
		}
		
		private function init():void {
			initBoard();
			updateBolaVisibility();
			addEventListener(MouseEvent.MOUSE_UP, mouseUp, false, 0, true);
			overlay = new Bitmap(new BitmapData(240, 340, true, 66000000));
			overlay.visible = false;
			addChild(overlay);
		}
		
		private function mouseUp(e:MouseEvent):void {
			var i:int;
			var j:int;
			var len:int;
			var bola:Bola;
			var bolaTurun:Bola;
			var k:int;
			
			trace('mouse Up, linkeds length: ' + bolaLinkeds.length);
			
			if (bolaLinkeds.length > 0) {
				//jadi
				for (i = 0; i < boardWidth; i++) {
					for (j = 0; j < boardHeight; j++) {
						bola = boards[i][j];
						if (bola.linked) {
							trace('bola jadi: ' + i + '/' + j);
							bola.jadi = true;
						}
					}
				}
			}
			
			//hapus bola jadi
			for (i = 0; i < boardWidth; i++) {
				for (j = 0; j < boardHeight; j++) {
					bola = boards[i][j];
					if (bola.jadi) {
						removeChild(bola);
						boards[i][j] = null;
						trace('hapus bola, pos: ' + i + '/' + j);
					}
				}
			}
			
			//turunin
			//cara cepat
			trace('turunin bola kosong');
			for (i = 0; i < boardWidth; i++) {
				for (j = 0; j < boardHeight; j++) {
					bola = boards[i][j];
					if (bola == null) {
						for (k = j; k > 0; k--) {
							if (k > 0) {
								boards[i][k] = boards[i][k - 1];
								bola = boards[i][k];
								if (bola) {
									bola.y = k * Bola.height - 160;
								}
							} else {
								boards[i][k] = null;
							}
						}
					}
				}
			}
			
			trace('buat bola baru di tempat kosong');
			for (i = 0; i < boardWidth; i++) {
				for (j = 0; j < boardHeight; j++) {
					bola = boards[i][j];
					if (bola == null) {
						trace('bola kosong pada pos: ' + i + '/' + j);
						bola = bolaCreate();
						bola.x = i * Bola.width;
						bola.y = j * Bola.height - 160;
						boards[i][j] = bola;
						addChild(bola);
					}
				}
			}
			
			updateBolaVisibility();
			bolaCurrent = null;
			bolaLinkeds = [];
		}
		
		private function clearBoard():void {
			var i:int;
			var j:int;
			
			for (i = 0; i < boardWidth; i++) {
				for (j = 0; j < boardHeight; j++) {
					boards[i][j] = null;
				}
			}
		}
		
		private function bolaCreate():Bola {
			var warna:int;
			var bola:Bola;
			
			warna = Math.floor(Math.random() * 3);
			
			if (warna == 0) {
				bola = new Bola(Bola.WR_MERAH);
			}
			
			if (warna == 1) {
				bola = new Bola(Bola.WR_BIRU);
			}
			
			if (warna == 2) {
				bola = new Bola(Bola.WR_HIJAU);
			}
			
			var tempBola:Bola = bola;
			bola = null;
			return tempBola;
		}
		
		private function bolaUnLink(bola:Bola):void {
			var idx:int=-1;
			var i:int;
			var bolaIdx:Bola;
			
			trace('unlink bola');
			
			for (i = 0; i < bolaLinkeds.length; i++) {
				if (bolaLinkeds[i] == bola) {
					idx = i + 1;
				}
			}
			
			if (idx > -1) {
				for (i = idx; i < bolaLinkeds.length; i++) {
					bolaIdx = bolaLinkeds[i];
					bolaIdx.linked = false;
				}
				bolaLinkeds.splice(idx, int.MAX_VALUE);
			}
		}
		
		private function bolaCocok(bola:Bola):Boolean {
			trace('test bola cocok:');
			trace('current color ' + bolaCurrent.color);
			trace('bola color ' + bola.color);
			
			if (bola.color != bolaCurrent.color) return false;
			
			if (bolaSebelah(bola)) {
				trace('return true');
				return true;
			}
			return false;
		}
		
		private function bolaSebelah(bola:Bola):Boolean {
			var i:int;
			var len:int;
			var dx:int;
			var dy:int;
			var bolaLk:Bola;
			
			trace('test bola sebelah: ');
			
			len = bolaLinkeds.length;
			for (i = 0; i < len; i++) {
				bolaLk = bolaLinkeds[i];
				dx = Math.abs(bola.x - bolaLk.x);
				dy = Math.abs(bola.y - bolaLk.y);
				
				if ((dx <= Bola.width) && (dy <= bola.height)) {
					return true;
					trace('bola sebelah return true');
				}
			}
			
			trace('return false');
			return false;
		}
		
		private function bolaLinkAdd(bola:Bola):void {
			bolaCurrent = bola;
			bola.linked = true;
			bolaLinkeds.push(bola);
		}
		
		private function bolaMouseDown(e:MouseEvent):void {
			var bola:Bola;
			
			e.stopPropagation();
			bola = e.currentTarget as Bola;
			
			if (bolaCurrent == null) {
				trace('bola mouse down: ' + bola.x + '/' + bola.y);
				bolaLinkAdd(bola);
			}
		}
		
		private function bolaMouseOver(e:MouseEvent):void {
			var bola:Bola;
			
			if (bolaCurrent == null) return;
			
			trace('bola mouseover');
			bola = e.currentTarget as Bola;
			trace('bola color ' + bola.color);
			
			if (bola.linked) {
				bolaUnLink(bola);
			} else {
				if (bolaCocok(bola)) {
					bolaLinkAdd(bola);
				}
			}
			
		}
		
		private function initBoard():void {
			var i:int;
			var j:int;
			var warna:int = 0;
			var bola:Bola;
			
			for (i = 0; i < boardWidth; i++) {
				boards[i] = new Array(boardHeight);
				for (j = 0; j < boardHeight; j++) {
					bola = bolaCreate();
					bola.x = i * Bola.width;
					bola.y = j * Bola.height - 160;
					bola.addEventListener(MouseEvent.MOUSE_DOWN, bolaMouseDown, false, 0, true);
					bola.addEventListener(MouseEvent.MOUSE_OVER, bolaMouseOver, false, 0, true);
					boards[i][j] = bola;
					addChild(bola);
				}
			}
		}
		
		private function updateBolaVisibility():void {
			var i:int;
			var j:int;
			var bola:Bola;
			
			for (i = 0; i < boardWidth; i++) {
				for (j = 0; j < boardHeight; j++) {
					bola = boards[i][j];
					if (bola) {
						if (j >= 10) {
							bola.visible = true;
						} else {
							bola.visible = false;
						}			
					}
				}
			}
		}
		
	}

}