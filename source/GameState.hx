package;

import flixel.FlxState;
import flixel.FlxG;
import openfl.utils.Assets;

typedef CellInfo = {
	xpos:Int,
	ypos:Int,
	num:Int,
	type:CellTypes
}

enum CellTypes {
	BOMB;
	EMPTY;
	NUM;
}
class GameState extends FlxState
{
	public var bombArray:Array<CellInfo> = [];
	public var numArray:Array<CellInfo> = [];
	public var emptyArray:Array<CellInfo> = [];
	public var cells:Map<CellInfo, Element>;
	public var smile:Element;
	public var timer1:Element;
	public var timer2:Element;
	public var timer3:Element;
	public var flags1:Element;
	public var flags2:Element;
	public var flags3:Element;
	override public function create() {
		FlxG.camera.bgColor = Std.parseInt(Assets.getText("game:assets/game/color.txt"));
		cells = new Map<CellInfo, Element>();
		generateField(9, 9, 10);
		createGraphic(9, 9);
		super.create();
	}
	
	// hardcoding moment
	public function generateField(width:Int, height:Int, bombs:Int) {
		for (i in 1...bombs) {
			var bomb:CellInfo = {
				xpos:0,
				ypos:0,
				num:0,
				type:BOMB
			}
			bomb.type = BOMB;
			bomb.xpos = FlxG.random.int(1, width);
			bomb.ypos = FlxG.random.int(1, height);
			for (j in bombArray) {
			    if (j != null) {
				    while (j.xpos == bomb.xpos && j.ypos == bomb.ypos) {
					    bomb.xpos = FlxG.random.int(1, width);
					    bomb.ypos = FlxG.random.int(1, height);
					}
				}
			}
			bombArray.push(bomb);
		}
		for (i in 1...width) {
			for (j in 1...height) {
				var cell:CellInfo = {
					xpos:0,
					ypos:0,
					num:0,
					type:EMPTY
				}
				cell.type = EMPTY;
				cell.xpos = i;
				cell.ypos = j;
				var isDublicate:Bool = false;
				for (g in bombArray) {
					var bomb = g;
					if (cell.xpos == bomb.xpos && cell.ypos == bomb.ypos) {
						isDublicate = true;
					}
				}
				if (isDublicate) {
					continue;
				} else {
					emptyArray.push(cell);
				}
			}
		}
		for (i in emptyArray) {
			var cell = i;
			for (j in bombArray) {
				var bomb = j;
				// the most hardcoded thing in this world
				if (cell.xpos != width && cell.xpos + 1 == bomb.xpos && cell.ypos == bomb.ypos) {
					cell.num = cell.num + 1;
				}
				if (cell.xpos != 1 && cell.xpos - 1 == bomb.xpos && cell.ypos == bomb.ypos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != height && cell.ypos + 1 == bomb.ypos && cell.xpos == bomb.xpos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != 1 && cell.ypos - 1 == bomb.ypos && cell.xpos == bomb.xpos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != height && cell.xpos != 1 && cell.xpos - 1 == bomb.xpos && cell.ypos + 1 == bomb.ypos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != height && cell.xpos != width && cell.xpos + 1 == bomb.xpos && cell.ypos + 1 == bomb.ypos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != 1 && cell.xpos != 1 && cell.xpos - 1 == bomb.xpos && cell.ypos - 1 == bomb.ypos) {
					cell.num = cell.num + 1;
				}
				if (cell.ypos != 1 && cell.xpos != width && cell.xpos + 1 == bomb.xpos && cell.ypos - 1 == bomb.ypos) {
					cell.num = cell.num + 1;
				}
			}
			if (cell.num > 0) {
				cell.type = NUM;
				numArray.push(cell);
				emptyArray.remove(cell);
			}
		}
	}
	
	public function createGraphic(width:Int, height:Int) {
		for (i in bombArray) {
			var element:Element = new Element(0, 0, CELL);
			add(element);
			cells.set(i, element);
		}
		for (i in numArray) {
			var element:Element = new Element(0, 0, CELL);
			add(element);
			cells.set(i, element);
		}
		for (i in emptyArray) {
			var element:Element = new Element(0, 0, CELL);
			add(element);
			cells.set(i, element);
		}
		for (i in cells.keys()) {
			var shit = cells.get(i);
			shit.x = shit.offsetX * (i.xpos - 1);
			shit.y = (shit.offsetY * (i.ypos - 1)) + 200;
		}
		smile = new Element(Std.int(FlxG.width / 2), 50, SMILE);
		add(smile);
		
		timer1 = new Element(smile.x + smile.offsetX + 100, 50, NUM);
		add(timer1);
		timer2 = new Element(timer1.x - timer1.offsetX - 10, 50, NUM);
		add(timer2);
		timer3 = new Element(timer2.x - timer2.offsetX - 10, 50, NUM);
		add(timer3);
		
	    	flags3 = new Element(smile.x - 100, 50, NUM);
		add(flags3);
		flags2 = new Element(flags3.x + flags3.offsetX + 10, 50, NUM);
		add(flags2);
		timer1 = new Element(flags2.x + flags2.offsetX + 10, 50, NUM);
		add(flags1);
	}
	
	public function thehelloftesting() {
		for (i in cells.keys()) {
			var shit = cells.get(i);
			switch(i.type) {
				case BOMB:
					shit.setAnim('cell_mine');
				case NUM:
					shit.setAnim('cell_' + i.num);
				case EMPTY:
					shit.setAnim('cell_null');
			}
		}
		smile.setAnim('smile_pressed');
		timer1.setAnim('n9');
		timer2.setAnim('n8');
		timer3.setAnim('n7');
		flags3.setAnim('n6');
		flags2.setAnim('n5');
		flags1.setAnim('n4');
	}
	
	override public function update(elapsed:Float) {
		if (FlxG.keys.justPressed.ENTER) {
			thehelloftesting();
		}
		super.update(elapsed);
	}
}
