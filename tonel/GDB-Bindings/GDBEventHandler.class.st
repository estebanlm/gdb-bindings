"
I am event handler for events fired by gdb.
"
Class {
	#name : #GDBEventHandler,
	#superclass : #Object,
	#instVars : [
		'announcer'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #events }
GDBEventHandler >> dispatchEvent: event [
	UIManager default defer: [ self processEvent: event ]
]

{ #category : #'as yet unclassified' }
GDBEventHandler >> onConsoleOutput: aString [
]

{ #category : #events }
GDBEventHandler >> onExecBreakpointHitEvent: event [
	
]

{ #category : #events }
GDBEventHandler >> onExecEndSteppingRange: event [
	
]

{ #category : #events }
GDBEventHandler >> onExecExitedEvent: event [
	
]

{ #category : #events }
GDBEventHandler >> onExecRunningEvent: event [
]

{ #category : #events }
GDBEventHandler >> onExecSignalReceived: event [
	
]

{ #category : #events }
GDBEventHandler >> onExecStoppedEvent: event [
	
]

{ #category : #'as yet unclassified' }
GDBEventHandler >> onLogOutput: aString [
]

{ #category : #'as yet unclassified' }
GDBEventHandler >> onTargetErrorOutput: aString [
]

{ #category : #'as yet unclassified' }
GDBEventHandler >> onTargetOutput: aString [
]

{ #category : #'events-processing' }
GDBEventHandler >> processEvent: event [
	^ event processWith: self
]
