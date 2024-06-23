/// https://community.intersystems.com/post/encoding-base64-stream-chunk-sizes#comment-200751
Class Oliver.Base64 Extends %RegisteredObject
{

/// Be cautious if changing CHUNKSIZE. Incorrect values could cause the resulting encoded data to be invalid.
/// It should always be a multiple of 57 and needs to be less than ~2.4MB when MAXSTRING is 3641144
Parameter CHUNKSIZE = 2097144;

ClassMethod B64EncodeStream(
	pStream As %Stream.Object,
	pAddCRLF As %Boolean = 0) As %Stream.Object
{
    set tEncodedStream=##class(%Stream.GlobalCharacter).%New()
    
    do pStream.Rewind()
    
    while ('pStream.AtEnd) {
        set tReadLen=..#CHUNKSIZE
        set tChunk=pStream.Read(.tReadLen)
        
        /*
        Note: Base 64 encoding is not able to encode a string which contains unicode (2 byte) characters. 
        If you need to Base 64 encode an unicode string, you should first translate the string to UTF8 format, then encode it.
        set tBinaryText=$ZCONVERT(tChunk,"O","UTF8")
        */
        
        do tEncodedStream.Write($System.Encryption.Base64Encode(tChunk,'pAddCRLF))
        if (pAddCRLF && 'pStream.AtEnd) {
            do tEncodedStream.Write($c(13,10))
        }
    }
    
    do tEncodedStream.Rewind()
    
    quit tEncodedStream
}

/// https://community.intersystems.com/post/base64-encode-word-document
ClassMethod B64EncodeWordDoc(
	pWordDoc As %String = "/ICS/jira/oliver1.docx",
	pAddCRLF As %Boolean = 0) As %String
{
	// file-binary reads bytes and not characters
	set pStream = ##class(%Stream.FileBinary).%New()
	set pStream.Filename = pWordDoc
	set tReadLen = 24000 // tReadLen #3 must be 0 !
	do pStream.Rewind()

    Set tEncodedFilename = pWordDoc_".b64"
    open tEncodedFilename:"nwu":0
	if '$test {
		quit $test
	}
	
	use tEncodedFilename
	while ('pStream.AtEnd) {
		write $System.Encryption.Base64Encode(pStream.Read(tReadLen),'pAddCRLF)
        if (pAddCRLF && 'pStream.AtEnd) {
            Write $c(13,10)
        }
	}
	close tEncodedFilename

	quit tEncodedFilename
}

}
