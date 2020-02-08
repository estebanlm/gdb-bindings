"
I represent an output record from GDB.

"
Class {
	#name : #GDBOutputRecord,
	#superclass : #Object,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBOutputRecord >> accept: aVisitor [
	self subclassResponsibility
]

{ #category : #testing }
GDBOutputRecord >> isAsyncRecord [
	^ false
]

{ #category : #testing }
GDBOutputRecord >> isEndRecord [
	^ false
]

{ #category : #testing }
GDBOutputRecord >> isGDBOutputRecord [
	^ true
]

{ #category : #testing }
GDBOutputRecord >> isOutOfBandRecord [
	^ false
]

{ #category : #testing }
GDBOutputRecord >> isResultRecord [
	^ false
]

{ #category : #testing }
GDBOutputRecord >> isStreamRecord [
	^ false
]

{ #category : #'as yet unclassified' }
GDBOutputRecord >> recordTypeName [
	^ self subclassResponsibility
]
