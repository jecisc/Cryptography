encoding
sizeOfObject: anObject

	| twosComplement |
	^ anObject positive
		ifTrue: [(anObject lastDigit allMask: 16r80)
			ifTrue: [anObject digitLength + 1]
			ifFalse: [anObject digitLength]]
		ifFalse: [
			twosComplement := anObject negated twosComplement.
			(twosComplement lastDigit noMask: 16r80)
				ifTrue: [twosComplement digitLength+1]
				ifFalse: [twosComplement digitLength]].

