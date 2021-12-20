"
I am a GDB machine interface client.

I use the the os-ioevents driver for pipe IO that does not stop the image.
"
Class {
	#name : #GDBMIClient,
	#superclass : #Object,
	#instVars : [
		'process',
		'session',
		'mutex',
		'outputReadingProcess',
		'stdin',
		'eventHandler',
		'tokenCountMutex',
		'tokenCount',
		'pendingCommands',
		'pendingCommandsMutex',
		'programOutputReadingProcess',
		'programErrorReadingProcess',
		'separateStdoutFromStderr',
		'useIORedirection',
		'isRunning',
		'isStopped',
		'isStoppingForCommand'
	],
	#classVars : [
		'AsyncExecHandlingMap',
		'AsyncNotificationHandlingMap'
	],
	#pools : [
		'LibOSIOEventsPool'
	],
	#category : #'GDB-Bindings-IOSEvents'
}

{ #category : #'class initialization' }
GDBMIClient class >> initialize [
	AsyncNotificationHandlingMap := Dictionary newFromPairs: #(
		'breakpoint-modified' onBreakpointModifiedNotification:
		'library-loaded' onLibraryLoadedNotification:
		'library-unloaded' onLibraryUnloadedNotification:
		'thread-group-added' onThreadGroupAddredNotification:
		'thread-group-started' onThreadGroupStartedNotification:
		'thread-group-exited' onThreadGroupExitedNotification:
		'thread-created' onThreadCreatedNotification:
		'thread-exited' onThreadExitedNotification:
		'thread-selected' onThreadSelectedNotification:).
	
	AsyncExecHandlingMap := Dictionary newFromPairs: #(
		running onExecRunningEvent:
		stopped onExecStoppedEvent:)
]

