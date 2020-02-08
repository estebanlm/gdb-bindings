"
I am a parser for an output record from the GDB Machine Interface.
"
Class {
	#name : #GDBOutputParser,
	#superclass : #GDBOutputGrammar,
	#classVars : [
		'CScapeCharacter'
	],
	#category : #'GDB-Bindings-Output'
}

{ #category : #initialization }
GDBOutputParser class >> initialize [
	CScapeCharacter := Dictionary newFromPairs: { 
		$a . 16r07 asCharacter.
		$b . 16r08 asCharacter.
		$f . 16r0c asCharacter.
		$n . Character lf.
		$r . Character cr.
		$t . Character tab.
		$v . 16r0b asCharacter.
		$' . $'.
		$" . $".
		$\ . $\.
	}.
	
]

{ #category : #records }
GDBOutputParser >> consoleStreamRecord [
	^ super consoleStreamRecord ==> [ :tok | GDBConsoleStreamRecord new value: tok second ]
]

{ #category : #accessing }
GDBOutputParser >> cstring [
	^ super cstring ==> [ :token |
		self parseCString: token second
	]

]

{ #category : #accessing }
GDBOutputParser >> emptyList [
	^ super emptyList ==> [ :tok | #() ]
]

{ #category : #accessing }
GDBOutputParser >> emptyTuple [
	^ super emptyTuple ==> [ :tok | OrderedDictionary new ]
]

{ #category : #records }
GDBOutputParser >> endRecord [
	^ super endRecord ==> [ :tok | GDBEndRecord new ]
]

{ #category : #records }
GDBOutputParser >> execAsyncRecord [
	^ super execAsyncRecord ==> [ :tok |
		GDBExecAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #records }
GDBOutputParser >> logStreamRecord [
	^ super logStreamRecord ==> [ :tok | GDBLogStreamRecord new value: tok second ]
]

{ #category : #accessing }
GDBOutputParser >> nonEmptyList [
	^ super nonEmptyList ==> [ :tok | tok second ]
]

{ #category : #accessing }
GDBOutputParser >> nonEmptyTuple [
	^ super nonEmptyTuple ==> [ :tok |
		OrderedDictionary newFrom: {tok second} , (tok third collect: #second)
	]
]

{ #category : #records }
GDBOutputParser >> notifyAsyncOutputRecord [
	^ super notifyAsyncOutputRecord ==> [ :tok |
		GDBNotifyAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #accessing }
GDBOutputParser >> parseCEscapeSequenceFrom: in into: out [
	| c codePoint |
	c := in next.
	CScapeCharacter at: c ifPresent: [ :v |
		out nextPut: v asInteger.
		^ self
	].

	"Hex"
	c = $x ifTrue: [
		codePoint := Integer readFrom: (in next: 2) base: 16.
		out nextPut: codePoint.
		^ self
	].

	"Octal"
	c isDigit ifTrue: [
		codePoint := Integer readFrom: c asString , (in next: 2) base: 8.
		out nextPut: codePoint.
		^ self
	].

	self error: 'Unsupported C escape character ' , c asString
]

{ #category : #accessing }
GDBOutputParser >> parseCString: content [
	| in c |
	^ (ByteArray streamContents: [ :out |
		in := ReadStream on: content.
		[in atEnd] whileFalse: [
			c := in next.
			c = $\ ifTrue: [
				self parseCEscapeSequenceFrom: in into: out
			] ifFalse: [
				out nextPut: c asInteger
			]
		].
	]) utf8Decoded
]

{ #category : #accessing }
GDBOutputParser >> result [
	^ super result ==> [ :tok |
		tok first -> tok third
	]
]

{ #category : #accessing }
GDBOutputParser >> resultListContent [
	^ super resultListContent ==> [ :tok | { tok first } , (tok second collect: #second) ]
]

{ #category : #records }
GDBOutputParser >> resultRecord [
	^ super resultRecord ==> [ :tok |
		GDBResultRecord new
			token: tok first;
			resultClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #accessing }
GDBOutputParser >> results [
	^ super results ==> [ :tok |
		OrderedDictionary newFrom: (tok collect: #second)
	]
]

{ #category : #records }
GDBOutputParser >> statusAsyncRecord [
	^ super statusAsyncRecord ==> [ :tok |
		GDBStatusAsyncOutput new
			token: tok first;
			asyncClass: tok third;
			results: tok fourth;
			yourself
		]
]

{ #category : #records }
GDBOutputParser >> targetStreamRecord [
	^ super targetStreamRecord ==> [ :tok | GDBTargetStreamRecord new value: tok second ]
]

{ #category : #accessing }
GDBOutputParser >> valueListContent [
	^ super valueListContent ==> [ :tok | { tok first } , (tok second collect: #second) ]
]

{ #category : #accessing }
GDBOutputParser >> variable [
	^ super variable ==> [ :token | token asSymbol ]

]
