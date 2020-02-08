Class {
	#name : #GDBEvent,
	#superclass : #Object,
	#instVars : [
		'gdb'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #'instance creation' }
GDBEvent class >> for: gdb [
	^ self new gdb: gdb
]

{ #category : #'instance creation' }
GDBEvent class >> for: gdb with: eventData [
	^ (self for: gdb)
		parseEventData: eventData
]

{ #category : #accessing }
GDBEvent >> gdb [
	^ gdb
]

{ #category : #accessing }
GDBEvent >> gdb: anObject [
	gdb := anObject
]

{ #category : #parsing }
GDBEvent >> parseEventData: eventData [
]

{ #category : #visiting }
GDBEvent >> processWith: eventHandler [
	self subclassResponsibility
]
