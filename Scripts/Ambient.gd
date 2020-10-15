extends Node2D

onready var WIcon = $WeatherIcon
onready var CLabel = $CityLabel
onready var TLabel = $TempLabel
onready var BGTex = $bg/bgtext
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var climateicons={
	"rain":"rainyWeather",
	"storm":"stormyWeather",
	"cloud":"cloudyWeather",
	"cloudly_day":"variableWeather",
	"clear_day":"sunnyWeather",
}
var climatebgday={
	"rain":"rainy22",
	"storm":"rainy22",
	"cloud":"rainy2",
	"cloudly_day":"rainy2",
	"clear_day":"sky2",
}

# Called when the node enters the scene tree for the first time.
func _ready():
	$WeatherRequest.connect("request_completed", self, "_on_request_completed")
	
	pass # Replace with function body.

func input(delta):
	if(Input.is_action_just_released("ui_accept")):
		$WeatherRequest.request("https://api.hgbrasil.com/weather?fields=only_results,temp,city_name,condition_slug&key=de918127&user_ip=remote")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	input(delta)
	
	pass
	
func _on_request_completed(result, response_code, headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	WIcon.texture = load("res://Sprites/Weather Icon Set/" + climateicons[json.result.condition_slug] + ".png")
	BGTex.texture = load("res://Sprites/bgs/" + climatebgday[json.result.condition_slug] + ".png")
	if (climatebgday[json.result.condition_slug] == "rain" or climatebgday[json.result.condition_slug] == "storm"):
		$Rain.set_visible(true)
	if (climatebgday[json.result.condition_slug] == "rain"):
		$RainWeak.play()
	elif (climatebgday[json.result.condition_slug] == "storm"):
		$RainStrong.play()


	CLabel.text = json.result.city_name
	TLabel.text = str(json.result.temp) + "° C"
