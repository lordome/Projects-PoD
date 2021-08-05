#!/bin/sh 
# export OMP_STACKSIZE=1g
export GFORTRAN_UNBUFFERED_PRECONNECTED=y
# ulimit -s unlimited

# ---------- O18_usdb --------------
echo "start running log_O18_usdb_j0p.txt ..."
cat > O18_usdb_0.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "O18_usdb_p.ptn"
  fn_save_wave = "O18_usdb_j0p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 0
  n_block = 0
  n_eigen = 2
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe O18_usdb_0.input > log_O18_usdb_j0p.txt 2>&1 

rm -f tmp_snapshot_O18_usdb_p.ptn_0_* tmp_lv_O18_usdb_p.ptn_0_* O18_usdb_0.input 


echo "start running log_O18_usdb_j4p.txt ..."
cat > O18_usdb_4.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "O18_usdb_p.ptn"
  fn_save_wave = "O18_usdb_j4p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 4
  n_block = 0
  n_eigen = 2
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe O18_usdb_4.input > log_O18_usdb_j4p.txt 2>&1 

rm -f tmp_snapshot_O18_usdb_p.ptn_4_* tmp_lv_O18_usdb_p.ptn_4_* O18_usdb_4.input 


echo "start running log_O18_usdb_j8p.txt ..."
cat > O18_usdb_8.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "O18_usdb_p.ptn"
  fn_save_wave = "O18_usdb_j8p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 8
  n_block = 0
  n_eigen = 2
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe O18_usdb_8.input > log_O18_usdb_j8p.txt 2>&1 

rm -f tmp_snapshot_O18_usdb_p.ptn_8_* tmp_lv_O18_usdb_p.ptn_8_* O18_usdb_8.input 


# --------------- transition probabilities --------------

echo "start running log_O18_usdb_tr_j0p_j4p.txt ..."
cat > O18_usdb_0_4.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "O18_usdb_p.ptn"
  fn_ptn_r = "O18_usdb_p.ptn"
  fn_load_wave_l = "O18_usdb_j0p.wav"
  fn_load_wave_r = "O18_usdb_j4p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe O18_usdb_0_4.input > log_O18_usdb_tr_j0p_j4p.txt 2>&1 

rm -f O18_usdb_0_4.input


echo "start running log_O18_usdb_tr_j4p_j4p.txt ..."
cat > O18_usdb_4_4.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "O18_usdb_p.ptn"
  fn_ptn_r = "O18_usdb_p.ptn"
  fn_load_wave_l = "O18_usdb_j4p.wav"
  fn_load_wave_r = "O18_usdb_j4p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe O18_usdb_4_4.input > log_O18_usdb_tr_j4p_j4p.txt 2>&1 

rm -f O18_usdb_4_4.input


echo "start running log_O18_usdb_tr_j4p_j8p.txt ..."
cat > O18_usdb_4_8.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "O18_usdb_p.ptn"
  fn_ptn_r = "O18_usdb_p.ptn"
  fn_load_wave_l = "O18_usdb_j4p.wav"
  fn_load_wave_r = "O18_usdb_j8p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe O18_usdb_4_8.input > log_O18_usdb_tr_j4p_j8p.txt 2>&1 

rm -f O18_usdb_4_8.input


echo "start running log_O18_usdb_tr_j8p_j8p.txt ..."
cat > O18_usdb_8_8.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "O18_usdb_p.ptn"
  fn_ptn_r = "O18_usdb_p.ptn"
  fn_load_wave_l = "O18_usdb_j8p.wav"
  fn_load_wave_r = "O18_usdb_j8p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe O18_usdb_8_8.input > log_O18_usdb_tr_j8p_j8p.txt 2>&1 

rm -f O18_usdb_8_8.input


./collect_logs.py log_*O18_usdb* > summary_O18_usdb.txt
echo "Finish computing O18_usdb.    See summary_O18_usdb.txt"
echo 

