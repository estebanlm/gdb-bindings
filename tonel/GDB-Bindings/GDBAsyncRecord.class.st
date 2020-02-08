"
I represent an asynchronous gdb notification.
"
Class {
	#name : #GDBAsyncRecord,
	#superclass : #GDBOutOfBandRecord,
	#instVars : [
		'token',
		'asyncClass',
		'results'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #accessing }
GDBAsyncRecord >> asyncClass [
	^ asyncClass
]

{ #category : #accessing }
GDBAsyncRecord >> asyncClass: anObject [
	asyncClass := anObject
]

{ #category : #testing }
GDBAsyncRecord >> isAsyncRecord [
	^ true
]

{ #category : #printing }
GDBAsyncRecord >> printOn: aStream [
	aStream print: token; space; nextPutAll: self recordTypeName;
		space; print: asyncClass; space; print: results
]

{ #category : #accessing }
GDBAsyncRecord >> results [
	^ results
]

{ #category : #accessing }
GDBAsyncRecord >> results: anObject [
	results := anObject
]

{ #category : #accessing }
GDBAsyncRecord >> token [
	^ token
]

{ #category : #accessing }
GDBAsyncRecord >> token: anObject [
	token := anObject
]
