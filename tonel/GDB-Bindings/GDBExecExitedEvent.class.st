Class {
	#name : #GDBExecExitedEvent,
	#superclass : #GDBExecStoppedEvent,
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #visiting }
GDBExecExitedEvent >> processWith: eventHandler [
	^ eventHandler onExecExitedEvent: self
]
