#!/usr/bin/perl
#

use strict;
use warnings;

use lib "./data";

#### have a look in the examples directory!
use XML::Compile::SOAP::Daemon::PSGI;
use XML::Compile::WSDL11;
use XML::Compile::SOAP11;
use XML::Compile::Util    qw/pack_type/;
use XML::Compile::SOAP::Util 'SOAP11ENV';
#use Log::Report;
use Responses qw/$responsedb/;


#dispatcher PERL => 'default', mode => 'VERBOSE';


my $responses = $responsedb;
my $notfound = +{
     generalFailure => {
                        faultcode => pack_type(SOAP11ENV, "Server"),
                        faultstring => "DENIED",
                        detail => {
                                  errorMessage => "ErrorCode: [code=151530, severity=ERROR] No such token, or token does not belong to you.",
                                  errorCode => "MRS-0004",
                        },
                    },
      _RETURN_CODE => 500,
};


my $daemon  = XML::Compile::SOAP::Daemon::PSGI->new(
#    preprocess => sub {
#        my ($req) = @_;
#        notice sprintf "Request\n---\n%s %s %s\n%s\n%s---",
#            $req->method, $req->request_uri, $req->protocol,
#            $req->headers->as_string,
#            $req->content;
#    },
#    postprocess => sub {
#        my ($req, $res) = @_;
#        notice sprintf "Response\n---\n%s %s\n%s\n%s---",
#            $res->status, HTTP::Status::status_message($res->status),
#            $res->headers->as_string,
#            $res->body;
#    },
);

# operation definitions from WSDL
my $schemas = "./wsdl";
my $wsdl = XML::Compile::WSDL11->new("$schemas/Vap_v2_0.wsdl");
$wsdl->importDefinitions("$schemas/Vap_schema_v2_0.xsd"); # more schemas
$daemon->operationsFromWSDL(
    $wsdl,
    callbacks => {
        checkVapNgod => \&checkVapNgod,
    },
);
$daemon->setWsdlResponse("$schemas/Vap_v2_0.wsdl");
# Set up PSGI app finally
my $vap_app = $daemon->to_app;

# Set up OPTIONS handler app
my $options_app = sub {
    return [ 200, [], [] ];
};

use Plack::Builder;
builder {
    mount "/api/Vap_v2_0" => $vap_app;
    mount "/hue-gateway/" => $options_app;
};


sub checkVapNgod {
    my ($self, $in) = @_;
    my $data = $in->{'parameter'};
    if (exists $responses->{'joke'}) {
        return $responses->{'joke'};
    }
    my $client_id = $data->{'clientId'};
    my $purchase_token_uuid = $data->{'purchaseTokenUuid'};
    my $key = $client_id . "_" . $purchase_token_uuid;
    my $out = (exists $responses->{$key})
        ? $responses->{$key}
        : $notfound;
    return $out
}
