Class {
	#name : #GDBExecEndSteppingRangeEvent,
	#superclass : #GDBExecStopInFrameEvent,
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #visiting }
GDBExecEndSteppingRangeEvent >> processWith: eventHandler [
	^ eventHandler onExecEndSteppingRange: self
]
