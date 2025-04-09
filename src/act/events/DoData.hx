package act.event;

/**
 * 执行逻辑数据
 */
class DoData<T,E> {
	public var data:T;

	public function new(data:T = null) {
		this.data = data;
	}

	/**
	 * 执行逻辑实现
	 * @param role 
	 */
	public function execute(role:E) {}

	public function toString() {
		return "[DoData " + Type.getClassName(Type.getClass(this)) + "]";
	}
}
