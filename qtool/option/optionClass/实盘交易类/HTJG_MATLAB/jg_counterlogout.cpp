/*
 * bool ret = ctpcounterlogout(int counter_id)
 * do the logout job for the specific counter.
 */
#include "mex.h"
#include "matrix.h"
#include "haitong_counter_export_wrapper.h"

#pragma comment(lib, "HaiTongAccess.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 0;
    if (nrhs > 1)
    {
        mexWarnMsgTxt("参数个数过多");
        return;
    }    
    counter_id = mxGetScalar(prhs[0]);
    
    bool ret = ReleaseCounter(counter_id);
    if(ret)
    {
        mexWarnMsgTxt("Counter Logout Success");
    }
    else
    {
        mexWarnMsgTxt("Counter Logout Failed");
    }
    plhs[0] = mxCreateLogicalScalar(ret);
    return;
}