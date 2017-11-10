/*
 * [counter_id] = ctpcounterlogin(addr, broker, investor, investor_pwd)
 * init the ctp counter. 
 * if init failed, counter_id is 0;
 */
#include "mex.h"
//#include "matrix.h"
#include "ctp_counter_export_wrapper.h"

#pragma comment(lib, "CTP_Counter.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // input args
    char *addr = NULL;
    char *broker = NULL;
    char *investor = NULL;
    char *investor_pwd = NULL;
    char * product_info = NULL;
    char * authen_code = NULL;
    
    addr = mxArrayToString(prhs[0]);
    broker = mxArrayToString(prhs[1]);
    investor = mxArrayToString(prhs[2]);
    investor_pwd = mxArrayToString(prhs[3]);
    product_info = mxArrayToString(prhs[4]);
    authen_code = mxArrayToString(prhs[5]);
    
    // output values : counter id    
    int counter_id = 0;
    bool ret = InitCounter(addr, broker, investor, investor_pwd, product_info, authen_code, counter_id);
    if(ret)
    {        
        mexWarnMsgTxt("Counter Login Success");
    }
    else
    {
        mexWarnMsgTxt("Counter Login Failed");
    }
    plhs[0] = mxCreateDoubleScalar(counter_id);
    return;
}
