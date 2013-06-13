package
{
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	

	public class DataList extends Sprite
	{
		private var _mask:Sprite;
		private var rowClass:Class;
		private var mc:Sprite;
		private var header:Sprite;
		private var rows:Array;
		private var _w:int;
		private var _h:int;
		private var _rowHeight:int=25;
		private var rowBg0:String;
		private var rowBg1:String;
		private var rowOver:String;
		private var rowChange:String;
		//private var scroll:ScrollBarByPhhui;
		private var align:String;
		private var isFilter:Boolean;
		public function DataList(w:int=400,h:int=300,obj:Object=null)
		{
			rows=[];
			_w=w;
			_h=h;
			if(obj){
				if(obj.rowHeight)_rowHeight=obj.rowHeight;
				if(obj.rowBga)rowBg0=obj.rowBga;
				if(obj.rowBgb)rowBg1=obj.rowBgb;
				if(obj.rowOver)rowOver=obj.rowOver;
				if(obj.rowChange)rowChange=obj.rowChange;
				if(obj.align)align=obj.align;
				if(obj.isFilter)isFilter = obj.isFilter;
			}
			_mask=new Sprite();
			mc=new Sprite();
			//scroll=new ScrollBarByPhhui();
			//createMask();
			//mc.mask=_mask;
		}
		public function bindData(data:Array,cl:Object,columnW:Array=null,param:Object=null):void{
			trace("0");
			clear();
			trace("1");
			if(!param)param={};
			param.align=align;
			trace("2");
			rowClass=Class(cl);
			var n:int=data.length;
			if(n<1)return;
			trace("a");
			for(var i:int=0;i<n;i++){
				rows[i]=new rowClass(_w,_rowHeight);
				rows[i].createStyle(i%2==0?rowBg0:rowBg1,rowOver,rowChange,isFilter);
				var m:int=data[0].length;
				var w:Array=columnW?columnW:getWidth(data[0]);
				for(var j:int=0;j<m;j++){
					rows[i].addColumn(data[i][j],w,param);
				}
				rows[i].name=data[i].toString();
				rows[i].y=i*_rowHeight;
				rows[i].buttonMode=true;
				//if(data[i].toString().search("<a href=")==-1){//如果参数中有超连接则不添加行点击监听
					rows[i].addEventListener(MouseEvent.CLICK,rowHandler);
				//}else{
					rows[i].addEventListener(EventInteraction.DISPATCH_DATA , columnClick);
				//}
				mc.addChild(rows[i]);
			}
			trace("b");
			rows[0].setChange();
			this.addChild(mc);
			this.addChild(_mask);
			//this.addChild(scroll);
			trace("c");
			//scroll.x=_w+35;
			//scroll.y=15;
			////scroll.bindObj(mc,{mask:_mask,type:1,height:_h});
			//scroll.update();
			trace("d");
		}
		private function rowHandler(e:MouseEvent):void{
			clearChange();
			if(!e.target.hasOwnProperty("setChange"))return;
			e.target.setChange();
			dispatchEvent(new EventInteraction("rowsClick",e.target.name ));
		}
		private function columnClick(e:EventInteraction):void{
			dispatchEvent(new EventInteraction("textClick",e.GetData));
		}
		private function getWidth(data:Array):Array{
			var n:int=data.length;
			var arr:Array=[];
			var res:int=0;
			for(var i:int=0;i<n;i++){
				arr.push(res);
				res+=data[i].toString().length*20+20;
			}
			return arr;
		}
		public function addRow():void{
			
		}
		public function removeRow():void{
			
		}
		public function clear():void{
			while(mc.numChildren>0){
				mc.removeChildAt(0);
			}
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			rows=[];
		}
		private function createMask():void{
			_mask.graphics.beginFill(0x000000);
			_mask.graphics.drawRect(-20,0,_w+50,_h);
			this.addChild(_mask);
		}
		private function clearChange():void{
			var n:int=rows.length;
			for(var i:int=0;i<n;i++){
				rows[i].removeChange();
			}
		}
	}
}