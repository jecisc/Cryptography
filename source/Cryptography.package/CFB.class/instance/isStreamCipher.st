testing
isStreamCipher
	"Because the actual ciphertext plays a role in computing the next vector, streaming mode seems inappropriate for CFB.  There's also an implementation issue; the vector is shortened after the last (irregularly sized) block, rendering that BlockCipher instance unusable.."
	^ false