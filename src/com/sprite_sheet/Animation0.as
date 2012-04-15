package com.sprite_sheet
{
	import flash.events.Event;
	import flash.display.Bitmap;
	
	public class Animation0 extends Animation {
		public var mBmps: Array = new Array();
		
		public function Animation0(): void
		{
		}
		
		override public function DoInit(): void
		{
			SetFrame(0);
			EnableShow(false);
		}
		
		override public function EnableShow(isEnable:Boolean): void
		{
			for each(var i in mBmps)
			{
				i.visible = isEnable;
			}
		}
		
		override public function IsShow(): Boolean
		{
			for each(var i in mBmps)
			{
				return i.visible;
			}
			
			return false;
		}
		
		override public function RealEnterFrameHandler(e:Event, elapseTime:int): void
		{
			if(mIsPlay)
			{
				var speed: Number = 1000 / mFps;
				mSumTime += elapseTime;
				var newFrameIndex:int = mSumTime / speed + 0.5;
				newFrameIndex %= mBmps.length;
			
				if(newFrameIndex != mFrameIndex)
				{
					SetFrame(newFrameIndex);
				}
			}
		}
		
		override public function SetFrame(frameIndex:int): void
		{
			if(numChildren != 0)
			{
				removeChild(mBmps[mFrameIndex]);
			}
			
			mFrameIndex = frameIndex;
			addChild(mBmps[mFrameIndex]);
		}
	}
}