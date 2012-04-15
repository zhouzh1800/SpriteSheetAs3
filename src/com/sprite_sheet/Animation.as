package com.sprite_sheet
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.utils.getTimer;
	import flash.geom.Matrix;
	
	public class Animation extends Sprite
	{
		public var mType: int;
		
		public var mFps: int;
		public var mWidth: int;
		public var mHeight: int;
		public var mLoopMode: int;
		public var mFrameCount: int;
		public var mIsPlay: Boolean;
		
		protected var mStartTime: int;
		protected var mSumTime: int;
		protected var mFrameIndex: int;
		
		protected var mPreTime: int;
		
		protected var mIsEnable: Boolean;
		
		public function Animation(): void
		{
			EnableUpdate(true);
		}
		
		private function enterFrameHandler(e:Event):void{
			var nowTime:int = getTimer();
			var elapseTime:int = nowTime - mPreTime;
			mPreTime = nowTime;
			
			RealEnterFrameHandler(e, elapseTime);
		}
		
		public function Init(): void 
		{
			var myMatrix:Matrix = new Matrix();
			myMatrix.translate(-mWidth / 2, -mHeight / 2);
			transform.matrix = myMatrix;
			DoInit();
		}
		
		public function DoInit(): void
		{
			
		}
		
		public function EnablePlay(isEnable:Boolean): void
		{
			mIsPlay = isEnable;
		}
		
		public function IsPlay(): Boolean
		{
			return mIsPlay;
		}
		
		public function EnableUpdate(isEnable:Boolean): void
		{
			//			if(isEnable)
			//			{
			//				stage.addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//			}
			//			else
			//			{
			//				stage.removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			//			}
			
			if(isEnable)
			{
				addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
			else
			{
				removeEventListener(Event.ENTER_FRAME, enterFrameHandler);
			}
		}
		
		public function IsUpdate(isEnable:Boolean): void
		{
			
		}
		
		public function EnableShow(isEnable:Boolean): void{}
		public function IsShow(): Boolean{ return false; }
		
		public function RealEnterFrameHandler(e:Event, elapseTime:int): void{}
		public function SetFrame(frameIndex:int): void{}
	}
	
}