encoding
encode: anObject withDERStream: derStream owner: owner ownerType: ownerType

	| tempStream |
	derStream nextPutTag: (self asn1Tag bitOr: 160).
	tempStream := derStream newStream.
	self parent encode: anObject withDERStream: tempStream owner: owner ownerType: ownerType.
	derStream nextPutLength: tempStream size.
	derStream nextPutAll: tempStream contents.
