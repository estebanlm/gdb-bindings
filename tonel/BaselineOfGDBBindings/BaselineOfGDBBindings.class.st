Class {
	#name : #BaselineOfGDBBindings,
	#superclass : #BaselineOf,
	#category : #BaselineOfGDBBindings
}

{ #category : #baselines }
BaselineOfGDBBindings >> baseline: spec [
	<baseline>

	spec for: #common do: [
		spec baseline: #'PetitParser2Core' with: [
			spec 
				repository: 'github://kursjan/petitparser2';
				loads: 'PetitParser2' ] ].
		spec package: #'GDB-Bindings' with: [
				spec requires: #(#'PetitParser2Core') ].
]
