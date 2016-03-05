# Description


This directory provides the _NewHope_ key exchange scheme implementation optimized for the Cortex-M0  processor and the underlying ARMv6-M architecture. 

The code provided in this directory was developed and tested on the 
[STM32F0Discovery development board](http://www.st.com/web/catalog/tools/FM116/SC959/SS1532/PF253215?sc=internet/evalboard/product/253215.jsp).


All carefully optimized assembly implementations can be found in files starting with `asm_`.




# Interaction


To interact with the Cortex-M0 either in server or in client mode 
depending on the script uploaded, we provide two python scripts. 
These can be found in the 'scripts' subdirectory.

* Proof-of-concept binaries
    + Server test: `make runServer` invokes the NewHope server side test. It loads the code into the device memory and calls the test_server python-script to test the communication and computations of the server-side code on the device against results taken from the reference implementation. 
    + Client test: `make runClient` invokes the NewHope client side test. It loads the code into the device memory and calls the test_client python-script to test the communication and computations of the client-side code on the device against results taken from the reference implementation. 
* Measurement binaries
    + Speed measurements: `make runSpeed` invokes cycle count measurements. It loads the code into the device memory and calls the monitor script to print the output of the device.
    + Memory usage measurement: `make runMemsize` invokes the memory measurements. The ROM usage can be determined by running `arm-none-eabi-size -t tests/libnewhopearm.a`.

# Communication-API


If one decides to implement different correspondence software for the 
Cortex-M0, the following has to be assumed:
All values send and received are bytes.
A GUARD parameter is used, it has the decimal value 10.
As can be seen in the python files in the "scripts" folder, the 
following structure is needed:



| Client        | Size | Server       | Size |
| ------------- |:----:| -------------|:----:|
| GUARD         | 1    | GUARD        | 1    | 
|< receive message A| 1824 |> send message A|1824|
| GUARD         | 1    | GUARD        | 1    |
|> send message B|2048| < receive message B |2048|
| GUARD         | 1    | GUARD        | 1    |
|response to keycheck|5|response to keycheck|5|

The keychecking process is part of the static implementation and should 
be removed from 'newhope.c' along with the constant character array `key_stored` in the file 
`test/client.c` and `test/server.c` files. The server side performs the computations from the API function `newhope_keygen` before it sends the message A and the computations from the API function `newhope_shareda` after it received message B. The client side performs the computations from the API function `newhope_sharedb` after it received message A and before it sends message B. 


# Troubleshooting 

During testing we encountered two pitfalls the code can run into.

* We experienced that the host scripts and the code on the Cortex-M0 get out of sync. In this case `make runClient` should be called, which will prompt `> Waiting for signal..`. If the rest button is pressed the host and Cortex-M0 should be in sync again. 

* We experienced that the output of `make runMemsize` is not printed. In this case we found that calling the `make runSpeed`,`make runMemsize`,`make runMemsize` solves that issue. 


  



