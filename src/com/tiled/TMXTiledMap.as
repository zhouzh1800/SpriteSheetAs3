package com.tiled
{
	import com.sprite_sheet.SpriteSheet;
	import com.sprite_sheet.TextureCache;
	
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import utils.loading.BigLoader;
	
	public class TMXTiledMap extends Sprite
	{
		public static var FlippedHorizontallyFlag:int   = 0x80000000;
		public static var FlippedVerticallyFlag:int     = 0x40000000;
		public static var FlippedAntiDiagonallyFlag:int = 0x20000000;
		
		protected var mLoader: BigLoader;
		protected var mMapInfo: TMXTiledMapInfo = new TMXTiledMapInfo();
		
		protected var mTilesets: Array = new Array();
		protected var mLayers: Array = new Array();
		
		public function TMXTiledMap(loader: BigLoader)
		{
			mLoader = loader;
		}
		
		public function Init(fileName:String): void
		{
			var xmlConfig:XML = XML(mLoader.getLoadedAssetById(fileName));
			mMapInfo.Init(xmlConfig);
			
			for(var i: int = 0; i < mMapInfo.mTilesets.length; i++)
			{
				var spriteSheet: SpriteSheet = TextureCache.Singleton().getSpriteSheet(mMapInfo.mTilesets[i].mImageSource);
				if(spriteSheet == null)
				{
					trace("find sprite sheet failed: " + mMapInfo.mTilesets[i].mImageSource);
				}
				else
				{
					var tileset: TMXTileset = new TMXTileset(spriteSheet, mMapInfo.mTilesets[i]);
					mTilesets.push(tileset);
				}
			}
			
			for(i = 0; i < mMapInfo.mLayers.length; i++)
			{
				var layer: TMXLayer = new TMXLayer(this, mMapInfo.mLayers[i]);
				layer.Init();
				mLayers.push(layer);
				addChild(layer);
			}
		}
		
		
		public function GetInfo(): TMXTiledMapInfo
		{
			return mMapInfo;
		}
		
		public function CreateTileByGid(gid: int): TMXTile
		{
			for(var i: int = 0; i < mTilesets.length; i++)
			{
				var tileset: TMXTileset = mTilesets[i];
				var tile: TMXTile = tileset.CreateTileByGid(gid);
				if(tile != null)
				{
					return tile;
				}
			}
			
			return null;
		}
		
		public function propertiesForGID(gid: int): Dictionary
		{
			for(var i: int = 0; i < mTilesets.length; i++)
			{
				var tileset: TMXTileset = mTilesets[i];
				var properties: Dictionary = tileset.GetTilePropertiesByGid(gid);
				if(properties != null)
				{
					return properties;
				}
			}
			
			return null;
		}
		
		public function GetLayers(): Array
		{
			return mLayers;
		}
		
		public function layerNamed(name: String): TMXLayer
		{
			for(var i: int = 0; i < mLayers.length; i++)
			{
				var layer: TMXLayer = mLayers[i];
				if(layer.GetInfo().mName == name)
				{
					return layer;
				}
			}
			return null;
		}
		
		public static function isFlippedAntiDiagonally(gid:int): Boolean
		{
			return (gid & FlippedAntiDiagonallyFlag) != 0;
		}
		
		public static function isFlippedHorizontally(gid:int): Boolean
		{
			return (gid & FlippedHorizontallyFlag) != 0;
		}
		
		public static function isFlippedVertically(gid:int): Boolean
		{
			return (gid & FlippedVerticallyFlag) != 0;
		}
		
		public static function converToRealGid(gid:int): int
		{
			return gid & ~(FlippedHorizontallyFlag | FlippedVerticallyFlag | FlippedAntiDiagonallyFlag);
		}
		
		public static function getTileTransformInfoByGid(gid: int): TMXTileTransformInfo
		{
			return getTileTransformInfo(isFlippedAntiDiagonally(gid), isFlippedHorizontally(gid), isFlippedVertically(gid));
		}
		
		public static function getTileTransformInfo(flippedAntiDiagonally: Boolean, flippedHorizontally: Boolean, flippedVertically: Boolean): TMXTileTransformInfo
		{
			var tti: TMXTileTransformInfo = new TMXTileTransformInfo();
			tti.isFlipX = false;
			tti.rotation = 0;
			
			if(flippedAntiDiagonally)
			{
				if(flippedHorizontally)
				{
					if(flippedVertically)
					{
						tti.isFlipX = true;
						tti.rotation = 90;
						tti.tx = 1;
					}
					else
					{
						tti.rotation = 90;
						tti.tx = 1;
					}
				}
				else
				{
					if(flippedVertically)
					{
						tti.rotation = -90;
						tti.ty = 1;
					}
					else
					{
						tti.isFlipX = true;
						tti.rotation = -90;
						tti.ty = 1;
					}
				}
			}
			else
			{
				if(flippedHorizontally)
				{
					if(flippedVertically)
					{
						tti.rotation = 180;
						tti.tx = 1;
						tti.ty = 1;
					}
					else
					{
						tti.isFlipX = true;
					}
				}
				else
				{
					if(flippedVertically)
					{
						tti.isFlipX = true;
						tti.rotation = 180;
						tti.tx = 1;
						tti.ty = 1;
					}
					else
					{
						
					}
				}
			}
			
			return tti;
		}
	}
}