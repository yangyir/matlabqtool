/*
 * [ret] = withdrawoptentrust(counter_id , entrust_id)
 */

#include "mex.h"
#include "ctp_entrust.hh"
#include "ctp_counter_export_wrapper.h"

#pragma comment(lib, "CTP_Counter.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 0;
    int entrust_id = 0;
    
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    entrust_id = mxGetScalar(prhs[pos++]);
    
    bool ret = WithDrawEntrust(counter_id, entrust_id);
    plhs[0] = mxCreateLogicalScalar(ret);
    return;
}