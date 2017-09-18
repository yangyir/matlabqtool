/*
 * [ret, entrust_sysid] = placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount)
 */

#include "mex.h"
#include "haitong_counter_export_wrapper.h"
#include "haitong_entrust.h"
#include "windows.h"

#pragma comment(lib, "HaiTongAccess.lib")

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
    
    Entrust *e = new Entrust(entrust_id, asset, code, direction, offset, price, amount);
    bool ret = PlaceEntrust(counter_id, *e);
    int loop = 10;
    if (ret)
    {
        if (e->isInserted())
        {
            mexWarnMsgTxt("委托成功");
        }
        else
        {
            mexWarnMsgTxt("委托失败");
            mexWarnMsgTxt(e->GetFailedInfo());
            ret = false;
        }        
    }
    else
    {
        mexWarnMsgTxt("委托失败");
        mexWarnMsgTxt(e->GetFailedInfo());
    }
    
    plhs[0] = mxCreateLogicalScalar(ret);
    plhs[1] = mxCreateString(e->GetSysId());
    delete (e);
    
    return;
}

