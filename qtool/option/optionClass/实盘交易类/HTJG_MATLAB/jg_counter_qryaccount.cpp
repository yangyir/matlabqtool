/* [ret] = ctpcounterqryaccount(counter_id) 
 *  �����ʽ��˻���������Ϣ����������֮����ʱ�������1�롣
 */

#include "mex.h"
#include "haitong_counter_export_wrapper.h"

#pragma comment(lib, "HaiTongAccess.lib")

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray *prhs[])
{
    int counter_id = 0;
    
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    bool ret = QryAccount(counter_id);
    plhs[0] = mxCreateLogicalScalar(ret);
    return;
}