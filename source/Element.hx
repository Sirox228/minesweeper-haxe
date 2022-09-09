package;

import flixel.FlxSprite;
import flixel.graphics.frames.FlxAtlasFrames;
import flixel.graphics.FlxGraphic;
import openfl.utils.Assets;

class Element extends FlxSprite
{
	public var offsetX:Int = 0;
	public var offsetY:Int = 0;

	public function new(x:Float = 0, y:Float = 0, type:Types)
	{
		super(x, y);
		antialiasing = false;
		// special thanks to VanBog for making minesweeper assets spritesheet
		frames = FlxAtlasFrames.fromSpriteSheetPacker(FlxGraphic.fromBitmapData(Assets.getBitmapData("game:assets/game/minesweeper.png"), false), Assets.getText("game:assets/game/minesweeper.txt"));
		switch (type) {
			case SMILE: // if you played minesweeper, you should know, what smile thing do
			    animation.addByPrefix('smile', 'smile_', 1, true);
			    animation.addByPrefix('smile_pressed', 'active smile_', 1, true);
			    animation.addByPrefix('smile_cool', 'cool smile_', 1, true);
			    animation.addByPrefix('smile_dead', 'dead smile_', 1, true);
			    animation.addByPrefix('smile_pog', 'fucking pog_', 1, true);
			    setAnim('smile');
			case CELL: // cell can be literally any cell, changing animations for it when pressed and etc. would be better than creating new one each time
			    animation.addByPrefix('cell', 'cell_', 1, true);
			    animation.addByPrefix('cell_null', 'active cell_', 1, true);
			    for (i in 1...8) { // i'm too lazy to add all anims manually
				    animation.addByPrefix('cell_' + Std.string(i), 'nm' + Std.string(i) + '_', 1, true);
			    }
			    animation.addByPrefix('cell_flag', 'flag_', 1, true);
			    animation.addByPrefix('cell_mine', 'mine_', 1, true);
			    animation.addByPrefix('cell_mine_pressed', 'active mine_', 1, true);
			    animation.addByPrefix('cell_not_mine', 'not mine_', 1, true);
			    setAnim('cell');
			case NUM: // numbers
			    animation.addByPrefix('nnull', 'null_', 1, true);
			    animation.addByPrefix('nmin', 'n-_', 1, true);
			    for (i in 0...9) { // lazyness again
				    animation.addByPrefix('n' + Std.string(i), 'n' + Std.string(i) + '_', 1, true);
				}
				setAnim('nnull');
		}
		offsetX = Std.int(width * 4);
		offsetY = type == NUM ? Std.int(height * 4) : height;
                if (type == NUM) {
		        setGraphicSize(Std.int(width * 4), Std.int(height * 4));
                } else {
                        setGraphicSize(Std.int(width * 4));
                }
	}
	
	public function setAnim(name:String) {
		animation.play(name);
	}
}

enum Types {
	SMILE;
	CELL;
	NUM;
}
