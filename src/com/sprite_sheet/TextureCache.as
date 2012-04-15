package com.sprite_sheet
{
	import utils.json.JSON;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.utils.Dictionary;
	
	import utils.loading.BigLoader;
	
	public class TextureCache
	{
		public static var mSingleton: TextureCache;
		
		public static function Singleton(): TextureCache
		{
			if(mSingleton == null)
			{
				mSingleton = new TextureCache();
			}
			
			return mSingleton;
		}
		private var mLoader: BigLoader;
		private var mSpriteSheetMap: Dictionary = new Dictionary();
		
		public function SetLoader(loader: BigLoader): void
		{
			mLoader = loader;
		}

		public function addSpriteSheet(texName:String): Boolean
		{
			if(mSpriteSheetMap[texName] != null)
			{
				return false;
			}
			
			var bmp: Bitmap = mLoader.getLoadedAssetById(texName);
			if(bmp == null)
			{
				return false;
			}
			var texture: BitmapData = bmp.bitmapData;
			
			var tileSheet:SpriteSheet= new SpriteSheet();
			tileSheet.init(texture);
			mSpriteSheetMap[texName] = tileSheet;

			return true;
		}	

		public function getSpriteSheet(name: String): SpriteSheet
		{
			return mSpriteSheetMap[name];
		}

	}
}