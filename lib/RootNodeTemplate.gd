extends Node

# "/root/MainScene"
var _path_to_self: String
# [signal_name, func_name, source_node, target_node]
var _signal_bind: Array
# [target_var_name, source_node, target_node]
var _node_ref: Array
# [target_var_name, source_lib, target_node]
var _lib_ref: Array


func _init(_signal: Array = [], _node: Array = [], _lib: Array = []):
	_signal_bind = _signal
	_node_ref = _node
	_lib_ref = _lib


func _ready():
	_set_path()
	_set_signal()
	_set_node_ref()
	_set_lib_ref()


func _set_path():
	_path_to_self = get_path()


func _set_signal():

	for s in _signal_bind:
		# [signal_name, func_name, source_node, target_node]
		for i in range(3, len(s)):
			print("get_node({source}).{signal_name}.connect(get_node({target}).{func})".format(
				{"source":_get_path(s[2]), "signal_name":s[0], "target":_get_path(s[i]), "func":s[1]}))
			get_node(_get_path(s[2]))[s[0]].connect(get_node(_get_path(s[i]))[s[1]])

func _set_node_ref():
	for n in _node_ref:
		# [target_var_name, source_node, target_node]
		for i in range(2, len(n)):
			print("get_node(_get_path({target_node}))[{target_name}] = get_node(_get_path({source}))".format(
				{"target_node":n[i], "target_name":n[0], "source":n[1]}))
			get_node(_get_path(n[i]))[n[0]] = get_node(_get_path(n[1]))

func _set_lib_ref():
	for n in _lib_ref:
		var res = load(n[1]).new()
		for i in range(2, len(n)):
			get_node(_get_path(n[i]))[n[0]] = res


func _get_path(path_to_node: String) -> String:
	#print("{0}/{1}".format([_path_to_self, path_to_node]))
	return "{0}/{1}".format([_path_to_self, path_to_node])
