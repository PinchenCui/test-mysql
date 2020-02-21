'''
Created on Apr 2, 2018

@author: andrewta
'''
import pickle


#Conversion method for name to num or vice versa

def convertSystemCall(call):
    NumToName = LoadDictionary("syscallsMapNumName.txt")
    NameToNum = LoadDictionary("syscallsMapNameNum.txt")
    if (isinstance(call, int)):
        return NumToName[call]
    else:
        return NameToNum[call]

#These methods Serialize Maps to a binary file

#Usage:
#    SaveDictionary(<Map to save>, <"File Name">)
def SaveDictionary(dictionary,File):
    with open(File, "wb") as myFile:
        pickle.dump(dictionary, myFile)
        myFile.close()

#Usage:
#    <Variable for map> = LoadDictionary(<"File Name">)
def LoadDictionary(File):
    with open(File, "rb") as myFile:
        dicti = pickle.load(myFile)
        myFile.close()
        return dicti
