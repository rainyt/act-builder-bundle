package act.data;

import hx.macro.JSONData;

/**
 * 数据表中的数据读取支持
 */
class XlsData {
	/**
	 * 角色数据
	 */
	public static var roles = JSONData.create("assets/xlsData/roles.json", ["roleid"], ["group"]);
}
