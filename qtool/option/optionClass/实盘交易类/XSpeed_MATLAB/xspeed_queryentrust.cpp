/*
 * [dealinfo] = xspeed_queryentrust(counter_id, entrust_id);
 * dealinfo 是一个向量， 包含：deal_amount, deal_volume, deal_price, cancel_amount四个值
 */
 
#include "mex.h"
#include "xspeed_counter_export_wrapper.h"
#include "xspeed_entrust.hh"
#include "windows.h"

#pragma comment(lib, "XSpeedSECCounterLib.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 1;
    int entrust_id = 1;
    
    int deal_amount = 0;
    double deal_volume = 0;
    double deal_price = 0;
    int cancel_amount = 0;
    
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    entrust_id = mxGetScalar(prhs[pos++]);
    mexWarnMsgTxt("ok for now");
    
    XSpeedEntrust *e = new XSpeedEntrust();
    
    bool ret = QryEntrust(counter_id, entrust_id, *e);
    // prepare output array.
    double * dealinfo;
    plhs[0] = mxCreateDoubleMatrix(4,1,mxREAL);
    dealinfo = mxGetPr(plhs[0]);
    
    dealinfo[0] = e->GetDealAmount();
    dealinfo[1] = e->GetDealVolume();
    dealinfo[2] = e->GetDealPrice();
    dealinfo[3] = e->GetCancelAmount();
    
    delete (e);
    return;
}