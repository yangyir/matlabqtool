/*
 * ctpcounter_getaccountinfo ȡ�˻��ʽ���Ϣ
 * [accountinfo, ret] = ctpcounter_getaccountinfo(counter_id)
 *  accountinfo �Ǹ��ṹ������������:
 *    double close_profit_;
 *    double position_profit_;
 *    double commission_;
 *    double available_fund_;
 *    double current_margin_;
 *    double frozen_margin_;
 *    // �ڳ�Ȩ��
 *    double pre_interest_;
 *    double present_interest_;
 *    double close_profit_rate_;
 *    double position_profit_rate_;
 */

#include "mex.h"
#include "trader_account_info.hh"
#include "ctp_counter_export_wrapper.h"

#pragma comment(lib, "CTP_Counter.lib")

const char * fieldsStruct[] = {"close_profit", "position_profit", \
        "commission", "available_fund", "current_margin", "frozen_margin", \
        "pre_interest", "present_interest","close_profit_rate", "position_profit_rate"};

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
//     double * accountdatabase = NULL;
//     plhs[0] = mxCreateDoubleMatrix(10, 1, mxREAL);
//     accountdatabase = mxGetPr(plhs[0]);

    int counter_id = 0;
    int pos = 0;
    counter_id = mxGetScalar(prhs[pos++]);
    
    TraderAccountInfo a;
    bool ret = GetAccountInfo(counter_id, a);
    
    // �������ؽṹ
    plhs[0] = mxCreateStructMatrix(1, 1, 10, fieldsStruct);
    
    // ƽ������
    mxSetField(plhs[0], 0, "close_profit", mxCreateDoubleScalar(a.close_profit_));
//     accountdatabase[0] = a.close_profit_;
    // �ֲ�����
    mxSetField(plhs[0], 0, "position_profit", mxCreateDoubleScalar(a.position_profit_));
//     accountdatabase[1] = a.position_profit_;
    // ������
    mxSetField(plhs[0], 0, "commission", mxCreateDoubleScalar(a.commission_));
//     accountdatabase[2] = a.commission_;
    // �����ʽ�
    mxSetField(plhs[0], 0, "available_fund", mxCreateDoubleScalar(a.available_fund_));
//     accountdatabase[3] = a.available_fund_;
    // ��ǰ��֤���ܶ�
    mxSetField(plhs[0], 0, "current_margin", mxCreateDoubleScalar(a.current_margin_));
//     accountdatabase[4] = a.current_margin_;
    // ���ᱣ֤��
    mxSetField(plhs[0], 0, "frozen_margin", mxCreateDoubleScalar(a.frozen_margin_));
//     accountdatabase[5] = a.frozen_margin_;
    // �ڳ�Ȩ��
    mxSetField(plhs[0], 0, "pre_interest", mxCreateDoubleScalar(a.pre_interest_));
//     accountdatabase[6] = a.pre_interest_;
    // ��ǰȨ��
    mxSetField(plhs[0], 0, "present_interest", mxCreateDoubleScalar(a.present_interest_));
//     accountdatabase[7] = a.present_interest_;
    // ƽ��������
    mxSetField(plhs[0], 0, "close_profit_rate", mxCreateDoubleScalar(a.close_profit_rate_));
//     accountdatabase[8] = a.close_profit_rate_;
    // �ֲ�������
    mxSetField(plhs[0], 0, "position_profit_rate", mxCreateDoubleScalar(a.position_profit_rate_));
//     accountdatabase[9] = a.position_profit_rate_;

    plhs[1] = mxCreateLogicalScalar(ret);
    return;
}