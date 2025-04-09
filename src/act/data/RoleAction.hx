package act.data;

enum abstract RoleAction(String) to String from String {
	var IDLE = "待机";
	var RUN = "跑步";
	var ATTACK = "普通攻击";
	var JUMP_UP = "跳跃";
	var JUMP_DOWN = "降落";
	var FAST_MOVE = "瞬步";
	var JUMP_ATTACK = "空中攻击";
	var DEFEND = "防御";
	var HIT = "受伤";
	var HIT_FLY_UP = "打飞";
	var HIT_FLY_DOWN = "倒落";
	var GET_UP = "起身";
}
