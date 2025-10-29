class_name ProjectVersion
extends Node

const VERSION_FILE_PATH := "res://version.txt"

static var version: String

static func get_line() -> String:
	if version.is_empty():
		version = _read_version()
	return version

static func _read_version() -> String:
	var access := FileAccess.open(VERSION_FILE_PATH, FileAccess.READ)
	var file_version := access.get_line()
	access.close()
	return file_version
