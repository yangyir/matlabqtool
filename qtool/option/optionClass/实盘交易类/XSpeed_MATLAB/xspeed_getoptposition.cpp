/*
 *    xspeed_getoptposition 取得账户持仓信息。
 *    [positions, ret] = xspeed_getoptposition(counter_id, code)
 *    positions 是一个OptionPositionInfo序列。
 */

#include "mex.h"
#include "option_position_info.hh"
#include "xspeed_counter_export_wrapper.h"
#include <vector>

#pragma comment(lib, "XSpeedSECCounterLib.lib")

const char * fieldsStruct[] = {"asset_code", "asset_name", "direction", \
        "total_position", "available_position", "avg_price", \
        "face_cost", "margin", "total_fee_cost"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int counter_id = 0;
    const char * code = NULL;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    code = mxArrayToString(prhs[pos++]);
    
    // Get Position vector from XSpeed counter dll.
    int elements_num = 0;
    OptPositionInfo * addr = NULL;
    bool ret = GetOptPositions(counter_id, code, elements_num, &addr);

    if (ret)
    {
        // Construct C++ Position Vector.
        std::vector<OptPositionInfo> vec;
        vec.reserve(elements_num);
        for (int i = 0; i < elements_num; i++)
        {
            OptPositionInfo element = *(addr + i);
            vec.push_back(element);
        }
        
        // Convert it to Matlab Position Array.
        plhs[0] = mxCreateStructMatrix(1, vec.size(), 10, fieldsStruct);
        mxArray *p = plhs[0];
        for (int i = 0; i < vec.size(); i++)
        {
            // asset_code
            mxSetField(p, i, "asset_code", mxCreateString(vec[i].asset_code_));
            // asset_name
            mxSetField(p, i, "asset_name", mxCreateString(vec[i].asset_name_));
            
            // direction
            int direction = 0;
            switch(vec[i].trade_direction_)
            {
                case TRADE_INVALID:
                    break;
                case TRADE_BUY:
                    direction = 1;
                    break;
                case TRADE_SELL:
                    direction = -1;
                    break;
            }
            mxSetField(p, i, "direction", mxCreateDoubleScalar(direction));
            // total_position
            mxSetField(p, i, "total_position", mxCreateDoubleScalar(vec[i].total_position_));
            // available position
            mxSetField(p, i, "available_position", mxCreateDoubleScalar(vec[i].available_position_));
            // avg price
            mxSetField(p, i, "avg_price", mxCreateDoubleScalar(vec[i].avg_price_));
            // face cost
            mxSetField(p, i, "face_cost", mxCreateDoubleScalar(vec[i].face_cost_));
            // margin
            mxSetField(p, i, "margin", mxCreateDoubleScalar(vec[i].margin_));
            // fee
            mxSetField(p, i, "total_fee_cost", mxCreateDoubleScalar(vec[i].total_fee_cost_));
        }
    }
    plhs[1] = mxCreateLogicalScalar(ret);
}

