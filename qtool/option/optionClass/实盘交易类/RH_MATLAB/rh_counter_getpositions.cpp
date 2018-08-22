/*
 *    ctpcounter_getpositions 取得账户持仓信息。
 *    [positions, ret] = ctpcounter_getpositions(counter_id, code)
 *    positions 是一个Position序列。
 */

#include "mex.h"
#include "position_info.hh"
#include "ctp_counter_export_wrapper.h"
#include <Windows.h>
#include <vector>

#pragma comment(lib, "CTP_Counter.lib")

const char * fieldsStruct[] = {"asset_code", "direction", \
        "total_position", "available_position", "avg_price", \
        "face_cost", "margin", "total_fee_cost"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int counter_id = 0;
    const char * code = NULL;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    code = mxArrayToString(prhs[pos++]);
    
    // Get Position vector from CTP counter dll.
    int elements_num = 0;
    PositionInfo * addr = NULL;
    bool ret = GetPositionsFromRemote(counter_id, code, elements_num, &addr);
    plhs[0] = mxCreateStructMatrix(1, elements_num, 9, fieldsStruct);
    if (ret)
    {
        // Construct C++ Position Vector.
        std::vector<PositionInfo> vec;
        vec.reserve(elements_num);
        for (int i = 0; i < elements_num; i++)
        {
            PositionInfo element = *(addr + i);
            vec.push_back(element);
        }
        
        // Convert it to Matlab Position Array.        
        mxArray *p = plhs[0];
        for (int i = 0; i < vec.size(); i++)
        {
            // asset_code
            mxSetField(p, i, "asset_code", mxCreateString(vec[i].asset_code_));
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
            // yesterday positon
            mxSetField(p, i, "available_position", mxCreateDoubleScalar(vec[i].available_position_));
            // today_position
            mxSetField(p, i, "avg_price", mxCreateDoubleScalar(vec[i].avg_price_));
            // position cost
            mxSetField(p, i, "face_cost", mxCreateDoubleScalar(vec[i].face_cost_));
            // margin
            mxSetField(p, i, "margin", mxCreateDoubleScalar(vec[i].margin_));
            // close_profit
            mxSetField(p, i, "total_fee_cost", mxCreateDoubleScalar(vec[i].total_fee_cost_));
        }
    }
    plhs[1] = mxCreateLogicalScalar(ret);
}

