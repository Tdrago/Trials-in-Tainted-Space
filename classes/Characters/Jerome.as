package classes.Characters
{
	import classes.CockClass;
	import classes.Creature;
	import classes.GLOBAL;
	import classes.Items.Apparel.ComfortableClothes;
	import classes.Items.Guns.*
	import classes.Items.Melee.Fists;
	import classes.GameData.StatTracking;

	public class Jerome extends Creature
	{
		
		
		//constructor
		public function Jerome()
		{
			this._latestVersion = 2;
			this.version = this._latestVersion;
			this._neverSerialize = true;
			
			this.short = "Jerome";
			this.originalRace = "human";
			this.a = "";
			this.capitalA = "";
			this.long = "";
			this.customDodge = "";
			this.customBlock = "";
			this.isPlural = false;
			
			this.meleeWeapon = new Fists();
			this.armor = new ComfortableClothes();
			
			this.armor.defense = 50;
			this.physiqueRaw = 25;
			this.reflexesRaw = 25;
			this.aimRaw = 25;
			this.intelligenceRaw = 15;
			this.willpowerRaw = 10;
			this.libidoRaw = 35;
			this.HPMod = 20;
			this.shieldsRaw = 0;
			this.HPRaw = this.HPMax();
			this.energyRaw = 100;
			this.lustRaw = 40;
			this.level = 7;
			this.XPRaw = normalXP();
			this.credits = 1000;
		
			this.sellMarkup = 1.3;
			this.buyMarkdown = .25;
			this.keeperSell = "boop";
			this.keeperBuy = "bop";
			this.keeperGreeting = "BLOOP.";
			
			this.femininity = 0;
			this.eyeType = 0;
			this.eyeColor = "brown";
			this.tallness = 132;
			this.thickness = 30;
			this.tone = 90;
			this.hairColor = "black";
			this.scaleColor = "FIXME";
			//this.scaleColor = titsPtr.chars["PC"].scaleColor;
			this.furColor = "FIXME";
			//this.furColor = titsPtr.chars["PC"].furColor;
			this.hairLength = 5;
			this.hairType = 0;
			this.beardLength = 0;
			this.beardStyle = 0;
			this.skinType = GLOBAL.SKIN_TYPE_SKIN;
			this.skinTone = "FIXME";
			//this.skinTone = titsPtr.chars["PC"].skinTone;
			this.skinFlags = new Array();
			this.faceType = 0;
			this.faceFlags = new Array();
			this.tongueType = 0;
			this.lipMod = 0;
			this.earType = 0;
			this.antennae = 0;
			this.antennaeType = 0;
			this.horns = 2;
			this.hornType = 0;
			this.armType = 0;
			this.gills = false;
			this.wingType = 0;
			this.legType = GLOBAL.TYPE_HUMAN;
			this.legCount = 2;
			this.legFlags = [GLOBAL.FLAG_PLANTIGRADE];
			//0 - Waist
			//1 - Middle of a long tail. Defaults to waist on bipeds.
			//2 - Between last legs or at end of long tail.
			//3 - On underside of a tail, used for driders and the like, maybe?
			this.genitalSpot = 0;
			this.tailType = 0;
			this.tailCount = 0;
			this.tailFlags = new Array();
			//Used to set cunt or dick type for cunt/dick tails!
			this.tailGenitalArg = 0;
			//tailGenital:
			//0 - none.
			//1 - cock
			//2 - vagina
			this.tailGenital = 0;
			//Tail venom is a 0-100 slider used for tail attacks. Recharges per hour.
			this.tailVenom = 0;
			//Tail recharge determines how fast venom/webs comes back per hour.
			this.tailRecharge = 5;
			//hipRating
			//0 - boyish
			//2 - slender
			//4 - average
			//6 - noticable/ample
			//10 - curvy//flaring
			//15 - child-bearing/fertile
			//20 - inhumanly wide
			this.hipRatingRaw = 10;
			//buttRating
			//0 - buttless
			//2 - tight
			//4 - average
			//6 - noticable
			//8 - large
			//10 - jiggly
			//13 - expansive
			//16 - huge
			//20 - inconceivably large/big/huge etc
			this.buttRatingRaw = 12;
			//No dicks here!
			this.cocks = new Array();
			
			var c:CockClass = new CockClass();
			c.cLengthRaw = 12;
			c.cThicknessRatioRaw = 3;
			c.cType = GLOBAL.TYPE_DRACONIC;
			c.addFlag(GLOBAL.FLAG_RIBBED);
			c.addFlag(GLOBAL.FLAG_NUBBY);
			cocks.push(c);
			
			//balls
			this.balls = 2;
			this.cumMultiplierRaw = 50;
			//Multiplicative value used for impregnation odds. 0 is infertile. Higher is better.
			this.cumQualityRaw = 3;
			this.cumType = GLOBAL.FLUID_TYPE_CUM;
			this.ballSizeRaw = 15;
			this.ballFullness = 100;
			//How many "normal" orgams worth of jizz your balls can hold.
			this.ballEfficiency = 30;
			//Scales from 0 (never produce more) to infinity.
			this.refractoryRate = 10;
			this.minutesSinceCum = 1650;
			this.timesCum = 899;
			
			//Goo is hyper friendly!
			this.elasticity = 3;
			//Fertility is a % out of 100. 
			this.fertilityRaw = 1.05;
			this.pregnancyMultiplierRaw = 1;
			
			this.breastRows[0].breastRatingRaw = 0;
			this.nippleColor = "brown";
			this.milkMultiplier = 0;
			this.milkType = GLOBAL.FLUID_TYPE_MILK;
			//The rate at which you produce milk. Scales from 0 to INFINITY.
			this.milkRate = 0;
			this.ass.wetnessRaw = 0;
			ass.loosenessRaw = 4;
			
			this.version = _latestVersion;
			this._isLoading = false;
		}
		
		public function UpgradeVersion1(dataObject:Object):void
		{
			// Clear out this shit and let the default constructor handle it.
			delete dataObject.meleeWeapon;
			delete dataObject.rangedWeapon;
			delete dataObject.lustVuln;
			delete dataObject.resistances;
			delete dataObject.bonusResistances;
			delete dataObject.bonusLustVuln;
		}
		
		override public function orgasm():void
		{
			// Hacking around base orgasm mechanics because this guys just cpt. cumbuckets 24/7
			StatTracking.track("characters/" + short + "/orgasms");
			timesCum++;
		}
	}
}