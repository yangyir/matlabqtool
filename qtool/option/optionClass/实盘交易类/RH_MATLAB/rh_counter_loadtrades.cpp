/*
 * [trades, ret] = ctp_counter_loadtrades(counter_id)
 * trades 是一个序列，包含当日成交记录。
 */

#include "mex.h"
#include "plain_trade_report.h"
#include "ctp_counter_export_wrapper.h"
#include <Windows.h>
#include <vector>

#pragma comment(lib, "CTP_Counter.lib")

const char * tradefieldsStruct[] = {"asset_code", "volume", "direction", \
        "trade_price", "trade_time"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    int counter_id = 0;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    
    // Get trade vector from CTP counter dll.
    int elements_num = 0;
    PlainTradeReport * addr = NULL;
    QueryAllTrade(counter_id);
    Sleep(10000);
    bool ret = GetAllTrades(counter_id, elements_num, &addr);
    plhs[0] = mxCreateStructMatrix(1, elements_num, 5, tradefieldsStruct);
    if (ret)
    {
        // Construct C++ Position Vector.
        std::vector<PlainTradeReport> vec;
        //vec.reserve(elements_num);
        for (int i = 0; i < elements_num; i++)
        {
            PlainTradeReport element = *(addr + i);
            vec.push_back(element);
        }
        
        // Convert it to Matlab trade Array.        
        mxArray *p = plhs[0];
        for (int i = 0; i < vec.size(); i++)
        {
            // asset_code
            mxSetField(p, i, "asset_code", mxCreateString(vec[i].code_));
            // volume
            mxSetField(p, i, "volume", mxCreateDoubleScalar(vec[i].amount_));
            // direction
            int direction = 0;
            switch(vec[i].direction_)
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
            // trade price
            mxSetField(p, i, "trade_price", mxCreateDoubleScalar(vec[i].price_));
            // trade time
            mxSetField(p, i, "trade_time", mxCreateString(vec[i].trade_time_));
        }
    }
    plhs[1] = mxCreateLogicalScalar(ret);
}
