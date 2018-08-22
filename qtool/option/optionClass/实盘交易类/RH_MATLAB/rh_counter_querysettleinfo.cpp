/*
 * [] = ctpcounter_querysettleinfo(counter_id, trade_date, file_path)
 * query settlement sheet. 
 * 
 */
#include "mex.h"
//#include "matrix.h"
#include "ctp_counter_export_wrapper.h"

#pragma comment(lib, "CTP_Counter.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    // input args
    int counter_id = 0;
    char *file_path = NULL;
    char *trade_date_str = NULL;
    
    counter_id = mxGetScalar(prhs[0]);
    trade_date_str = mxArrayToString(prhs[1]);
    file_path = mxArrayToString(prhs[2]);
    
    QuerySettlementInfo(counter_id, trade_date_str, file_path);    
    return;
}
