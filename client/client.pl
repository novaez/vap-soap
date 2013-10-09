#!/usr/bin/perl

use warnings;
use strict;

use constant SERVERHOST => 'localhost';
use constant SERVERPORT => '8180';

use XML::Compile::SOAP11::Client;
use XML::Compile::Transport::SOAPHTTP;
use XML::Compile::WSDL11;
use Log::Report   'example', syntax => 'SHORT';
use Data::Dumper;
use URI;                                            #

my $clientId = shift || "20001";
my $purchaseTokenUuid = shift || "014c7e2e-61f8-43bb-b8f3-97dac1e7a07a";

print "clientId=$clientId, purchaseTokenUuid=$purchaseTokenUuid\n";  

my $service_address = 'http://'.SERVERHOST.':'.SERVERPORT.'/api/Vap_v2_0';
my $uri = URI->new($service_address);                # additional HTTP authorization
$uri->userinfo('administrator:quative'); 

my $http = XML::Compile::Transport::SOAPHTTP->new(  # setting new transport
    address => $uri->as_string,                     # with explicit address
);
my $transport = $http->compileClient;             # SOAPAction header

my $schemas = "../wsdl";
# operation definitions from WSDL
my $wsdl = XML::Compile::WSDL11->new("$schemas/Vap_v2_0.wsdl");
$wsdl->importDefinitions("$schemas/Vap_schema_v2_0.xsd"); # more schemas

my $checkVapNgod = $wsdl->compileClient(
    'checkVapNgod', 
    transporter => $transport,
);

my ($answer, $trace) = $checkVapNgod->(
    clientId => $clientId,
    purchaseTokenUuid => $purchaseTokenUuid,
);

if($answer->{Fault})
{   
    warning "Check VAP NGOD failed: {text}"
       , text => $answer->{Fault}{faultstring};
    exit;
}

print Dumper $answer;
#print Dumper $trace;
