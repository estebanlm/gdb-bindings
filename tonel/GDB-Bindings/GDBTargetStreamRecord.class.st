"
I contain textual output from the running target.
"
Class {
	#name : #GDBTargetStreamRecord,
	#superclass : #GDBStreamRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBTargetStreamRecord >> accept: aVisitor [
	^ aVisitor visitTargetStreamRecord: self
]

{ #category : #'as yet unclassified' }
GDBTargetStreamRecord >> recordTypeName [
	^ #targetStream
]
