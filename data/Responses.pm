package Responses;

use XML::Compile::Util    qw/pack_type/;
use XML::Compile::SOAP::Util 'SOAP11ENV';

use vars '$VERSION';
$VERSION = '1.00';

use base 'Exporter';

our @EXPORT = qw/$responsedb/;

our $responsedb = +{
                    "20001_general-error" => {
                         Fault => {
                                            faultcode => pack_type(SOAP11ENV, "Server"),
                                            faultstring => "A fault of server.",
                                        },
                         _RETURN_CODE => 404,
                    },
                    "20001_private-error" => {
                         generalFailure => {
                                            faultcode => pack_type(SOAP11ENV, "Server"),
                                            faultstring => "A fault of server.",
                                            detail => {
                                                      errorMessage => "This is a test.",
                                                      errorCode => "999",
                                            },
                                        },
                          _RETURN_CODE => 500,
                    },
                    #"joke" => {
                    "20001_014c7e2e-61f8-43bb-b8f3-97dac1e7a07a" => {
                        'ngodInfo' => {
                                      'clientPrivateString' => 'example'
                                    },
                        'generalInfo' => {
                                         'accountId' => 'example',
                                         'deviceId' => 'example',
                                         'spid' => '-100',
                                         'serverBusinessString' => 'example',
                                         'contentType' => 'COD'
                                       },
                        'playlist' => {
                                      'initialAssetIndex' => 42,
                                      'assets' => [
                                                  {
                                                    'assetUri' => 'example',
                                                    'multicastProgram' => 42,
                                                    'multicastAddress' => 'example',
                                                    'eventEndMillis' => '-100',
                                                    'bitRate' => '-100',
                                                    'playType' => 'ENTERTAINMENT',
                                                    'trickPlay' => {
                                                                   'pause' => 1,
                                                                   'fastForward' => 1,
                                                                   'stop' => 1,
                                                                   'rewind' => 1,
                                                                   'play' => 1
                                                                 },
                                                    'definition' => 'SD',
                                                    'cableLabsProviderId' => 'example',
                                                    'multicastSourceAddress' => 'example',
                                                    'eventStartMillis' => '-100',
                                                    'multicastPort' => 42,
                                                    'cableLabsAssetId' => 'example',
                                                    'assetFilename' => 'example',
                                                    'encoding' => 'MPEG2'
                                                  }
                                                ],
                                      'accessCriteriaHex' => '1234',
                                      'timeOffset' => '-100'
                                    }
                             },
                    };

1;
