package act.data;

import differ.shapes.Circle;
import differ.shapes.Polygon;
import differ.shapes.Shape;
import haxe.Json;
import act.data.IRoleData;

/**
 * 项目导出器
 */
class ProjectDataExport {
	/**
	 * 预备导出的数据
	 */
	public var data:IRoleData;

	public function new(data:IRoleData) {
		this.data = data;
	}

	/**
	 * 导出格式
	 * @return String
	 */
	public function export():String {
		return Json.stringify(data, (key:Dynamic, value:Dynamic) -> {
			var result:Dynamic = value;
			if (key == "root") {
				return null;
			} else if (value is Shape) {
				var shape:Shape = value;
				if (shape is Polygon) {
					var polygon:Polygon = cast shape;
					result = {
						"type": "Polygon",
						"points": [
							for (vector in polygon.vertices) {
								[vector.x, vector.y];
							}
						]
					};
				} else if (shape is Circle) {
					var circle:Circle = cast shape;
					result = {
						"type": "Circle",
						"radius": circle.radius
					};
				}
			}
			return result;
		}, "	");
	}
}
