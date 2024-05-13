extends Node

var host = "http://102.152.195.26"
signal Message(content)
var http_request = HTTPRequest.new()
var CurrentAccount = ""
func _ready():
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	

func _http_request_completed(result, response_code, headers, body:PackedByteArray):
	Message.emit(body.get_string_from_utf8())
	print(body.get_string_from_utf8())


func Send(RQ):
	http_request.request(host+RQ)
