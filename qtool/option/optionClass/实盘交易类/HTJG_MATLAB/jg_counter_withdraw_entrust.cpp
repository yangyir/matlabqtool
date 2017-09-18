/*
 * [ret] = withdrawoptentrust(counter_id , entrust_id)
 */

#include "mex.h"
#include "haitong_entrust.h"
#include "haitong_counter_export_wrapper.h"

#pragma comment(lib, "HaiTongAccess.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 0;
    int entrust_id = 0;
    
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    entrust_id = mxGetScalar(prhs[pos++]);
    
    Entrust *e = new Entrust();    
    bool ret = WithDrawEntrust(counter_id, entrust_id, *e);
    plhs[0] = mxCreateLogicalScalar(ret);
    delete(e);
    return;
}