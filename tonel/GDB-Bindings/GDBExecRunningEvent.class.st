Class {
	#name : #GDBExecRunningEvent,
	#superclass : #GDBExecEvent,
	#instVars : [
		'threadId'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #parsing }
GDBExecRunningEvent >> parseEventData: eventData [
	threadId := eventData at: 'thread-id' ifAbsent: [ nil ]
]

{ #category : #visiting }
GDBExecRunningEvent >> processWith: eventHandler [
	^ eventHandler onExecRunningEvent: self
]

{ #category : #accessing }
GDBExecRunningEvent >> threadId [
	^ threadId
]

{ #category : #accessing }
GDBExecRunningEvent >> threadId: anObject [
	threadId := anObject
]
