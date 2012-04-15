package com.tiled
{
	import flash.display.Sprite;
	
	public class TMXLayer extends Sprite
	{
		protected var mInfo: TMXLayerInfo;
		protected var mMap: TMXTiledMap;
		
		protected var mTiles: Array = new Array();
		public function TMXLayer(map: TMXTiledMap, info: TMXLayerInfo)
		{
			mInfo = info;
			mMap = map;
		}
		
		public function Init(): void
		{
			for(var tileId: int = 0; tileId < mInfo.mHeight * mInfo.mWidth; tileId++)
			{
				var tileX: int = tileId % mInfo.mWidth;
				var tileY: int = tileId / mInfo.mWidth;
				var tileGid:int = mInfo.GetTileGid(tileId);
				var realTileGid: int = TMXTiledMap.converToRealGid(tileGid);
				var tti: TMXTileTransformInfo = TMXTiledMap.getTileTransformInfoByGid(tileGid);
				
				var tile: TMXTile = mMap.CreateTileByGid(realTileGid);
				if(tile != null)
				{
					tile.SetGid(tileGid);
					tile.x = tileX * mMap.GetInfo().mTileWidth;
					tile.y = tileY * mMap.GetInfo().mTileHeight;
					tile.rotation = tti.rotation;
					tile.x += tti.tx * mMap.GetInfo().mTileWidth;
					tile.y += tti.ty * mMap.GetInfo().mTileHeight;
					addChild(tile);
				}
				
				mTiles.push(tile);
			}
		}
		
		public function GetInfo(): TMXLayerInfo
		{
			return mInfo;
		}
		
		public function GetTile(tx: int, ty: int): TMXTile
		{
			var tileId: int = tx + ty * mInfo.mWidth;
			if(tileId >= mTiles.length)
			{
				return null;
			}
			return mTiles[tileId];
		}
		
		public function RemoveTile(tx: int, ty: int): Boolean
		{
			var tileId: int = tx + ty * mInfo.mWidth;
			if(tileId >= mTiles.length)
			{
				return false;
			}
			
			var tile: TMXTile = mTiles[tileId];
			if(tile != null	)
			{
				removeChild(tile);
				mTiles[tileId] = null;
				mInfo.mTiles[tileId] = 0;
			}
			return true;
		}
		
		public function tileGIDAt(x: int, y: int): int
		{
			var idx: int = x + y * mInfo.mWidth;
			if(idx >= mTiles.length)
			{
				return -1;
			}
			var tile: TMXTile = mTiles[idx];
			if(tile == null)
			{
				return 0;
			}
			
			return tile.GetGid();
		}
	}
}