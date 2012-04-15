package com.tiled
{	
	import com.sprite_sheet.SpriteSheetFrame;
	
	import flash.display.Sprite;
	
	public class TMXTile extends Sprite
	{
		protected var mGid: int;
		protected var mSpriteSheetFrame: SpriteSheetFrame;
		public function TMXTile(gid: int, spriteSheetFrame: SpriteSheetFrame)
		{
			mGid = gid;
			mSpriteSheetFrame = spriteSheetFrame;
			Init();
		}
		
		public function Init(): void
		{
			addChild(mSpriteSheetFrame);
		}
		
		public function GetGid(): int
		{
			return mGid;
		}
		
		public function SetGid(gid: int): void
		{
			mGid = gid;
		}
	}
}