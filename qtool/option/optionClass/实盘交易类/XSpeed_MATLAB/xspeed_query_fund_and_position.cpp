/* [ret] = xspeed_query_fund_and_positions(counter_id) 
 *  发送该柜台资金账户持仓的请求信息。
 */

#include "mex.h"
#include "xspeed_counter_export_wrapper.h"

#pragma comment(lib, "XSpeedSECCounterLib.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 0;
    
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    bool ret = QryAccount(counter_id);
    QryPosition(counter_id);
    plhs[0] = mxCreateLogicalScalar(ret);
    return;
}