%Test 3: Extension to due to inadvertent control input (test 1)

if time < 15
    iv_err    = Error;
	sv_err    = Error;
	lga_err   = NoError;
	lgasv_err = double(Errors.NoError);
	lgu_err   = NoError;
	lgusv_err = double(Errors.NoError);
	da_err    = NoError;
	dasv_err  = double(Errors.NoError);
	du_err    = NoError;
	dusv_err  = double(Errors.NoError);
	ev_err    = NoError;
else 
    iv_err    = NoError;
	sv_err    = NoError;
	lga_err   = NoError;
	lgasv_err = double(Errors.NoError);
	lgu_err   = NoError;
	lgusv_err = double(Errors.NoError);
	da_err    = NoError;
	dasv_err  = double(Errors.NoError);
	du_err    = NoError;
	dusv_err  = double(Errors.NoError);
	ev_err    = NoError;
    
end 