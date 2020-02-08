"
I represent an asynchronous output related to the running target.
"
Class {
	#name : #GDBExecAsyncOutput,
	#superclass : #GDBAsyncRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBExecAsyncOutput >> accept: aVisitor [
	^ aVisitor visitExecAsyncOutput: self
]

{ #category : #'as yet unclassified' }
GDBExecAsyncOutput >> recordTypeName [
	^ #execAsyncOutput
]
