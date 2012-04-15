package com.sprite_sheet
{
	import flash.display.Sprite;
	import flash.display.Bitmap;
	
	public class SpriteSheetFrame extends Sprite 
	{
		protected var mWidth: int;
		protected var mHeight: int;
		protected var mBitmap: Bitmap;
		
		public function SpriteSheetFrame(bmp: Bitmap, width: int, height: int)
		{
			mWidth = width;
			mHeight = height;
			
			mBitmap = bmp;
			addChild(mBitmap);
		}
		
		public function getWidth(): int
		{
			return mWidth;
		}
		
		public function getHeight(): int
		{
			return mHeight;
		}
	}
}
