% Test 19: Loss of hydraulic control system ( Shuttle valve fail )

if time < 15
    iv_err    = NoError;
	sv_err    = NoError;
	lga_err   = NoError;
	lgasv_err = double(Errors.NoError);
	lgu_err   = NoError;
	lgusv_err = double(Errors.JammedCentre);
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