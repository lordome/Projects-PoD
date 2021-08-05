#This is the input file for cosmo_rate.py
#Details follow
#CB stands for compact binary
import os
os.environ['MKL_NUM_THREADS'] = '1' #this command prevents Python from multithreading (useful especiallfy for demoblack machine!)
import numpy as np
import pandas as pd
import scipy.interpolate as scpi
from astropy.cosmology import Planck15  as Planck
import astropy.units as u
import sys
from math import erf, log10

# Simulations specificities (PopSynth / N-body)
cb_class = ['BHNS']# list of compact objects type 
Z_simulated = [0.0002, 0.0004, 0.0008, 0.0012, 0.0016, 0.002, 0.004, 0.006, 0.008, 0.012, 0.016, 0.02]# list of metallicity used from simulations, as float type, ascending order

formation_channel = 'iso' # formation channel type (iso,dyn)
if formation_channel=='iso':
		fbin = 0.5 # fraction of binaries, for 'iso' it must be either 50% or 40%. 40% when len(Z) < 12
		fimf = 0.285 # correction for initial mass function. For 'iso' must be 0.285
		fbin_save = int(100.0*fbin) #this is the fraction of binaries that appears in the file name. Dynamical binaries are alredy 40 % of binaries
elif formation_channel=="dyn":
		fbin = 1. # fraction of binaries, for 'iso' it must be either 50% or 40%. 40% when len(Z) < 12
		fimf = 1. # correction for initial mass function. For 'iso' must be 0.285
		fbin_save = 40 #this is the fraction of binaries that appears in the file name. Dynamical binaries are alredy 40 % of binaries

sim = 'A5' # this parameter is used in naming the output files depending on the types of simulations considered (i.e values of alpha, SN model type...)

###########################################################
# Description of input files
###########################################################
# The code will search in sim/input_catalogues/ folder files .dat
# divided per each CB and per each Z.
# The files are divided in three columns: delay times in years, primary mass and secondary mass in solar masses.
# The first row of each file containes the total simulated mass. 

# Redshift bins. The merger rate density will be evaluated in the middle of the redshift bin
bin_z = 0.1# redshift bin width
zMAX = 8.0# maximum redshift
zMIN = 0.0# minimum redshift 

# Solar metallicity
Z_sun = 0.019 #from Gallazzi et al. 2008

# Choose model for average metallicity fit type (so far only linear model implemented)
metmod_type = 'galaxy'
if metmod_type == 'linear':
	def metz(z, slope, intercept):
		# This function evaluates the mean metallicity evolution with redshift
		#-------------------------
		# z --> redshift
		# slope --> of the linear metallicity evolution model. It has to be given below.
		# intercept --> of the linear metallicity evolution model. It has to be given below.
		#-------------------------

		Z_average = intercept+slope*z # the result is in log-sun scale 
		return Z_average

elif metmod_type == 'galaxy':
	# This chance gives the possibility to introduce Metallicities models from 2D datasets (z vs log(Z))
	# A 1d interpolation over the provided dataset is exploited in order to get a consistent model.
	# !!! --- IMPORTANT --- !!! The first row in the upload file is skipped.

	## path to the file where data are stored.
	path_to_file = 'logZ_FMR.txt' 
	data = pd.read_csv(path_to_file, sep=" ", header=None, skiprows = 1)
	data.iloc[:,1] = data.iloc[:,1]-np.log10(Z_sun)	
	interp_met = scpi.interp1d(data.iloc[:,0], data.iloc[:,1], fill_value='extrapolate')

	def metz(z, slope, intercept):
		# This function evaluates the mean metallicity evolution starting from a dataset of redshift vs metallicities.
		#-------------------------
		# z --> redshift
		# slope --> Not used in this function. Parameter kept for consistency with previous definition
		# intercept --> Not used in this function. Parameter kept for consistency with previous definition
		#-------------------------

		Z_average = interp_met(z) # the result is in log-sun scale 
		return Z_average
else:
	print("Please choose between the following models: linear - galaxy")
	exit()


########
# every metallicity related quantity must be given in log-sun scale
#######
# metallicity options	
metmod =  'D18solmet'# insert the average metallicity model, e.g D18solmet means De Cia et al. 2018 slope with redshift but rescaled to solar metallicity at redshift zero
met_slope_avg = -0.24 # from De Cia et al. 2018
met_inter_avg = 1 # from Gallazzi et al. 2008
sigma_met = 0.20 # value of the metallicity spread in log-sun-scale 

met_uncertainty = 'No' # if 'Yes' the uncertainty due to metallicity will be computed
met_slope_sprd = 0 # from De Cia et al. 2018
met_inter_sprd = 0 # from Gallazzi et al. 2008

# star formation rate options
sfr_uncertainty = 'Yes'# if 'Yes' the uncertainty due to sfr will be computed,
sfr_avg = -2 # from Madau & Dickinson 2016, normalisation value
sfr_sprd = 0.2 # from Madau & Dickinson 2016

# number of iterations if uncertainty is ON
N_iter = 50 #number of iteration to be done for evaluating the uncertainty: it must be at least one!
		#1000 iterations are enough to perform a robust estimation of the uncertainties

n_paral = 1 #value to be assigned in order to paralelize the code and not to overwrite oder output

# catalogs options
catalogues_c = 'No' # if 'Yes' merging CB per redshift bin are produced
N_cat = 0 # number of CB per redshift bin
N_figures = 5 # number of significant decimal digits that are saved for each paramter of the merging compact binary catalogue. This feature has been provided for saving memory space. 

# merging efficiency 
eta_interpol_c = 'No'# if 'Yes' the code evaluates the MRD using the merging efficiency interpolated from Z_simulated on Z_interpol
Z_interpol = [0.0008, 0.008, 0.016] #values of metallicity on which the code performs merging efficiency interpolation, as float, ascending order

# path where to write output file
path_out = sim+'/output_FMR_lowerz/'#path to the output folder. The output are divided by CB class
