package act.data;

/**
 * 击中数据
 */
class HitData {
	/**
	 * 击中后产生的击退效果，对应X轴
	 */
	public var hitMoveX:Float = 0;

	/**
	 * 击中后产生的击飞效果，对应Y轴
	 */
	public var hitMoveY:Float = 0;

	/**
	 * 击中后产生僵直时间
	 */
	public var stiffenTime:Float = 0;

	/**
	 * 是否为重击攻击，如果为重击攻击，会产生强力的卡帧效果，并会造成击飞效果
	 */
	public var isBlow:Bool = false;

	/**
	 * 碰撞体产生的坐标点X
	 */
	public var createX:Float = 0;

	/**
	 * 碰撞体产生的坐标点Y
	 */
	public var createY:Float = 0;

	/**
	 * 该攻击是否被防御
	 */
	public var isDefense:Bool = false;

	public function new() {}

	/**
	 * 克隆击中效果
	 * @return HitData
	 */
	public function clone():HitData {
		var hitData:HitData = new HitData();
		hitData.hitMoveX = hitMoveX;
		hitData.hitMoveY = hitMoveY;
		hitData.stiffenTime = stiffenTime;
		hitData.createX = createX;
		hitData.createY = createY;
		return hitData;
	}

	/**
	 * 更新碰撞体产生的坐标点
	 * @param x 坐标X
	 * @param y 坐标Y
	 */
	public function updateCreatePoint(x:Float, y:Float):Void {
		createX = x;
		createY = y;
	}
}
