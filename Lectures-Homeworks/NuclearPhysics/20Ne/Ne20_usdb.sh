#!/bin/sh 
# export OMP_STACKSIZE=1g
export GFORTRAN_UNBUFFERED_PRECONNECTED=y
# ulimit -s unlimited

# ---------- Ne20_usdb --------------
echo "start running log_Ne20_usdb_j0p.txt ..."
cat > Ne20_usdb_0.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "Ne20_usdb_p.ptn"
  fn_save_wave = "Ne20_usdb_j0p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 0
  n_block = 0
  n_eigen = 1
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe Ne20_usdb_0.input > log_Ne20_usdb_j0p.txt 2>&1 

rm -f tmp_snapshot_Ne20_usdb_p.ptn_0_* tmp_lv_Ne20_usdb_p.ptn_0_* Ne20_usdb_0.input 


echo "start running log_Ne20_usdb_j4p.txt ..."
cat > Ne20_usdb_4.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "Ne20_usdb_p.ptn"
  fn_save_wave = "Ne20_usdb_j4p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 4
  n_block = 0
  n_eigen = 1
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe Ne20_usdb_4.input > log_Ne20_usdb_j4p.txt 2>&1 

rm -f tmp_snapshot_Ne20_usdb_p.ptn_4_* tmp_lv_Ne20_usdb_p.ptn_4_* Ne20_usdb_4.input 


echo "start running log_Ne20_usdb_j8p.txt ..."
cat > Ne20_usdb_8.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "Ne20_usdb_p.ptn"
  fn_save_wave = "Ne20_usdb_j8p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 8
  n_block = 0
  n_eigen = 1
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe Ne20_usdb_8.input > log_Ne20_usdb_j8p.txt 2>&1 

rm -f tmp_snapshot_Ne20_usdb_p.ptn_8_* tmp_lv_Ne20_usdb_p.ptn_8_* Ne20_usdb_8.input 


echo "start running log_Ne20_usdb_j12p.txt ..."
cat > Ne20_usdb_12.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "Ne20_usdb_p.ptn"
  fn_save_wave = "Ne20_usdb_j12p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 12
  n_block = 0
  n_eigen = 1
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe Ne20_usdb_12.input > log_Ne20_usdb_j12p.txt 2>&1 

rm -f tmp_snapshot_Ne20_usdb_p.ptn_12_* tmp_lv_Ne20_usdb_p.ptn_12_* Ne20_usdb_12.input 


echo "start running log_Ne20_usdb_j16p.txt ..."
cat > Ne20_usdb_16.input <<EOF
&input
  beta_cm = 0.0
  eff_charge = 1.5, 0.5, 
  fn_int = "usdb.snt"
  fn_ptn = "Ne20_usdb_p.ptn"
  fn_save_wave = "Ne20_usdb_j16p.wav"
  gl = 1.0, 0.0, 
  gs = 3.91, -2.678, 
  hw_type = 2
  is_double_j = .true.
  max_lanc_vec = 200
  maxiter = 300
  mode_lv_hdd = 0
  mtot = 16
  n_block = 0
  n_eigen = 1
  n_restart_vec = 10
&end
EOF
nice ./kshell.exe Ne20_usdb_16.input > log_Ne20_usdb_j16p.txt 2>&1 

rm -f tmp_snapshot_Ne20_usdb_p.ptn_16_* tmp_lv_Ne20_usdb_p.ptn_16_* Ne20_usdb_16.input 


# --------------- transition probabilities --------------

echo "start running log_Ne20_usdb_tr_j0p_j4p.txt ..."
cat > Ne20_usdb_0_4.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j0p.wav"
  fn_load_wave_r = "Ne20_usdb_j4p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_0_4.input > log_Ne20_usdb_tr_j0p_j4p.txt 2>&1 

rm -f Ne20_usdb_0_4.input


echo "start running log_Ne20_usdb_tr_j4p_j4p.txt ..."
cat > Ne20_usdb_4_4.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j4p.wav"
  fn_load_wave_r = "Ne20_usdb_j4p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_4_4.input > log_Ne20_usdb_tr_j4p_j4p.txt 2>&1 

rm -f Ne20_usdb_4_4.input


echo "start running log_Ne20_usdb_tr_j4p_j8p.txt ..."
cat > Ne20_usdb_4_8.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j4p.wav"
  fn_load_wave_r = "Ne20_usdb_j8p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_4_8.input > log_Ne20_usdb_tr_j4p_j8p.txt 2>&1 

rm -f Ne20_usdb_4_8.input


echo "start running log_Ne20_usdb_tr_j8p_j8p.txt ..."
cat > Ne20_usdb_8_8.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j8p.wav"
  fn_load_wave_r = "Ne20_usdb_j8p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_8_8.input > log_Ne20_usdb_tr_j8p_j8p.txt 2>&1 

rm -f Ne20_usdb_8_8.input


echo "start running log_Ne20_usdb_tr_j8p_j12p.txt ..."
cat > Ne20_usdb_8_12.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j8p.wav"
  fn_load_wave_r = "Ne20_usdb_j12p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_8_12.input > log_Ne20_usdb_tr_j8p_j12p.txt 2>&1 

rm -f Ne20_usdb_8_12.input


echo "start running log_Ne20_usdb_tr_j12p_j12p.txt ..."
cat > Ne20_usdb_12_12.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j12p.wav"
  fn_load_wave_r = "Ne20_usdb_j12p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_12_12.input > log_Ne20_usdb_tr_j12p_j12p.txt 2>&1 

rm -f Ne20_usdb_12_12.input


echo "start running log_Ne20_usdb_tr_j12p_j16p.txt ..."
cat > Ne20_usdb_12_16.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j12p.wav"
  fn_load_wave_r = "Ne20_usdb_j16p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_12_16.input > log_Ne20_usdb_tr_j12p_j16p.txt 2>&1 

rm -f Ne20_usdb_12_16.input


echo "start running log_Ne20_usdb_tr_j16p_j16p.txt ..."
cat > Ne20_usdb_16_16.input <<EOF
&input
  fn_int   = "usdb.snt"
  fn_ptn_l = "Ne20_usdb_p.ptn"
  fn_ptn_r = "Ne20_usdb_p.ptn"
  fn_load_wave_l = "Ne20_usdb_j16p.wav"
  fn_load_wave_r = "Ne20_usdb_j16p.wav"
  hw_type = 2
  eff_charge = 1.5, 0.5
  gl = 1.0, 0.0
  gs = 3.91, -2.678
&end
EOF
nice ./transit.exe Ne20_usdb_16_16.input > log_Ne20_usdb_tr_j16p_j16p.txt 2>&1 

rm -f Ne20_usdb_16_16.input


./collect_logs.py log_*Ne20_usdb* > summary_Ne20_usdb.txt
echo "Finish computing Ne20_usdb.    See summary_Ne20_usdb.txt"
echo 

