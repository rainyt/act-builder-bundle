package act.data;

import hx.gemo.Point;
import hx.display.BlendMode;

/**
 * 特效渲染数据
 */
class EffectData {
	/**
	 * 原始数据
	 */
	public var root:Dynamic;

	/**
	 * 坐标X，相对角色的坐标
	 */
	public var x:Float = 0;

	/**
	 * 坐标Y，相对角色的坐标
	 */
	public var y:Float = 0;

	/**
	 * 缩放X
	 */
	public var scaleX:Float = 1;

	/**
	 * 缩放Y
	 */
	public var scaleY:Float = 1;

	/**
	 * 旋转角度
	 */
	public var rotation:Float = 0;

	/**
	 * FPS，特效的FPS默认为`16`
	 */
	public var fps:Int = 16;

	/**
	 * 显示对象的名称
	 */
	public var displayName:String;

	/**
	 * 特效名称
	 */
	public var name:String;

	/**
	 * 渲染模式
	 */
	public var blendMode:BlendMode;

	/**
	 * 颜色变更支持（v2）这是幻想纹章v2版本支持的颜色修改，会增加大量的纹理内存，为了有效优化内存，新的编辑器将不再采取此方案实现
	 */
	public var colorMatrixFilter:Array<Float>;

	/**
	 * 音频ID
	 */
	public var sound:String;

	/**
	 * 特效存活时间，默认为`-1`，当为`-1`时，则会根据特效播放结束后自动消失
	 */
	public var liveTime:Float = -1;

	/**
	 * 特效移动速度
	 */
	public var speed:Point;

	/**
	 * 是否为飞行道具，如果是，则可以被技能销毁
	 */
	public var isFlyProp:Bool = false;

	/**
	 * 是否锁定动作，如果是，则特效会跟随着角色的动作进行，当动作中断停止后，则会消失
	 */
	public var isLockAction:Bool = false;

	/**
	 * 是否跟随角色
	 */
	public var isFollow:Bool = false;

	/**
	 * TODO 攻击数据，如击退等
	 */
	// public var hitData

	public function new() {}
}
