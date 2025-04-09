package act.data;

import differ.math.Vector;
import differ.shapes.Polygon;
import differ.shapes.Circle;
import differ.shapes.Shape;

class WorldObjectData {
	public var data:Dynamic;

	public function new(data:Dynamic) {
		this.data = data;
	}

	public function getConfig(id:String):ObjectConfig {
		var array:Array<ObjectConfig> = data.objects;
		for (index => value in array) {
			if (value.id == id) {
				return value;
			}
		}
		return null;
	}

	/**
	 * 创建碰撞块
	 * @param id 
	 * @return Shape
	 */
	public function createCollision(id:String):Shape {
		var config = getConfig(id);
		switch config.collisionType {
			case POLYGON:
				var points:Array<Vector> = [];
				var len = Std.int(config.points.length / 2);
				for (i in 0...len) {
					points.push(new Vector(config.points[i * 2], config.points[i * 2 + 1]));
				}
				return new Polygon(0, 0, points);

			case CIRCLE:
				return new Circle(0, 0, config.radian);
		}
	}
}

typedef ObjectConfig = {
	id:String,
	offestX:Float,
	offestY:Float,
	collisionType:CollisionType,
	points:Array<Float>,
	radian:Float,
	classType:String,
	type:String,
	path:String,
}

enum abstract CollisionType(String) to String from String {
	var POLYGON = "polygon";

	var CIRCLE = "circle";
}
