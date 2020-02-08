Class {
	#name : #GDBHandle,
	#superclass : #Object,
	#instVars : [
		'gdb'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #'instance creation' }
GDBHandle class >> for: gdb [
	^ self new gdb: gdb
]

{ #category : #'instance creation' }
GDBHandle class >> for: gdb from: result [
	^ (self for: gdb) constructFromResult: result
]

{ #category : #'as yet unclassified' }
GDBHandle >> constructFromResult: result [

]

{ #category : #accessing }
GDBHandle >> gdb [
	^ gdb
]

{ #category : #accessing }
GDBHandle >> gdb: anObject [
	gdb := anObject
]
