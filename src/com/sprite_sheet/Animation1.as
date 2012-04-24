package com.sprite_sheet
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.geom.Rectangle;
	public class Animation1 extends Animation {
		public var mBmp: Bitmap;
		public var mScrollRect: Rectangle = new Rectangle();
		
		public function Animation0(): void
		{
		}
		
		override public function DoInit(): void
		{
			addChild(mBmp);
			mBmp.visible = false;
		}
		
		override public function EnableShow(isEnable:Boolean): void
		{
			mBmp.visible = isEnable;
		}
		
		override public function IsShow(): Boolean
		{
			return mBmp.visible;
		}
		
		override public function RealEnterFrameHandler(e:Event, newFrameIndex: int): void
		{
			if(mIsPlay)
			{
				if(newFrameIndex != mFrameIndex)
				{
					SetFrame(mFrameIndex);
				}
			}
		}
		
		
		override public function SetFrame(frameIndex:int): void
		{
			var cols: int = mBmp.width / mWidth;
			var rows: int = mBmp.height / mHeight;
			
			mFrameIndex = frameIndex;
			
			var numRow:int = mFrameIndex / cols;
			var numCol:int = mFrameIndex % cols;
			
			mScrollRect.x = numCol * mWidth;
			mScrollRect.y = numRow * mHeight;
			mScrollRect.width = mWidth;
			mScrollRect.height = mHeight;
			
			mBmp.scrollRect = mScrollRect;
		}
	}
}