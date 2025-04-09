package act.data;

import differ.math.Vector;
import differ.shapes.Polygon;
import differ.shapes.Circle;
import differ.shapes.Shape;

/**
 * 角色碰撞器数据
 */
class RoleCollider {
	/**
	 * 受击区域
	 */
	public var body:Shape;

	/**
	 * 角色站位点区域
	 */
	public var bottom:Shape;

	public function new() {
		// bottom = new Circle(0, 0, 3);
		var width = 6;
		var height = 70;
		var tileWidth = width / 2;
		var tileHeight = height / 2;
		bottom = new Polygon(0, 0, [
			new Vector(-tileWidth, -tileHeight),
			new Vector(tileWidth, -tileHeight),
			new Vector(tileWidth, tileHeight),
			new Vector(-tileWidth, tileHeight)
		]);
		var width = 20;
		var height = 70;
		var tileWidth = width / 2;
		body = new Polygon(0, 0, [
			new Vector(-tileWidth, -height),
			new Vector(tileWidth, -height),
			new Vector(tileWidth, 0),
			new Vector(-tileWidth, 0)
		]);
	}

	/**
	 * 更新坐标
	 * @param x 
	 * @param y 
	 */
	public function updatePoint(x:Float, y:Float):Void {
		bottom.x = x;
		bottom.y = y - 35;
		body.x = x;
		body.y = y;
	}
}
