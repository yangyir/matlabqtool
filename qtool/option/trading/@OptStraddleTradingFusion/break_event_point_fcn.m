function result_ = break_event_point_fcn(s, tau, callQuote_, putQuote_, cost)

callPricer_ = callQuote_.QuoteOpt_2_OptPricer;
putPricer_  = putQuote_.QuoteOpt_2_OptPricer;
callPricer_.S = s;
putPricer_.S  = s;
callPricer_.tau = tau;
putPricer_.tau  = tau;

result_ = callPricer_.calcPx + putPricer_.calcPx - cost;


end 