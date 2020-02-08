"
I represent the result for a gdb command.
"
Class {
	#name : #GDBResultRecord,
	#superclass : #GDBOutputRecord,
	#instVars : [
		'token',
		'resultClass',
		'results'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBResultRecord >> accept: aVisitor [
	^ aVisitor visitResultRecord: self
]

{ #category : #testing }
GDBResultRecord >> isResultRecord [
	^ true
]

{ #category : #printing }
GDBResultRecord >> printOn: aStream [
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: resultClass; space; print: results
]

{ #category : #'as yet unclassified' }
GDBResultRecord >> recordTypeName [
	^ #result
]

{ #category : #accessing }
GDBResultRecord >> resultClass [
	^ resultClass
]

{ #category : #accessing }
GDBResultRecord >> resultClass: anObject [
	resultClass := anObject
]

{ #category : #accessing }
GDBResultRecord >> results [
	^ results
]

{ #category : #accessing }
GDBResultRecord >> results: anObject [
	results := anObject
]

{ #category : #accessing }
GDBResultRecord >> token [
	^ token
]

{ #category : #accessing }
GDBResultRecord >> token: anObject [
	token := anObject
]
