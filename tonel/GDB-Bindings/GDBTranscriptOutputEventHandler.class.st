"
I am a gdb event handler that prints its output into the Transcript.
"
Class {
	#name : #GDBTranscriptOutputEventHandler,
	#superclass : #GDBEventHandler,
	#category : #'GDB-Bindings-FrontEnd'
}

{ #category : #'as yet unclassified' }
GDBTranscriptOutputEventHandler >> onConsoleOutput: aString [

	Transcript show: aString withInternalLineEndings; cr.
]

{ #category : #'as yet unclassified' }
GDBTranscriptOutputEventHandler >> onLogOutput: aString [
	Transcript show: aString withInternalLineEndings
]

{ #category : #'as yet unclassified' }
GDBTranscriptOutputEventHandler >> onTargetErrorOutput: aString [
	Transcript show: aString withInternalLineEndings
]

{ #category : #'as yet unclassified' }
GDBTranscriptOutputEventHandler >> onTargetOutput: aString [
	Transcript show: aString withInternalLineEndings
]
