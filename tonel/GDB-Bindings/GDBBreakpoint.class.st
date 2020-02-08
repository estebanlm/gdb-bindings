Class {
	#name : #GDBBreakpoint,
	#superclass : #GDBHandle,
	#instVars : [
		'number',
		'type',
		'file',
		'line',
		'enabled',
		'func',
		'addr'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBBreakpoint >> addr [
	^ addr
]

{ #category : #accessing }
GDBBreakpoint >> addr: anObject [
	addr := anObject
]

{ #category : #'as yet unclassified' }
GDBBreakpoint >> constructFromResult: result [
	| bkpt |
	bkpt := result at: #bkpt.
	number := (bkpt at: #number) asInteger.
	type := (bkpt at: #type) asSymbol.
	enabled := (bkpt at: #enabled) ~= 'n'.
	file := bkpt at: #file.
	line := (bkpt at: #line) asInteger.
	func := bkpt at: #func ifAbsent: [nil].
	addr := bkpt at: #addr ifAbsent: [nil].

]

{ #category : #accessing }
GDBBreakpoint >> enabled [
	^ enabled
]

{ #category : #accessing }
GDBBreakpoint >> enabled: anObject [
	enabled := anObject
]

{ #category : #accessing }
GDBBreakpoint >> file [
	^ file
]

{ #category : #accessing }
GDBBreakpoint >> file: anObject [
	file := anObject
]

{ #category : #accessing }
GDBBreakpoint >> func [
	^ func
]

{ #category : #accessing }
GDBBreakpoint >> func: anObject [
	func := anObject
]

{ #category : #accessing }
GDBBreakpoint >> line [
	^ line
]

{ #category : #accessing }
GDBBreakpoint >> line: anObject [
	line := anObject
]

{ #category : #accessing }
GDBBreakpoint >> number [
	^ number
]

{ #category : #accessing }
GDBBreakpoint >> number: anObject [
	number := anObject
]

{ #category : #printing }
GDBBreakpoint >> printOn: aStream [
	aStream nextPutAll: 'Breakpoint '; print: number; space;
		nextPutAll: (enabled
			ifTrue: ['enabled']
			ifFalse: ['disabled'])
]

{ #category : #accessing }
GDBBreakpoint >> type [
	^ type
]

{ #category : #accessing }
GDBBreakpoint >> type: anObject [
	type := anObject
]
