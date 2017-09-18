/*
 * [ret, entrust_sysid] = xspeed_placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount)
 */

#include "mex.h"
#include "xspeed_counter_export_wrapper.h"
#include "xspeed_entrust.hh"
#include "windows.h"

#pragma comment(lib, "XSpeedSECCounterLib.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id;
    int entrust_id;
    int asset_type;
    char * code;
    int direction;
    int offset;
    double price;
    int amount;
    
    int pos = 0;
    // input args num should be 8. 
    counter_id = mxGetScalar(prhs[pos++]);
    entrust_id = mxGetScalar(prhs[pos++]);
    asset_type = mxGetScalar(prhs[pos++]);
    code = mxArrayToString(prhs[pos++]);
    direction = mxGetScalar(prhs[pos++]);
    offset = mxGetScalar(prhs[pos++]);
    price = mxGetScalar(prhs[pos++]);
    amount = mxGetScalar(prhs[pos++]);
    
    char buf[512];
    memset(buf, 0, 512);
    sprintf(buf, "counter: %d, entrust: %d, asset: %d, code: %s, direct: %d, offset: %d, price: %f, amount: %d ",
            counter_id, entrust_id, asset_type, code, direction, offset, price, amount);
    mexWarnMsgTxt(buf);
    
    AssetType asset = static_cast<AssetType>(asset_type);
    
    XSpeedEntrust e(entrust_id, asset, code, direction, offset, price, amount);
    bool ret = PlaceEntrust(counter_id, e);
    int loop = 10;
    if (ret)
    {
        do
        {
            Sleep(100);
            QryEntrust(counter_id, entrust_id, e);
            loop--;
        }while(!e.isInserted() && !e.isClosed() && loop >= 0);
    }
    if (e.isInserted())
    {
        mexWarnMsgTxt("委托成功");
    }
    else if (e.isClosed())
    {
        mexWarnMsgTxt("委托失败");
        ret = false;
    }
    else
    {
        mexWarnMsgTxt("委托失败");
        ret = false;
    }
    
    plhs[0] = mxCreateLogicalScalar(ret);
    plhs[1] = mxCreateDoubleScalar(e.GetSysId());
    
    return;
}

