Class {
	#name : #GDBExecSignalReceivedEvent,
	#superclass : #GDBExecStopInFrameEvent,
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #visiting }
GDBExecSignalReceivedEvent >> processWith: eventHandler [
	^ eventHandler onExecSignalReceived: self
]
