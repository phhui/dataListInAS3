package
{
    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.events.Event;
    
    public class ScrollBarByPhhui extends Sprite
    {
		private var _obj:Object;//滚动对象
		private var _type:int=0;//0:文本，1：非文本
		private var _mask:Object;//遮罩对象
		private var _h:int=0;//滚动条高度
		private var _scrollvnum:int=0;//文本显示行数
		private var _v:int=5;//文本滚动速度（行/像素）
		
		private var _s:Number=0;//鼠标点击滑块时的纵坐标距滑块坐标距离
		private var _bars:Number=0;//滑块可滑动距离
		private var _bar:Object;//滑块
		private var _up:Object;//向上按钮
		private var _down:Object;//向下按钮
		private var _bg:Object;//滑槽
		
        public function ScrollBarByPhhui ()
        {
			
        }
		public function bindObj(obj:Object,param:Object=null):void{//初始化
			_obj=obj;
			if(param){
			if(param.bar)_bar=param.bar;else _bar=this.pq_bar;
			if(param.upArrow)_up=param.upArrow;else _up=this.pq_up;
			if(param.ownArrow)_down=param.downArrow;else _down=this.pq_down;
			if(param.bg)_bg=param.bg;else _bg=this.pq_bg;
			if(param.type)_type=param.type;
			if(param.mask)_mask=param.mask;
			if(param.height)_h=param.height;
			if(param.textLineNum)_scrollvnum=param.textLineNum;
			if(param.v)_v=param.v;
			}
			setxy();
		}
		public function update():void{//当被滚动对象更新时，而需要改变滚动条状态，调用此方法
			if(checkhide()==false){
				this.visible=false;
				_obj.removeEventListener(MouseEvent.MOUSE_WHEEL,mousewheel);
			}
		}
		private function checkhide():Boolean{//判断是否显示滚动条
			if(_type==1&&_obj.height<=_mask.height){
				return false;
			}else if(_type==0&&int(_obj.maxScrollV)<_scrollvnum){
				return false;
			}
			return true;
		}
		private function setxy():void{//设置滚动条高度，对象遮罩等
			_bar.y=_bg.y;
			_bar.x=_bg.x;
			_bg.height=_h>0?_h-_up.height*2:_bg.height;
			_down.y=_bg.y+_bg.height;
			_bars=_bg.height-_bar.height;
			if(_type==1){
				_obj.mask=_mask;
			}
			addlisten();
		}
		private function addlisten():void{//为滚动条添加监听事件
			_bar.addEventListener(MouseEvent.MOUSE_DOWN,barclick);
			_bar.addEventListener(MouseEvent.MOUSE_UP,barup);
			if(stage)stage.addEventListener(MouseEvent.MOUSE_UP,barup);
			_up.addEventListener(MouseEvent.MOUSE_DOWN,upclick);
			_down.addEventListener(MouseEvent.MOUSE_DOWN,downclick);
			this.addEventListener(MouseEvent.MOUSE_DOWN,barclick);
			_obj.addEventListener(MouseEvent.MOUSE_UP,barup);
			_obj.addEventListener(MouseEvent.MOUSE_WHEEL,mousewheel);
		}
		private function barclick(e:MouseEvent):void{//鼠标点击滑块
			_s=mouseY-_bar.y;
			trace("滑块侦听开始");
			_bar.addEventListener(Event.ENTER_FRAME,barevent);
		}
		private function barup(e:MouseEvent):void{//鼠标点击滑块释放
			delevent();
		}
		private function upclick(e:MouseEvent):void{//鼠标点击向上按钮事件
			if(checkbar()){
				if(_type==0){
					_bar.y-=_bars*_v/_obj.maxScrollV;//滑块移动的距离=文本滚动行数*滑块可移动的总距离/文本总行数
				}else{
					_bar.y-=_bars*_v/(_obj.height-_mask.height);//滑块移动的距离=滚动对象滚动的像素*滑块可移动的总距离/(被滚动对象的高度-遮罩的高度（即显示范围的高度))
				}
				objrun(0-_v);//调用方法移动对象
				delevent();//校正滑块位置并删除监听
			}
		}
		private function downclick(e:MouseEvent):void{//鼠标点击向下按钮事件
			if(checkbar()){
				if(_type==0){
					_bar.y+=_bars*_v/_obj.maxScrollV;
				}else{
					_bar.y+=_bars*_v/(_obj.height-_mask.height);
				}
				objrun(_v);
				delevent();
			}
		}
		private function mousewheel(e:MouseEvent):void{//鼠标滑轮事件
			if(e.delta>0){
				if(checkbar()){
					_bar.y-=2;
					if(_type==0){
						_obj.scrollV=(_bar.y-_bg.y)*_obj.maxScrollV/_bars;
					}else{
						_obj.y=_mask.y-(_bar.y-_bg.y)*(_obj.height-_mask.height)/_bars;
					}
				}else{
					delevent();
				}
			}else{
				if(checkbar()){
					_bar.y+=2;
					if(_type==0){
						_obj.scrollV=(_bar.y-_bg.y)*_obj.maxScrollV/_bars;
					}else{
						_obj.y=_mask.y-(_bar.y-_bg.y)*(_obj.height-_mask.height)/_bars;
					}
				}else{
					delevent();
				}
			}
		}
		private function barevent(e:Event):void{
			if(checkbar()){
				_bar.y=mouseY-_s;
				if(_type==0){
					_obj.scrollV=(_bar.y-_bg.y)*_obj.maxScrollV/_bars;
				}else{
					_obj.y=_mask.y-(_bar.y-_bg.y)*(_obj.height-_mask.height)/_bars;
				}
			}else{
				delevent();
			}
		}
		public function objrun(i:Number):void{
			if(_type==0){
				_obj.scrollV+=i;
			}else{
				_obj.y-=i;
				if(_obj.y>_mask.y){
					_obj.y=_mask.y;
				}else if(_obj.y<(_mask.y-_obj.height+_mask.height)){
					_obj.y=_mask.y-_obj.height+_mask.height;
				}
			}
		}
		public function checkbar():Boolean{
			if(_bar.y>=_bg.y&&_bar.y<=(_bars+_bg.y)){
				return true;
			}
			return false;
		}
		public function delevent():void{
			if(_bar.y<_bg.y){
				_bar.y=_bg.y;
			}else if(_bar.y>(_bg.y+_bg.height-_bar.height)){
				_bar.y=_bg.y+_bg.height-_bar.height;
			}
			trace("滑块侦听结束");
			_bar.removeEventListener(Event.ENTER_FRAME,barevent);
		}
	}
}