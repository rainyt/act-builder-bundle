package act.data;

/**
 * 角色数据
 */
class RoleData {
	/**
	 * 移动速度，该值越大移动速度就越快
	 */
	public var speed:Float = 3.15;

	/**
	 * 跳跃力，该值越大跳跃的高度就越高
	 */
	public var jump:Float = 5.8;

	/**
	 * 最大的跳跃次数
	 */
	public var maxJumpTimes:Int = 2;

	/**
	 * 最大的允许残影次数
	 */
	public var maxForceSkillTimes:Int = 1;

	/**
	 * 连击数
	 */
	public var hitCounts:Int = 0;

	public var mp:Int = 0;

	public var hp:Int = 0;

	public function new() {}
}
