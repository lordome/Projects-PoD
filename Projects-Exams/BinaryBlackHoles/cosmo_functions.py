#################################################
# This script contains the whole set of functions
# that are necessary to comso_rate.py
#################################################
import os
os.environ['MKL_NUM_THREADS'] = '1' #this command prevents Python from multithreading (useful for demoblack machine)
import numpy as np
from math import erf
from astropy.cosmology import Planck15 as Planck
import astropy.units as u
import random
import bisect

def merger_rate_density(metz, bin_z, z_hist, Zs, bin_t, td_Z, eta, met_slope, met_inter, sfr_norm, sigma_met):
    # This is the most important function of cosmo_rate.py. It evaluates the merger density (MD) and the merger rate density (MRD)

    #----------------------
    # metz --> function that evaluates the mean metallicity evolution with redshift. It is defined in cosmo_input.py
    # bin_z --> width of the redshift bin. It is defined in cosmo_input.py
    # z_hist --> array of redshift binning
    # Zs --> This array is the concatenation of Zlist with two extreme values
    # bin_t --> array of lookback time binning
    # td_Z --> list of compact binaries delay times, divided by metallicity. 
    # eta --> merger efficiency. Evaluated in cosmo_rate.py
    # met_slope --> slope of the metallicity evolution model
    # met_inter --> intercept of the metallicity evolution model
    # sfr_norm --> normalisation of the star formation rate
    # sigma_met --> metallicity spread that is going to be used in the gaussian distribution of metallicity values 
    #               at each given redshift
    #----------------------                
    
    len_Zlist = len(Zs)-2 #This is equal to the metallicity array length. 

    # Initialise quantities
    MRD = np.ones((len(z_hist)))
    w = (len(z_hist), len(z_hist), len_Zlist)
    v = np.ones(w)
    v_index = np.ones(w, dtype=np.ndarray)

    for i, zf in enumerate(z_hist):

        zf_bin = zf-bin_z/2.  # value of the formation redshift at the middle of the bin
        # compute associated formation time in yr
        t_form = np.array(Planck.lookback_time(zf_bin)/u.Gyr*10**9)

        # compute star formation rate in Msun yr-1 Mpc-3 (model Madau & Fragos year 2016)
        SFR = sfr_norm*(1. + zf_bin)**(2.6) / \
            (1.+((1. + zf_bin)/3.2)**(6.2))  # Msun yr-1 Mpc-3

        # compute the mass density of compact objects by multypling star formation rate with the associated time in the redshift bin
        min_dt = Planck.lookback_time(zf)/u.Gyr*10**9  # In yr
        max_dt = Planck.lookback_time(zf-bin_z)/u.Gyr*10**9  # In yr
        dt = min_dt - max_dt
        Mdens = dt*SFR  # Msun Mpc-3

        # compute value of average metallicity in the redshift bin. The metallicity is assumed to be log-normal distributed.
        # metz gives the result in log-sun scale
        mu = metz(zf_bin, met_slope, met_inter)

        # compute the probability for each metallicity using cumulative distribution functions
        prob = np.zeros(len_Zlist) 
        for p in range(len_Zlist):
            xA = Zs[p+1] - (Zs[p+1]-Zs[p])/2.
            probA = 0.5*(1+erf((xA - mu)/(sigma_met*2**0.5)))
            xB = Zs[p+1] + (Zs[p + 2]-Zs[p+1])/2.
            probB = 0.5*(1+erf((xB - mu)/(sigma_met*2**0.5)))
            prob[p] = probB-probA
        #if sum(prob)<0.95:
        #    print('sum of all probabilities = ',sum(prob),'at formation z = ', zf)
        #    exit()
        # loop over each metallicity
        for m in range(len_Zlist):

            tdm = td_Z[m]  # Delay time of compact binaries
            t_merg = t_form - tdm # time of merger yr

            # build histogram of the merger times of the compact objects mergers
            [vv, base] = np.histogram(t_merg, bins=bin_t)

            # This quantity gives us the number of objects merging per Mpc-3 as a function of 3 variables.
            # The first index tracks the merger time bin, the second the time bin of formation time and the final one the metallicity
            # vv[::-1]/float(len(tdm)) gives the proportion of mergers formed at zf that merges in each zm. by multipyling it with the merger efficiency eta (Msol-1),
            # the probability that the metallicity was m at zf and the mass density at zf, we obtain the density of objects per Mpc-3 that formed at zf with met Z and
            # merged at zm.
            v[:, i, m] = vv[::-1]/float(len(tdm))*eta[m]*prob[m]*Mdens

            # Compute the quantity v_index, that is the values of the mergers' indices in the catalogs that formed at zf with met Z and merged at zm
            vv_index = np.digitize(t_merg, bin_t, right=True)
            vv_index_save = np.zeros((len(z_hist)), dtype=np.ndarray)
            for n in range(1, len(z_hist)+1):
                vv_index_save[n-1] = np.argwhere(vv_index == n)

            for k in range(len(z_hist)):
                v_index[k, i, m] = vv_index_save[len(z_hist)-1-k]

    # compute the merger density and merger rate density for each zm, by summing all formation redshift up to zm and all metallicities.
    for d in range(0, len(z_hist), 1):  # k selects the merging redshift
        rate = 0
        for q in range(0, d + 1, 1):  # k+1 in order to reach diagonal values
            rate = rate + sum(v[d, q, :])
        MRD[d] = rate/(bin_t[len(z_hist)-d]-bin_t[len(z_hist)-d-1]
                       )*10**9  # merger rate density

    return MRD, v, v_index



