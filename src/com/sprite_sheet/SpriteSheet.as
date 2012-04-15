package com.sprite_sheet
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	//
	// AnimPack holds a single texture tile sheet, and can have 
	// multiple animation sequneces in it.
	//
	public class SpriteSheet
	{
		private var mTextureSheet:BitmapData;

		public function init(sheet:BitmapData):void
		{
			mTextureSheet= sheet;
		}
		
		public function getSpriteSheetFrameByRect(rect: Rectangle): SpriteSheetFrame
		{
			var bmp: Bitmap = new Bitmap(mTextureSheet);
			bmp.scrollRect = rect;
			
			var ssbmp: SpriteSheetFrame = new SpriteSheetFrame(bmp, rect.width, rect.height);
			
			return ssbmp;
		}
		
		public function getBitmapByRect(rect: Rectangle): Bitmap
		{
			var bmp: Bitmap = new Bitmap(mTextureSheet);
			bmp.scrollRect = rect;
			
			return bmp;
		}
	}
}