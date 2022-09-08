package;

import flixel.FlxGame;
import openfl.display.Sprite;
import lime.app.Application;
import openfl.Lib;
import openfl.events.UncaughtErrorEvent;
import haxe.CallStack.StackItem;
import haxe.CallStack;
import sys.FileSystem;
import sys.io.File;
import flash.system.System;
using StringTools;

class Main extends Sprite
{
	public function new()
	{
		super();
		Lib.current.loaderInfo.uncaughtErrorEvents.addEventListener(UncaughtErrorEvent.UNCAUGHT_ERROR, function(u:UncaughtErrorEvent)
		{
			var callStack:Array<StackItem> = CallStack.exceptionStack(true);
			var errMsg:String = '';

			for (stackItem in callStack)
			{
				switch (stackItem)
				{
					case CFunction:
						errMsg += 'a C function\n';
					case Module(m):
						errMsg += 'module ' + m + '\n';
					case FilePos(s, file, line, column):
						errMsg += file + ' (line ' + line + ')\n';
					case Method(cname, meth):
						errMsg += cname == null ? "<unknown>" : cname + '.' + meth + '\n';
					case LocalFunction(n):
						errMsg += 'local function ' + n + '\n';
				}
			}

			errMsg += u.error;
			
			Sys.println(errMsg);
			Application.current.window.alert(errMsg, 'Error!');

			try
			{
				if (!FileSystem.exists('logs'))
					FileSystem.createDirectory('logs');

				File.saveContent('logs/'
				        + Application.current.meta.get('file')
					+ '-'
					+ Date.now().toString().replace(' ', '-').replace(':', "'")
					+ '.log',
					errMsg
					+ '\n');
			}

			System.exit(1);
		});
		addChild(new FlxGame(0, 0, GameState, 1, 60, 60, true));
	}
}
