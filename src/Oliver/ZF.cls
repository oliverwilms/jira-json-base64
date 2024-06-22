Class Oliver.ZF
{

ClassMethod Test() As %Status
{
	Set tSC = $$$OK
	Set tReturn = $ZF(-100,"/SHELL","pwd")
	Set tReturn = $ZF(-100,"/SHELL","hostname")
	Quit tSC
}

ClassMethod Hostname(pArg As %String = "") As %String
{
	Set q = """"
	Set tFilename = "oliverzf.txt"
	Set tHostname = ""
	Set pFlags = "/SHELL/STDOUT="_q_tFilename_q
	Set pCmd = "hostname"
	//Set pArg = "-s"
	If (pArg = "") {
		Set tReturn = $ZF(-100,pFlags,pCmd)
	} Else {
		Set tReturn = $ZF(-100,pFlags,pCmd,pArg)
	}
	Write "tReturn = ",tReturn,!
	//Hang 1
	Set tHostname = ..ReadFile(tFilename)
	Quit tHostname
}

ClassMethod JiraGet(pURL As %String, pFileOutput As %String, pFileOutlog As %String) As %String
{
	Set q = """"
	//Set pFlags = "/LOGCMD /NOQUOTE"  ; This does NOT work without /SHELL
	Set pFlags = "/LOGCMD /NOQUOTE /SHELL"
	Set pHeader = "--header="_q_"Authorization: Bearer MyTokenValue+F"_q
	Set pNoCheck = "--no-check-certificate"
	Set pCmd = "wget"
	;
	Set tReturn = $ZF(-100,pFlags,pCmd,pHeader,pNoCheck,"-O",pFileOutput,"-a",pFileOutlog,pURL)
	Write "tReturn = ",tReturn,!
	//Hang 1
	Set tReturn = ..ReadFile(pFileOutlog)
	Quit tReturn
}

ClassMethod ReadFile(pFile As %String) As %String
{
	If ($Get(pFile) = "") Quit ""
	Set timeout = 2
	Try {
		Open pFile:("R"):timeout  // read
		If $test {
			Use pFile
			Read host
			Close pFile
		}
	} Catch {
	}
	//Set tReturn = ..ParseHost($Get(host))
	Set tReturn = $Get(host)
	Quit tReturn
}

}
