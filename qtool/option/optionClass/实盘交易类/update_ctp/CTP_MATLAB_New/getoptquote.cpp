/*
 * getoptquote.cpp is to get the option quote by code. 
 * [mktdata, level_p, update_time] = getoptquote(asset_code) 
 * ����mktΪ 7*1 ����ֵ����������Ϊ���¼ۣ����̼ۣ���߼ۣ���ͼۣ��ɽ���, ���գ����
 * level_p Ϊ�����۸��̿����ݣ�5*4����
 * update_time ������ʱ����ַ�����
 * ��һ����������Ϊ�� ί��ۣ�ί������ί���ۣ�ί������
 * Level �����嵵����Ĺ�Ʊ����Ȩ��˵��
 * ������Ϊ ��1�е�����������Ϊ��һ������
 * ��������Ϊ �����е���һ������Ϊ��һ�����壬 ����
 * �����ڻ�����һ������ģ� ���������ݾ��ڵ�һ�����С�
 */

#include "mex.h"
#include "ctp_quote_listener_wrapper.h"
#include "ctp_opt_quote.hh"
#include <string>

#  pragma comment(lib,"CTP_MarketData.lib")

CTPOptQuote tempQuote;

void mexFunction(int nlhs, mxArray *plhs[], int nrhs, const mxArray* prhs[])
{
    double * mktdatabase;
    double * leveldata;
    const char * update_time;
    char * code;
    int levelI;
    
    plhs[0] = mxCreateDoubleMatrix(7, 1, mxREAL);
    mktdatabase = mxGetPr(plhs[0]);
    
    plhs[1] = mxCreateDoubleMatrix(5, 4, mxREAL);
    leveldata = mxGetPr(plhs[1]);
    
    if (nrhs != 1)
    {
        //mexErrMsgTxt("Usage: getoptquote( asset_code )");
    }
    
    int q_src_id = 0;
    
    int pos = 0;
    q_src_id = mxGetScalar(prhs[pos++]);
    code = mxArrayToString(prhs[pos++]);    
    QueryOptQuote(q_src_id, code, tempQuote);
    
    // prepare mkt data:
    // ���¼ۣ����̼ۣ���߼ۣ���ͼۣ��ɽ���������ʱ��
    mktdatabase[0] = tempQuote.last_ / 10000.0;
    mktdatabase[1] = tempQuote.open_ / 10000.0;
    mktdatabase[2] = tempQuote.high_ / 10000.0;
    mktdatabase[3] = tempQuote.low_ / 10000.0;
    mktdatabase[4] = tempQuote.amount_;    
    mktdatabase[5] = tempQuote.pre_close_ / 10000.0;
    mktdatabase[6] = tempQuote.pre_settle_ / 10000.0;
    
    // ����ʱ��
    update_time = tempQuote.update_time_;
    plhs[2] = mxCreateString(update_time);
    
    levelI = 0;
    // prepare level data
    leveldata[levelI] = tempQuote.bid_p1_ / 10000.0;
    leveldata[levelI + 5] = tempQuote.bid_q1_;
    leveldata[levelI + 10] = tempQuote.ask_p1_ / 10000.0;
    leveldata[levelI + 15] = tempQuote.ask_q1_;
    
    levelI = 1;
    leveldata[levelI] = tempQuote.bid_p2_ / 10000.0;
    leveldata[levelI + 5] = tempQuote.bid_q2_;
    leveldata[levelI + 10] = tempQuote.ask_p2_ / 10000.0;
    leveldata[levelI + 15] = tempQuote.ask_q2_;
    
    levelI = 2;
    leveldata[levelI] = tempQuote.bid_p3_ / 10000.0;
    leveldata[levelI + 5] = tempQuote.bid_q3_;
    leveldata[levelI + 10] = tempQuote.ask_p3_ / 10000.0;
    leveldata[levelI + 15] = tempQuote.ask_q3_;
    
    levelI = 3;
    leveldata[levelI] = tempQuote.bid_p4_ / 10000.0;
    leveldata[levelI + 5] = tempQuote.bid_q4_;
    leveldata[levelI + 10] = tempQuote.ask_p4_ / 10000.0;
    leveldata[levelI + 15] = tempQuote.ask_q4_;
    
    levelI = 4;
    leveldata[levelI] = tempQuote.bid_p5_ / 10000.0;
    leveldata[levelI + 5] = tempQuote.bid_q5_;
    leveldata[levelI + 10] = tempQuote.ask_p5_ / 10000.0;
    leveldata[levelI + 15] = tempQuote.ask_q5_;

    return;
}