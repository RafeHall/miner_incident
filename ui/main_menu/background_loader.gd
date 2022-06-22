var _thread: Thread = Thread.new();
var _mutex: Mutex = Mutex.new();
var _done: bool = false;


func load_res(path: String) -> void:
	_thread.start(self, "_load_res", path, Thread.PRIORITY_HIGH);


func done() -> bool:
	var result = false;
	
	_lock();
	if _done:
		result = true;
	_unlock();
	
	return result;


func get_res() -> Resource:
	var result = null;
	
	_lock();
	if _done:
		result = _thread.wait_to_finish();
	_unlock();
	
	return result;


func dispose() -> void:
	if _thread.is_active():
		_thread.wait_to_finish();
	_unlock();


func _lock() -> void:
	_mutex.lock();


func _unlock() -> void:
	_mutex.unlock();


func _load_res(path: String) -> Resource:
	var resource = load(path);
	
	_lock();
	_done = true;
	_unlock();
	
	return resource;
