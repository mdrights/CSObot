<?php
// Written on Feb 11, 2017.
// http://www.wikihow.com/Develop-an-IRC-Bot

$server = '94.125.182.252';
$port = 6667;
$nickname = 'MDbot';
$ident = 'mdrightsBot';
$gecos = 'Mdrights first testing bot';
$channel = '#GentooWithoutJUJU';

function check_error( $var ) {
if ( $var === false ){
  $errorCode = socket_last_error();
  $errorString = socket_strerror( $errorCode );
  die( "Error $errorCode: $errorString\n" );
}
}

$socket = socket_create( AF_INET, SOCK_STREAM, SOL_TCP ); //套接字地址

check_error( $socket );

$bind = socket_bind( $socket, "127.0.0.1", 12345 );

check_error( $bind );

$listen = socket_listen( $socket );

check_error( $listen );

$connect = socket_connect( $socket, $server, $port );

check_error( $connect );

#socket_write( $socket, 'PING' );
socket_write( $socket, "NICK $nickname\r\n" ) or die( "could not write ...\n" );
socket_write( $socket, "USER $ident * 8 :$gecos\r\n" );

//$client = socket_accept( $socket );
//check_error( $client );

echo socket_read( $socket, 1024, PHP_NORMAL_READ );


// --------------------

while ( is_resource( $socket ) ) {

    $data = trim( socket_read( $socket, 1024, PHP_NORMAL_READ ) );
    echo $data . "\n";

  $d = explode(' ', $data);

  $d = array_pad( $d, 10, '' );

  if ( $d[0] === 'PING' ) {
	socket_write( $socket, 'PONG' . $d[1] . "\r\n" );
  }

  if ( $d[1] === '376' || $d[1] === '422' ) {
	socket_write( $socket, 'JOIN ' . $channel . "\r\n" );
  }

  if ( $d[3] == ':@moo' ) {
	$moo = "M" . str_repeat( "o", mt_rand(2, 15) );
	socket_write( $socket, 'PRIVMSG ' . $d[2] . " :$moo\r\n" );
  }
}
?>
