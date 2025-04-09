package act.data;

import act.events.EventData;
import haxe.Json;

using Reflect;

class ProjectRoleData implements IRoleData {
	/**
	 * 事件Tag
	 */
	public var eventTag:String;

	/**
	 * 精灵图偏移X
	 */
	public var offsetX:Float = 0;

	/**
	 * 精灵图偏移Y
	 */
	public var offsetY:Float = 0;

	/**
	 * 动作数据
	 */
	public var actions:Map<String, ActionData> = [];

	/**
	 * 组合键数组，一般是经过了排序，由长组合键到短组合键
	 */
	public var groupKeyActions:Array<ActionData> = [];

	/**
	 * 角色事件数据
	 */
	public var eventData:EventData = new EventData();

	/**
	 * 缩放比例
	 */
	public var scale:Float = 1;

	/**
	 * 角色数据
	 * @param data 
	 */
	public function new(data:String) {
		parse(this, Json.parse(data));
	}

	/**
	 * 解析数据结构
	 * @param parent 
	 * @param data 
	 */
	private function parse(parent:Dynamic, data:Dynamic):Void {
		for (key in Reflect.fields(data)) {
			switch (key) {
				default:
					Reflect.setProperty(parent, key, data.getProperty(key));
			}
		}
	}
}
