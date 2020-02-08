"
I am a grammar for an output record from the GDB Machine Interface.
"
Class {
	#name : #GDBOutputGrammar,
	#superclass : #PP2CompositeNode,
	#instVars : [
		'outOfBandRecord',
		'resultRecord',
		'endRecord',
		'asyncRecord',
		'streamRecord',
		'recordToken',
		'resultClass',
		'results',
		'string',
		'stringCharacter',
		'variable',
		'value',
		'const',
		'tuple',
		'list',
		'cstring',
		'emptyTuple',
		'nonEmptyTuple',
		'result',
		'emptyList',
		'nonEmptyList',
		'execAsyncRecord',
		'statusAsyncRecord',
		'asyncClass',
		'consoleStreamRecord',
		'targetStreamRecord',
		'logStreamRecord',
		'notifyAsyncOutputRecord',
		'listContent',
		'valueListContent',
		'resultListContent'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #accessing }
GDBOutputGrammar >> asyncClass [
	^ string
]

{ #category : #records }
GDBOutputGrammar >> asyncRecord [
	^ execAsyncRecord / statusAsyncRecord / notifyAsyncOutputRecord
]

{ #category : #records }
GDBOutputGrammar >> consoleStreamRecord [
	^ '~' asPParser , cstring
]

{ #category : #accessing }
GDBOutputGrammar >> const [
	^ cstring
]

{ #category : #accessing }
GDBOutputGrammar >> cstring [
	^ $" asPParser , (($\ asPParser , #any asPParser) / $" asPParser negate) star flatten, $" asPParser
]

{ #category : #accessing }
GDBOutputGrammar >> emptyList [
	^ '[]' asPParser
]

{ #category : #accessing }
GDBOutputGrammar >> emptyTuple [
	^ '{}' asPParser
]

{ #category : #records }
GDBOutputGrammar >> endRecord [
	^ '(gdb)' asPParser
]

{ #category : #records }
GDBOutputGrammar >> execAsyncRecord [
	^ recordToken optional , $* asPParser , asyncClass , results
]

{ #category : #accessing }
GDBOutputGrammar >> list [
	^ emptyList / nonEmptyList
]

{ #category : #accessing }
GDBOutputGrammar >> listContent [
	^ valueListContent / resultListContent
]

{ #category : #records }
GDBOutputGrammar >> logStreamRecord [
	^ '&' asPParser , cstring
]

{ #category : #accessing }
GDBOutputGrammar >> nonEmptyList [
	^ $[ asPParser , listContent, $] asPParser
]

{ #category : #accessing }
GDBOutputGrammar >> nonEmptyTuple [
	^ ${ asPParser , result , ($, asPParser , result) star , $} asPParser 
]

{ #category : #records }
GDBOutputGrammar >> notifyAsyncOutputRecord [
	^ recordToken optional , $= asPParser , asyncClass , results
]

{ #category : #records }
GDBOutputGrammar >> outOfBandRecord [
	^ asyncRecord / streamRecord
]

{ #category : #accessing }
GDBOutputGrammar >> recordToken [
	^ #digit asPParser plus flatten
]

{ #category : #accessing }
GDBOutputGrammar >> result [
	^ variable , $= asPParser , value
]

{ #category : #accessing }
GDBOutputGrammar >> resultClass [
	^ string
]

{ #category : #accessing }
GDBOutputGrammar >> resultListContent [
	^ result , ($, asPParser , result) star
]

{ #category : #records }
GDBOutputGrammar >> resultRecord [
	^ recordToken optional , '^' asPParser , resultClass, results
]

{ #category : #accessing }
GDBOutputGrammar >> results [
	^ ($, asPParser , result) star
]

{ #category : #accessing }
GDBOutputGrammar >> start [
	^ outOfBandRecord / resultRecord / endRecord
]

{ #category : #records }
GDBOutputGrammar >> statusAsyncRecord [
	^ recordToken optional , $+ asPParser , asyncClass , results
]

{ #category : #records }
GDBOutputGrammar >> streamRecord [
	^ consoleStreamRecord / targetStreamRecord / logStreamRecord
]

{ #category : #accessing }
GDBOutputGrammar >> string [
	^ stringCharacter plus flatten
]

{ #category : #accessing }
GDBOutputGrammar >> stringCharacter [
	^ #letter asPParser / #digit asPParser / $_ asPParser / $- asPParser
]

{ #category : #records }
GDBOutputGrammar >> targetStreamRecord [
	^ '@' asPParser , cstring
]

{ #category : #accessing }
GDBOutputGrammar >> tuple [
	^ emptyTuple / nonEmptyTuple
]

{ #category : #accessing }
GDBOutputGrammar >> value [
	^ const / tuple / list
]

{ #category : #accessing }
GDBOutputGrammar >> valueListContent [
	^ value , ($, asPParser , value) star
]

{ #category : #accessing }
GDBOutputGrammar >> variable [
	^ string
]
