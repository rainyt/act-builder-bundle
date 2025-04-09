package act.data;

import game.event.*;
import hx.gemo.Point;
import hx.assets.Assets;
import hx.events.Keyboard;
import haxe.Json;
import act.data.RoleAction;
import differ.math.Vector;
import differ.shapes.Polygon;

using Reflect;

/**
 * 幻想纹章2的人物数据包读取支持
 */
class Hxwz2RolePackageData implements IRoleData {
	/**
	 * 事件Tag
	 */
	public var eventTag:String;

	/**
	 * 精灵图偏移X
	 */
	public var offsetX:Float = 0;

	/**
	 * 精灵图偏移Y
	 */
	public var offsetY:Float = 0;

	/**
	 * 动作数据
	 */
	public var actions:Map<String, ActionData> = [];

	/**
	 * 组合键数组，一般是经过了排序，由长组合键到短组合键
	 */
	public var groupKeyActions:Array<ActionData> = [];

	/**
	 * 角色事件数据
	 */
	public var eventData:EventData = new EventData();

	/**
	 * 缩放比例
	 */
	public var scale:Float = 1;

	public function new(xml:Xml) {
		var data:Xml = xml.firstElement();
		if (data.exists("px")) {
			offsetX = Std.parseFloat(data.get("px"));
		}
		if (data.exists("py")) {
			offsetY = Std.parseFloat(data.get("py"));
		}
		if (data.exists("eventTag")) {
			eventTag = data.get("eventTag");
		}
		// 解析动作数据
		for (action in data.elements()) {
			if (action.nodeName == "act") {
				var actionData = new ActionData();
				// CD
				actionData.cd = Std.parseInt(action.get("cd"));
				// 技能名称
				actionData.name = action.get("name");
				// 描述
				actionData.desc = action.get("tips");
				// 事件标签
				actionData.eventTag = action.get("eventTag");
				// 释放消耗
				actionData.mpConsume = Std.parseInt(action.get("mp"));
				// 生命消耗
				actionData.hpConsume = Std.parseInt(action.get("hp"));
				var groupKeys = [];
				if (actionData.name == "普通攻击" || actionData.name == "空中攻击") {
					groupKeys = [Keyboard.J];
				} else {
					// 组合键
					var leftKey = action.get("left");
					var rightKey = action.get("right");
					if (leftKey != null && leftKey != "无") {
						// 组合键
						for (key in leftKey.split("")) {
							switch key {
								case "↑":
									groupKeys.push(Keyboard.W);
								case "↓":
									groupKeys.push(Keyboard.S);
								case "←":
									groupKeys.push(Keyboard.A);
								case "→":
									groupKeys.push(Keyboard.D);
							}
						}
					}
					if (rightKey != null && rightKey != "无") {
						// 组合键
						groupKeys.push(StringTools.fastCodeAt(rightKey, 0));
					}
				}
				if (groupKeys.length > 0) {
					actionData.groupKeys = groupKeys;
					groupKeyActions.push(actionData);
				}
				// FPS
				var xmlFps = Std.parseInt(action.get("fps"));
				actionData.fps = mathFps(2 + xmlFps);
				// 判断技能类型
				var isAirSkill = action.get("isAirSkill") == "true" || actionData.name == "空中攻击";
				var isIgnoreInjured = action.get("isIgnoreInjured") == "true";
				if (isIgnoreInjured) {
					// 全能技能
					actionData.type = ALL_SKILL;
				} else if (isAirSkill) {
					// 空中技能
					actionData.type = AIR_SKILL;
				} else {
					// 地面技能
					actionData.type = GROUND_SKILL;
				}
				var gox = 0.;
				var goy = 0.;
				// 计算出每帧移动的FPS计算
				var moveFps = xmlFps + 3;
				if (moveFps == 0) {
					moveFps = 1;
				}
				for (frame in action.elements()) {
					var lastFrameData = actionData.frames.length > 0 ? actionData.frames[actionData.frames.length - 1] : null;
					var frameData = new FrameData();
					frameData.eventTag = frame.get("eventTag");
					frameData.name = frame.get("name");
					frameData.sound = frame.get("soundName");
					frameData.sound = (frameData.sound == "" || frameData.sound == null) ? null : Assets.formatName(frameData.sound);
					// 计算间隔移动值
					var currentGox = Std.parseFloat(frame.get("gox"));
					var currentGoy = Std.parseFloat(frame.get("goy"));
					if (lastFrameData != null) {
						// 需要进行推算长度
						lastFrameData.moveX = (currentGox - gox) / moveFps;
						lastFrameData.moveY = (currentGoy - goy) / moveFps;
					}
					gox = currentGox;
					goy = currentGoy;
					// 计算碰撞块，幻想纹章2只有矩形碰撞块
					if (frame.exists("hitX") && frame.exists("hitY") && frame.exists("hitWidth") && frame.exists("hitHeight")) {
						var hitX = Std.parseFloat(frame.get("hitX"));
						var hitY = Std.parseFloat(frame.get("hitY"));
						var hitWidth = Std.parseFloat(frame.get("hitWidth"));
						var hitHeight = Std.parseFloat(frame.get("hitHeight"));
						frameData.collision = new Polygon(0, 0, [
							new Vector(hitX, hitY),
							new Vector(hitX + hitWidth, hitY),
							new Vector(hitX + hitWidth, hitY + hitHeight),
							new Vector(hitX, hitY + hitHeight)
						]);
						// 碰撞块有效时间
						var hitLiveTime = Std.parseFloat(frame.get("hiteffective")) * 1 / 30;
						frameData.collisionLiveTime = hitLiveTime;
						// 添加击中数据
						frameData.hitData = new HitData();
						frameData.hitData.hitMoveX = Std.parseFloat(frame.get("asZ")) * 0.35;
						frameData.hitData.hitMoveY = Std.parseFloat(frame.get("asY")) * 0.35;
						frameData.hitData.isBlow = frame.get("isBlow") == "blow";
						if (frame.exists("asR"))
							frameData.hitData.stiffenTime = Std.parseFloat(frame.get("asR")) / 60;
						else if (frame.exists("asS")) {
							frameData.hitData.stiffenTime = Std.parseFloat(frame.get("asS")) / 60;
						}
					}
					if (frame.exists("effects")) {
						var effects:Array<Dynamic> = Json.parse(frame.get("effects"));
						if (effects.length > 0) {
							for (value in effects) {
								var effectJson = Json.parse(value);
								// trace(actionData.name, effectJson);
								var effectData:EffectData = new EffectData();
								effectData.x = effectJson.x;
								effectData.y = effectJson.y;
								effectData.rotation = effectJson.rotation;
								effectData.name = effectJson.name;
								effectData.scaleX = effectJson.scaleX;
								effectData.scaleY = effectJson.scaleY;
								effectData.displayName = effectJson.findName;
								effectData.blendMode = effectJson.blendMode;
								effectData.isLockAction = effectJson != null && effectJson.isLockAction;
								effectData.isFollow = effectJson.isFollow != null && effectJson.isFollow;
								// 位移速度
								if (effectJson.gox != 0 || effectJson.goy != 0) {
									effectData.speed = new Point(effectJson.gox * 0.5, effectJson.goy * 0.5);
								}
								effectData.liveTime = (effectJson.time == null || effectJson.time == 0) ? -1 : effectJson.time;
								if (effectJson.color != null) {
									var array:Array<Float> = effectJson.color;
									if (array.length > 0) {
										effectData.colorMatrixFilter = array;
									}
								}
								if (effectJson.fps != null) {
									effectData.fps = mathFps(effectJson.fps - 1);
								}
								effectData.root = effectJson;
								frameData.effects.push(effectData);
							}
						}
					}
					actionData.frames.push(frameData);
					// TODO 跳跃动作特殊处理，仅保留最后1帧，前面的帧可以作为过渡动画优化
					if (actionData.name == RoleAction.JUMP_UP) {
						actionData.frames = [actionData.frames[actionData.frames.length - 1]];
					} else if (actionData.name == RoleAction.JUMP_ATTACK) {
						// 空中攻击允许位移
						actionData.allowAirMove = true;
					}
					// 停止帧判断
					if (frame.exists("asA")) {
						frameData.isStop = frame.get("asA") == "stop";
						if (frameData.isStop) {
							// trace(actionData.name, "停顿帧");
						}
					}
				}
				if (actionData.frames.length == 0)
					continue;
				this.actions.set(actionData.name, actionData);
			} else if (action.nodeName == "ifRoot") {
				for (event in action.elements()) {
					var eventName = event.get("name");
					trace(eventName);
					var allAction = new EventAction();
					// 这里都是条件判断
					for (ifEvnet in event.elements()) {
						var eventAction = new EventAction();
						var array:Array<Dynamic> = Json.parse(ifEvnet.get("ifData"));
						for (item in array) {
							var ifData = createIfData(item.data);
							if (ifData == null) {
								// 	trace("ifData", item.data);
								// 	throw "ifData is null, by data is " + Json.stringify(item);
							} else
								eventAction.ifDatas.push(ifData);
						}
						for (doChild in ifEvnet.elements()) {
							var json = Json.parse(doChild.get("doData"));
							var doData = createDoData(json);
							if (doData == null) {
								// trace("doChild", json);
								// throw "doData is null, by data is " + Json.stringify(json);
							} else
								eventAction.doDatas.push(doData);
						}
						allAction.doDatas.push(eventAction);
					}
					if (allAction.doDatas.length > 0)
						eventData.actions.set(eventName, allAction);
				}
			}
		}
		// 组合键排序
		groupKeyActions.sort(function(a, b) {
			return a.groupKeys.length > b.groupKeys.length ? -1 : 1;
		});
	}

