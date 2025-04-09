package act.events;

import act.events.DoData;

/**
 * 事件动作
 */
class EventAction<E> extends DoData<Dynamic, Dynamic> {
	/**
	 * 条件判断数据
	 */
	public var ifDatas:Array<IfData<Dynamic, Dynamic>> = [];

	/**
	 * 执行列表
	 */
	public var doDatas:Array<DoData<Dynamic, Dynamic>> = [];

	/**
	 * 执行事件动作
	 * @param role 
	 */
	override public function execute(role:E):Void {
		// 条件判断
		if (ifDatas.length > 0) {
			for (data in ifDatas) {
				var ret = data.result(role);
				if (data.isInvert) {
					ret = !ret;
				}
				if (!ret) {
					return;
				}
			}
		}
		// 执行动作
		for (data in doDatas) {
			data.execute(role);
		}
	}
}
