"
I represent a logging message by gdb that can be produced by the internals of gdb.
"
Class {
	#name : #GDBLogStreamRecord,
	#superclass : #GDBStreamRecord,
	#category : #'GDB-Bindings-Output'
}

{ #category : #visiting }
GDBLogStreamRecord >> accept: aVisitor [
	^ aVisitor visitLogStreamRecord: self
]

{ #category : #'as yet unclassified' }
GDBLogStreamRecord >> recordTypeName [
	^ #logStream
]
