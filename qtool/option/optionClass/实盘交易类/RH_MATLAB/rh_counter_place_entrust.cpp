/*
 * [ret, entrust_sysid] = placeoptentrust(counter_id, entrust_id, asset_type, code, direction, offset, price, amount)
 */

#include "mex.h"
#include "rh_counter_export_wrapper.h"
#include "rh_entrust.hh"
#include "windows.h"

#pragma comment(lib, "RonHangSystem.lib")

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
    
    RHEntrust e(entrust_id, asset, code, direction, offset, price, amount);
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
        mexWarnMsgTxt("ί�гɹ�");
    }
    else if (e.isClosed())
    {
        mexWarnMsgTxt("ί��ʧ��");
        ret = false;
    }
    else
    {
        mexWarnMsgTxt("ί��ʧ��");
        ret = false;    
    }
    
    plhs[0] = mxCreateLogicalScalar(ret);
    plhs[1] = mxCreateString(e.GetSystemId());
    
    return;
}

