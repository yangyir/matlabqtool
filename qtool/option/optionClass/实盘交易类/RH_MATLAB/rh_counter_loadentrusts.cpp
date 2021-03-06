/*
 * [trades, ret] = ctp_counter_loadtrades(counter_id)
 * trades 是一个序列，包含当日成交记录。
 */

#include "mex.h"
#include "rh_entrust.hh"
#include "rh_counter_export_wrapper.h"
#include <Windows.h>
#include <vector>

#pragma comment(lib, "RonHangSystem.lib")

const char * tradefieldsStruct[] = {"asset_code", "asset_name", "target_price",\
        "target_volume", "direction", "offset", "entrust_id",\
        "entrust_no", "deal_volume", "cancel_volume"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int counter_id = 0;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    
    // Get entrust vector from RH counter dll.
    int elements_num = 0;
    RHEntrust * addr = NULL;
    QueryAllOrder(counter_id, elements_num, &addr);
    bool ret = (elements_num > 0 && addr != NULL);
    plhs[0] = mxCreateStructMatrix(1, elements_num, 10, tradefieldsStruct);    
    if (ret)
    {
        // Construct C++ Position Vector.
        std::vector<RHEntrust> vec;
        //vec.reserve(elements_num);
        for (int i = 0; i < elements_num; i++)
        {
            RHEntrust element = *(addr + i);
            vec.push_back(element);
        }
        
        // Convert it to Matlab entrust info Array.        
        mxArray *p = plhs[0];
        for (int i = 0; i < vec.size(); i++)
        {
            // asset_code
            mxSetField(p, i, "asset_code", mxCreateString(vec[i].GetCode()));
            // asset_name
            mxSetField(p, i, "asset_name", mxCreateString(vec[i].GetName()));
            // target price
            mxSetField(p, i, "target_price", mxCreateDoubleScalar(vec[i].GetTargetPrice()));
            // volume
            mxSetField(p, i, "target_volume", mxCreateDoubleScalar(vec[i].GetTargetAmount()));
            // direction
            int direction = 0;
            switch(vec[i].GetDirection())
            {
                case 0:
                    break;
                case 1:
                    direction = 1;
                    break;
                case 2:
                    direction = -1;
                    break;
            }
            mxSetField(p, i, "direction", mxCreateDoubleScalar(direction));
            // offset
            int offset = 0;
            switch(vec[i].GetOffsetFlag())
            {
                case 0:
                    break;
                case 1:
                    offset = 1;
                    break;
                case 2:
                case 3:
                    offset = -1;
                    break;
            }
            mxSetField(p, i, "offset", mxCreateDoubleScalar(offset));
            // entrust_id
            mxSetField(p, i, "entrust_id", mxCreateDoubleScalar(vec[i].GetOrderId()));
            // entrust_no
            mxSetField(p, i, "entrust_no", mxCreateString(vec[i].GetSystemId()));
            // deal_volume
            mxSetField(p, i, "deal_volume", mxCreateDoubleScalar(vec[i].GetDealAmount()));
            // cancel_volume
            mxSetField(p, i, "cancel_volume", mxCreateDoubleScalar(vec[i].GetCancelAmount()));
        }
    }
    plhs[1] = mxCreateLogicalScalar(ret);
}
