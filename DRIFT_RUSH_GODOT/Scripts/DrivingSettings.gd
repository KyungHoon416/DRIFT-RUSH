extends RefCounted
var sensitivity := 1.0
var deadzone := 0.08
var invert := false
var tilt_enabled := true
var vibration := true
var volume := 0.7
var neutral := 0.0
var kart_color := "ff8b27"
const COLORS = ["ff8b27", "32c7e8", "ed80b6", "99dc81"]
const PATH = "user://driving_settings.cfg"
func load_settings(path := PATH):
 var cfg := ConfigFile.new()
 if cfg.load(path)!=OK: return
 var saved_color: String = str(cfg.get_value("garage","color","ff8b27"))
 kart_color=saved_color if saved_color in COLORS else "ff8b27"
 sensitivity=clampf(float(cfg.get_value("controls","sensitivity",1.0)),0.5,2.0)
 deadzone=clampf(float(cfg.get_value("controls","deadzone",0.08)),0.0,0.3)
 invert=bool(cfg.get_value("controls","invert",false))
 tilt_enabled=bool(cfg.get_value("controls","tilt",true))
 vibration=bool(cfg.get_value("feedback","vibration",true))
 volume=clampf(float(cfg.get_value("feedback","volume",0.7)),0,1)
func save_settings(path := PATH) -> Error:
 var cfg := ConfigFile.new()
 cfg.set_value("garage","color",kart_color)
 cfg.set_value("controls","sensitivity",sensitivity)
 cfg.set_value("controls","deadzone",deadzone)
 cfg.set_value("controls","invert",invert)
 cfg.set_value("controls","tilt",tilt_enabled)
 cfg.set_value("feedback","vibration",vibration)
 cfg.set_value("feedback","volume",volume)
 return cfg.save(path)
func calibrate(gravity: Vector3) -> bool:
 if gravity.length()<0.1: return false
 neutral=gravity.x
 return true
func tilt_value(gravity: Vector3) -> float:
 if not tilt_enabled or gravity.length()<0.1: return 0.0
 var value := clampf((gravity.x-neutral)/4.0,-1,1)
 if absf(value)<=deadzone: return 0.0
 value=signf(value)*(absf(value)-deadzone)/(1.0-deadzone)
 return clampf(value*sensitivity*(-1 if invert else 1),-1,1)
