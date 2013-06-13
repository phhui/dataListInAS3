package
{
	
	
	import fl.controls.TextArea;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	public class dataRow extends Sprite
	{
		private var column:Array;
		private var columnWidth:int=20;
		private var rowOver:Sprite=new Sprite();
		private var rowBg:Sprite=new Sprite();
		private var rowChange:Sprite=new Sprite();
		private var _load:LoadObj=new LoadObj();
		private var index:int;
		private var _isFilter:Boolean =false;
		
		public function dataRow(w:int,h:int)
		{
			column=new Array();
			this.addChild(rowBg);
			this.addChild(rowOver);
			this.addChild(rowChange);
			rowBg.mouseEnabled=false;
			rowBg.mouseChildren=false;
			rowOver.mouseEnabled=false;
			rowOver.mouseChildren=false;
			rowBg.mouseEnabled=false;
			rowChange.mouseEnabled=false;
			rowChange.mouseChildren=false;
			//createBg(w,h);
			rowOver.mouseChildren=false;
			rowOver.mouseEnabled=false;
			//this.addEventListener(MouseEvent.CLICK,setChange);
			this.addEventListener(MouseEvent.ROLL_OVER,overHandler);
			this.addEventListener(MouseEvent.ROLL_OUT,outHandler);
		}
		
		/**
		 * paramObj-object参数
		 * 需要设置描边hasFilter:"true"
		 * hideCols:[0,[1,2,3]] 表示如果第0列，有出现值=1=2=3 的时候隐藏TEXT="";
		 * 
		 * */
		public function addColumn(param:*,widthArr:Array,paramObj:Object=null):void{
			if(param!=0&&!param)return;
			var i:int=column.length;
			index=i;
			if(param is DisplayObject){
				column[i]=new Sprite();
				column[i].name="column"+i.toString();
				column[i].y=0;
				column[i].addChild(param);
				column[i].x=i>0?column[i-1].width+columnWidth:0;
				this.addChild(column[i]);
			}else{
				column[i]=new TextField();
				trace("aa");
				column[i].autoSize=TextFieldAutoSize.CENTER;
				trace("ab");
				column[i].name="column"+i.toString();
				column[i].textColor=0xffffff;
				column[i].htmlText=param;
				if(paramObj && paramObj.hasFilter ||_isFilter){
					setTextFilters(column[i]);
				}
				column[i].autoSize=paramObj.align;
				if(paramObj && paramObj.hideCols && i==paramObj.hideCols[0]){
					for(var j:int=0;j<paramObj.hideCols[1].length;j++){
						if(int(column[i].text)== int(paramObj.hideCols[1][j])){
							column[i].text="";
						}
					}
				}
				
				column[i].y=rowBg.height>0?rowBg.height/2-column[i].height/2:5;
				if(widthArr[i+1]){
					column[i].x=int(widthArr[i])+(int(widthArr[i+1])-int(widthArr[i])-column[i].textWidth)/2;
					if(param&&paramObj.align=="left")column[i].x=int(widthArr[i]);
				}else{
					column[i].x=int(widthArr[i]);
				}
				this.addChild(column[i]);
				if(param.toString().search("<a href=")>-1){//如果文本中包含超连接则添加点击监听
					column[i].addEventListener(TextEvent.LINK,textClick);
				}else{
					column[i].mouseEnabled=false;
				}
			}
		}
		private function textClick(e:TextEvent):void{
			dispatchEvent(new EventInteraction("textClick",e.text));
		}
		public function removeColumn(i:int):void{
			this.removeChild(column[i]);
			column.splice(i,1);
		}
		public function clear():void{
			while(this.numChildren>0){
				this.removeChildAt(0);
			}
			column=[];
		}
		private function overHandler(e:MouseEvent):void{
			rowOver.alpha=1;
		}
		private function outHandler(e:MouseEvent):void{
			rowOver.alpha=0;
		}
		private function createBg(w:int,h:int):void{
			rowOver.graphics.beginFill(0xffffff);
			rowOver.graphics.drawRect(0,0,w,h);
			this.addChild(rowOver);
			rowOver.alpha=0;
		}
		public function createStyle(bg:String=null,overbg:String=null,changebg:String=null,isFilter:Boolean=false):void{
			if(bg){
				_load.load(bg,{onComplete:bgloaded});
				function bgloaded(e:*):void{
					rowBg.addChild(e.target.content);
					column[index].y=rowBg.height/2-column[index].height/2;
				}
			}
			if(overbg){
				_load.load(overbg,{onComplete:overbgloaded});
				function overbgloaded(e:*):void{
					rowOver.addChild(e.target.content);
				}
				rowOver.alpha=0;
			}
			if(changebg){
				_load.load(changebg,{onComplete:changebgloaded});
				function changebgloaded(e:*):void{
					rowChange.addChild(e.target.content);
				}
				rowChange.alpha=0;
			}
			_isFilter = isFilter;
		}
		public function setChange(e:MouseEvent=null):void{
			rowChange.alpha=1;
		}
		public function removeChange():void{
			rowChange.alpha=0;
		}
		public function setTextFilters(text:TextField,color:Number=0x000000):void
		{
			var gf:GlowFilter = new GlowFilter();
			gf.color = color;
			gf.alpha = 1;
			gf.blurX = 2;
			gf.blurY = 2;
			gf.strength = 5;
			text.filters = [gf];
			var textformat:TextFormat=new TextFormat();
			textformat.bold=true;
			text.setTextFormat(textformat);
		}
	}
}