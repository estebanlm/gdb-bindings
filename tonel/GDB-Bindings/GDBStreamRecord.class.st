"
I represent the output from some gdb stream.
"
Class {
	#name : #GDBStreamRecord,
	#superclass : #GDBOutOfBandRecord,
	#instVars : [
		'value'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #testing }
GDBStreamRecord >> isStreamRecord [
	^ true
]

{ #category : #printing }
GDBStreamRecord >> printOn: aStream [
	aStream nextPutAll: self recordTypeName; space; print: value.
]

{ #category : #accessing }
GDBStreamRecord >> value [
	^ value
]

{ #category : #accessing }
GDBStreamRecord >> value: anObject [
	value := anObject
]