def eta_interpol(Z_missing, Z_simulated, eta_known):
    # This function provides the merger efficiency interpolation

    #---------------
    # Z_missing --> list of metallicities on which the interpolation is to be performed
    # Z_simulated --> list of metallicity that has been used in the simulation
    # eta_known --> merger efficiency that is evaluated in cosmo_rate.py, with the data provided by the simulations
    #--------------- 

    # interpolation of the merging efficiency on the provided values
    eta_unknown_log = np.interp(
        np.log10(Z_missing), np.log10(Z_simulated), np.log10(eta_known))
    eta_unknown = 10**(eta_unknown_log)
    Z_list_us = np.concatenate((Z_simulated, Z_missing))
    Z_list = np.sort(Z_list_us)
    Z_list_index = np.argsort(Z_list_us)
    eta_us = np.concatenate((eta_known, eta_unknown))
    eta = [eta_us[Z_list_index[i]] for i in range(len(Z_list_index))]
    return eta, Z_list

def sort_catalogues(Z_list, Z_simulated, td_Z_sim, mrem1_Z_sim, mrem2_Z_sim):
    # This function provides the delay time and mass arrays once the eta_interpolation.py has been launched

    #--------------
    # Z_list --> list of all metallicities, both missing and simulated (see above function)
    # Z_simulated --> list of simulated metalicity only
    # td_Z_sim --> time delays of simulated compact binaries.
    # mrem1_Z_sim --> primary mass of simulated compact binaries
    # mrem2_Z_sim --> secondary mass of simulated compact bineries
    #--------------

    td_Z = np.zeros((len(Z_list)), dtype=np.ndarray)
    mrem1_Z = np.zeros((len(Z_list)), dtype=np.ndarray)
    mrem2_Z = np.zeros((len(Z_list)), dtype=np.ndarray)
    index = np.zeros((len(Z_list)))

    Z_list = Z_list.tolist()

    for i in range(len(Z_list)):
        err = 100.
        if Z_list[i] <= 0.002:
            for met in Z_simulated:
                if err > np.abs(Z_list[i] - met):
                    err = np.abs(Z_list[i] - met)
                    index[i] = Z_simulated.index(met)
        else:
            index[i] = Z_simulated.index(0.02)

    index = [int(index[y]) for y in range(len(index))]
    # print(index)
    td_Z = [td_Z_sim[index[y]] for y in range(len(Z_list))]
    mrem1_Z = [mrem1_Z_sim[index[y]] for y in range(len(Z_list))]
    mrem2_Z = [mrem2_Z_sim[index[y]] for y in range(len(Z_list))]

    return td_Z, mrem1_Z, mrem2_Z

