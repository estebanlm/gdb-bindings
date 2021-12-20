Class {
	#name : #BaselineOfGDBBindings,
	#superclass : #BaselineOf,
	#category : #BaselineOfGDBBindings
}

{ #category : #baselines }
BaselineOfGDBBindings >> baseline: spec [
	<baseline>

	spec for: #common do: [
		self petitParser2: spec.
		self osIOEvents: spec.
		self gIO: spec.
		
		spec package: #'GDB-Bindings' with: [ spec requires: #(#'PetitParser2Core') ].
		spec package: #'GDB-Bindings-IOEvents' with: [ spec requires: #(#'GDB-Bindings' 'OSIOEvents') ].
		spec package: #'GDB-Bindings-GIO' with: [ spec requires: #(#'GDB-Bindings' 'GIO') ].
		spec package: #'GDB-Bindings-Tests' with: [ spec requires: #(#'GDB-Bindings') ].
	
		spec 
			group: 'default' with: #('core' 'ioevents' 'tests');
			group: 'core' with: #('GDB-Bindings');
			group: 'gio' with: #('core' 'GDB-Bindings-GIO');
			group: 'ioevents' with: #('core' 'GDB-Bindings-IOEvents');
			group: 'tests' with: #('core' 'GDB-Bindings-Tests')
	 ]
]

{ #category : #'external projects' }
BaselineOfGDBBindings >> gIO: spec [

	spec baseline: 'GIO' with: [ 
		spec 
			className: 'BaselineOfGtk';
			repository: 'github://pharo-spec/gtk-bindings/src';
			loads: 'GLib' ]
]

{ #category : #'external projects' }
BaselineOfGDBBindings >> osIOEvents: spec [
	
	spec baseline: #'OSIOEvents' with: [
		spec repository: 'github://ronsaldo/os-ioevents/tonel' ]

]

{ #category : #'external projects' }
BaselineOfGDBBindings >> petitParser2: spec [
		
	spec baseline: #'PetitParser2Core' with: [
		spec 
			repository: 'github://kursjan/petitparser2';
			loads: 'PetitParser2' ]
]
