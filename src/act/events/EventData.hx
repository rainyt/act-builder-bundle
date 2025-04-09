package act.events;

/**
 * 游戏事件支持，可用于实现不同的角色直接的自定义效果块支持
 */
class EventData {
	/**
	 * 事件动作列表
	 */
	public var actions:Map<String, EventAction<Dynamic>> = [];

	public function new() {}

    /**
     * 根据名字获得事件动作ƒ
     * @param name 
     * @return EventAction
     */
    public function getEventActionByName(name:String):EventAction<Dynamic> {
        return actions.get(name);
    }
}
