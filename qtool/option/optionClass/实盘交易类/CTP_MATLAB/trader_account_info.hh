#ifndef TRADER_ACCOUNT_INFO_HH
#define TRADER_ACCOUNT_INFO_HH

#define DLLEXPORT __declspec(dllexport)

struct DLLEXPORT TraderAccountInfo
{
    TraderAccountInfo();
    TraderAccountInfo(double pre_deposite,
                    double pre_margin, 
                    double current_margin,
                    double frozen_margin,
                    double close_profit,
                    double position_profit,
                    double commission,
                    double available_fund);

    void Update(double pre_deposite,
                    double pre_margin, 
                    double current_margin,
                    double frozen_margin,
                    double close_profit,
                    double position_profit,
                    double commission,
                    double available_fund);
    
    double close_profit_;
    double position_profit_;

    double commission_;
    double available_fund_;
    
    double current_margin_;
    double frozen_margin_;

    // ÆÚ³õÈ¨Òæ
    double pre_interest_;
    double present_interest_;

    double close_profit_rate_;
    double position_profit_rate_;
};


#endif