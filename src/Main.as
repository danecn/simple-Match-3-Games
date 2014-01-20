/*
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * 
 * */

package {
	import flash.display.Sprite;
	import flash.events.Event;
	import objects.Bola;
	import screen.Game;

	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite {
	
		private var game:Game;
		
		public function Main():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function gameClose():void {
			if (game) {
				removeChild(game);
				game = null;
			}
		}
		
		private function gameOpen():void {
			gameClose();
			game = new Game();
			addChild(game);
		}
		
		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			gameOpen();
		}
	}

}