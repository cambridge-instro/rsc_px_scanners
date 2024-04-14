import socket
import numpy as np

def CIinit(scannerPORT):

    """ 
    CI scanner initialisation.
    Returns a UDP object.
    """
    
    s = socket.socket(socket.AF_INET,   # Internet
                    socket.SOCK_DGRAM)  # UDP
                    
    s.bind(("", scannerPORT))
    
    return s
    
def CIread(s):

    """ 
    CI scanner read.
    Takes a UDP object bound to a scanner PORT, and returns a 16 Px array and the address that sent it.
    """
    
    byte_data, scannerIP = s.recvfrom(127)
    
    return np.array(byte_data.decode("utf-8").split(','), dtype = float), scannerIP[0]

def CIzero(scannerIP):

    """ 
    CI scanner zero.
    Checks first, then sends a ZERO command to the scanner at scannerIP.
    
    print(f"                - WARNING -              ")
    print(" ")
    print(f' - ABOUT TO ZERO SCANNER AT {scannerIP} -')
    print(" ")
    input(f'- PRESS "ENTER" TO CONTINUE OR "CRTL C" TO STOP -')
    """

    sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM) # UDP
    sock.sendto(bytes("ZERO", "utf-8"),(scannerIP, 8888))
 

#
# Initialise a scanner with it's PORT. The PORT for each scanner should be setup in the web tool, 
# in SETUP mode using the yellow DIP switch visible through the hole in the back
#
s4004 = CIinit(4004)

#
# Grab a sample of data and print
#
Px, scannerIP_4004 = CIread(s4004)
print(Px)
print(scannerIP_4004)

#
# Uncomment the line below to run the example script to zero the scanner.
#
# WARNING, make sure the wind is off. The scanner has no internal valves.
#
# Best accuracy is achieved if the scanner is zeroed after it's been running for ~5 mins. 
# 
# Once zeroed, the unit will achieve the datasheet specs of the Honeywell RSC sensors
#
# NOTE the +/-1kPa scanners use +/-2"H20 RSC sensors with a custom calibration.
#
# https://prod-edam.honeywell.com/content/dam/honeywell-edam/sps/siot/ja/products/sensors/pressure-sensors/board-mount-pressure-sensors/trustability-rsc-series/documents/sps-siot-trustability-rsc-series-data-sheet-32321348-ciid-164408.pdf
#

# CIzero(scannerIP_4004)











