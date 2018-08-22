#ifndef CTP_ASSET_HH
#define CTP_ASSET_HH

#include <string>
#define DLLEXPORT __declspec(dllexport)

struct DLLEXPORT Asset
{
    Asset();
    Asset(const char* name, const char * code);
    std::string asset_name_;
    std::string asset_code_;
};

#endif