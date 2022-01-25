Class {
	#name : #GDBGIOChannelMIClient,
	#superclass : #Object,
	#instVars : [
		'stdin',
		'stdout',
		'stderr',
		'eventHandler',
		'process',
		'queueStdout',
		'queueStderr',
		'commandQueue',
		'isRunning',
		'isStoppingForCommand',
		'tokenProvider'
	],
	#classVars : [
		'AsyncExecHandlingMap',
		'AsyncNotificationHandlingMap'
	],
	#category : #'GDB-Bindings-GIO'
}

{ #category : #initialization }
GDBGIOChannelMIClient class >> initialize [

	AsyncNotificationHandlingMap := Dictionary newFromPairs: #(
		'breakpoint-modified' onBreakpointModifiedNotification:
		'library-loaded' onLibraryLoadedNotification:
		'library-unloaded' onLibraryUnloadedNotification:
		'thread-group-added' onThreadGroupAddredNotification:
		'thread-group-started' onThreadGroupStartedNotification:
		'thread-group-exited' onThreadGroupExitedNotification:
		'thread-created' onThreadCreatedNotification:
		'thread-exited' onThreadExitedNotification:
		'thread-selected' onThreadSelectedNotification:
	).
	
	AsyncExecHandlingMap := Dictionary newFromPairs: #(
		running onExecRunningEvent:
		stopped onExecStoppedEvent:
	).
]

