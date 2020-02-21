import numpy as np
from sklearn.base import BaseEstimator, TransformerMixin

def Get_Casis_CUDataset():
    X = []
    Y = []
    datafile = "SEC.txt"
    #datafile = "CASIS-25_CU.txt"
    with open(datafile, "r") as feature_file:
        for line in feature_file:
            line = line.strip().split(",")
            Y.append(line[0][:4])
            X.append([float(x) for x in line[1:]])
    return np.array(X), np.array(Y), datafile

def Get_attacks():
    X = []
    Y = []
    datafile = "Attack.txt"
    #datafile = "Attack_AL.txt"
    with open(datafile, "r") as feature_file:
        for line in feature_file:
            line = line.strip().split(",")
            Y.append(line[0][:4])
            X.append([float(x) for x in line[1:]])
    return np.array(X), np.array(Y), datafile

class DenseTransformer(BaseEstimator, TransformerMixin):

    def __init__(self):
        pass

    def fit(self, X, y=None):
        return self

    def transform(self, X):
        return X.toarray()

