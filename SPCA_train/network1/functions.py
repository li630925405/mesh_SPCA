import numpy as np
import tensorflow as tf

# Relu functions
def sigm(P):
    return 1./tf.exp(-P)

def tanh_opt(A):
    return 1.7159*tf.tanh(2/3*A)

# norm function
def normalize(x, mu, sigma):
    return (x-mu)/sigma

def MSE(y,y_hat):
    return np.mean(np.square(y_hat-y))