{ #category : #commands }
GDBMIClient >> cli: aString [
	^ self cli: aString withResult: self newFutureCommandResult
]

{ #category : #commands }
GDBMIClient >> cli: aString withResult: aPhanideGDBFutureCommandResult [
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; space; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult
]

{ #category : #'convenience commands' }
GDBMIClient >> createBreakpointInFile: fileName atLine: line [
	| breakpointCommand |
	breakpointCommand := self ensureStopped: [ 
		self mi: ('-break-insert --source {1} --line {2}' format: {fileName asCStringForGDB . line asString})
	].

	^ GDBBreakpoint for: self from: breakpointCommand results
]

{ #category : #events }
GDBMIClient >> dispatchEvent: event [
	^ eventHandler dispatchEvent: event
]

{ #category : #'as yet unclassified' }
GDBMIClient >> ensureStopped: aBlock [
	(isRunning or: [isStoppingForCommand]) ifFalse: [ ^ aBlock value ].
	isStoppingForCommand := true.
	(self mi: '-exec-interrupt') value.
	^ [ 
		aBlock value.
	] ensure: [
		isStoppingForCommand := false.
		(self mi: '-exec-continue') value.
	]
]

{ #category : #accessing }
GDBMIClient >> eventHandler [
	^ eventHandler
]

{ #category : #accessing }
GDBMIClient >> eventHandler: anObject [
	eventHandler := anObject
]

{ #category : #'convenience commands' }
GDBMIClient >> execContinue [
	^ self mi: '-exec-continue'
]

{ #category : #'convenience commands' }
GDBMIClient >> execFinish [

	^ self mi: '-exec-finish'
]

{ #category : #'convenience commands' }
GDBMIClient >> execInterrupt [
	^ self mi: '-exec-interrupt'
]

{ #category : #'convenience commands' }
GDBMIClient >> execNext [
	^ self mi: '-exec-next'
]

{ #category : #'convenience commands' }
GDBMIClient >> execRun [
	^ self mi: '-exec-run'
]

{ #category : #'convenience commands' }
GDBMIClient >> execStep [
	^ self mi: '-exec-step'
]

{ #category : #private }
GDBMIClient >> finishProcessExecution [

	process finish.
	outputReadingProcess ifNotNil: [ outputReadingProcess terminate ].
	programOutputReadingProcess ifNotNil: [ programOutputReadingProcess terminate ].
	programErrorReadingProcess ifNotNil: [ programErrorReadingProcess terminate ]
]

{ #category : #accessing }
GDBMIClient >> gdbCommand [
	^ 'gdb -q --interpreter=mi'
	
]

{ #category : #'convenience commands' }
GDBMIClient >> getLocalsInThread: threadId frameLevel: frameLevel [
	| variables |
	variables := (self mi: ('-stack-list-variables --thread {1} --frame {2} --simple-values' format: {threadId asString . frameLevel asString})) results.
	^ (variables at: #variables) collect: [ :var | GDBVariable for: self from: var ]
]

{ #category : #'convenience commands' }
GDBMIClient >> getStackTraceForThread: threadId [
	| trace frames |
	trace := (self mi: ('-stack-list-frames --thread {1}' format: {threadId asString})) results at: #stack.
	frames := trace collect: [ :frame |
		self assert: frame key = #frame.
		(GDBStackFrame for: self from: frame value)
			thread: threadId
	].
	^ frames
]

{ #category : #initialization }
GDBMIClient >> initialize [
	super initialize.
	eventHandler := GDBTranscriptOutputEventHandler new.
	
	tokenCountMutex := Semaphore forMutualExclusion.
	tokenCount := 0.
	isRunning := false.
	isStoppingForCommand := false.
]

{ #category : #initialization }
GDBMIClient >> initializeGDBMI [
	"Enable the async mode."
	stdin nextPutAll: '-gdb-set mi-async on'; lf
]

{ #category : #commands }
GDBMIClient >> mi: aString [

	^ self mi: aString withResult: self newFutureCommandResult
]

{ #category : #commands }
GDBMIClient >> mi: aString withResult: aPhanideGDBFutureCommandResult [
	stdin nextPutAll: aPhanideGDBFutureCommandResult token asString; nextPutAll: aString; lf.
	^ aPhanideGDBFutureCommandResult
]

{ #category : #private }
GDBMIClient >> newFutureCommandResult [
	| token result |
	token := self newToken.
	result := GDBFutureCommandResult new token: token.
	pendingCommandsMutex critical: [ 
		pendingCommands at: token put: result
	].
	^ result
]

{ #category : #private }
GDBMIClient >> newToken [
	| result |
	tokenCountMutex critical: [ 
		result := (tokenCount := tokenCount + 1).
	].
	^ result
	
]

{ #category : #notifications }
GDBMIClient >> onBreakpointModifiedNotification: notificationData [
]

{ #category : #events }
GDBMIClient >> onExecRunningEvent: eventData [
	isRunning := true.
	^ self dispatchEvent: (GDBExecRunningEvent for: self with: eventData)
]

{ #category : #events }
GDBMIClient >> onExecStoppedEvent: eventData [
	isStoppingForCommand ifTrue: [ ^ self ].
	isStopped := true.
	^ self dispatchEvent: (GDBExecStoppedEvent for: self with: eventData)

]

{ #category : #notifications }
GDBMIClient >> onLibraryLoadedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onLibraryUnloadedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadCreatedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadExitedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadGroupAddredNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadGroupExitedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadGroupStartedNotification: notificationData [
]

{ #category : #notifications }
GDBMIClient >> onThreadSelectedNotification: notificationData [
]

{ #category : #'as yet unclassified' }
GDBMIClient >> outputReadingProcessEntry [
	| stdout line |
	stdout := process stdout textStream.
	[ (line := stdout nextLine)] whileNotNil: [ 
		self processOutputLine: line ]
]

{ #category : #'as yet unclassified' }
GDBMIClient >> processOutputLine: line [
	| record |
	record := GDBOutputParser parse: line.
	record isPetit2Failure ifTrue: [
		^ [
			self error: 'Failed to parse gdb output record: ' , line printString
		] fork
	].

	record accept: self
]

{ #category : #'as yet unclassified' }
GDBMIClient >> programErrorOutputReadingProcess [
	| stderr line |
	stderr := process extraStderr textStream.
	self flag: 'FIXME: Do not read per line here.'.
	[(line := stderr nextLine)] whileNotNil: [ 
		eventHandler onTargetErrorOutput: line; onTargetErrorOutput: String cr.
	]

]

{ #category : #'as yet unclassified' }
GDBMIClient >> programOutputReadingProcess [
	| stdout line |
	stdout := process extraStdout textStream.
	self flag: 'FIXME: Do not read per line here.'.
	[(line := stdout nextLine)] whileNotNil: [ 
		eventHandler onTargetOutput: line; onTargetOutput: String cr
	]

]

{ #category : #'convenience commands' }
GDBMIClient >> quit [
	self mi: '-gdb-exit'.
	^ self finishProcessExecution
]

{ #category : #accessing }
GDBMIClient >> separateStdoutFromStderr [
	^ separateStdoutFromStderr ifNil: [ separateStdoutFromStderr := false ]
]

{ #category : #accessing }
GDBMIClient >> separateStdoutFromStderr: aBoolean [
	^ separateStdoutFromStderr := aBoolean
]

{ #category : #'convenience commands' }
GDBMIClient >> setProgramArguments: arguments [
	^ self mi: (ByteString streamContents: [:out |
		out nextPutAll: '-exec-arguments'.
		arguments do: [ :arg |
			out space.
			arg asCStringForGDBInto: out
		].
	
		self useIORedirection ifTrue: [
			self separateStdoutFromStderr ifTrue: [ 
				out nextPutAll: ' <&3 >&4 2>&5'
			] ifFalse: [ 
				out nextPutAll: ' <&3 >&4 2>&4'
			]
		].
	])
]

{ #category : #'convenience commands' }
GDBMIClient >> setProgramFileAndSymbols: programFileName [
	^ self mi: ('-file-exec-and-symbols {1}' format: {programFileName asCStringForGDB})
]

{ #category : #commands }
GDBMIClient >> start [
	| programStdin |
	process := OSIOEventsDriver uniqueInstance spawnShell: self gdbCommand flags: OS_IOEVENTS_SPAWN_FLAGS_OPEN_EXTRA_PIPES.
	session := Smalltalk session.
	
	mutex := Semaphore forMutualExclusion.
	pendingCommands := Dictionary new.
	pendingCommandsMutex := Semaphore forMutualExclusion.

	outputReadingProcess := self startOutputReadingProcess.
	programOutputReadingProcess := self startProgramOutputReadingProcess.
	self separateStdoutFromStderr ifTrue: [ 
		programErrorReadingProcess := self startProgramErrorOutputReadingProcess.
	].
	
	stdin := process stdin textStream.
	programStdin := process extraStdin textStream.
	self initializeGDBMI
]

{ #category : #'as yet unclassified' }
GDBMIClient >> startOutputReadingProcess [
	^ [
		self outputReadingProcessEntry
	] fork
]

{ #category : #'as yet unclassified' }
GDBMIClient >> startProgramErrorOutputReadingProcess [
	^ [
		self programErrorOutputReadingProcess
	] fork
]

{ #category : #'as yet unclassified' }
GDBMIClient >> startProgramOutputReadingProcess [
	^ [
		self programOutputReadingProcess
	] fork
]

{ #category : #accessing }
GDBMIClient >> useIORedirection [
	^ useIORedirection ifNil: [ useIORedirection := true ]
]

{ #category : #accessing }
GDBMIClient >> useIORedirection: anObject [
	useIORedirection := anObject
]

{ #category : #visiting }
GDBMIClient >> visitConsoleStreamRecord: record [
	eventHandler onConsoleOutput: record value
]

{ #category : #visiting }
GDBMIClient >> visitEndRecord: record [
]

{ #category : #visiting }
GDBMIClient >> visitExecAsyncOutput: record [
	| asyncClass data selector |
	asyncClass := record asyncClass.
	data := record results.
	
	selector := AsyncExecHandlingMap at: asyncClass ifAbsent: [
		eventHandler onLogOutput:(ByteString streamContents: [:out |
			out nextPutAll: 'Unsupported async exec event from gdb:'; cr.
			out nextPutAll: asyncClass; space; print: data; cr.
		]).
		^ self
	].

	^ self perform: selector with: data
]

{ #category : #visiting }
GDBMIClient >> visitLogStreamRecord: record [
	eventHandler onLogOutput: record value
]

{ #category : #visiting }
GDBMIClient >> visitNotifyAsyncOutput: record [
	| asyncClass data selector |
	asyncClass := record asyncClass.
	data := record results.
	
	selector := AsyncNotificationHandlingMap at: asyncClass ifAbsent: [
		eventHandler onLogOutput:(ByteString streamContents: [:out |
			out nextPutAll: 'Unsupported async notfication from gdb:'; cr.
			out nextPutAll: asyncClass; space; print: data; cr.
		]).
		^ self
	].

	^ self perform: selector with: data
]

{ #category : #visiting }
GDBMIClient >> visitResultRecord: record [
	| tokenValue |
	record token ifNil: [ ^ self ].
	
	tokenValue := record token asInteger.
	pendingCommandsMutex critical: [
		pendingCommands at: tokenValue ifPresent: [ :result |
			pendingCommands removeKey: tokenValue.
			result value: record
		].
	].
]

{ #category : #visiting }
GDBMIClient >> visitStatusAsyncOutput: record [
	Transcript show: 'TODO: Handle status async output'; cr; show: record; cr.
]

{ #category : #visiting }
GDBMIClient >> visitTargetStreamRecord: record [
	eventHandler onTargetOutput: record value
]

{ #category : #'convenience commands' }
GDBMIClient >> workingDirectory: workingDirectory [

	^ self mi: ('-environment-cd {1}' format: {workingDirectory asCStringForGDB})
]
