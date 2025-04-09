package act.data;

import hx.events.Keyboard;

/**
 * 动作数据，一般指一个动作，例如一个技能动作、常规移动、待机等动作
 */
class ActionData {
	/**
	 * 每帧的数据
	 */
	public var frames:Array<FrameData> = [];

	/**
	 * 动作名称
	 */
	public var name:String;

	/**
	 * 描述
	 */
	public var desc:String;

	/**
	 * 所需的技能点消耗
	 */
	public var mpConsume:Int = 0;

	/**
	 * 所需的生命值消耗
	 */
	public var hpConsume:Int = 0;

	/**
	 * 所需的CD
	 */
	public var cd:Int = 0;

	/**
	 * 事件标签
	 */
	public var eventTag:String;

	/**
	 * FPS
	 */
	public var fps:Int = 0;

	/**
	 * 动作类型，决定了该动作的释放方式
	 */
	public var type:ActionType = AUTO;

	/**
	 * 允许释放该动作的时候空格移动，仅限于技能释放过程中
	 */
	public var allowAirMove:Bool = false;

	/**
	 * 组合键
	 */
	public var groupKeys:Array<Int>;

	public function new() {}

	/**
	 * 测试组合键
	 * @param keys 
	 * @return Bool
	 */
	public function testGroupKey(keys:Array<Int>, isJumping:Bool):Bool {
		// trace("测试组合键", this.name, keys, groupKeys);
		if (groupKeys.length > keys.length) {
			return false;
		} else if (groupKeys.length < keys.length) {
			keys = keys.slice(keys.length - groupKeys.length);
		}
		for (index => value in keys) {
			if (value != groupKeys[index]) {
				return false;
			}
		}
		if (isJumping) {
			// 这里需要判断是否为空中技能
			return type == ALL_SKILL || type == AIR_SKILL;
		} else {
			return type == ALL_SKILL || type == GROUND_SKILL;
		}
	}

	/**
	 * 是否为必杀技
	 */
	public function isMustSkill():Bool {
		if (groupKeys == null)
			return false;
		if (groupKeys.length > 0) {
			var key = groupKeys[groupKeys.length - 1];
			return key == Keyboard.O;
		}
		return false;
	}

	/**
	 * 是否为辅助技能
	 */
	public function isAssistSkill():Bool {
		if (groupKeys == null)
			return false;
		if (groupKeys.length > 0) {
			var key = groupKeys[groupKeys.length - 1];
			return key == Keyboard.P;
		}
		return false;
	}
}

/**
 * 动作释放类型
 */
enum abstract ActionType(Int) to Int from Int {
	/**
	 * 自动处理
	 */
	var AUTO = 1;

	/**
	 * 地面技能：仅允许在接触地面的情况下使用
	 */
	var GROUND_SKILL = 2;

	/**
	 * 空中技能：仅允许悬浮在空中的情况下使用
	 */
	var AIR_SKILL = 3;

	/**
	 * 所有情况均可使用
	 */
	var ALL_SKILL = 4;
}
