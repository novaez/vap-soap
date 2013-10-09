vap-soap
========

A WebService in Perl.


## Prerequisite 
Run the commands below to install libraries and Perl modules required by the service.

    $ install/install.sh

## To start 
Run the commands below to start the service. It will host on a Starman server running on port 8180.

    $ ./run.sh

If you want to run on another port, run the script above with a argument of the port you desired:

    $ ./run.sh port_number

Once the service starts, you can use [http://server:port/api/Vap_v2_0](http://server:port/api/Vap_v2_0) as endpoint to access the VAP service.

## To close 
You can terminate it with a `cntrl-c` in the controlling terminal window.

## How to config responses

The service is wrote in Perl and it loads the responses data from a Perl module named `Responses.pm`. You can find the module in `.../data/` folder.

This `Responses.pm` is a pure data module used as a database. It contains a hash table named `responsedb` with all request, response info. To get desired responses you just need to customize it. 

A request contains two arguments: `clientId` and `purchaseTokenUuid`, thus the `responsedb` use the concatenation of them with a `_` as the key, which looks like `clientId_purchaseTokenUuid`, and use the content returned within response as the value.

### A trick
If you use `joke` as the key of an entry in the `resposnedb`, the service will always return that entry, regardless of the arguments `clientId` and 'purchaseTokenUuid` in request. 

There are three types of responses as below.

### General error
In Java code, this error will cause a `RuntimeException`.

The below is a sample data:
```perl
{
     Fault => {
                        faultcode => pack_type(SOAP11ENV, "Server"),
                        faultstring => "A fault of server.",
                    },
     _RETURN_CODE => 404,
}
```

### Private error
In Java code, this error will cause a `VapNackException`, which is a custom exception. See the element `VapNackInfo` in `.../wsdl/Vap_schema_v2_0.xsd` for detail information.

The below is a sample data:
```perl
{
     generalFailure => {
                        faultcode => pack_type(SOAP11ENV, "Server"),
                        faultstring => "A fault of server.",
                        detail => {
                                  errorMessage => "ErrorCode: [code=151530, severity=ERROR] No such token, or token does not belong to you.",
                                  errorCode => "MRS-0004",
                        },
                    },
      _RETURN_CODE => 500,
}
```

### Normal
A normal response contains a hash table of three sub hash tables, all of which are defined in `.../wsdl/Vap_schema_v2_0.xsd`. See the element `VapResponse` in the XSD file for detail information.

The below is a sample data:
```perl
{
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
}
```

## A client
You can find a client script in the `.../client` folder. It accepts two arguments: `clientId` and `purchaseTokenUuid`. They both are optional. The default value are as the table below.

| clientId | purchaseTokenUuid                    |
| -------- | ------------------------------------ |
| 20001    | 014c7e2e-61f8-43bb-b8f3-97dac1e7a07a |

This client always connect to the port `8180` on `localhost`. If you want to connect to another, change the constants `SERVERHOST` and `SERVERPORT` in the script.
