# OSC UDP Listener
#

param( $address="Any", $port=10024 )
#$udpclient.Close( )

add-type -AssemblyName microsoft.VisualBasic
add-type -AssemblyName System.Windows.Forms

try{
	$endpoint = new-object System.Net.IPEndPoint( [IPAddress]::$address, $port )
	$udpclient = new-object System.Net.Sockets.UdpClient $port
}
catch{
	throw $_
	exit -1
}

Write-Host "Press ESC to stop the udp server ..." -fore yellow
Write-Host "Waiting for USP message `"/-action/go ,i 0`" on port $port..." -fore yellow
Write-Host ""
while( $true )
{
	if( $host.ui.RawUi.KeyAvailable )
	{
		$key = $host.ui.RawUI.ReadKey( "NoEcho,IncludeKeyUp,IncludeKeyDown" )
		if( $key.VirtualKeyCode -eq 27 )
		{	break	}
	}

	if( $udpclient.Available )
	{
		$content = $udpclient.Receive( [ref]$endpoint )
		Write-Host "$($endpoint.Address.IPAddressToString):$($endpoint.Port) $([Text.Encoding]::ASCII.GetString($content))"
        $command = [Text.Encoding]::ASCII.GetString($content)
        if($command.substring(0, $command.IndexOf(",")) -eq "/-action/go")
        {
            [void] [System.Reflection.Assembly]::LoadWithPartialName("'Microsoft.VisualBasic")
            $x32tctitle = get-process x32tc | ?{$_.MainWindowTitle} | select -exp MainWindowTitle
            [Microsoft.VisualBasic.Interaction]::AppActivate($x32tctitle)
            [System.Windows.Forms.SendKeys]::SendWait('^g')
        }
	}
}

$udpclient.Close( )