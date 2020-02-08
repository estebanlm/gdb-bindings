"
I represent an asynchronous notification from gdb.
"
Class {
	#name : #GDBNotifyAsyncOutput,
	#superclass : #GDBAsyncRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBNotifyAsyncOutput >> accept: aVisitor [
	^ aVisitor visitNotifyAsyncOutput: self
]

{ #category : #'as yet unclassified' }
GDBNotifyAsyncOutput >> recordTypeName [
	^ #notifyAsyncOutput
]
