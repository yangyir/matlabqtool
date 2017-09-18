/*
 * [ret] = xspeed_withdrawoptentrust(counter_id , entrust_id)
 */

#include "mex.h"
#include "xspeed_counter_export_wrapper.h"
#include "xspeed_entrust.hh"
#include "windows.h"

#pragma comment(lib, "XSpeedSECCounterLib.lib")

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