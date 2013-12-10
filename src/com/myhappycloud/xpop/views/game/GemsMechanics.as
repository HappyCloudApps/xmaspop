package com.myhappycloud.xpop.views.game
{
	import org.osflash.signals.Signal;
	import flash.display.MovieClip;
	import com.greensock.easing.Linear;
	import flash.display.DisplayObject;
	import com.greensock.data.TweenLiteVars;
	import com.greensock.TweenLite;
	import assets.GameGem;

	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.TextField;

	public class GemsMechanics extends Sprite
	{
		private static const NUM_GEMS : int = 6;
		private var gems_array : Array = new Array();
		private var aGem : MovieClip;
		private var selectorBox : Sprite = new Sprite();
		private var selectorRow : int = -10;
		private var selectorColumn : int = -10;
		private var red : uint = 0xFF0000;
		private var clickPossible : Boolean = false;
		private var score_txt : TextField = new TextField();
		private var hint_txt : TextField = new TextField();
		private var score : uint = 0;
		private var inaRow : uint = 0;
		private var match : Boolean = true;
		private var rotate : Boolean = false;
		private var gemCanvas : Sprite = new Sprite();
		private var gemWH : Number = 49.3;
		private var gameWH : Number = 396;
		private var _scoreUpdate : Signal;

		public function GemsMechanics()
		{
			_scoreUpdate = new Signal(uint);
			// Game initiation
			// Create and style score text
			addChild(score_txt);
			score_txt.textColor = 0xFFFFFF;
			score_txt.x = 500;
			// Create and style hint text
			addChild(hint_txt);
			hint_txt.textColor = 0xFFFFFF;
			hint_txt.x = 550;
			
			initialSetupGems();

			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function initialSetupGems() : void
		{
			// Create Gems in rows and columns
			addChild(gemCanvas);
			gemCanvas.x = 240;
			gemCanvas.y = 240;
			for (var i : uint = 0; i < 8; i++)
			{
				gems_array[i] = new Array();
				for (var j : uint = 0; j < 8; j++)
				{
					do
					{
						gems_array[i][j] = Math.floor(Math.random() * NUM_GEMS);
					}
					while (rowLineLength(i, j) > 2 || columnLineLength(i, j) > 2);
					aGem = new MovieClip();
					/*
					aGem.graphics.beginFill(colours_array[gems_array[i][j]]);
					aGem.graphics.drawCircle(23, 23, 23);
					aGem.graphics.endFill();
					*/
					aGem.name = i + "_" + j;
					aGem.x = j * gemWH - 240;
					aGem.y = i * gemWH - 240;
					aGem.targetY = aGem.y;
					var gemGraph:GameGem = new GameGem();
					var frame:int = (gems_array[i][j])+1;
					gemGraph.gotoAndStop(frame);

					aGem.addChild(gemGraph);
					gemCanvas.addChild(aGem);
				}
			}
			// Create and style selector box
			addChild(selectorBox);
			selectorBox.graphics.lineStyle(2, red, 1);
			selectorBox.graphics.drawRect(0, 0, gemWH, gemWH);
			selectorBox.visible = false;
		}

		private function init(e : Event = null) : void
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// Listen for user input
			stage.addEventListener(MouseEvent.CLICK, onClick);

			addEventListener(Event.ENTER_FRAME, everyFrame);
		}

		// Every frame...
		private function everyFrame(e : Event) : void
		{
			// Assume that gems are not falling
			var gemsAreFalling : Boolean = false;
			// Check each gem for space below it
			for (var i : int = 6; i >= 0; i--)
			{
				for (var j : uint = 0; j < 8; j++)
				{
					// If a spot contains a gem, and has an empty space below...
					if (gems_array[i][j] != -1 && gems_array[i + 1][j] == -1)
					{
						// Set gems falling
						gemsAreFalling = true;
						gems_array[i + 1][j] = gems_array[i][j];
						gems_array[i][j] = -1;
						gemCanvas.getChildByName(i + "_" + j).y += gemWH;
//						var gem : MovieClip = MovieClip(gemCanvas.getChildByName(i + "_" + j));
//						TweenLite.killTweensOf(gem);
//						var vars:TweenLiteVars = new TweenLiteVars();
//						gem.targetY = gem.targetY+gemWH;
//						vars.y(gem.targetY);
//						vars.ease(Linear.easeNone);
//						TweenLite.to(gem,.3,vars);
						gemCanvas.getChildByName(i + "_" + j).name = (i + 1) + "_" + j;
						break;
					}
				}
				// If a gem is falling
				if (gemsAreFalling)
				{
					// don't allow any more to start falling
					break;
				}
			}
			// If no gems are falling
			if (!gemsAreFalling)
			{
				// Assume no new gems are needed
				var needNewGem : Boolean = false;
				// but check all spaces...
				for (i = 7; i >= 0; i--)
				{
					for (j = 0; j < 8; j++)
					{
						// and if a spot is empty
						if (gems_array[i][j] == -1)
						{
							// now we know we need a new gem
							needNewGem = true;
							// pick a random color for the gem
							gems_array[0][j] = Math.floor(Math.random() * NUM_GEMS);
							// create the gem
							aGem = new MovieClip();
							/*
							aGem.graphics.beginFill(colours_array[gems_array[0][j]]);
							aGem.graphics.drawCircle(23, 23, 23);
							aGem.graphics.endFill();
							*/
							// ID it
							aGem.name = "0_" + j;
							// position it
							aGem.x = j * gemWH - 240;
							aGem.y = -240;
							aGem.targetY = aGem.y;
							// show it
							var gemGraph:GameGem = new GameGem();
							var frame:int = (gems_array[0][j])+1;
							gemGraph.gotoAndStop(frame);
							trace('frame: ' + (frame));
							aGem.addChild(gemGraph);
							gemCanvas.addChild(aGem);
							// stop creating new gems
							break;
						}
					}
					// if a new gem was created, stop checking
					if (needNewGem)
					{
						break;
					}
				}
				// If no new gems were needed...
				if (!needNewGem)
				{
					// assume no more/new lines are on the board
					var moreLinesAvailable : Boolean = false;
					// check all gems
					for (i = 7; i >= 0; i--)
					{
						for (j = 0; j < 8; j++)
						{
							// if a line is found
							if (rowLineLength(i, j) > 2 || columnLineLength(i, j) > 2)
							{
								// then we know more lines are available
								moreLinesAvailable = true;
								// creat a new array, set the gem type of the line, and where it is
								var lineGems : Array = [i + "_" + j];
								var gemType : uint = gems_array[i][j];
								var linePosition : int;
								// check t's a horizontal line...
								if (rowLineLength(i, j) > 2)
								{
									// if so, find our how long it is and put all the line's gems into the array
									linePosition = j;
									while (sameGemIsHere(gemType, i, linePosition - 1))
									{
										linePosition--;
										lineGems.push(i + "_" + linePosition);
									}
									linePosition = j;
									while (sameGemIsHere(gemType, i, linePosition + 1))
									{
										linePosition++;
										lineGems.push(i + "_" + linePosition);
									}
								}
								// check t's a vertical line...
								if (columnLineLength(i, j) > 2)
								{
									// if so, find our how long it is and put all the line's gems into the array
									linePosition = i;
									while (sameGemIsHere(gemType, linePosition - 1, j))
									{
										linePosition--;
										lineGems.push(linePosition + "_" + j);
									}
									linePosition = i;
									while (sameGemIsHere(gemType, linePosition + 1, j))
									{
										linePosition++;
										lineGems.push(linePosition + "_" + j);
									}
								}
								// for all gems in the line...
								for (i = 0; i < lineGems.length; i++)
								{
									// remove it from the program
									gemCanvas.removeChild(gemCanvas.getChildByName(lineGems[i]));
									// find where it was in the array
									var cd : Array = lineGems[i].split("_");
									// set it to an empty gem space
									gems_array[cd[0]][cd[1]] = -1;
									// set the new score
									score += inaRow;
									// set the score setter up
									inaRow++;
								}
								// if a row was made, stop the loop
								break;
							}
						}
						// if a line was made, stop making more lines
						if (moreLinesAvailable)
						{
							break;
						}
					}
					// if no more lines were available...
					if (!moreLinesAvailable)
					{
						/*
						// rotation code
						
						if (rotate)
						{
						gemCanvas.rotation += 5;
						if (gemCanvas.rotation % 90 == 0)
						{
						rotate = false;
						gemCanvas.rotation = 0;
						rotateClockwise(gems_array);
						while (gemCanvas.numChildren > 0)
						{
						gemCanvas.removeChildAt(0);
						}
						for (i = 0; i < 8; i++)
						{
						for (j = 0; j < 8; j++)
						{
						aGem = new Sprite();
						aGem.graphics.beginFill(colours_array[gems_array[i][j]]);
						aGem.graphics.drawCircle(23, 23, 23);
						aGem.graphics.endFill();
						aGem.name = i + "_" + j;
						aGem.x = j * gemWH - 240;
						aGem.y = i * gemWH - 240;
						gemCanvas.addChild(aGem);
						}
						}
						}
						}
						else
						{
						// allow new moves to be made
						clickPossible = true;
						// remove score multiplier
						inaRow = 0;
						}
						 
						 */
						// allow new moves to be made
						clickPossible = true;
						// remove score multiplier
						inaRow = 0;
					}
				}
			}
			// display new score
			score_txt.text = score.toString();
			_scoreUpdate.dispatch(score);
		}

		// When the user clicks
		private function onClick(e : MouseEvent) : void
		{
			// If a click is allowed
			if (clickPossible)
			{
				// If the click is within the game area...
				if (mouseX < gameWH && mouseX > 0 && mouseY < gameWH && mouseY > 0)
				{
					// Find which row and column were clicked
					var clickedRow : uint = Math.floor(mouseY / gemWH);
					var clickedColumn : uint = Math.floor(mouseX / gemWH);
					// Check if the clicked gem is adjacent to the selector
					// If not...
					if (!(((clickedRow == selectorRow + 1 || clickedRow == selectorRow - 1) && clickedColumn == selectorColumn) || ((clickedColumn == selectorColumn + 1 || clickedColumn == selectorColumn - 1) && clickedRow == selectorRow)))
					{
						// Find row and colum the selector should move to
						selectorRow = clickedRow;
						selectorColumn = clickedColumn;
						// Move it to the chosen position
						selectorBox.x = gemWH * selectorColumn;
						selectorBox.y = gemWH * selectorRow;
						// If hidden, show it.
						selectorBox.visible = true;
					}
					// If it is not next to it...
					else
					{
						// Swap the gems;
						swapGems(selectorRow, selectorColumn, clickedRow, clickedColumn);
						// If they make a line...
						if (rowLineLength(selectorRow, selectorColumn) > 2 || columnLineLength(selectorRow, selectorColumn) > 2 || rowLineLength(clickedRow, clickedColumn) > 2 || columnLineLength(clickedRow, clickedColumn) > 2)
						{
							// remove the hint text
							hint_txt.text = "";
							// dis-allow a new move until cascade has ended (removes glitches)
							clickPossible = false;
							// move and rename the gems
							gemCanvas.getChildByName(selectorRow + "_" + selectorColumn).x = clickedColumn * gemWH - 240;
							gemCanvas.getChildByName(selectorRow + "_" + selectorColumn).y = clickedRow * gemWH - 240;
							gemCanvas.getChildByName(selectorRow + "_" + selectorColumn).name = "t";
							gemCanvas.getChildByName(clickedRow + "_" + clickedColumn).x = selectorColumn * gemWH - 240;
							gemCanvas.getChildByName(clickedRow + "_" + clickedColumn).y = selectorRow * gemWH - 240;
							gemCanvas.getChildByName(clickedRow + "_" + clickedColumn).name = selectorRow + "_" + selectorColumn;
							gemCanvas.getChildByName("t").name = clickedRow + "_" + clickedColumn;
							match = true;
							rotate = true;
						}
						// If not...
						else
						{
							// Switch them back
							swapGems(selectorRow, selectorColumn, clickedRow, clickedColumn);
							match = false;
						}
						if (match)
						{
							// Move the selector position to default
							selectorRow = -10;
							selectorColumn = -10;
							// and hide it
							selectorBox.visible = false;
						}
						else
						{
							// Set the selector position
							selectorRow = clickedRow;
							selectorColumn = clickedColumn;
							// Move the box into position
							selectorBox.x = gemWH * selectorColumn;
							selectorBox.y = gemWH * selectorRow;
							match = false;
							// If hidden, show it.
							selectorBox.visible = true;
						}
					}
				}
				// If the click is outside the game area
				else
				{
					// For gems in all rows...
					for (var i : uint = 0; i < 8; i++)
					{
						// and columns...
						for (var j : uint = 0; j < 8; j++)
						{
							// if they're not too close to the side...
							if (i < 7)
							{
								// swap them horizontally
								swapGems(i, j, i + 1, j);
								// check if they form a line
								if ((rowLineLength(i, j) > 2 || columnLineLength(i, j) > 2 || rowLineLength(i + 1, j) > 2 || columnLineLength(i + 1, j) > 2))
								{
									// if so, name the move made
									selectorBox.x = j * gemWH;
									selectorBox.y = i * gemWH;
									selectorBox.visible = true;
									hint_txt.text = (i + 1).toString() + "," + (j + 1).toString() + "->" + (i + 2).toString() + "," + (j + 1).toString();
								}
								// swap the gems back
								swapGems(i, j, i + 1, j);
							}
							// then if they're not to close to the bottom...
							if (j < 7)
							{
								// swap it vertically
								swapGems(i, j, i, j + 1);
								// check if it forms a line
								if ((rowLineLength(i, j) > 2 || columnLineLength(i, j) > 2 || rowLineLength(i, j + 1) > 2 || columnLineLength(i, j + 1) > 2) )
								{
									// if so, name it
									selectorBox.x = j * gemWH;
									selectorBox.y = i * gemWH;
									selectorBox.visible = true;
									hint_txt.text = (i + 1).toString() + "," + (j + 1).toString() + "->" + (i + 1).toString() + "," + (j + 2).toString();
								}
								// swap the gems back
								swapGems(i, j, i, j + 1);
							}
						}
					}
				}
			}
		}

		// Swap given gems
		private function swapGems(fromRow : uint, fromColumn : uint, toRow : uint, toColumn : uint) : void
		{
			// Save the original position
			var originalPosition : uint = gems_array[fromRow][fromColumn];
			// Move original gem to new position
			gems_array[fromRow][fromColumn] = gems_array[toRow][toColumn];
			// move second gem to saved, original gem's position
			gems_array[toRow][toColumn] = originalPosition;
		}

		// Find out if there us a horizontal line
		private function rowLineLength(row : uint, column : uint) : uint
		{
			var gemType : uint = gems_array[row][column];
			var lineLength : uint = 1;
			var checkColumn : int = column;
			// check how far left it extends
			while (sameGemIsHere(gemType, row, checkColumn - 1))
			{
				checkColumn--;
				lineLength++;
			}
			checkColumn = column;
			// check how far right it extends
			while (sameGemIsHere(gemType, row, checkColumn + 1))
			{
				checkColumn++;
				lineLength++;
			}
			// return total line length
			return (lineLength);
		}

		// Find out if there us a vertical line
		private function columnLineLength(row : uint, column : uint) : uint
		{
			var gemType : uint = gems_array[row][column];
			var lineLength : uint = 1;
			var checkRow : int = row;
			// check how low it extends
			while (sameGemIsHere(gemType, checkRow - 1, column))
			{
				checkRow--;
				lineLength++;
			}
			// check how high it extends
			checkRow = row;
			while (sameGemIsHere(gemType, checkRow + 1, column))
			{
				checkRow++;
				lineLength++;
			}
			// return total line length
			return (lineLength);
		}

		private function sameGemIsHere(gemType : uint, row : int, column : int) : Boolean
		{
			// Check there are gems in the chosen row
			if (gems_array[row] == null)
			{
				return false;
			}
			// If there are, check if there is a gem in the chosen slot
			if (gems_array[row][column] == null)
			{
				return false;
			}
			// If there is, check if it's the same as the chosen gem type
			return gemType == gems_array[row][column];
		}

		private function rotateClockwise(a : Array) : void
		{
			var n : int = a.length;
			for (var i : int = 0; i < n / 2; i++)
			{
				for (var j : int = i; j < n - i - 1; j++)
				{
					var tmp : String = a[i][j];
					a[i][j] = a[n - j - 1][i];
					a[n - j - 1][i] = a[n - i - 1][n - j - 1];
					a[n - i - 1][n - j - 1] = a[j][n - i - 1];
					a[j][n - i - 1] = tmp;
				}
			}
		}

		public function get scoreUpdate() : Signal
		{
			return _scoreUpdate;
		}
	}
}