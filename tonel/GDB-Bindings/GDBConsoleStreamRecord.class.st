"
I represent the console output from a gdb CLI command.
"
Class {
	#name : #GDBConsoleStreamRecord,
	#superclass : #GDBStreamRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBConsoleStreamRecord >> accept: aVisitor [
	^ aVisitor visitConsoleStreamRecord: self
]

{ #category : #'as yet unclassified' }
GDBConsoleStreamRecord >> recordTypeName [
	^ #consoleStream
]
