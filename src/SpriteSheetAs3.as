package
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	
	import com.sprite_sheet.AnimSpriteSheet;
	import com.sprite_sheet.SpriteSheetFrame;
	import com.sprite_sheet.TextureCache;
	import com.sprite_sheet.SpriteFrameCache;
	import com.tiled.TMXTiledMap;
	import utils.Stats;
	import utils.loading.BigLoader;
	import utils.loading.BigLoadItem;
	
	//[SWF (width="750", height="600")]
	public class SpriteSheetAs3 extends Sprite
	{
		private var _loader:BigLoader;	
		private var mMap: TMXTiledMap;
		
		public function SpriteSheetAs3()
		{
			addEventListener(Event.ADDED_TO_STAGE, onAdded);
		}
		
		protected function onAdded(event:Event):void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.frameRate= 60;
			
			var appWidth:Number= 750;
			graphics.beginFill(0x434E8E);
			graphics.drawRect(0,0, appWidth, 24);
			graphics.endFill();
			
			graphics.beginFill(0xf0f0f0);
			graphics.drawRect(0,24, appWidth, 600);
			graphics.endFill();
			
			var st:DisplayObject= new Stats();
			st.y= 20;
			addChild(st);
			
			// load resources
			_loader= new BigLoader();
			
			_loader.add("data/untitled.tmx", "untitled.tmx", 1, BigLoadItem.DATA);
			
			_loader.add("data/terrain0.png", "terrain0.png");
			_loader.add("data/terrain0.plist", "terrain0.plist", 1, BigLoadItem.DATA);
			
			_loader.add("data/Clown_Normal.png", "Clown_Normal.png");
			_loader.add("data/Clown_Normal.plist", "Clown_Normal.plist", 1, BigLoadItem.DATA);
			
			//			_loader.add("data/remiWalk.json", "sheetData");
			//			_loader.add("data/remiWalk.png", "sheet");
			
			_loader.addEventListener(Event.COMPLETE, onAnimLoaded);
			_loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadFailed);
			_loader.start();
		}
		
		private static const NUM_H:int = 6;
		
		protected function onAnimLoaded(event:Event):void
		{
			SpriteFrameCache.Singleton().SetLoader(_loader);
			SpriteFrameCache.Singleton().AddSpriteFrames("terrain0.plist");
			SpriteFrameCache.Singleton().AddSpriteFrames("Clown_Normal.plist");
			
			TextureCache.Singleton().SetLoader(_loader);
			//SpriteSheetManager.Singleton().addSpriteSheet("sheet.png");
			TextureCache.Singleton().addSpriteSheet("terrain0.png");
			TextureCache.Singleton().addSpriteSheet("Clown_Normal.png");
			
			mMap = new TMXTiledMap(_loader);
			mMap.Init("untitled.tmx");
			
			addChild(mMap);
			
			var row:int = 0;
			for (var i:int = 0; i < 24; i++) 	{
				
				var anim: AnimSpriteSheet = createAnim();
				addChild(anim);
				
				anim.mFps = 2 * (i + 1);
				
				row = int(i/NUM_H);
				anim.x= 20 + 100*(i%NUM_H) + row*36; 
				anim.y= 150 + row*60;
			}
		}
		
		protected function createAnim(): AnimSpriteSheet
		{
			var bmps: Array = new Array();
			for(var i:int = 0; i < 10; i++)
			{
				var bmp:SpriteSheetFrame = SpriteFrameCache.Singleton().CreateSpriteSheetFrame("Clown_Normal0" + i + ".png");
				bmps.push(bmp);
			}
			
			for(i = 10; i < 23; i++)
			{
				bmp = SpriteFrameCache.Singleton().CreateSpriteSheetFrame("Clown_Normal" + i + ".png");
				bmps.push(bmp);
			}
			
			var anim: AnimSpriteSheet = new AnimSpriteSheet(bmps);
			anim.mFps = 30;
			
			anim.EnableShow(true);
			anim.EnablePlay(true);
			
			return anim;
		}
		
		
		protected function onLoadFailed(event:IOErrorEvent):void
		{
			trace("Cannot find file!");
			trace(event.text);
		}
	}
}