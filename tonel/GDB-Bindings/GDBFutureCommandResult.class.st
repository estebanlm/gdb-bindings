"
I am a GDB future command result. I am a future that holds a token.
"
Class {
	#name : #GDBFutureCommandResult,
	#superclass : #OSIOEventsFuture,
	#instVars : [
		'token'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBFutureCommandResult >> resultClass [
	^ self value resultClass
]

{ #category : #accessing }
GDBFutureCommandResult >> results [
	^ self value results
]

{ #category : #accessing }
GDBFutureCommandResult >> token [
	^ token
]

{ #category : #accessing }
GDBFutureCommandResult >> token: anObject [
	token := anObject
]
