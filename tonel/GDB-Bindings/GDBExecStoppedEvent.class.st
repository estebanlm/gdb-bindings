Class {
	#name : #GDBExecStoppedEvent,
	#superclass : #GDBExecEvent,
	#instVars : [
		'reason'
	],
	#classVars : [
		'ReasonEventClassMap'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #'instance creation' }
GDBExecStoppedEvent class >> for: gdb with: eventData [
	| reason |
	reason := eventData at: #reason.
	^ ((ReasonEventClassMap at: reason ifAbsent: [ self ]) for: gdb)
		parseEventData: eventData
]

{ #category : #'class initialization' }
GDBExecStoppedEvent class >> initialize [
	ReasonEventClassMap := Dictionary newFromPairs: {
		'breakpoint-hit' . GDBExecBreakpointHitEvent .
		'signal-received' . GDBExecSignalReceivedEvent .
		'end-stepping-range' . GDBExecEndSteppingRangeEvent .
		'exited' . GDBExecExitedEvent .
		'exited-normally' . GDBExecExitedEvent .
	}.
]

{ #category : #parsing }
GDBExecStoppedEvent >> parseEventData: eventData [
	reason := eventData at: #reason.
]

{ #category : #visiting }
GDBExecStoppedEvent >> processWith: eventHandler [
	^ eventHandler onExecStoppedEvent: self
]

{ #category : #accessing }
GDBExecStoppedEvent >> reason [
	^ reason
]

{ #category : #accessing }
GDBExecStoppedEvent >> reason: anObject [
	reason := anObject
]
