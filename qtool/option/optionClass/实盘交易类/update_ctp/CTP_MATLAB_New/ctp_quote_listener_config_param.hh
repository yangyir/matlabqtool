#ifndef CTP_QUOTE_LISTENTER_CONFIG_PARAM_HH
#define CTP_QUOTE_LISTENTER_CONFIG_PARAM_HH

#include <string>

#define DLLEXPORT __declspec(dllexport)

class DLLEXPORT ListenerInitParamIF
{
public:
    virtual bool Valid() = 0;
};

class DLLEXPORT CTPListenerConfigParam : public ListenerInitParamIF
{
public:
    CTPListenerConfigParam();
    explicit CTPListenerConfigParam(const std::string& front_addr, const std::string& broker_id, const std::string& investor_id, const std::string& investor_pwd);
    bool Valid();

    std::string front_addr_;
    std::string broker_id_;
    std::string investor_id_;
    std::string investor_password_;
};

#endif