Class {
	#name : #GDBExecStopInFrameEvent,
	#superclass : #GDBExecStoppedEvent,
	#instVars : [
		'frame'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBExecStopInFrameEvent >> frame [
	^ frame
]

{ #category : #accessing }
GDBExecStopInFrameEvent >> frame: anObject [
	frame := anObject
]

{ #category : #parsing }
GDBExecStopInFrameEvent >> parseEventData: eventData [
	super parseEventData: eventData.
	frame := GDBStackFrame for: gdb from: (eventData at: #frame).
	frame thread: (eventData at: 'thread-id') asInteger
]
