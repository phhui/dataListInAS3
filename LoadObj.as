package
{
	
	
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.system.System;
	import flash.utils.Dictionary;
	
	public class LoadObj
	{
		private var _obj:Object={};
		private var _load:Loader=new Loader();
		private var loadingurl:String="";
		
		
		private var urlloader:URLLoader = new URLLoader();
		private var pq_url:URLRequest;
		
		private var urlList:Array=[];
		private var objList:Array=[];
		private var loadedData:Dictionary=new Dictionary();
		
		public function LoadObj()
		{
			
		}
		/**
		 *加载对象 
		 * @param url 地址
		 * @param obj onComplete加载完后执行的方法
		 * 
		 */		
		public function load(url:String,obj:Object=null):void{
//			if(loadedData[url]){//如果该对象已加载过则直接读取
//				obj.onComplete(loadedData[url]);
//				return;
//			}//已加载过的对象取出来是错的，暂时注释
			urlList.push(url);
			objList.push(obj);
			if(loadingurl.length>0)return;
			startload();
		}
		private function startload():void{
			if(urlList.length>0){
				loadingurl=urlList[0];
				if(!loadingurl)return;
				trace("开始加载："+urlList[0]);
				if(checkUrl()=="xml"){
					urlLoad();
				}else{
					objLoad();
				}
			}
		}
		private function checkUrl():String{
			var reg:RegExp=/.jpg|.png|.gif|.jpeg|.swf/;
			var url_string:String = urlList[0];
			
			url_string = url_string.split("?")[0];
			
			if(reg.exec(url_string.substring(url_string.length-4))){
				return "obj";
			}else{
				return "xml";
			}
		}
		private function objLoad():void{
			_load.name=urlList[0];
			_load.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
			_load.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR ,loadError);
			_load.contentLoaderInfo.addEventListener(Event.OPEN, openHandler);
			_load.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, loading);
			_load.load(new URLRequest(urlList[0]));
		}
		private function onComplete(e:Event):void{
			var s:String=e.currentTarget.content.parent.name;
			loadedData[s]=e;
			trace(urlList[0]+"加载完成");
			remove();
			if(objList[0]["parent"]!=null&&objList[0]["parent"] as DisplayObject)objList[0]["parent"].addChild(e.target.content);
			if(objList[0].onComplete){
				try{
					if(objList[0]["param"]!=null)objList[0].onComplete(e,objList[0]["param"]);
					else objList[0].onComplete(e);
				}catch(err:Error){typeError(err.message);}
			}
			loadingurl="";
			urlList.shift();
			objList.shift();
			startload();
		}
		private function loadError(e:IOErrorEvent):void{
			trace("LoadObj加载文件失败！"+e.text);
			remove();
			if(objList[0].errorFunc){
				objList[0].errorFunc(e);
			}
			loadingurl="";
			urlList.shift();
			objList.shift();
			startload();
		}
		private function openHandler(e:Event):void{
			
		}
		private function loading(e:ProgressEvent):void{
			if(objList[0].progressFunc){
				objList[0].progressFunc(e);
			}
		}
		private function remove():void{
			_load.contentLoaderInfo.removeEventListener(Event.COMPLETE, onComplete);
			_load.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR ,loadError);
			_load.contentLoaderInfo.removeEventListener(Event.OPEN, openHandler);
			_load.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, loading);
		}
		/**
		 *加载XML 
		 * @param _Url
		 * @param _obj
		 * 
		 */		
		private function urlLoad():void//URLRequestMethod.GET
		{
			pq_url = new URLRequest(urlList[0]);
			urlloader.addEventListener(Event.COMPLETE,urlloadComplete);
			urlloader.addEventListener(IOErrorEvent.IO_ERROR,urlloadError);
			urlloader.load(pq_url);
		}
		private function urlloadComplete(e:Event):void
		{
			urlloader.removeEventListener(Event.COMPLETE,urlloadComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,urlloadError);
			if(objList[0].onComplete != null)
			{
				try{
					if(objList[0]["param"]!=null)objList[0].onComplete(String(urlloader.data),objList[0]["param"]);
					else objList[0].onComplete(String(urlloader.data));
				}catch(err:Error){typeError(err.message);}
			}
			loadingurl="";
			urlList.shift();
			objList.shift();
			startload();
		}
		private function urlloadError(e:IOErrorEvent):void
		{
			trace("LoadObj加载文件失败"+e.text);
			urlloader.removeEventListener(Event.COMPLETE,urlloadComplete);
			urlloader.removeEventListener(IOErrorEvent.IO_ERROR,loadError);
			if(objList[0].errorFunc!=null){
				objList[0].errorFunc(e);
			}
			loadingurl="";
			urlList.shift();
			objList.shift();
			startload();
		}
		private function typeError(err:String):void{
			if(objList[0].errorType!=null){
				objList[0].errorType(err);
			}
		}
		public function get loader():Loader{
			return _load;
		}
	}
}