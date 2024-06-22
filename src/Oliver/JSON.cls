Class Oliver.JSON
{

ClassMethod Atest() As %Status
{
	Set do = {"evidences":[{"filename":"VALIP-1559.docx","contentType":"application/vnd.openxmlformats-officedocument.wordprocessingml.document","data":"https://jira.devops.oliver.com/my-jira/plugins/servlet/raven/attachment/51630/VALIP-1559.docx"}]}
	Set tSC = ..Iterate(.do)
	Quit $$$OK
}

ClassMethod Iterate(
	ByRef obj As %DynamicAbstractObject,
	document = 0,
	path = "obj",
	returnOnError = 0) As %Status
{
	#dim iterator As %Iterator.Array
	set iterator = obj.%GetIterator()
	while iterator.%GetNext(.key, .value) {
		if $classname(obj) = "%Library.DynamicArray" {
			set newPath = path _ ".%GetAt(" _ key _ ")"
		} else {
            if $zname(key, 6) = 1 {
                set newPath = path _  "." _ key
            } else {
                set newPath = path _  ".""" _ key _ """"
            }
        }
		if $isObject(value) {
			do ..Iterate(value, document, newPath)
		}
		Write !,key," = ",value
		If (key = "data") {
			Set x = ..lookData(value)
			Set obj.data = x
		}
	}
	Quit $$$OK
}

ClassMethod lookData(
	pFile As %String = "",
	pFileNew As %String = "") As %Status
{
	Set q = """"
	Set tData = q_pFile_q
	Set tFileOutlog = "/ICS/jira/wlogDATA"
	Set tFileOutput = "/ICS/jira/wgetDATA1343.docx"
	Set tSC = ##class(Oliver.ZF).JiraGet(tData,tFileOutput,tFileOutlog)
	Set stream = ##class(%Stream.FileBinary).%New()
	Set tSC = stream.LinkToFile(tFileOutput)
	Set tEncodedStream = ##class(Oliver.Base64).B64EncodeStream(stream)
	Quit tEncodedStream.Read()
}

}
