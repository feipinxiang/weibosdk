package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	import com.weibo.charts.events.ChartEvent;
	import com.weibo.charts.style.CoordinateChartStyle;

	/**
	 * 标签轴处理逻辑
	 * @author yaofei
	 */	
	public class LabelLogic
	{
		internal var axisLength:Number = 450;
		internal var labelLength:Number = 30;
		
		protected var _axisData:Array;
		protected var _gridData:Array;
		
		protected var coordinate:CoordinateLogic;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function LabelLogic(coordinate:CoordinateLogic)
		{
			this.coordinate = coordinate;
			super();
		}
		
// ==========================================
// 公开方法
// ------------------------------------------
		
		public function get axisData():Array { return this._axisData; }
		public function get gridData():Array { return this._gridData; }

		/**
		 * 计算标签轴数据
		 * @param data
		 */		
		public function set dataProvider(data:Array):void
		{
			var count:int = data.length;
			var unit:Number = (chartStyle.touchSide && count>1) ? axisLength/(count-1) : axisLength/count;
			_axisData = [];
			_gridData = [];
			
			//为避免文字重叠，设置的标签出现的间隔。默认为1，即：每个标签都显示。
			var quotient:int = chartStyle.axisStyle.partLength || 1;
//			coordinate.autoLabel = labelLength > unit;
//			chart.dispatchEvent(new ChartEvent(ChartEvent.CHART_LABELAXIS_SHOW, labelLength > unit, true));
			//coordinate.autoLabel 如果标签过长，而按需要分配
			if (chartStyle.axisStyle.autoHide && labelLength > unit)
				quotient = Math.max(Math.ceil(labelLength / unit), quotient);
			
			
			var i:int;
			var startI:int = (quotient + count % quotient - 1) / 2;
			var position:Number;
			for (i = 0; i < count; i++)
			{
				//获取Label文字
//				var label:String = (data[i] is String) ? data[i] :data[i][labelKey];
//				if (chart.labelFun != null) label = chart.labelFun(label);
				
				if ((i - startI) % quotient == 0)
				{
					if (chartStyle.touchSide && count>1){
						position = i/(count-1)*axisLength
					}
					else{
						position = i/count*axisLength + unit / 2;
					}
					_axisData.push({
						index:		i,
						label:		data[i],
						position:	position
					});
				}
			}
			
			for (i = 1; i < count; i++)
			{
				_gridData.push({
					position:	chartStyle.touchSide ? i/(count-1)*axisLength : i/count*axisLength
				});
			}
			
		}
		
		private function get chartStyle():CoordinateChartStyle
		{
			return coordinate.chartStyle;
		}
		
	}
}