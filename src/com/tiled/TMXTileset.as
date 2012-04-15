package com.tiled
{
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import com.sprite_sheet.SpriteSheet;
	import com.sprite_sheet.SpriteSheetFrame;
	
	public class TMXTileset
	{
		protected var mInfo: TMXTilesetInfo;
		protected var mSpriteSheet: SpriteSheet;
		protected var mTileWidthNum: int;
		protected var mTileHeightNum: int;
		protected var mTileTotalNum: int;
		
		public function TMXTileset(spriteSheet: SpriteSheet, info: TMXTilesetInfo)
		{
			mInfo = info;
			mSpriteSheet = spriteSheet;
			mTileWidthNum = (mInfo.mImageWidth - 2 * mInfo.mMargin + mInfo.mSpacing) / (mInfo.mTileWidth + mInfo.mSpacing);
			mTileHeightNum = (mInfo.mImageHeight - 2 * mInfo.mMargin + mInfo.mSpacing) / (mInfo.mTileHeight + mInfo.mSpacing);
			mTileTotalNum = mTileWidthNum * mTileHeightNum;
		}
		
		public function CreateTileByGid(gid: int): TMXTile
		{
			var tileId: int = gid - mInfo.mFirstGid;
			if(tileId >= 0 && tileId < mTileTotalNum)
			{
				var frameTileX: int = tileId % mTileWidthNum;
				var frameTileY: int = tileId / mTileWidthNum;
				var frameX: int = frameTileX * (mInfo.mTileWidth + mInfo.mSpacing) + mInfo.mMargin;
				var frameY: int = frameTileY * (mInfo.mTileHeight + mInfo.mSpacing) + mInfo.mMargin;
				var rect: Rectangle = new Rectangle(frameX, frameY, mInfo.mTileWidth, mInfo.mTileHeight);
				var spriteSheetFrame:SpriteSheetFrame = mSpriteSheet.getSpriteSheetFrameByRect(rect);
				
				var tile: TMXTile = new TMXTile(gid, spriteSheetFrame);
				
				return tile;
			}
			
			return null;
		}
		
		public function GetTilePropertiesByGid(gid: int): Dictionary
		{
			var tileId: int = gid - mInfo.mFirstGid;
			if(tileId >= 0 && tileId < mTileTotalNum)
			{
				return mInfo.mTileMap[tileId];
			}
			return null;
		}
	}
}