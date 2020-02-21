import os, timeit, math
import csv
import copy

def dataCreator(Nos,sequences,times,procs,para_f,para_l,para_v):
    with open('merged_data.csv', mode='w+') as csv_file:
        fieldnames = ['syscall', 'time', 'process', 'fields', 'length', 'value']
        writer = csv.DictWriter(csv_file, fieldnames=fieldnames)
        writer.writeheader()
        rows = []
        for i in range(len(Nos)):
            row = {'syscall': str(sequences[i]), 'time': str(times[i]), 'process': str(procs[i]), 'fields': str(para_f[i]), 'length': str(para_l[i]), 'value': str(para_v[i])}
            rows.append(row)
        writer.writerows(rows)

def sampleRead(path):
    print ("Start Sample Reading......")
    fileList = os.listdir(path)
    ret1 = []
    ret2 = []
    ret3 = []
    ret4 = []
    ret5 = []
    No = 1
    total_length = 0
    for f in fileList:
        print (f),
        seq = []
        time = []
        para = []
        proc = []
        Nos = []
        try:
            with open(path+"/"+f, "r") as sample:
                count = 0
                cur = 0
                last = -1
                tail = []
                for line in sample:
                    count += 1
                    cur += 1
                    temp = line.strip("\n").strip().split(',')
                    if temp[0]=='77':
                        if last == cur-1:
                            last += 1
                            tail = temp
                            continue
                        last = cur
                        tail = temp
                        seq.append(temp[0])
                        if len(temp) > 1:
                            time.append(temp[1])
                            proc.append(temp[2])
                            para.append(temp[3])
                            Nos.append(No)
                    else:
                        if last == cur-1:
                            seq.append(tail[0])
                            if len(tail)> 1:
                                time.append(tail[1])
                                proc.append(tail[2])
                                para.append(tail[3])
                                Nos.append(No)
                            tail = []
                        seq.append(temp[0])
                        if len(temp)> 1:
                            time.append(temp[1])
                            proc.append(temp[2])
                            para.append(temp[3])
                            Nos.append(No)
                if not seq:
                    seq.append('0')
                    seq.append('999')
                    time.append('0')
                    time.append('999')
                    para.append(' ')
                    para.append(' ')
                    proc.append(' ')
                    proc.append(' ')
                ret1.extend(seq)
                ret2.extend(time)
                ret3.extend(proc)
                ret4.extend(para)
                ret5.extend(Nos)
                print (count)
                total_length += count
        except:
            raise Exception()
        No += 1
        break
    #print("Max Count: " + str(max))
    print("Total Length: "+ str(total_length))
    print("Length After Preprocessing: "+ str(len(ret1)))
    print ("Samples Read Done!")
    return ret1,ret2,ret3,ret4,ret5

def goodParaFeed(seqs,paras):
    print ("_________________________________________")
    print ("Start Loading and Preprocessing the Observations...\n")
    seqRef = list(set(seqs))
    calls = dict.fromkeys(seqRef,[])
    for i in range(len(seqs)):
        calls[seqs[i]].append(paras[i])
        calls[seqs[i]] = list(set(calls[seqs[i]]))
    print ("Total " + str(len(calls))+ " syscalls used as good references:")
    return calls

def numericalPara(paras):
    fields = []
    lens = []
    vals = []
    for para in paras:
        field = para.count('=')
        this_len = len(para)
        val = 0
        for c in para:
            val += ord(c)
        fields.append(field)
        lens.append(this_len)
        vals.append(val)
    return fields,lens,vals

def numericalProc(procs):
    scale = len(set(procs))
    ret = []
    for proc in procs:
        val = 0
        for c in proc:
            val += ord(c)
        ret.append(val)
    return ret

goodDir = "/home/auresearch/SQL-Dataset/"

start = timeit.default_timer()
goodseq,goodtime,goodproc,goodpara,goodNo = sampleRead(goodDir)


print ("___________________________________")

print ("Numercial the data...")
para_f,para_l,para_v = numericalPara(goodpara)
proc_n = numericalProc(goodproc)
print ("_________________________")
print ("Writing into CSV File!")
dataCreator(goodNo,goodseq,goodtime,proc_n,para_f,para_l,para_v)
print ("All Done!")

stop = timeit.default_timer()
print ("Time used: ", stop-start)
