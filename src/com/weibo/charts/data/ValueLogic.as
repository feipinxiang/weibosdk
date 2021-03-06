package com.weibo.charts.data
{
	import com.weibo.charts.ChartBase;
	
	/**
	 * 笛卡尔坐标系数值轴算法
	 * 取出最大值最小值
	 * 返回数值坐标的数据
	 * @author yaofei
	 */
	public class ValueLogic
	{
		private var coordinate:CoordinateLogic;
		
		private var _axisLength:Number = 0;
		private var _labelLength:Number = 20;
		
		protected var _dataProvider:Array;
		
		//数据层的最大最小值
		protected var dataMininum:Number;
		protected var dataMaxinum:Number;
		//坐标轴的最大最小值
		protected var minimum:Number;
		protected var maximum:Number;
		//单元格的单位数值
		protected var majorUnit:Number;
		//是否总显示0
//		public var alwaysShowZero:Boolean;
		//是否在坐标轴上总显示整数
//		public var integer:Boolean = false;
		
		//数据中表示Label的Key值文字，用于匹配数据
//		private var _labelKey:String;
		//数值坐标的数据，用于绘制图形
		internal var _axisData:Array;
		
		//引用核心图表对象,-----目前只用到了：coordinateLogic.axisType == "vertical"
//		private var chart:ChartBase;
		
//		private var secLogic:ValueLogic;
		
// ==========================================
// 构造函数
// ------------------------------------------
		
		public function ValueLogic(coordinate:CoordinateLogic)
		{
			this.coordinate = coordinate;
			
			super();
		}
		
// ==========================================
// 公开方法
// ------------------------------------------
		
		/**
		 * 数据中表示Label的Key值文字，用于匹配数据
		 * @param value
		 */		
//		public function set labelKey(value:String):void { this._labelKey = value; }
		
		/**
		 * 数据中表示Label的Key值文字，用于匹配数据
		 * @return 
		 */		
//		public function get labelKey():String { return this._labelKey; }
		

		public function get labelLength():Number { return _labelLength; }
		public function set labelLength(value:Number):void
		{
			_labelLength = value;
		}

		public function get axisLength():Number { return _axisLength; }
		public function set axisLength(value:Number):void
		{
			_axisLength = value;
		}

		/**
		 * 数值坐标的数据，用于绘制图形
		 * @return 
		 */		
		public function get axisData():Array { return this._axisData; }
		
		/*public function get subAxisData():Array
		{
			if (secLogic == null) return [];
			return secLogic._axisData;
		}*/
		
		/**
		 * 传入原始数据，计算主轴数据
		 * @param value
		 */		
		public function setData(min:Number, max:Number):void
		{
//			this._dataProvider = value as Array;
//			this.parseDataProvider();
			
			this.minimum = this.dataMininum = min;
			this.maximum = this.dataMaxinum = max;
			this.checkMinAndMax();
			
			var range:Number = this.maximum - this.minimum;
			/*if (true)//addMore
			{
				range *= 1.1;
				this.maximum = roundToPrecision(this.minimum + range, 10);
			}*/
			
			var maxNumLabels:Number = axisLength / (labelLength * 2.5);//暂定
			var tempMajorUnit:Number = range / maxNumLabels;
			this.calculateUnit(tempMajorUnit);
			
			
			this.adjustMin();this.adjustMax();
			this._axisData = this.calculateAxisData(true);
		}
		
		
		/**
		 * 计算副轴数据，只能用于副轴
		 * @param min
		 * @param max
		 */		
		public function setSolidData(min:Number, max:Number, length:uint):void
		{
			this.minimum = this.dataMininum = min;
			this.maximum = this.dataMaxinum = max;
			
			//返回空数据
			if (isNaN(min) || isNaN(max))
			{
				this._axisData = [];
				return;
			}
			
			checkMinAndMax();
			
			var tempMajorUnit:Number = (this.maximum - this.minimum) / (length - 2);
			
			calculateUnit(tempMajorUnit);
			
			adjustMin();
			adjustMax2(length);
//			trace(this.minimum, this.maximum, majorUnit);
//			this.maximum = roundToPrecision(minimum + majorUnit * (length - 1));
//			trace(this.maximum, this.minimum, "========>", tempMajorUnit, majorUnit)
//			if (minimum != 0) trace("=========>",majorUnit, length, "::", max, maximum, majorUnit)
			
			this._axisData = this.calculateAxisData();
			/*if (majorUnit == 0)
			{
				_axisData = [];
			}
			else
			{
				var value:Number = this.minimum;
				_axisData = [getAxisData(value)];
				for (var i:int = 1; i < length; i++)
				{
					value = roundToPrecision(value + majorUnit, 10);
					_axisData.push(getAxisData(value));
				}
			}*/
		}
		
		/**
		 * 根据数值获取坐标值
		 * @param data
		 * @return 
		 */		
		public function getPosition(value:Number):Number
		{
//			if (!data) return NaN;
			
			var range:Number = this.maximum - this.minimum;
			if(range == 0)
			{
				return 0;
			}
			
			var position:Number;
			//？？？统一坐标
			/*if (coordinateLogic.reverseAxis)
			{
				position = (value - this.minimum) / range * this.axisLength;
			}
			else
			{*/
				position = (this.maximum - value) / range * this.axisLength;
//			}
//			trace(this.minimum, this.maximum, value,position)
			return position;
		}
		
		
// ==========================================
// 私有方法
// ------------------------------------------
		
		protected function calculateUnit(tempMajorUnit:Number):void
		{
			
			var order:Number = Math.ceil(Math.log(tempMajorUnit) * Math.LOG10E);
			var roundedMajorUnit:Number = Math.pow(10, order);
			
			var diff:Number = Math.ceil(tempMajorUnit / Math.pow(10,order-1));
			if (!this.coordinate.chartStyle.integer || order > 0)
			{
				tempMajorUnit = diff * Math.pow(10,order-1);
			}
			else
			{
				tempMajorUnit = roundedMajorUnit;
			}
			
			
			this.majorUnit = roundToPrecision(tempMajorUnit, 10);
		}
		
		/**
		 * 确保数值的正确性
		 */		
		protected function checkMinAndMax():void
		{
			if (this.minimum > this.maximum)
			{
				var tempnum:Number = this.minimum;
				this.minimum = this.maximum;
				this.maximum = tempnum;
			}
			else if (this.minimum == this.maximum)
			{
				this.maximum = this.maximum + 1;
			}
			
			if (this.coordinate.chartStyle.alwaysShow0 && this.minimum > 0)
			{
				this.minimum = 0;
			}
		}
		
		/**
		 * 调整最小值到相对的整数
		 */		
		protected function adjustMin():void
		{
			if (this.minimum != 0)
			{
				var oldMinimun:Number = this.dataMininum;
				this.minimum = Math.floor(this.dataMininum / this.majorUnit) * majorUnit;
				if (oldMinimun == this.minimum)
				{
					this.minimum -= majorUnit;
				}
			}
			this.minimum = roundToPrecision(minimum, 10);
		}
		
		/**
		 * 调整最大值到相对的整数
		 */		
		protected function adjustMax():void
		{
			if (this.maximum != 0)
			{
				var oldMaximum:Number = this.dataMaxinum;
				this.maximum = Math.ceil(dataMaxinum / this.majorUnit) * majorUnit;
				if (oldMaximum == this.maximum && coordinate.chartStyle.gridStyle.addMore)
				{
					this.maximum += majorUnit;
				}
			}
			this.maximum = roundToPrecision(maximum, 10);
		}
		
		protected function adjustMax2(length:int):void
		{
			var oldMaximum:Number = this.dataMaxinum;
			this.maximum = roundToPrecision(minimum + majorUnit * (length - 1), 10);
			/*if (oldMaximum == this.maximum)
			{
				this.maximum += majorUnit;
			}*/
//			this.maximum = roundToPrecision(maximum, 10);
		}
		
		/** 计算轴数据
		 */		
		private function calculateAxisData(minlen:Boolean = false):Array
		{
			var tempUnit:Number = this.majorUnit;
			if (tempUnit == 0)
			{
				return [];
			}
			var value:Number = this.minimum;
			
			//主轴创建前的准备工作，包括：修正，最少3段
			if (minlen)
			{
				var i:int = 0;
				while (value < this.maximum || i < 3)
				{
					i++;
					value = roundToPrecision(value + tempUnit, 10);
				}
				
				//适当延长最大值
				if (coordinate.chartStyle.gridStyle.addMore && this.dataMaxinum > value - tempUnit/2)
				{
					this.maximum = roundToPrecision(value + tempUnit, 10);
				}
				//修正最大值
				else
				{
					this.maximum = value;
				}
			}
			
			//开始创建轴数据（数组）
			value = this.minimum;
			var data:Array = [getAxisData(value)];
			while (value < this.maximum)
			{
				value = roundToPrecision(value + tempUnit, 10);
				data.push(getAxisData(value));
			}
			
			return data;
		}
		
		/**
		 * 转换成轴单位数据
		 * @param value
		 * @return 
		 */		
		protected function getAxisData(value:Number):Object
		{
//			value = roundToPrecision(value, 10);
			var label:String = isNaN(value) ? "" : value.toString();
//			if (chart.valueFun != null) label = chart.valueFun(value);
			var data:Object = {
				label:		label,
				value:		value,
				position:	getPosition(value)
			}
			return data;
		}
		
		protected function roundToPrecision(number:Number, precision:int = 0):Number
		{
			var decimalPlaces:Number = Math.pow(10, precision);
			return Math.round(decimalPlaces * number) / decimalPlaces;
		}
	}
}