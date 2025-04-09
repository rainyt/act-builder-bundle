package act.events;

/**
 * 基础的条件判断数据
 */
class IfData<T, E> {
	public var data:T;

	/**
	 * 运算结果是否取反值
	 */
	public var isInvert:Bool = false;

	/**
	 * 反值
	 */
	public function invert():IfData<T,E> {
		isInvert = !isInvert;
		return this;
	}

	public function new(data:T) {
		this.data = data;
	}

	/**
	 * 返回条件判断结果
	 * @param role 
	 * @return Bool
	 */
	public function result(role:E):Bool {
		return true;
	}

	/**
	 * 运算符检查
	 * @param op 运算符
	 * @param value 左边值
	 * @param value2 右边值
	 * @return Bool
	 */
	public function checkOp(value:Int, value2:Int):Bool {
		var opData:Dynamic = this.data;
		switch (opData.op) {
			case ">=":
				return value >= value2;
			case "==":
				return value == value2;
			case "<=":
				return value <= value2;
			case ">":
				return value > value2;
			case "<":
				return value < value2;
			case "!=":
				return value != value2;
			default:
				return false;
		}
		return false;
	}

	public function toString() {
		return "[IfData " + Type.getClassName(Type.getClass(this)) + "]";
	}
}

typedef IfOpData = {
	var op:String;
}
