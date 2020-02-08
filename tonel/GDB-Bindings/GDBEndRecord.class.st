"
I represent the end of a set of gdb output records. I represent the following string from the gdb machine interface:

(gdb)

"
Class {
	#name : #GDBEndRecord,
	#superclass : #GDBOutputRecord,
	#instVars : [
		'resultClass',
		'results'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBEndRecord >> accept: aVisitor [
	^ aVisitor visitEndRecord: self
]

{ #category : #testing }
GDBEndRecord >> isEndRecord [
	^ true
]

{ #category : #printing }
GDBEndRecord >> printOn: aStream [
	aStream nextPutAll: self recordTypeName
]

{ #category : #'as yet unclassified' }
GDBEndRecord >> recordTypeName [
	^ #end
]
