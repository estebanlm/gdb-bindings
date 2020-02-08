"
I represent an asynchronous status from gdb.
"
Class {
	#name : #GDBStatusAsyncOutput,
	#superclass : #GDBAsyncRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBStatusAsyncOutput >> accept: aVisitor [
	^ aVisitor visitStatusAsyncOutput: self
]

{ #category : #'as yet unclassified' }
GDBStatusAsyncOutput >> recordTypeName [
	^ #statusAsyncOutput
]
