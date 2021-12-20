Class {
	#name : #GDBGIOChannelMICommandQueue,
	#superclass : #Object,
	#instVars : [
		'pendingCommandsMutex',
		'pendingCommands'
	],
	#category : #'GDB-Bindings-GIO'
}

{ #category : #'as yet unclassified' }
GDBGIOChannelMICommandQueue >> consumeToken: aToken ifPresent: aBlock [
 
	pendingCommandsMutex critical: [
		pendingCommands 
			at: aToken
			ifPresent: [ :result |
				pendingCommands removeKey: aToken.
				aBlock value: result ] ]
]

{ #category : #initialization }
GDBGIOChannelMICommandQueue >> initialize [

	super initialize.
	pendingCommands := Dictionary new.
	pendingCommandsMutex := Semaphore forMutualExclusion	
]

{ #category : #'as yet unclassified' }
GDBGIOChannelMICommandQueue >> pushCommandToken: token result: result [
 	
	pendingCommandsMutex critical: [ 
		pendingCommands at: token put: result ].

]
