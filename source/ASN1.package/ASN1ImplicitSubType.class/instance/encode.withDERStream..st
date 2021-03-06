encoding
encode: anObject withDERStream: derStream

	| myTag tempStream |
	myTag := self asn1Tag bitOr: 128.
	self parent isConstructed
		ifTrue: [myTag := myTag bitOr: 32].
	derStream nextPutTag: myTag.
	tempStream := derStream newStream.
	self parent encodeValue: anObject withDERStream: tempStream.
	derStream nextPutLength: tempStream size.
	derStream nextPutAll: tempStream contents.



