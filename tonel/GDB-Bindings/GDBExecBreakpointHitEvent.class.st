Class {
	#name : #GDBExecBreakpointHitEvent,
	#superclass : #GDBExecStopInFrameEvent,
	#instVars : [
		'breakpointNumber'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBExecBreakpointHitEvent >> breakpointNumber [
	^ breakpointNumber
]

{ #category : #accessing }
GDBExecBreakpointHitEvent >> breakpointNumber: anObject [
	breakpointNumber := anObject
]

{ #category : #parsing }
GDBExecBreakpointHitEvent >> parseEventData: eventData [
	super parseEventData: eventData.
	breakpointNumber := eventData at: #bkptno.
]

{ #category : #visiting }
GDBExecBreakpointHitEvent >> processWith: eventHandler [
	^ eventHandler onExecBreakpointHitEvent: self
]
