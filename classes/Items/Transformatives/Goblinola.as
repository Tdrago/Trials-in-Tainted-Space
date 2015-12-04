package classes.Items.Transformatives
{
	import classes.Engine.Interfaces.*;
	import classes.GLOBAL;
	import classes.kGAMECLASS;
	import classes.ItemSlotClass;
	import classes.GameData.TooltipManager;
	import classes.StringUtil;
	import classes.Creature;
	import classes.Characters.PlayerCharacter;
	import classes.Engine.Utility.rand;
	import classes.Util.InCollection;
	import classes.Util.RandomInCollection;
	import classes.CockClass;
	import classes.BreastRowClass;
	import classes.VaginaClass;
	
	public class Goblinola extends ItemSlotClass
	{
		//constructor
		public function Goblinola()
		{
			_latestVersion = 1;
			quantity = 1;
			stackSize = 10;
			type = GLOBAL.FOOD;
			
			shortName = "Goblinola";
			longName = "goblinola snack bar";
			
			TooltipManager.addFullName(shortName, StringUtil.toTitleCase(longName));
			
			description = "a healthy goblinola snack bar";
			tooltip = "A snack bar that is gaudily advertised on its plastic wrap as a tasty, healthy treat for the gabilani on the go. Your codex indicates that it is edible and quite nourishing, but is also likely to trigger the reconfiguration function of your nanites.";
			
			TooltipManager.addTooltip(shortName, tooltip);
			
			attackVerb = "";
			
			basePrice = 500;
			
			combatUsable = true;
			targetsSelf = true;
			
			version = _latestVersion;
		}
		
		protected function rand(max: Number): Number
		{
			return int(Math.random() * max);
		}
		// Physical Changes
		private function minorGoblinMutations(target:Creature):void
		{
			var totalTFs:Number = target.statusEffectv2("Goblinola Bar");
			if(totalTFs == 0) totalTFs = 1;
			//Used to hold the TF we pull out of the array of effects
			var select:int = 0;
			var x:int = 0;
			//Build a list of all potential TFs
			var TFList:Array = new Array();
			//#1 Goblin skin: Requires non-human skin texture, non green, blue, or yellow skin.
			if(target.skinType != GLOBAL.SKIN_TYPE_SKIN || !InCollection(target.skinTone, "green", "lime", "emerald", "aqua", "pale blue", "turquoise", "yellow", "amber", "topaz"))
				TFList[TFList.length] = 1;
			//#2 Goblin ears: Requires non-elven ears.
			if(target.earType != GLOBAL.TYPE_SYLVAN || target.earType != GLOBAL.TYPE_GABILANI)
				TFList[TFList.length] = 2;
			//#3 Goblin hair: Requires non-black hair.
			if(target.hairType == GLOBAL.HAIR_TYPE_REGULAR && !InCollection(target.hairColor, "black", "onyx", "jet-black"))
				TFList[TFList.length] = 3;
			//#4 Goblin eyes: Requires non-goblin eyes.
			if(target.eyeType != GLOBAL.TYPE_GABILANI)
				TFList[TFList.length] = 4;
			//#5 Goblin face: Requires non-goblin face, goblin eyes, and elven ears.
			if(!target.hasStatusEffect("Gabilani Face Change") && target.faceType != GLOBAL.TYPE_GABILANI && target.eyeType == GLOBAL.TYPE_GABILANI && (target.earType == GLOBAL.TYPE_SYLVAN || target.earType == GLOBAL.TYPE_GABILANI))
			{
				TFList[TFList.length] = 5;
			}
			//#6 Reduce height (most common TF): Requires height greater than 3'6". Those with vaginas reduce height by 1-2 inches. Those without vaginas reduce by 2-3 inches.
			if(target.tallness > 42)
			{
				TFList[TFList.length] = 6;
				TFList[TFList.length] = 6;
				TFList[TFList.length] = 6;
			}
			//#7 Change masculinity/femininity (second most common TF): Males move towards slightly masculine, females move towards moderately feminine.
			if((target.rawmf("m", "f") == "m" && target.femininity > 30) || (target.rawmf("m", "f") == "f" && target.femininity < 70))
			{
				TFList[TFList.length] = 7;
				TFList[TFList.length] = 7;
			}
			//#8 Change legs and feet to humanoid: Requires non-humanoid legs and either goblin ears or goblin eyes. Legs become normal human legs. Advances time by 20 minutes when it triggers.
			if((target.legType != GLOBAL.TYPE_HUMAN || !target.isBiped()) && (target.eyeType == GLOBAL.TYPE_GABILANI || target.earType == GLOBAL.TYPE_SYLVAN || target.earType == GLOBAL.TYPE_GABILANI))
				TFList[TFList.length] = 8;
			//#9 Change arms to human: Requires non-human arms and humanoid legs.
			if((target.armType != GLOBAL.TYPE_HUMAN) && target.legType == GLOBAL.TYPE_HUMAN && target.isBiped())
				TFList[TFList.length] = 9;
			//#10 Remove tail: Requires a non-parasitic tail or tails and humanoid legs. Remove tail.
			if(target.hasTail() && target.legType == GLOBAL.TYPE_HUMAN && target.isBiped())
				TFList[TFList.length] = 10;
			
			//Loop through doing TFs until we run out, pulling out whichever we use.
			while(TFList.length > 0 && totalTFs > 0)
			{	
				kGAMECLASS.eventBuffer += "\n\n";
				//Pick a TF	
				x = rand(TFList.length);
				select = TFList[x];
				//Cull 'dat TF from the list.
				TFList.splice(x,1);
				//#0 Catch all
				if(select == 0)
				{
					kGAMECLASS.eventBuffer += "Your stomach is still somewhat uneasy from the health bar.";
				}
				//#1 Goblin skin: Skin changes to human texture, and either green, blue, or yellow colouration. Blue and yellow are rarer.
				else if(select == 1)
				{
					// Choose new skin color! 3/5 chance to get greens, 1/5 chance to get blues, 1/5 chance to get yellows
					var newSkinTone:String = "";
					if(rand(5) > 1) newSkinTone = RandomInCollection("green", "lime", "emerald");
					else newSkinTone = RandomInCollection("aqua", "pale blue", "turquoise", "yellow", "amber", "topaz");
					
					if(target.skinToneUnlocked(newSkinTone))
					{
						target.skinTone = newSkinTone;
						// Transformation text (human texture):
						if(target.skinType == GLOBAL.SKIN_TYPE_SKIN) kGAMECLASS.eventBuffer += "You notice something odd about your skin and find, much to your surprise, that your flesh tone has changed! <b>You now have [pc.skinColor] colored skin.</b>";
						// Transformation text (non-human texture):
						else kGAMECLASS.eventBuffer += "You touch your face in a moment of idle contemplation, and find that it feels very different than usual. You check your reflection in and see that not only has your skin’s texture changed to something much more in line with what a human’s normally is, it’s also turned an unusual [pc.skinColor] color. <b>You now have [pc.skinColor] human skin!</b>";
						
						target.skinType = GLOBAL.SKIN_TYPE_SKIN;
						target.clearSkinFlags();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.skinToneLockedMessage();
					}
				}
				//#2 Goblin ears: Ears become elven/goblin ears (long and pointed).
				else if(select == 2)
				{
					if(target.earTypeUnlocked(GLOBAL.TYPE_GABILANI))
					{
						// Transformation text:
						kGAMECLASS.eventBuffer += "Your ears have been bothering you for a bit now. You give them a another scratch a discover that they’ve reshaped themselves! <b>You now have long pointy gabilani ears!</b>";
						target.earType = GLOBAL.TYPE_GABILANI;
					}
					else
					{
						kGAMECLASS.eventBuffer += target.earTypeLockedMessage();
					}
				}
				//#3 Goblin hair: Hair turns black. Works if you're bald, but not if you have no hair growth.
				else if(select == 3)
				{
					// Choose new hair color!
					var newHairColor:String = "";
					newHairColor = RandomInCollection("black", "onyx", "jet-black");
					
					if(target.hairColorUnlocked(newHairColor))
					{
						kGAMECLASS.eventBuffer += "Your scalp has been feeling very itchy for the last hour or so. It hasn’t been bad enough to really mess with your concentration,";
						target.hairColor = newHairColor;
						// Transformation text (have hair):
						if(target.hairLength > 0) kGAMECLASS.eventBuffer += " but now a few strands come away in your hands to reveal that your hair color has changed. <b>You’re now sporting [pc.hairColor] hair!</b>";
						else kGAMECLASS.eventBuffer += " but you’re sure something about your head has definitely changed...";
					}
					else
					{
						kGAMECLASS.eventBuffer += target.hairColorLockedMessage();
					}
				}
				//#4 Goblin eyes: Gain goblin eyes (black irises).
				else if(select == 4)
				{
					if(target.eyeTypeUnlocked(GLOBAL.TYPE_GABILANI) && target.eyeColorUnlocked("black"))
					{
						// Transformation text:
						kGAMECLASS.eventBuffer += "The lighting here seems to bother you for some reason, and you have no choice but to close your eyes for a few seconds. Finally the feeling passes and you’re able to carry on. A minute later you catch your reflection and discover that your eyes have transformed! <b>Your irises are now completely black, and you can’t really tell the difference between your irises and pupils.</b>";
						target.eyeType = GLOBAL.TYPE_GABILANI;
						target.eyeColor = "black";
					}
					else if(target.eyeTypeUnlocked(GLOBAL.TYPE_GABILANI))
					{
						kGAMECLASS.eventBuffer += target.eyeColorLockedMessage();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.eyeTypeLockedMessage();
					}
				}
				//#5a Goblin face: Gain goblin face (triangular shape, pointy nose).
				else if(select == 5)
				{
					if(target.faceTypeUnlocked(GLOBAL.TYPE_GABILANI))
					{
						// Transformation text (stage 1):
						if(!target.hasStatusEffect("Gabilani Face Change"))
						{
							kGAMECLASS.eventBuffer += "You double over as a sudden wave of pain passes through your [pc.face]. It feels like the bones are grinding against one another! Finally, the pain becomes dull enough that you can keep moving, but it’s still there.";
							// [increase PC fatigue]
							target.energy(-50);
							target.createStatusEffect("Gabilani Face Change", 0, 0, 0, 0, true, "", "", false, 30);
						}
					}
					else
					{
						kGAMECLASS.eventBuffer += target.faceTypeLockedMessage();
					}
					
				}
				//#6 Reduce height: Those with vaginas reduce height by 1-2 inches. Those without vaginas reduce by 2-3 inches.
				else if(select == 6)
				{
					// Get tallness and shrunken values!
					var newTallness:Number = target.tallness;
					var nShrink:Number = 1 + rand(2);
					if(!target.hasVagina()) nShrink += 1;
					newTallness -= nShrink;
					
					if(target.tallnessUnlocked(newTallness))
					{
						// Transformation text (variation 1):
						if(rand(3) == 0) kGAMECLASS.eventBuffer += "You’ve been feeling a bit stiff all over for the last half hour or so. Finally, the feeling passes and you give relaxed sigh, only to hear your codex give a warning beep. When you check it, you discover that it’s detected a height change in you. <b>Apparently you’ve shrunk slightly in height!</b>";
						// Transformation text (variation 2):
						else if(rand(2) == 0) kGAMECLASS.eventBuffer += "Your clothes feel unusually loose on you, and you hear a warning beep come from your codex. Apparently, over the last hour or so, <b>you’ve shrunk slightly in height!</b>";
						// Transformation text (variation 3):
						else kGAMECLASS.eventBuffer += "A groan escapes your lips as you give your [pc.legOrLegs] a rub. They’ve been feeling a bit stiff, and you stretch them out. There is a beep from your codex as it informs you that your recorded height is inaccurate with your actual stature. <b>You’ve shrunk a little over the last hour.</b>";
						
						target.tallness = newTallness;
					}
					else
					{
						kGAMECLASS.eventBuffer += target.tallnessLockedMessage();
					}
				}
				//#7 Change masculinity/femininity: Males move towards slightly masculine, females move towards moderately feminine.
				else if(select == 7)
				{
					// Get femininity and change value!
					var newFem:Number = target.femininity;
					var nChange:Number = 2 + rand(3);
					if(target.rawmf("m","f") == "m") nChange *= -1;
					newFem += nChange;
					
					if(target.femininityUnlocked(newFem))
					{
						target.femininity = newFem;
						
						// Transformation text (variation 1):
						if(rand(2) == 0)
						{
							kGAMECLASS.eventBuffer += "You feel a strange tingling in your face, and gently touch it. It feels";
							if(nChange > 0) kGAMECLASS.eventBuffer += " softer, smoother, and more feminine";
							else if(nChange < 0) kGAMECLASS.eventBuffer += " harder, rougher, and more masculine";
							else kGAMECLASS.eventBuffer += " different at first, but it quickly passes";
							kGAMECLASS.eventBuffer += ".";
						}
						// Transformation text (variation 2):
						else
						{
							kGAMECLASS.eventBuffer += "An odd feeling comes over you. Thinking you know what it is, you take a look at yourself with the codex.";
							if(nChange > 0) kGAMECLASS.eventBuffer += " Your suspicions are confirmed, your face has taken on more feminine characteristics.";
							else if(nChange < 0) kGAMECLASS.eventBuffer += " Your suspicions are confirmed, your face has taken on more masculine characteristics.";
							else kGAMECLASS.eventBuffer += " Nothing really changed at all.";
						}
					}
					else
					{
						kGAMECLASS.eventBuffer += target.femininityLockedMessage();
					}
				}
				//#8 Change legs and feet to humanoid: Legs become normal human legs. Advances time by 20 minutes when it triggers.
				else if(select == 8)
				{
					if(target.legTypeUnlocked(GLOBAL.TYPE_HUMAN) && target.legCountUnlocked(2))
					{
						//Transformation text:
						kGAMECLASS.eventBuffer += "The pain of transformation suddenly rushes through your [pc.legOrLegs]. You have no choice but to find a safe place to huddle down and wait for the process to finish. It is an uncomfortable twenty minutes wait for the process to finish, but thankfully what you’re changing into isn’t hugely outlandish. The joints reform and reshape themselves into human-like legs and feet. After a few ginger steps and bends of the knee, you find the sensation of being a plantigrade biped coming quite naturally.";
						
						kGAMECLASS.processTime(15 + rand(10));
						target.legType = GLOBAL.TYPE_HUMAN;
						target.legCount = 2;
						target.clearLegFlags();
						target.addLegFlag(GLOBAL.FLAG_PLANTIGRADE);
						target.genitalSpot = 0;
					}
					else if(target.legTypeUnlocked(GLOBAL.TYPE_HUMAN))
					{
						kGAMECLASS.eventBuffer += target.legCountLockedMessage();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.legTypeLockedMessage();
					}
				}
				//#9 Change arms to human: Arms change to human arms. Advances time by 15 minutes when it triggers.
				else if(select == 9)
				{
					if(target.armTypeUnlocked(GLOBAL.TYPE_HUMAN))
					{
						// Transformation text:
						kGAMECLASS.eventBuffer += "The flesh in your [pc.arms] feels weak and palpitant, and as the sensation increases, you find yourself unable to do anything with them.";
						if(target.hasFur()) kGAMECLASS.eventBuffer += " Fur sloughs off them in big, uneven chunks.";
						kGAMECLASS.eventBuffer += " It’s with some relief when after about fifteen minutes the transformation completes, and you are able to move your now human arms around and admire them in all their lightly haired, elbow-y glory.";
						
						kGAMECLASS.processTime(10 + rand(8));
						target.armType = GLOBAL.TYPE_HUMAN;
						target.clearArmFlags();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.armTypeLockedMessage();
					}
				}
				//#10 Remove tail: Remove tail.
				else if(select == 10)
				{
					if(target.tailTypeUnlocked(0) && target.tailCountUnlocked(0))
					{
						// Requires a non-parasitic tail or tails and humanoid legs. Remove tail.
						// Transformation text:
						kGAMECLASS.eventBuffer += "For the last little while you feel like you’re missing something. After checking your pockets and possessions, you suddenly become aware that you’ve managed to lose your tail";
						if(target.tailCount != 1) kGAMECLASS.eventBuffer += "s";
						kGAMECLASS.eventBuffer += " somewhere! <b>You no longer have";
						if(target.tailCount == 1) kGAMECLASS.eventBuffer += " a tail";
						else kGAMECLASS.eventBuffer += " any tails";
						kGAMECLASS.eventBuffer += ".</b>";
						
						target.removeTails();
					}
					else if(target.tailTypeUnlocked(0))
					{
						kGAMECLASS.eventBuffer += target.tailCountLockedMessage();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.tailTypeLockedMessage();
					}
				}
				totalTFs--;
			}
			return;
		}
		//#5b Goblin face: Stage two happens 30 minutes after stage 1 ends, and the face type only changes when stage 2 triggers.
		public function itemGoblinFaceTFGo(target:Creature):void
		{
			// Transformation text (stage 2):
			kGAMECLASS.eventBuffer += "Finally the pain in your face subsides, and you take a deep breath. You check to see what the damage is and find that your face has restructured itself. Your nose has grown longer and pointier, while your jaw has narrowed a fair bit giving your face a more angular appearance not unlike that of an upside down triangle. <b>You now have a gabilani face!</b>";
			// Actual face type change
			target.faceType = GLOBAL.TYPE_GABILANI;
			target.clearFaceFlags();
			target.addFaceFlag(GLOBAL.FLAG_ANGULAR);
			target.removeStatusEffect("Gabilani Face Change");
		}
		// Sexual and Stat Changes and Perks
		private function majorGoblinMutations(target:Creature):void
		{
			//How many TFs? Max of 2.
			var totalTFs:Number = Math.floor(target.statusEffectv2("Goblinola Bar")/2);
			if(totalTFs < 1) totalTFs = 1;
			//Used for holding temporary garbage
			var x:int = 0;
			//Used to hold the TF we pull out of the array of effects
			var select:int = 0;
			
			//Build a list of all potential TFs
			var TFList:Array = new Array();
			//#1 Goblin cock: Requires at least one non-goblin cock.
			if(target.cockTotal(GLOBAL.TYPE_GABILANI) < target.cocks.length)
				TFList[TFList.length] = 1;
			//#2 Goblin vagina: Requires at least one non-goblin vagina.
			if(target.totalVaginas(GLOBAL.TYPE_GABILANI) < target.vaginas.length)
				TFList[TFList.length] = 2;
			//#3 Goblin cum: Requires non-oily grey cum and at least one goblin dick.
			if(target.hasCock(GLOBAL.TYPE_GABILANI) && target.cumType != GLOBAL.FLUID_TYPE_GABILANI_CUM)
				TFList[TFList.length] = 3;
			//#4 Goblin girlcum: Requires non-oily grey girlcum, and at least one goblin vagina.
			if(target.hasVaginaType(GLOBAL.TYPE_GABILANI) && target.girlCumType != GLOBAL.FLUID_TYPE_GABILANI_GIRLCUM)
				TFList[TFList.length] = 4;
			//#5 Intelligence increase towards 85%
			if(target.IQ() < 85)
				TFList[TFList.length] = 5;
			//#6 Reflexes increase towards 60%
			if(target.RQ() < 60)
				TFList[TFList.length] = 6;
			//#7 Physique decrease towards 30%
			if(target.PQ() > 30)
				TFList[TFList.length] = 7;
			//#8 Fertility increase/Libido increase towards 80%
			if(target.libido() < 80)
				TFList[TFList.length] = 8;
			//#9 If fully morphed: Hips plus butt increase by 1 after every pregnancy
			if(target.hasVagina() && (target.race() == "gabilani" || (target.isPregnant() && rand(4) == 0)) && !target.hasPerk("Fecund Figure"))
				TFList[TFList.length] = 9;
			//#10 If fully morphed: Some sort of cybernetics bonus if/when that ever happens
			if(((target.race() == "gabilani" && target.isCyborg()) || (target.isCyborg(2) && rand(4) == 0)) && !target.hasPerk("Cybernetic Synchronization"))
				TFList[TFList.length] = 10;
			
			//Loop through doing TFs until we run out, pulling out whichever we use.
			while(TFList.length > 0 && totalTFs > 0)
			{
				var i:int = 0;
				var n:int = 0;
				var cockList:Array = [];
				var cuntList:Array = [];
				
				kGAMECLASS.eventBuffer += "\n\n";
				//Pick a TF	
				x = rand(TFList.length);
				select = TFList[x];
				//Cull 'dat TF from the list.
				TFList.splice(x,1);
				//#0 Catch all
				if(select == 0)
				{
					kGAMECLASS.eventBuffer += "Your stomach gives an audible gurgle. It is still a bit unsettled by the health bar.";
				}
				//#1 Goblin cock: One cock turns into a goblin cock. This increases the PC's lust.
				else if(select == 1)
				{
					// Look for eligible penises
					for(i = 0; i < target.cocks.length; i++)
					{
						if(target.cocks[i].cType != GLOBAL.TYPE_GABILANI) cockList.push(i);
					}
					// Select random penis!
					n = cockList[rand(cockList.length)];
					
					if(target.cockTypeUnlocked(n, GLOBAL.TYPE_GABILANI))
					{
						// Transformation text (PC has undergarments):
						if(target.hasLowerGarment()) kGAMECLASS.eventBuffer += "Your [pc.cock " + n + "] tingles, rubbing against your [pc.lowerUndergarment] somewhat uncomfortably. Finally you check what’s going on downstairs and discover that your member has actually reformed into an alien cock!";
						// Transformation text (PC has no undergarments, but does lower garments):
						else if(target.isCrotchGarbed()) kGAMECLASS.eventBuffer += "Your [pc.cock " + n + "] tingles, rubbing against your [pc.lowerGarments] somewhat uncomfortably. Finally you check what’s going on downstairs and discover that your member has actually reformed into an alien cock!";
						// Transformation text (PC has no undergarments, or lower garments):
						else kGAMECLASS.eventBuffer += "Your [pc.cock " + n + "] tingles, feeling somewhat uncomfortable as the air moves around it. Finally you check what’s going on downstairs and discover that your member has actually reformed into an alien cock!";
						kGAMECLASS.eventBuffer += " Its tip is now a pair of spherical crowns separated with a deep ridge with an otherwise relatively human shaft linking it to your crotch. <b>You now have a gabilani cock!</b>";
						
						target.shiftCock(n, GLOBAL.TYPE_GABILANI);
						target.removeStatusEffect("Genital Slit");
						target.lust(20 + rand(30));
					}
					else
					{
						kGAMECLASS.eventBuffer += target.cockTypeLockedMessage();
					}
				}
				//#2 Goblin vagina: One vagina turns into a goblin vagina. This increases the PC's lust.
				else if(select == 2)
				{
					// Look for eligible vagainas
					for(i = 0; i < target.vaginas.length; i++)
					{
						if(target.vaginas[i].type != GLOBAL.TYPE_GABILANI) cuntList.push(i);
					}
					// Select random vagina!
					n = RandomInCollection(cuntList);
					
					if(target.vaginaTypeUnlocked(n, GLOBAL.TYPE_GABILANI))
					{
						// Transformation text 
						kGAMECLASS.eventBuffer += "A strange feeling in your nethers overtakes you, eliciting an unexpected moan of pleasure from your lips. After basking in the sensation for a few moments, you give an experimental pull and discover that a whole new set of muscles have grown in and around";
						// If PC has multiple vaginas:
						if(target.vaginas.length > 0) kGAMECLASS.eventBuffer += " one of";
						kGAMECLASS.eventBuffer += " your female sex";
						if(target.vaginas.length > 0) kGAMECLASS.eventBuffer += "es";
						kGAMECLASS.eventBuffer += " which you can control with great ease.";
						// (non-human vagina)
						if(target.vaginas[n].type != GLOBAL.TYPE_HUMAN) kGAMECLASS.eventBuffer += " After checking its appearance, you find that from the outside it looks pretty close to a human’s.";
						kGAMECLASS.eventBuffer += " <b>You now have a";
						if(target.totalVaginas(GLOBAL.TYPE_GABILANI) > 0) kGAMECLASS.eventBuffer += "nother";
						kGAMECLASS.eventBuffer += " gabilani vagina!</b>";
						
						target.shiftVagina(n, GLOBAL.TYPE_GABILANI);
						// Increase capacity but also increase tightness.
						if(target.vaginas[n].loosenessRaw > 1) target.vaginas[n].loosenessRaw -= 1;
						if(target.vaginas[n].loosenessRaw < 0.5) target.vaginas[n].loosenessRaw = 0.5;
						if(target.vaginas[n].bonusCapacity < 2000) target.vaginas[n].bonusCapacity = 2000;
						else target.vaginas[n].bonusCapacity += 500;
						target.lust(10 + rand(20));
					}
					else
					{
						kGAMECLASS.eventBuffer += target.vaginaTypeLockedMessage();
					}
				}
				//#3 Goblin cum: Cum changes to oily grey cum.
				else if(select == 3)
				{
					if(target.cumTypeUnlocked(GLOBAL.FLUID_TYPE_GABILANI_CUM))
					{
						// Transformation text:
						kGAMECLASS.eventBuffer += "You grunt in surprise";
						//Not exhibitionist:
						if(target.exhibitionism() < 50) kGAMECLASS.eventBuffer += " and slight embarrassment";
						kGAMECLASS.eventBuffer += " as [pc.eachCock] swells up and oozes pre in a burst of hard heat. You cautiously touch and examine it with your fingers. It’s warm and smells musky as ever, but the color and texture of it has changed to a semi-transparent oil. You snort as you imagine attempting to massage someone with it. <b>You now ejaculate gabilani cum.</b>";
						
						target.cumType = GLOBAL.FLUID_TYPE_GABILANI_CUM;
					}
					else
					{
						kGAMECLASS.eventBuffer += target.cumTypeLockedMessage();
					}
				}
				//#4 Goblin girlcum: Girlcum turns into oily gray girlcum. The PC cums in the scene, resetting lust and time since last orgasm.
				else if(select == 4)
				{
					if(target.girlCumTypeUnlocked(GLOBAL.FLUID_TYPE_GABILANI_GIRLCUM))
					{
						// Transformation text:
						kGAMECLASS.eventBuffer += "The muscles of your alien pussy quiver pleasantly and you feel an incredible urge to fill them with whatever is at hand, which ends up being exactly what you stick in there. After fingering yourself to orgasm, you check your fingers and discover they’re covered in a very oily grey liquid, very different from your usual discharge. <b>You now have gabilani girlcum!</b>";
						
						target.girlCumType = GLOBAL.FLUID_TYPE_GABILANI_GIRLCUM;
						target.orgasm();
					}
					else
					{
						kGAMECLASS.eventBuffer += target.girlCumTypeLockedMessage();
					}
				}
				//#5 Intelligence increase towards 85%
				else if(select == 5)
				{
					// < 60% Intel:
					if(target.IQ() <= 60) kGAMECLASS.eventBuffer += "The unsettlement in your gut spreads to your head as you continue about your business. More and more thoughts, observations and conjectures about your recent experiences cram themselves into your mind’s eye until you’re weighed down under a migraine. It fades, though, and once it does you feel like your ability to digest information has improved.";
					// > 60% Intel:
					else kGAMECLASS.eventBuffer += "A headache pulses behind your brow as your brain rewires itself slightly. You see yet more layers of information splitting off everything you observe; the immediate impulses coursing through your mind is how you might exploit it, how you might grasp your realizations and do something fantastical with it before anyone else does. It’s an awesome and more than slightly eerie sensation.";
					
					target.intelligence(2);
				}
				//#6 Reflexes increase towards 60%
				else if(select == 6)
				{
					kGAMECLASS.eventBuffer += "Your movements feel jerkier, as if your joints were acting up. As your perception adapts, though, you realize that in actuality you are now reacting and moving slightly faster.";
					
					target.reflexes(2);
				}
				//#7 Physique decrease towards 30%
				else if(select == 7)
				{
					// > 60% Phy:
					if(target.PQ() >= 60) kGAMECLASS.eventBuffer += "The muscles in your arms and [pc.lowerBody] feel like they’re getting softer and more supple as time goes on, and you’re left with the uneasy impression you’re not as physically capable as you once were. What kind of health food was that, anyway?";
					// < 60% Phy:
					else kGAMECLASS.eventBuffer += "You huff for breath and wipe your brow, heart hammering from all the physical exertion you’ve been putting yourself through recently. In irritation you find yourself dreaming up all sorts of contraptions you could design to ferry yourself around, saving yourself all this unnecessary effort...";
					
					target.physique(-2);
				}
				//#8 Fertility increase/Libido increase towards 80%
				else if(select == 8)
				{
					kGAMECLASS.eventBuffer += "You " + target.mf("growl","purr") + " with enjoyment as liquid heat sinks down from your tummy to your groin,";
					if(target.balls > 0)
					{
						kGAMECLASS.eventBuffer += " your [pc.balls] swelling in gratification";
						target.cumQualityRaw += 1;
					}
					if(target.balls > 0 && target.hasVagina()) kGAMECLASS.eventBuffer += " and";
					if(target.hasVagina())
					{
						kGAMECLASS.eventBuffer += " [pc.eachVagina] moistening with anticipatory need";
						target.fertilityRaw += 1;
					}
					kGAMECLASS.eventBuffer += ". An increasingly tigrish and prickly urge to breed is stealing over you.";
					
					//Lust increase
					target.lust(30 + rand(50));
				}
				//#9 If fully morphed: Hips plus butt increase by 1 after every pregnancy
				else if(select == 9)
				{
					kGAMECLASS.eventBuffer += "Hm, you feel a little more bottom heavy than usual. You squeeze your [pc.hip] only to find it getting taut between your fingers. Giving your [pc.butt] a slap, it rebounds back with an odd sensation. Your body seems to have changed to adapt to its fertile nature, flaring out and becoming womanly, at least for your lower body anyway...";
					kGAMECLASS.eventBuffer += "\n\n<b>Perk Gained: Fecund Figure</b> - Gradually, your hips and ass will permanently increase in size during pregnancy.";
					
					// Perk: "Fecund Figure"
					// v1: hip size bonus
					// v2: butt size bonus
					// v3: belly size bonus (maybe)
					// v4: growth gains (adds per day while pregnant or post-pregnancy)
					target.createPerk("Fecund Figure", 1, 1, 0, 0, "Your broodmare body permanently changes you more into a fertility goddess while you are pregnant.");
				}
				//#10 If fully morphed: Some sort of cybernetics bonus if/when that ever happens
				else if(select == 10)
				{
					kGAMECLASS.eventBuffer += "Your mind frees up all of a sudden, as if any intrusive or distracting thoughts have been neatly organized and packed away. Your bond with robotics must have advanced and adapted on a deeper biological level. You feel that the more you interact with technology, the more you will be able to learn and retain. You have definitely become one with the machine.";
					kGAMECLASS.eventBuffer += "\n\n<b>Perk Gained: Cybernetic Synchronization</b> - Being naturally inclined to technology, your body and mind become one with machine, augmenting your intelligence with each cybernetic enhancement.";
					
					// Perk: "Cybernetic Synchronization"
					// v1: max intelligence bonus for each enhancement
					// v2: ???
					// v3: ???
					// v4: ???
					target.createPerk("Cybernetic Synchronization", 5, 0, 0, 0, "Cybernetic enhancements will give you an additional intelligence capacity boost.");
				}
				totalTFs--;
			}
			return;
		}
		
		// Potentials for TFs
		public function itemGoblinTF(done:Boolean = false):void
		{
			kGAMECLASS.eventBuffer += "\n\n<u>The goblinola bar has an effect....</u>";
			
			var target:Creature = kGAMECLASS.chars["PC"];
			var oddsOfMajorTF:int = target.statusEffectv2("Goblinola Bar") * 20;
			
			if(oddsOfMajorTF >= rand(100) + 1)
			{
				majorGoblinMutations(target);
			}
			else minorGoblinMutations(target);
			
			// Transformation effects end:
			if(done)
			{
				if(target.hasStatusEffect("Gabilani Face Change"))
				{
					kGAMECLASS.eventBuffer += "\n\nThe pain in your finally face subsides. You check yourself to find that it has been left unchanged.";
					target.removeStatusEffect("Gabilani Face Change");
				}
				kGAMECLASS.eventBuffer += "\n\nYou notice that your stomach seems to have settled down now. <b>You’re unlikely to feel any more effects from the goblinola you ate earlier.</b>";
			}
			
			clearMenu();
			addButton(0, "Next", kGAMECLASS.mainGameMenu);
		}
		// Face Transformation:
		public function itemGoblinFaceTF():void
		{
			itemGoblinFaceTFGo(kGAMECLASS.chars["PC"]);
		}
		// Finish!
		public function itemEndGoblinTF():void
		{
			itemGoblinTF(true);
			clearMenu();
			addButton(0,"Next",kGAMECLASS.mainGameMenu);
		}
		
		//METHOD ACTING!
		override public function useFunction(target:Creature, usingCreature:Creature = null):Boolean
		{
			kGAMECLASS.author("Nonesuch");
			
			var healing:int = 25;
			if(target is PlayerCharacter)
			{
				clearOutput();
				// Consuming:
				output("You unwrap the goblinola and munch on the stuff. There are some constants that hold true the galaxy over, and health snacks are one of them: It’s reasonably tasty, takes a while to chew and is vaguely unsatisfying. Your stomach is left a little unsettled. (<b>+" + healing + " HP</b>)");
				output("\n");
				
				// Immediate effects: The player gains some health.
				target.HP(healing);
				
				// They then gain a hidden status effect for goblin transformations.
				// These happen at random during the item's duration, but can only start happening an hour after the item was consumed.
				
				// time: 4-8 hours of the effect
				var timerStamp:int = (240 + rand(241));
				
				if(target.hasStatusEffect("Goblinola Bar"))
				{
					// If already under effects, reset timer!
					target.setStatusValue("Goblinola Bar", 1, timerStamp);
					target.setStatusMinutes("Goblinola Bar", timerStamp);
					// Increase chance for major TFs!
					if(target.statusEffectv2("Goblinola Bar") < 4) target.addStatusValue("Goblinola Bar",2,1);
				}
				else
				{
					// "Goblinola Bar"
					// v1: Timestamp!
					// v2: Number of major transformations
					target.createStatusEffect("Goblinola Bar", timerStamp, 1, 0, 0, false, "Icon_Poison", "Your stomach is a little unsettled by the health bar you ate...", false, timerStamp);
				}
				
				return true;
			}
			//Not the player!
			else
			{
				if(kGAMECLASS.inCombat()) output("\n");
				else clearOutput();
				output(target.capitalA + target.short + " unwraps and eats the bar, revitalizing some of [target.hisHer] health! (<b>+" + healing + " HP</b>)");
				target.HP(healing);
				output("\n");
			}
			return false;
		}
	}
}