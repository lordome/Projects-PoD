##########################################################################
# What follows is the main script of cosmoRate. It takes
# cosmo_input.py where all the initial conditions and variables
# are defined. Please refer to cosmo_input.py for further details.
# This script gives as output a file .dat where the first
# column is the middle of the redshift bin, 
# the second the merger density (MD) [Gpc^{-3}]
# and the third column the merger rate density (MRD) [Gpc^{-3}yr^{-1}].
# Further columns are always the MRD evlauted for uncertainty estimation.
###########################################################################
import sys
import cosmo_functions as cf
import os
from random import gauss
from astropy.cosmology import Planck15 as Planck
import astropy.units as u
from astropy.cosmology import z_at_value


# Read the input file
file_input = sys.argv[1]
if file_input == 'cosmo_input':
    from cosmo_input import *
else:
    print('Your input file has not been recongnized')
    exit()

# histograms of redshift/time in descending order
z_hist = np.arange(zMAX, zMIN, -bin_z)
bin_t1 = sorted(np.array(Planck.lookback_time(z_hist))*10**9)  # in yrs using Planck15 
bin_t = np.insert(bin_t1, 0, 0)

for k in range(len(cb_class)):  # loop over compact object type
    print(cb_class[k], sim)
    ############################
    # read the input catalogues
    ############################
    # initialise
    mrem1_Z_sim = []
    mrem2_Z_sim = []
    td_Z_sim = []
    mtot_Z_sim = []

    # read masses and time delays from catalogs
    for Z_sim in Z_simulated:
        [mrem1_Z_read, mrem2_Z_read, td_Z_read] = np.loadtxt(
            sim+'/input_catalogues/data_'+cb_class[k]+'_'+str(Z_sim)+'.dat', skiprows=1, unpack=True)
        mrem1_Z_sim.append(mrem1_Z_read)
        mrem2_Z_sim.append(mrem2_Z_read)
        td_Z_sim.append(td_Z_read)
        mtot_is_0 = np.loadtxt(sim+'/input_catalogues/data_' +
                               cb_class[k]+'_'+str(Z_sim)+'.dat', usecols=0)
        mtot_Z_sim.append(mtot_is_0[0])

    # compute merger efficiency. The binary fraction (fbin) and the IMF parameter (fimf) need to be specified in the input file.
    eta_known = [np.array(len(td_Z_sim[q]))/np.array(mtot_Z_sim[q])
                 * fbin*fimf for q in range(len(td_Z_sim))]

    # if option activated, use an interpolation on missing metallicities
    if eta_interpol_c == 'Yes':
        [eta, Z_list] = cf.eta_interpol(Z_interpol, Z_simulated, eta_known)
        [td_Z, mrem1_Z, mrem2_Z] = cf.sort_catalogues(
            Z_list, Z_simulated, td_Z_sim, mrem1_Z_sim, mrem2_Z_sim)
    else:
        eta = eta_known
        Z_list = Z_simulated
        td_Z = td_Z_sim
        mrem1_Z = mrem1_Z_sim
        mrem2_Z = mrem2_Z_sim

    # This contains the values of the merger rate densities for each realisation
    MR_z = np.zeros((len(z_hist), N_iter))

    # Values for the model of averaged metallicity and SFR. These values correspond to the median
    # Model and references in cosmo_input.py
    met_slope = met_slope_avg
    met_inter = np.log10(met_inter_avg)
    sfr_norm = 10**(sfr_avg)

    # Prepare the metallicity array used to evaluate the probability distributions of metallicities
    # two metallicity extremes are defined such that the sum of all probabilities is always one
    # (in log-sun sale since sigma_met is in log-sun scale)
    Z_max_z = metz(z_hist[len(z_hist)-1], met_slope, met_inter)
    Z_max_spread_log_sun = Z_max_z+20*sigma_met
    Z_min_z = metz(z_hist[0], met_slope, met_inter)
    Z_min_spread_log_sun = Z_min_z-20*sigma_met

    # Z_list is transformed in log-sun scale
    Z_log_sun = np.log10(Z_list)-np.log10(Z_sun)
    Zs = np.append(np.append(Z_min_spread_log_sun,
                             Z_log_sun), Z_max_spread_log_sun)  # here Z_max_spread_log_sun and Z_min_spread_log_sun are appended

    #If options are disbaled, loop done only once for the median values of the models.
    for i in range(N_iter):

        # compute the merger rate densities (MRD) and merger densities (MD). The quantity v is the number of mergers per Mpc-3 as a function of merger and
        # the quantity v_index contains the catalogs' indices of the merging objects. Both quantities depend on merger redshift, formation redshift
        # and metallicity
        [MRD, v,  v_index] = cf.merger_rate_density(
            metz, bin_z, z_hist, Zs, bin_t, td_Z, eta, met_slope, met_inter, sfr_norm, sigma_met)

        # store merger rate density
        MR_z[:, i] = MRD[::-1]

        # resample values depending on assumptions on metallicity evolution and star formation rate uncertainty
        if met_uncertainty == 'Yes':
            if N_iter <= 1:
                print('select more iterations!')
                exit()
            met_slope = gauss(met_slope_avg, met_slope_sprd)
            met_inter = np.log10(gauss(met_inter_avg, met_inter_sprd))

        if sfr_uncertainty == 'Yes':
            if N_iter <= 1:
                print('select more iterations!')
                exit()
            sfr_norm = 10**(gauss(sfr_avg, sfr_sprd))

    #Save MD and MRD in output file
    head = "Redshift"+"\t\t"+"Merger Rate Density [Gpc^-3yr^-1]"
    location = path_out+cb_class[k]+'/'
    filename = '/MRD_spread_'+str(len(Z_list))+'Z_'+str(fbin_save)+'_'+eta_interpol_c+'_'+metmod+'_'+str(
        sigma_met)+'_'+met_uncertainty+'_'+sfr_uncertainty+'_'+str(n_paral)+'.dat'

    # Column 0: merger redshift, Column 1: Merger density, Column >=2: Merger Rate Density
    MR_z_save = np.zeros((len(z_hist), N_iter+1))
    for c in range(len(z_hist)):
        MR_z_save[c, :] = np.hstack(
            [z_hist[::-1][c]-bin_z/2, MR_z[c, :]])
    np.savetxt(location+filename, MR_z_save, header=head)

    # if catalog option is activated, produce catalogs of merging compact objects in various redshift bins
    if catalogues_c == 'Yes':
        Zperc = cf.catalogues(z_hist, Z_list, v, v_index, N_cat,
                              td_Z, mrem1_Z, mrem2_Z, location, cb_class[k], sim, N_figures)

        # Column 0: merger redshift, Column from 1 to len(Z_list)-1:Metallicity percentage, Column len(Z_list): sum of the percentages
        Zperc_comp = np.zeros((len(z_hist), len(Z_list)+2))
        for a in range(len(z_hist)):
            Zperc_comp[a, :] = np.hstack(
                [z_hist[a]-bin_z/2, Zperc[a, :], np.sum(Zperc[a, :])])

        filename_Zperc = '/Zperc_z_'+str(len(Z_list))+'Z_'+str(fbin_save)+'_'+eta_interpol_c+'_'+metmod+'_'+str(
            sigma_met)+'_'+met_uncertainty+'_'+sfr_uncertainty+'_'+str(n_paral)+'.dat'
        head_Zperc = 'Redshift'+'\t'+str(Z_list)+'\t'+'Total percentage'
        np.savetxt(location+filename_Zperc, Zperc_comp,
                   header=head_Zperc, fmt='%f')
