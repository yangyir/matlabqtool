/*
 * getoptquote.cpp is to get the option quote by code. 
 * [mktdata, level_p, update_time] = getoptquote(asset_code) 
 * 其中mkt为 7*1 的数值向量，依次为最新价，开盘价，最高价，最低价，成交量, 昨收，昨结
 * level_p 为买卖价格盘口数据（5*4矩阵）
 * update_time 是行情时间的字符串。
 * 第一到四列依次为： 委买价，委买量，委卖价，委卖量。
 * Level 对于五档行情的股票与期权来说，
 * 买档数据为 第1行到第五行依次为买一到买五
 * 卖档数据为 第五行到第一行依次为卖一到卖五， 逆序
 * 对于期货这样一档行情的， 买卖档数据均在第一行排列。
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
    // 最新价，开盘价，最高价，最低价，成交量，交易时间
    mktdatabase[0] = tempQuote.last_ / 10000.0;
    mktdatabase[1] = tempQuote.open_ / 10000.0;
    mktdatabase[2] = tempQuote.high_ / 10000.0;
    mktdatabase[3] = tempQuote.low_ / 10000.0;
    mktdatabase[4] = tempQuote.amount_;    
    mktdatabase[5] = tempQuote.pre_close_ / 10000.0;
    mktdatabase[6] = tempQuote.pre_settle_ / 10000.0;
    
    // 交易时间
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