	/**
	 * 反推幻想纹章2的人物包FPS，将FPS反推到60FPS比例中
	 * @param fps 
	 * @return Int
	 */
	private function mathFps(fps:Int):Int {
		// 幻纹2的fps是按30FPS计算的，因此，这里需要合理计算
		var fpsDt = 1 / 30;
		// 角色的FPS间隔值值默认是2
		var roleFps:Float = fps * fpsDt;
		// 根据FPS间隔反推FPS值
		return roleFps <= 0 ? 30 : Std.int(1 / roleFps);
	}

	/**
	 * 创建执行数据
	 * @param data 
	 * @return DoData
	 */
	private function createDoData(data:Dynamic):DoData<Dynamic> {
		var tag:String = data.tag;
		// 判断事件条件
		// 判断执行事件条件
		switch tag {
			// case "stopCD":
			// case "NewstopCD":
			// case "fps":
			// case "Newfps":
			// case "jump":
			// case "newjump":
			// case "fang":
			// case "Newfang":
			// case "moveSpeed":
			// case "NewmoveSpeed":
			case "dmg":
				// 弃用
				return null;
			// case "Newdmg":
			// case "jumint":
			// case "showRoleSkill":
			// case "zhendong":
			// case "changeRole":
			// case "NewchangeRole":
			case "scaleX":
				return new DoSetScaleX({
					scaleX: data.fx == "左" ? -1 : 1
				});
			// case "scaleXF":
			case "hitString":
				// 切换动作
				return new DoChangeSkillAction({
					name: data.skillName
				});
			// case "NewhitString":
			// case "goTips":
			case "go":
				return new DoGoFrame({
					value: Std.parseInt(data.value)
				});
			case "stopSkill":
				return new DoStopSkillAction();
			// case "stChange":
			// case "mpChange":
			// case "hpChange":
			case "move":
				return new DoMove({
					roleTarget: data.roleTarget,
					target: data.target,
					x: Std.parseFloat(data.x),
					y: Std.parseFloat(data.y)
				});
			case "setData":
				switch (data.getProperty("cname")) {
					case "数字":
						return new DoSetData({
							key: data.name,
							value: Std.parseFloat(data.data),
							action: SET
						});
					default:
						trace("未知类型", data.getProperty("cname"));
				};
				// case "moveTag":
				// case "toMoveTag":
				// case "toEffect":
				// case "toEffectto":
				// case "setSkill":
				// case "FXSkill":
				// case "zhuizong":
				// case "addHitN":
				// case "setHitN":
				// case "caiHong":
				// case "caiHongyang":
				// case "Skilltoint":
				// case "addSkilltoint":
				// case "SkillFX":
				// case "killSkill":
				// case "setBGM":
				// case "setqz":
				// case "setgod":
				// case "setrigid":
				// case "setweizhi":
				// case "stopGame":
				// case "stopRole":
				// case "fuKong":
				// case "fuKongk":
				// case "fuKongd":
				// case "JD":
				// case "playM":
		}
		return new DoThrowData(data);
	}

