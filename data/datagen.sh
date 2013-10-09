#!/bin/bash

read -d '' head <<"EOF"
package Responses;

use XML::Compile::Util    qw/pack_type/;
use XML::Compile::SOAP::Util 'SOAP11ENV';

use vars '$VERSION';
$VERSION = '1.00';

use base 'Exporter';

our @EXPORT = qw/$responsedb/;

our $responsedb = +{
    "20001_general-error" => {
         generalFailure => {
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
                                      errorCode => 999,
                            },
                        },
          _RETURN_CODE => 200,
    },
EOF

echo "${head}"

for i in {1..3}
do
    read -d '' entity <<EOF
    "${i}_${i}" => {
        'ngodInfo' => {
                      'clientPrivateString' => 'example-${i}'
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
EOF
    echo  "    ${entity}"
done

read -d '' end <<EOF
    };

1;
EOF

echo "${end}"
