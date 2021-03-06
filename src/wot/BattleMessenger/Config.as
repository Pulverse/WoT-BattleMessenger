import wot.BattleMessenger.utils.Utils;
import wot.BattleMessenger.utils.GlobalEventDispatcher;
//import com.xvm.Logger;

class wot.BattleMessenger.Config
{
	private static var CONFIG_FILE:String = "BattleMessenger.conf";
	
	public static var EVENT_CONFIG_LOADED:String = "config_loaded";
	
	private static var _config:Object;
	private static var _loaded:Boolean = false;
	
	private static var _error:String = null;
	
	private static var _defaultConfig:Object = {
		enabled: true,
		chatLength: 10,
		backgroundAlpha: 100,
		ignore: {
			clan: true,
			squad: true,
			companyBattle: true,
			specialBattle: true,
			trainingBattle: true,
			randomBattle: false
		},
		blockAlly: {
			dead: false,
			alive: false
		},
		blockEnemy: {
			dead: false,
			alive: false
		},
		antispam: {
			enabled: false,
			duplicateCount: 2,
			duplicateInterval: 7,
			playerCount: 3,
			playerInterval: 7,
			WG_Filters: false,
			customFilters: []
		},
		xvm: {
			enabled: false,
			minRating: 0
		},
		debugMode: false
	};
	
	private static var _customFilters:Array = new Array();
		
	public static function get enabled():Boolean    {
        return battleMessenger.enabled;
	}
	
	/** Chat setting */
	public static function get chatLength():Number   {
        return battleMessenger.chatLength;
	}
	
	public static function get backgroundAlpha():Number {
		return battleMessenger.backgroundAlpha;
	}
	
	/** Ignore */
	public static function get ignoreClan():Boolean   {
        return battleMessenger.ignore.clan;
	}
	
	public static function get ignoreSquad():Boolean   {
        return battleMessenger.ignore.squad;
	}	
	
	public static function get ignoreCompanyBattle():Boolean   {
        return battleMessenger.ignore.companyBattle;
	}
	
	public static function get ignoreSpecialBattle():Boolean   {
        return battleMessenger.ignore.specialBattle;
	}
	
	public static function get ignoreTrainingBattle():Boolean   {
        return battleMessenger.ignore.trainingBattle;
	}
	
	public static function get ignoreRandomBattle():Boolean   {
        return battleMessenger.ignore.randomBattle;
	}
	
	/** Blokers */
	public static function get blockAllyDead():Boolean   {
        return battleMessenger.blockAlly.dead;
	}
	
	public static function get blockAllyAlive():Boolean   {
        return battleMessenger.blockAlly.alive;
	}
	
	public static function get blockEnemyDead():Boolean   {
        return battleMessenger.blockEnemy.dead;
	}
	
	public static function get blockEnemyAlive():Boolean   {
        return battleMessenger.blockEnemy.alive;
	}
	
	/** Antispam */
	public static function get antispamEnabled():Boolean   {
        return antispam.enabled;
	}
	
	public static function get antispamDuplcateCount():Number   {
        return antispam.duplicateCount;
	}
	
	public static function get antispamDuplicateInterval():Number   {
        return antispam.duplicateInterval;
	}
	
	public static function get antispamPlayerCount():Number   {
        return antispam.playerCount;
	}
	
	public static function get antispamPlayerInterval():Number   {
        return antispam.playerInterval;
	}
	
	public static function get antispamWGFiltersEnabled():Boolean	{
		return antispam.WG_Filters;
	}
	
	public static function get antispamCustomFilters():Array   {
		if (_customFilters.length == 0) {
			for (var i in antispam.customFilters) {
				_customFilters.push(antispam.customFilters[i]);
			}
		}
        return _customFilters;
	}
	
	/** XVM */
	public static function get xvmEnabled():Boolean	{
		return battleMessenger.xvm.enabled;
	}
	
	public static function get xvmMinRating():Number {
		return battleMessenger.xvm.minRating;
	}
	
	public static function get debugMode():Boolean   {
        return battleMessenger.debugMode;
	}
	
	
	/** private */
	private static function get battleMessenger():Object
    {
        return _config;
    }
	
	private static function get blockAlly():Object
    {
        return battleMessenger.blockAlly;
    }
	
	private static function get blockEnemy():Object
    {
        return battleMessenger.blockEnemy;
    }
	
	private static function get antispam():Object
    {
        return battleMessenger.antispam;
    }
	
	/** Load config from file */
	public static function loadConfig()	{
		if (_config) return;
		
		var lv:LoadVars = new LoadVars();
		lv.onData = onLoadConfig;
        lv.load(CONFIG_FILE);
	}
	
	private static function onLoadConfig(str:String) {
		
		if (str) {
			try {
				var userConfig = com.xvm.JSON.parse(str);
				if (userConfig) {
					_config = Utils.MergeConfigs(userConfig, _defaultConfig);
				}
			}catch (ex) {
				var head = ex.at > 0 ? str.substring(0, ex.at) : "";
				head = head.split("\r").join("").split("\n").join("");
				while (head.indexOf("  ") != -1)
					head = head.split("  ").join(" ");
				head = head.substr(head.length - 75, 75);

				var tail = (ex.at + 1 < str.length) ? str.substring(ex.at + 1, str.length) : "";
				tail = tail.split("\r").join("").split("\n").join("");
				while (tail.indexOf("  ") != -1)
					tail = tail.split("  ").join(" ");

				var text:String = "Error loading config file \n" +
					"[" + ex.at + "] " + Utils.trim(ex.name) + ": " + Utils.trim(ex.message) + "\n  " +
					head + ">>>" + str.charAt(ex.at) + "<<<" + tail;
				_error = text;
			}
		}
		/** set default config */
		if (!_config) _config = _defaultConfig;
		
		_loaded = true;
		GlobalEventDispatcher.dispatchEvent({type: EVENT_CONFIG_LOADED});
	}
	
	public static function get error():String {
		return _error;
	}
	
	public static function isLoaded():Boolean {
		return _loaded;
	}
}