	/**
	 * 创建条件数据
	 * @param data 
	 * @return IfData
	 */
	private function createIfData(data:Dynamic):IfData<Dynamic> {
		var tag:String = data.tag;
		// 判断事件条件
		switch tag {
			case "hitEnemyRect":
				return new IfEnemyRectRange({
					width: Std.parseFloat(data.width),
					height: Std.parseFloat(data.height)
				});
			case "FrameNameIs":
				return new IfActionName(data);
			case "EffectIf":
				return new IfEffectifExist(data);
			// case "effint":
			// return new Ifeffint(data);
			// case "effhitrole":
			// return new effhitrole(data);
			case "hitEnemy":
				return new IfHitTestEnemy(data);
			// case "hitEnemyRect":
			// return new IfhitEnemyRect(data);
			// case "noEffectIf":
			// return new IfnoEffectIf(data);
			// case "UnCDIf":
			// return new IfUnCDIf(data);
			// case "CDIf":
			// return new IfCDIf(data);
			case "KeyIf":
				return new IfKeyLURDDown({
					key: data.getProperty("if")
				});
			case "isJump":
				return new IfJumpState(data);
			case "unJump":
				return new IfJumpState(data).invert();
			case "FrameNameNoIs":
				return new IfActionName(data).invert();
			// case "NewFrameNameNoIs":
			// return new IfNewFrameNameNoIs(data);
			// case "FrameNameIs":
			// return new IfFrameNameIs(data);
			case "MPIf":
				return new IfMpValue({
					op: data.getProperty("op"),
					value: Std.parseInt(data.value)
				});
			// case "HPIf":
			// return new IfHPIf(data);
			// case "RandomIf":
			// return new IfRandomIf(data);
			case "FrameIf":
				return new IfCurrentFrame({
					op: data.getProperty("if"),
					value: Std.parseInt(data.value)
				});
			case "ifData":
				return new IfCustomDataValue({
					op: data.getProperty("if"),
					key: data.name,
					value: data.data
				});
			case "ifHits":
				return new IfHitsCounts({
					op: data.getProperty("if"),
					value: Std.parseInt(data.hits)
				});
			// case "roleWin":
			// return new IfroleWin(data);
			// case "NewifHits":
			// return new IfNewifHits(data);
			// case "effecthitmap":
			// return new Ifeffecthitmap(data);
			// case "NewHPIf":
			// return new IfNewHPIf(data);
			// 两个mpif？
			// case "MPIf":
			// return new IfMPIf(data);
			// case "rightMap":
			// return new IfrightMap(data);
			// case "fxP":
			// return new IffxP(data);
			case "Effecthit":
				// 暂不支持
				return new IfData(data);
				// return new IfEffecthit(data);
				// case "fxP":
				// return new IffxP(data);
		}
		return null;
	}
}
