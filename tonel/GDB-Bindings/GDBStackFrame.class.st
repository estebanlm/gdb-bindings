Class {
	#name : #GDBStackFrame,
	#superclass : #GDBHandle,
	#instVars : [
		'thread',
		'addr',
		'func',
		'file',
		'line',
		'args',
		'arch',
		'level'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBStackFrame >> addr [
	^ addr
]

{ #category : #accessing }
GDBStackFrame >> addr: anObject [
	addr := anObject
]

{ #category : #accessing }
GDBStackFrame >> arch [
	^ arch
]

{ #category : #accessing }
GDBStackFrame >> arch: anObject [
	arch := anObject
]

{ #category : #accessing }
GDBStackFrame >> args [
	^ args
]

{ #category : #accessing }
GDBStackFrame >> args: anObject [
	args := anObject
]

{ #category : #'as yet unclassified' }
GDBStackFrame >> constructFromResult: data [
	level := (data at: #level ifAbsent: [ '0' ]) asInteger.
	addr := data at: #addr ifAbsent: [ nil ].
	func := data at: #func ifAbsent: [ nil ].
	file := data at: #file ifAbsent: [ nil ].
	line := (data at: #line ifAbsent: [ '0' ]) asInteger.
	args := data at: #args ifAbsent: [ nil ].
	arch := data at: #arch ifAbsent: [ nil ].
]

{ #category : #accessing }
GDBStackFrame >> file [
	^ file
]

{ #category : #accessing }
GDBStackFrame >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GDBStackFrame >> func [
	^ func
]

{ #category : #accessing }
GDBStackFrame >> func: anObject [
	func := anObject
]

{ #category : #initialization }
GDBStackFrame >> initialize [
	super initialize.
	thread := 1.
]

{ #category : #accessing }
GDBStackFrame >> level [
	^ level
]

{ #category : #accessing }
GDBStackFrame >> level: anObject [
	level := anObject
]

{ #category : #accessing }
GDBStackFrame >> line [
	^ line
]

{ #category : #accessing }
GDBStackFrame >> line: anObject [
	line := anObject
]

{ #category : #accessing }
GDBStackFrame >> locals [ 

	^ gdb 
		getLocalsInThread: self thread 
		frameLevel: self level
]

{ #category : #accessing }
GDBStackFrame >> thread [
	^ thread
]

{ #category : #accessing }
GDBStackFrame >> thread: anObject [
	thread := anObject
]
