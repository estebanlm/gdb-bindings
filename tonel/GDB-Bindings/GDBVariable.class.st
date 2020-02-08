Class {
	#name : #GDBVariable,
	#superclass : #GDBHandle,
	#instVars : [
		'name',
		'arg',
		'type',
		'value'
	],
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #accessing }
GDBVariable >> arg [
	^ arg
]

{ #category : #accessing }
GDBVariable >> arg: anObject [
	arg := anObject
]

{ #category : #'as yet unclassified' }
GDBVariable >> constructFromResult: data [
	name := data at: #name ifAbsent: [ nil ].
	arg := data at: #arg ifAbsent: [ nil ].
	type := data at: #type ifAbsent: [ nil ].
	value := data at: #value ifAbsent: [ nil ].
]

{ #category : #accessing }
GDBVariable >> name [
	^ name
]

{ #category : #accessing }
GDBVariable >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GDBVariable >> type [
	^ type
]

{ #category : #accessing }
GDBVariable >> type: anObject [
	type := anObject
]

{ #category : #accessing }
GDBVariable >> value [
	^ value
]

{ #category : #accessing }
GDBVariable >> value: anObject [
	value := anObject
]
