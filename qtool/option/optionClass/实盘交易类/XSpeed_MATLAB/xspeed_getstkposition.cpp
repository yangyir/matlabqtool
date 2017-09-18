/*
 *    xspeed_getstkpositions 取得账户股票持仓信息。
 *    [positions, ret] = xspeed_getstkpositions(counter_id, code)
 *    positions 是一个Position序列。
 */

#include "mex.h"
#include "stock_position_info.hh"
#include "xspeed_counter_export_wrapper.h"
#include <vector>

#pragma comment(lib, "XSpeedSECCounterLib.lib")

const char * fieldsStruct[] = {"asset_code", "asset_name"\
        "total_position", "available_position", "avg_price", \
        "face_cost", "total_fee_cost"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int counter_id = 0;
    const char * code = NULL;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    code = mxArrayToString(prhs[pos++]);
    
    // Get Position vector from CTP counter dll.
    int elements_num = 0;
    StockPositionInfo * addr = NULL;
    bool ret = GetStkPositions(counter_id, code, elements_num, &addr);

    if (ret)
    {
        // Construct C++ Position Vector.
        std::vector<StockPositionInfo> vec;
        vec.reserve(elements_num);
        for (int i = 0; i < elements_num; i++)
        {
            StockPositionInfo element = *(addr + i);
            vec.push_back(element);
        }
        
        // Convert it to Matlab Position Array.
        plhs[0] = mxCreateStructMatrix(1, vec.size(), 7, fieldsStruct);
        mxArray *p = plhs[0];
        for (int i = 0; i < vec.size(); i++)
        {
            // asset_code
            mxSetField(p, i, "asset_code", mxCreateString(vec[i].asset_code_));
            // asset_name
            mxSetField(p, i, "asset_name", mxCreateString(vec[i].asset_name_));
            // total_position
            mxSetField(p, i, "total_position", mxCreateDoubleScalar(vec[i].total_position_));
            // available positon
            mxSetField(p, i, "available_position", mxCreateDoubleScalar(vec[i].available_position_));
            // avg_price_
            mxSetField(p, i, "avg_price", mxCreateDoubleScalar(vec[i].avg_price_));
            // face cost
            mxSetField(p, i, "face_cost", mxCreateDoubleScalar(vec[i].face_cost_));
            // total_fee_cost
            mxSetField(p, i, "total_fee_cost", mxCreateDoubleScalar(vec[i].total_fee_cost_));
        }
    }
    plhs[1] = mxCreateLogicalScalar(ret);
}

