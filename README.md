vap-soap
========

A WebService in Perl.


## Prerequisite	
Run the commands below to install libraries and Perl modules required by the emulator.

	$ install/install.sh

## To start	
Run the commands below to start the emulator. It will host on a Starman server running on port 8180.

	$ ./run.sh

If you want to run on another port, run the script above with a argument of the port you desired:

	$ ./run.sh port_number

Once the emulator starts, you can use [http://server:port/api/Vap_v2_0](http://server:port/api/Vap_v2_0) as endpoint to access the VAP service.

#To close	
You can terminate it with a `cntrl-c` in the controlling terminal window.
