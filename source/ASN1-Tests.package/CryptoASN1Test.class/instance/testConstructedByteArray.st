tests - BER
testConstructedByteArray

	| bytes obj testObj |
	bytes := #(36 12 4 4 1 35 69 103 4 4 137 171 205 239).
	testObj :=#(1 35 69 103 137 171 205 239) asByteArray.
	obj := ASN1Stream decodeBytes: bytes.
	self assert: (obj = testObj).
