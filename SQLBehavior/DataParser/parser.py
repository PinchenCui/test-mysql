'''
Created on Mar 26, 2018

@author: andrewta, pinchen

Usage:
parse(<"Input File Name">)
'''



import sys, os
from systemCallsConverter import convertSystemCall
from warnings import catch_warnings
#from StdSuites.Type_Names_Suite import null


def parse(filePath):
    HumanReadable = open(filePath + "HR", "w")         #create a Human readable file
    AnalyticsReadable = open(filePath + "AR", "w")     #create a Analytics readable file
    
    try:  
        with open(filePath,"r") as toParse:                 #read the Input file
            removeWhiteSpace = toParse                      #check that the file is not empty
            tempcollect = aggregate(removeWhiteSpace)       ##
            toParse.seek(0)                                 ##
            if (isNotEmpty(tempcollect)):                   ##
                for i, line in enumerate(toParse):          #Add Header lines to Human readable
                    if (i <= 6):                            ##
                        if (isNotEmpty(line)):              ##
                            HumanReadable.write(line)       ##
                    elif (i > 6 and i < 8):                 #Add column Heads to HR
                        HumanReadable.write("Machine Name            Calling Program            PID            Syscall\n")
                        HumanReadable.write("-------------------------------------------------------------------------\n")
                    else:
                        words = line.split()                #Check for empty lines
                        tempcollect = aggregate(words)      ##                  
                        if (isNotEmpty(tempcollect) and len(words) > 7 and words[7] == '<' and words[8] != 'switch'): #if the line is of format "####, time, #, machine name, HEX, calling program name, Process id, call send symbol, call name" process it
                            timeAll = words[1].split(':')
                            time = timeToSec(timeAll)
                            machineName = words[3]
                            callingProgram = words[5]
                            PID = words[6]
                            syscall = words[8]
                            parameter = ' '.join(str(p).strip('\n').replace(',',' ') for p in words[9:])
                            #print machineName, callingProgram, PID, syscall
                            #HumanReadable.write('{:24.22}'.format(machineName) + '{:26.24}'.format(callingProgram) + '{:17.15}'.format(PID) + '{:13.11}'.format(syscall + '(' + str(convertSystemCall(syscall)) + ')') + '\n')
                            AnalyticsReadable.write(str(convertSystemCall(syscall))+','+ time + ','+ callingProgram + ',' + parameter +'\n')
            else:
                print "File is empty"
                                                  
    except (OSError, IOError) as e:
        print "The Input File is not found by this tool. error: " + str(e) + "\n"

    os.remove(filePath)
    os.remove(filePath + "HR")

def timeToSec(time):
    total = 0.0
    total += int(time[0])*60*60
    total += int(time[1])*60
    total += float(time[2])
    return str(total)

def isNotEmpty(s):
    return bool(s and s.strip())

def aggregate(l):
    allOfIt = ''
    for line in l:
        allOfIt += line.strip()
    return allOfIt

def main():
    #print sys.argv[1]
    parse(sys.argv[1])

if __name__ == '__main__':
    main();

