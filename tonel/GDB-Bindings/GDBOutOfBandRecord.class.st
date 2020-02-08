"
I represent an out of band gdb output record. I can be generated asynchronously.
"
Class {
	#name : #GDBOutOfBandRecord,
	#superclass : #GDBOutputRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #testing }
GDBOutOfBandRecord >> isOutOfBandRecord [
	^ true
]
