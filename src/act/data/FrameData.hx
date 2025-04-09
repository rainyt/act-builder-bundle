package act.data;

import differ.shapes.Shape;

/**
 * 帧数据
 */
class FrameData {
	/**
	 * 事件标签
	 */
	public var eventTag:String;

	/**
	 * 精灵图名称
	 */
	public var name:String;

	/**
	 * 与上一帧的移动间距X
	 */
	public var moveX:Float = 0;

	/**
	 * 与上一帧的移动间距Y
	 */
	public var moveY:Float = 0;

	/**
	 * 帧碰撞数据，如果帧存在碰撞数据时，则在战斗过程中，会产生攻击效果
	 */
	public var collision:Shape;

	/**
	 * 帧碰撞有效时间
	 */
	public var collisionLiveTime:Float = 0;

	/**
	 * 击中效果
	 */
	public var hitData:HitData;

	/**
	 * 该帧需要停顿
	 */
	public var isStop:Bool = false;

	/**
	 * 特效渲染数据
	 */
	public var effects:Array<EffectData> = [];

	/**
	 * 播放音效
	 */
	public var sound:String;

	public function new() {}
}
