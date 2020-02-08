Class {
	#name : #BaselineOfGDBBindings,
	#superclass : #BaselineOf,
	#category : #BaselineOfGDBBindings
}

{ #category : #baselines }
BaselineOfGDBBindings >> baseline: spec [
	<baseline>

	| conditionalDeps |
	spec for: #common do: [
		conditionalDeps := #().
		Smalltalk globals at: #PP2CompositeNode ifAbsent: [ 
			conditionalDeps := { #'PetitParser2Core' }.
			spec baseline: #'PetitParser2Core' with: [
					spec
						repository: 'github://kursjan/petitparser2' ].
		].
		spec
			baseline: #'OSIOEvents' with: [
				spec
					repository: 'github://ronsaldo/os-ioevents' ].
		spec
			package: #'GDB-Bindings' with: [
				spec requires: #(#'OSIOEvents') , conditionalDeps
			].
	].
]
