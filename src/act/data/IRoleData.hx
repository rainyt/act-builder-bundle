package act.data;

import act.events.EventData;

/**
 * 角色数据包接口
 */
interface IRoleData {
	/**
	 * 角色偏移坐标x
	 */
	public var offsetX:Float;

	/**
	 * 角色偏移坐标y
	 */
	public var offsetY:Float;

	/**
	 * 角色动作数据
	 */
	public var actions:Map<String, ActionData>;

	/**
	 * 组合键数组，一般是经过了排序，由长组合键到短组合键
	 */
	public var groupKeyActions:Array<ActionData>;

	/**
	 * 角色事件数据
	 */
	public var eventData:EventData;

	/**
	 * 整体缩放比例
	 */
	public var scale:Float;

	/**
	 * 事件标签
	 */
	public var eventTag:String;
}