def catalogues(z_hist, Z_list, v, v_index, N_cat, tdZ, mrem1Z, mrem2Z, location, objn, sim, N_figures):
    # This function creates the catalogues of merging compact objects as predicted by this model
    # It gives as output a file with N_cat (cfr cosmo_input.py)
    # compact binaries, a Z_perc catalogue where the percentage distribution are displayed

    #-------------
    # z_hist --> array of redshift binning
    # Z_list --> list of metallicities 
    # v --> matrix with three dimensions: formation redshift, merging redshift, metallicity. It is an output of merger_rate_density. It contains the merger rate density before summation
    # v_index --> matrix with three dimensions: formation redshift, merging redshift, metallicity. It is an output of merger_rate_density. It contains the index of compact binaries that form at a given redshift and merge at another given redshift, divided by metallicity
    # N_cat --> number of binaries per each catalogues
    # tdZ --> compact binaries delay times, divided by metallicity
    # mrem1Z --> compact binaries primary mass, divided by metallicity
    # mrem2Z --> compact binaries secondary mass, divided by metallicity
    # location --> folder location in which the catalogues must be save
    # objn --> compact binary class (BBH, BHNS and BNS)
    # sim --> name of the simulation as given in cosmo_input.py
    # N_figures --> number of significant decimal digits that are saved
    #---------------

    [z_merge_table, t_merge_table] = np.loadtxt(
        'cosmo_zmerge_table/cosmo_zmerge_table.dat', skiprows=1, unpack=True)

    bin_z = z_hist[0]-z_hist[1]
    # initialise
    Znum = np.zeros((len(z_hist), len(Z_list)))
    Zperc = np.zeros((len(z_hist), len(Z_list)))
    Ztot = np.zeros(len(z_hist))

    # loop on merger redshift
    for k in range(len(z_hist)):

        # The quantity Znum corresponds to the integral of the merger density from formation redshift up to merger redshift as a function of merger redshift and metalllicty

        if sum(sum(v[k, :, :])) == 0:
            print('When MRD = 0, catalogues are not produced')
            continue
        for c in range(len(Z_list)):
            Znum[k, c] = sum(v[k, :, c])

        Ztot[k] = sum(Znum[k, :])
        Zperc[k, :] = Znum[k, :]*(100/Ztot[k])

        # contain the values of the parameter. 
        cat = np.zeros((int(N_cat), 6))
        wrong = 0
        source_number = np.zeros((len(Z_list)))
        for r in range(int(N_cat)):
            Zrand = np.random.uniform(0, 100)
            Zsampling = 0
            for d in range((len(Z_list))):
                Zsampling = Zsampling + Zperc[k, d]
                if Zrand < Zsampling:
                    source_number[d] += 1
                    break
        count = 0
        for d in range(len(Z_list)):
            mrem1 = mrem1Z[d]
            mrem2 = mrem2Z[d]
            td = tdZ[d]
            lentd = len(td)
            # list of possible indeces at that metallicity
            ind = v_index[k, 0, d]
            z_form_all = np.repeat(z_hist[0]-bin_z/2., len(v_index[k, 0, d]))
            for f in range(1, k+1):
                ind = np.concatenate((ind, v_index[k, f, d]), axis=None)
                z_form_all = np.concatenate((z_form_all, np.repeat(
                    z_hist[f]-bin_z/2., len(v_index[k, f, d]))), axis=None)

            for g in range(int(source_number[d])):
                if len(ind) == 0:
                    wrong = wrong + 1
                else:
                    ind_rand_index = random.randrange(len(ind))
                    ind_rand = ind[ind_rand_index]

                # Here I am sampling the binary parameters
                m1 = mrem1[ind_rand]
                m2 = mrem2[ind_rand]
                td_sam = td[ind_rand]
                # Once I recover the formation redshift I can evaluate the merging redshift
                z_form = z_form_all[ind_rand_index]
                t_form = Planck.lookback_time(z_form).value*1e09
                t_merg = t_form-td_sam
                #  the merging time are listed in a table in cosmo_z_merge and are read at the beginning of this function
                t_merge_right_index = bisect.bisect_left(t_merge_table, t_merg)
                t_merge_left_index = t_merge_right_index-1
                z_merge_left = z_merge_table[t_merge_left_index]
                z_merge_right = z_merge_table[t_merge_right_index]
                # the merging redshift is given as the middle value between the previous and next redshift
                z_merge = z_merge_left+(z_merge_right-z_merge_left)/2.

                if (z_merge > z_form) or (z_merge > z_hist[k]) or (z_merge < z_hist[k]-bin_z):
                    if (abs(z_merge-z_hist[k])>1e-04) and (abs(z_merge-(z_hist[k]-bin_z))>1e-04):
                        print('There is a problem with redhsifts! z_form = ', z_form,
                          'while z_merg = ', z_merge, 'which should be within = ', z_hist[k], 'and ', z_hist[k]-bin_z)
                        exit()
                cat[count, :] = [m1, m2,
                               z_merge, z_form, td_sam, Z_list[d]]
                count = count + 1

        head_cat = 'm1[Msun]'+'\t'+'m2[Msun]'+'\t' + \
            'z_merg'+'\t'+'z_form'+'\t'+'time_delay [yr]'+'\t'+'Z progenitor'
        # numbers are rounded up to #N_figures significant decimal figures. See cosmo_input.py for further details
        np.savetxt(location+'/'+objn+'_'+sim+'_' +
                   str(len(z_hist)-k)+'.dat', cat, header=head_cat, fmt='%1.'+str(N_figures)+'f')
        if wrong > 0:
            print(
                wrong, ' compact binaries were selected despite their time delay at redshift = ', z_hist[k])
    return Zperc

#############
