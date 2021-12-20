Class {
	#name : #GDBGIOChannelMITokenProvider,
	#superclass : #Object,
	#instVars : [
		'tokenCountMutex',
		'tokenCount'
	],
	#category : #'GDB-Bindings-GIO'
}

{ #category : #initialization }
GDBGIOChannelMITokenProvider >> initialize [

	tokenCountMutex := Semaphore forMutualExclusion.
	tokenCount := 0
]

{ #category : #accessing }
GDBGIOChannelMITokenProvider >> nextToken [
	| result |
	
	tokenCountMutex critical: [ 
		result := (tokenCount := tokenCount + 1) ].
	
	^ result
	
]
