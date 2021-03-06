package com.weibo.charts.style
{
	import flash.text.TextFormat;

	/**
	 * 
	 * yaofei
	 */
	public class AxisStyle
	{
		public var type:String = "normal";
		
		//===== 标签轴部分 =====
		public var labelFun:Function;
		public var labelFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		public var autoHide:Boolean = false;
		public var partLength:uint = 1;//间隔单位（个）
		
		
		//===== 数值轴部分 =====
		public var showValueUnit:Boolean = true;
		
		public var valueFun:Function;
		public var valueFormat:TextFormat = new TextFormat("Arial", 12, 0x999999, false);
		
		
		public var valueLineColor:uint = 0xe7e7e7;
		public var valueLineThickness:Number = 1;
		
		
		public var marginLeft:Number = 3;
		public var marginRight:Number = 3;
		public var marginBottom:Number = 3;
	}
}