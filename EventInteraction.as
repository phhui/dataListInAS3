package
{
	import flash.display.MovieClip;
	import flash.events.Event;
	
	/** 这个类，主要定义用来在项目中传递的事件的类
	 * 参数格式： 
	 * */
	public class EventInteraction extends Event
	{
		public static  const DISPATCH_DATA:String="DISPATCH_DATA";
		private var cmd :String ="";
		private var actions_string:String ="";
		private var datas:Object;
		/** cmd: 主消息，actions：具体操作消息， Data：传送的具体信息,根据实际情况， 在转为对应的类型
		 * */
		public function EventInteraction(cmds:String,Data:Object = null ,actions:String = ""){
			super(DISPATCH_DATA);
			this.cmd = cmds ;
			this.actions_string = actions;
			this.datas = Data ;
		}
		public function get GetCmd():String {
			return cmd ;
		}
		public function get GetAction():String{
			return actions_string;
		}
		public function get GetData():Object{
			return datas ;
		}
	}
}