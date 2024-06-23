/// https://community.intersystems.com/post/encoding-base64-stream-chunk-sizes#comment-200751
Class Oliver.Base64 Extends %RegisteredObject
{

/// Be cautious if changing CHUNKSIZE. Incorrect values could cause the resulting encoded data to be invalid.
/// It should always be a multiple of 57 and needs to be less than ~2.4MB when MAXSTRING is 3641144
Parameter CHUNKSIZE = 2097144;

ClassMethod B64EncodeStream(pStream As %Stream.Object, pAddCRLF As %Boolean = 0) As %Stream.Object
{
    set tEncodedStream=##class(%Stream.GlobalCharacter).%New()
    
    do pStream.Rewind()
    
    while ('pStream.AtEnd) {
        set tReadLen=..#CHUNKSIZE
        set tChunk=pStream.Read(.tReadLen)
        
        /*
        Note: Base 64 encoding is not able to encode a string which contains unicode (2 byte) characters. 
        If you need to Base 64 encode an unicode string, you should first translate the string to UTF8 format, then encode it.
        */
        set tBinaryText=$ZCONVERT(tChunk,"O","UTF8")
        
        do tEncodedStream.Write($System.Encryption.Base64Encode(tBinaryText,'pAddCRLF))
        if (pAddCRLF && 'pStream.AtEnd) {
            do tEncodedStream.Write($c(13,10))
        }
    }
    
    do tEncodedStream.Rewind()
    
    quit tEncodedStream
}

ClassMethod B64EncodeWordDoc(pWordDoc As %String = "/ICS/jira/oliver1.docx", pAddCRLF As %Boolean = 0) As %Stream.Object
{
	#dim pStream As %Stream.Object
	Set pStream=##class(%Stream.FileBinary).%New()
	Set tSC = pStream.LinkToFile(pWordDoc)
	
    Set tEncodedFilename = pWordDoc_".b64"
    Set tEncodedStream=##class(%Stream.FileBinary).%New()
    Set tSC = tEncodedStream.LinkToFile(tEncodedFilename)

    do pStream.Rewind()
    
    while ('pStream.AtEnd) {
        set tReadLen=..#CHUNKSIZE
        set tChunk=pStream.Read(.tReadLen)
        
        /*
        Note: Base 64 encoding is not able to encode a string which contains unicode (2 byte) characters. 
        If you need to Base 64 encode an unicode string, you should first translate the string to UTF8 format, then encode it.
        */
        set tBinaryText=$ZCONVERT(tChunk,"O","UTF8")
        
        do tEncodedStream.Write($System.Encryption.Base64Encode(tBinaryText,'pAddCRLF))
        if (pAddCRLF && 'pStream.AtEnd) {
            do tEncodedStream.Write($c(13,10))
        }
    }
    
    do tEncodedStream.Rewind()
    Set tSC = tEncodedStream.%Save()
    Do $System.Status.DisplayError(tSC)
    quit tEncodedStream
}

}
