import numpy as np
import matplotlib.pyplot as plt
import scipy.optimize as optim
from scipy.integrate import odeint, solve_ivp


# Author parameters
m_p0p1 = 0.0265
m_p4950 = 0.0057

m_p0G = 0.0022
m_p49G = 0.0031

m_p0S = 0.0027
m_p49S = 0.0052

m_p0A = 0.0018
m_p49A = 0.0016

m_GS = 6.837 * 10**(-4)
m_AD = 0.0011

# Our parameters with uniform distribution
m_p0p1 = 0.0222
m_p4950 = 0.0088

m_p0G = 7.85*10**(-4)
m_p49G = 2.19*10**(-7)

m_p0S = 0.0014
m_p49S = 0.0035

m_p0A = 0.0027
m_p49A = 0.0083

m_GS = 0.05
m_AD = 0.0263

k = 3.71 * 10**(-4)