{ #category : #commands }
GDBGIOChannelMIClient >> cli: aString [

	^ self cli: aString withResult: self newFutureCommandResult
]

{ #category : #'private - commands' }
GDBGIOChannelMIClient >> cli: aString withResult: aFutureCommandResult [

	stdin writeLineFlush: (String streamContents: [ :stream |
		stream 
			nextPutAll: aFutureCommandResult token asString; 
			space; 
			nextPutAll: aString] ).

	^ aFutureCommandResult
]

{ #category : #'event handling' }
GDBGIOChannelMIClient >> dispatchEvent: event [

	^ eventHandler dispatchEvent: event
]

{ #category : #private }
GDBGIOChannelMIClient >> ensureStopped: aBlock [
	
	(isRunning or: [ isStoppingForCommand ]) ifFalse: [ ^ aBlock value ].
	
	isStoppingForCommand := true.
	(self mi: '-exec-interrupt') value.
	^ [ aBlock value ] 
	ensure: [
		isStoppingForCommand := false.
		(self mi: '-exec-continue') value ]
]

{ #category : #accessing }
GDBGIOChannelMIClient >> eventHandler [

	^ eventHandler
]

{ #category : #accessing }
GDBGIOChannelMIClient >> eventHandler: anEventHandler [ 
	
	eventHandler := anEventHandler
]

{ #category : #commands }
GDBGIOChannelMIClient >> execContinue [

	^ self mi: '-exec-continue'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execFinish [

	^ self mi: '-exec-finish'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execInterrupt [

	^ self mi: '-exec-interrupt'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execNext [

	^ self mi: '-exec-next'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execReturn [

	^ self mi: '-exec-return'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execRun [

	^ self mi: '-exec-run'
]

{ #category : #commands }
GDBGIOChannelMIClient >> execStep [

	^ self mi: '-exec-step'
]

{ #category : #accessing }
GDBGIOChannelMIClient >> gdbCommand [

	self flag: #TODO. "Take if from config"
	^ '/usr/bin/gdb'
]

{ #category : #'accessing - threads' }
GDBGIOChannelMIClient >> getLocalsInThread: threadId frameLevel: frameLevel [
	| variables |
	
	variables := (self mi: ('-stack-list-variables --thread {1} --frame {2} --simple-values' format: {threadId asString . frameLevel asString})) results.
	^ (variables at: #variables) collect: [ :var | GDBVariable for: self from: var ]
]

{ #category : #'accessing - threads' }
GDBGIOChannelMIClient >> getStackTraceForThread: threadId [
	| trace frames |
	
	trace := (self 
		mi: ('-stack-list-frames --thread {1}' format: {threadId asString})) results 
		at: #stack.
	frames := trace collect: [ :frame |
		self assert: frame key = #frame.
		(GDBStackFrame for: self from: frame value)
			thread: threadId ].

	^ frames
]

{ #category : #initialization }
GDBGIOChannelMIClient >> initialize [

	super initialize.	isRunning := false.
	isStoppingForCommand := false.
	isRunning := false.
	self initializeEventHandler
]

{ #category : #initialization }
GDBGIOChannelMIClient >> initializeEventHandler [

	eventHandler := GDBTranscriptOutputEventHandler new
]

{ #category : #testing }
GDBGIOChannelMIClient >> isRunning [

	^ isRunning
]

{ #category : #testing }
GDBGIOChannelMIClient >> isStopped [

	^ self isRunning not
]

{ #category : #commands }
GDBGIOChannelMIClient >> mi: aString [

	^ self mi: aString withResult: self newFutureCommandResult
]

{ #category : #'private - commands' }
GDBGIOChannelMIClient >> mi: aString withResult: aFutureCommandResult [

	stdin writeLineFlush: (String streamContents: [ :stream |
		stream
			nextPutAll: aFutureCommandResult token asString; 
			nextPutAll: aString] ).

	^ aFutureCommandResult
]

{ #category : #'private - factory' }
GDBGIOChannelMIClient >> newFutureCommandResult [
	| token result |

	token := self newToken.
	result := GDBFutureCommandResult newToken: token.
	commandQueue pushCommandToken: token result: result.

	^ result
]

{ #category : #'private - factory' }
GDBGIOChannelMIClient >> newToken [
	
	^ tokenProvider nextToken
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onBreakpointModifiedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onExecRunningEvent: eventData [

	isRunning := true.
	^ self dispatchEvent: (GDBExecRunningEvent for: self with: eventData)
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onExecStoppedEvent: eventData [

	isStoppingForCommand ifTrue: [ ^ self ].
	^ self dispatchEvent: (GDBExecStoppedEvent for: self with: eventData)
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onLibraryLoadedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onLibraryUnloadedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadCreatedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadExitedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadGroupAddredNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadGroupExitedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadGroupStartedNotification: notificationData [

	self flag: #TODO
]

{ #category : #'private - notifying' }
GDBGIOChannelMIClient >> onThreadSelectedNotification: notificationData [

	self flag: #TODO
]

{ #category : #private }
GDBGIOChannelMIClient >> performAsyncExecutionRecord: record [
	| asyncClass data selector |

	asyncClass := record asyncClass.
	data := record results.	
	selector := AsyncExecHandlingMap at: asyncClass ifAbsent: [
		eventHandler onLogOutput:(ByteString streamContents: [:out |
			out nextPutAll: 'Unsupported async exec event from gdb:'; cr.
			out nextPutAll: asyncClass; space; print: data; cr ]).
		^ self ].

	^ self perform: selector with: data
]

{ #category : #private }
GDBGIOChannelMIClient >> performAsyncNotificationRecord: record [
	| asyncClass data selector |

	asyncClass := record asyncClass.
	data := record results.
	
	selector := AsyncNotificationHandlingMap 
		at: asyncClass 
		ifAbsent: [
			eventHandler onLogOutput:(ByteString streamContents: [:out |
				out nextPutAll: 'Unsupported async notfication from gdb:'; cr.
				out nextPutAll: asyncClass; space; print: data; cr ]).
			^ self ].

	^ self perform: selector with: data
]

{ #category : #private }
GDBGIOChannelMIClient >> prepareGDBMI [

	"Enable the async mode."
	stdin writeLineFlush: '-gdb-set mi-async on'
]

{ #category : #private }
GDBGIOChannelMIClient >> processOutputLine: line [
	| record |
	
	[
		record := GDBOutputParser parse: line.
		record isPetit2Failure 
			ifTrue: [
				self error: 'Failed to parse gdb output record: ', line printString ] ] 
	on: Error 
	fork: [ :e | e pass  ]
	return: [ ^ self ].

	record accept: self
]

{ #category : #private }
GDBGIOChannelMIClient >> queueStderr [

	^ queueStderr ifNil: [ queueStderr := TFWorker named: 'STDERR_QUEUE' ]
]

{ #category : #private }
GDBGIOChannelMIClient >> queueStdout [

	^ queueStdout ifNil: [ queueStdout := TFWorker named: 'STDOUT_QUEUE' ]
]

{ #category : #commands }
GDBGIOChannelMIClient >> quit [

	self mi: '-gdb-exit'.
	self stop
]

{ #category : #private }
GDBGIOChannelMIClient >> read: aChannel [
	| line |

	[ line := aChannel readLine ]
	whileNotNil: [ self processOutputLine: line ]
]

{ #category : #accessing }
GDBGIOChannelMIClient >> setEnvironmentVariable: nameString value: valueString [

	^ self mi: ('set environment {1}={2}' format: { nameString. valueString })
]

{ #category : #accessing }
GDBGIOChannelMIClient >> setProgramArguments: arguments [

	^ self mi: (ByteString streamContents: [ :out |
		out nextPutAll: '-exec-arguments'.
		arguments do: [ :arg |
			out space.
			arg asCStringForGDBInto: out ] ])
]

{ #category : #accessing }
GDBGIOChannelMIClient >> setProgramFileAndSymbols: programFileName [

	^ self mi: ('-file-exec-and-symbols {1}' format: { programFileName asCStringForGDB })
]

{ #category : #accessing }
GDBGIOChannelMIClient >> setWorkingDirectory: aString [

	^ self mi: ('-environment-cd {1}' format: { aString asCStringForGDB } )
]

{ #category : #starting }
GDBGIOChannelMIClient >> start [

	process := GIOPipedProcess 
		spawn: self gdbCommand 
		arguments: #('-i=mi')
		flags: GSpawnFlags G_SPAWN_DO_NOT_REAP_CHILD.
		
	stdin := process inChannel.
	stdout := process outChannel.
	stderr := process errChannel.
	self startStdoutReadingProcess.
	self startStderrReadingProcess.
	
	commandQueue := GDBGIOChannelMICommandQueue new.
	tokenProvider := GDBGIOChannelMITokenProvider new.
	
	self prepareGDBMI
]

{ #category : #'private - starting' }
GDBGIOChannelMIClient >> startStderrReadingProcess [
	
	^ [ 
		TFProcessLocalWorker worker: self queueStderr.
		self read: stderr.
	] forkNamed: ('STDERR_READ_FD_{1}' format: { process pid })
]

{ #category : #'private - starting' }
GDBGIOChannelMIClient >> startStdoutReadingProcess [
	
	^ [ 
		TFProcessLocalWorker worker: self queueStdout.
		self read: stdout.
	] forkNamed: ('STDOUT_READ_FD_{1}' format: { process pid })
]

{ #category : #starting }
GDBGIOChannelMIClient >> stop [

	process ifNil: [  ^ self ].
	process close.
	process := nil.
	isRunning := false
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitConsoleStreamRecord: record [

	eventHandler onConsoleOutput: record value
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitEndRecord: record [

	self flag: #TODO.
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitExecAsyncOutput: record [

	^ self performAsyncExecutionRecord: record
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitLogStreamRecord: record [

	eventHandler onLogOutput: record value
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitNotifyAsyncOutput: record [

	^ self performAsyncNotificationRecord: record
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitResultRecord: record [
	| tokenValue |
	
	record token ifNil: [ ^ self ].

	tokenValue := record token asInteger.
	commandQueue 
		consumeToken: tokenValue
		ifPresent: [ :result | result value: record ]
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitStatusAsyncOutput: record [

	Transcript show: 'TODO: Handle status async output'; cr; show: record; cr.
]

{ #category : #'private - visiting' }
GDBGIOChannelMIClient >> visitTargetStreamRecord: record [

	eventHandler onTargetOutput: record value
]
