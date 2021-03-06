get the page
httpsGetDocumentFromUrl: url args: args accept: mimeType request: requestString
	"Return the exact contents of a web object. Asks for the given MIME 
type. If mimeType is nil, use 'text/html'. An extra requestString may be 
submitted and must end with crlf.  The parsed header is saved. Use a 
proxy server if one has been registered.  tk 7/23/97 17:12"
	"Note: To fetch raw data, you can use the MIME type 
'application/octet-stream'."

	| serverName serverAddr port sock header page type stream length newUrl connectToHost connectToPort |
	Socket initializeNetwork.
	serverName := url authority.
	url port isNil
		ifTrue: [port := self defaultPort]
		ifFalse: [port := url port].
	page := url fullPath.
	args ifNotNil: [page := page, (self argString: args) ].

	connectToHost := serverName.
	connectToPort := port.

	serverAddr := NetNameResolver addressForName: connectToHost timeout: 20.
	serverAddr ifNil: [^ 'Could not resolve the server named: ', serverName].

	3 timesRepeat: [
		sock := HttpsSocket new.
		sock connectTo: serverAddr port: connectToPort.
		(sock waitForConnectionUntil: (Time millisecondClockValue + (10000) truncated)) ifTrue: [
			sock sendCommand: 'GET ', page, ' HTTP/1.0', String crlf, 
				(mimeType ifNotNil: ['ACCEPT: ', mimeType, String crlf] ifNil: ['']),
				'ACCEPT: text/html', String crlf,	"Always accept plain text"
				requestString,	"extra user request. Authorization"
				'Host: ', serverName, ':', port printString, String crlf.

			stream := sock getData readStream.
			header := stream upToAll: String crlf, String crlf. 
			sock header: header.
			length := sock getHeader: 'content-length'.
			length ifNotNil: [ length := length asNumber ].
			type := sock getHeader: 'content-type'.
			sock responseCode first = $3 ifTrue: [
				newUrl := sock getHeader: 'location'.
				newUrl ifNotNil: [ 
					sock destroy.
					newUrl := HttpsUrl absoluteFromText: (self 
						expandUrl: newUrl 
						ip: serverAddr 
						port: port).
					(url = newUrl) ifTrue: [^ 'Could not redirect to a new page on server: ', serverName].
					^newUrl retrieveContentsArgs: args accept: mimeType] ].
			^ MIMEDocument contentType: type content: stream upToEnd url: url]].

	Socket deadServer: serverName.  sock destroy.
	^ 'Server ',serverName,' is not responding'.

