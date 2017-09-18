#ifndef TF_QUOTE_ENUM_TRAITS_HH
#define TF_QUOTE_ENUM_TRAITS_HH

#include "quote_enum_def.hh"

template<>
struct enum_traits<MarketType>
{    
    static const MarketType enumerators[];
    static const bool sorted = true;
};


template<>
struct enum_traits<TradeStatus>
{
    static const TradeStatus enumerators[];
    static const bool sorted = true;
};

template<>
struct enum_traits<TradeOrderStatus>
{
    static const TradeOrderStatus enumerators[];
    static const bool sorted = false;
};

template<typename T, typename ValType>
T check(ValType v)
{
    typedef enum_traits<T> traits;
    const T *first = traits::enumerators;
    const T *last = endof(traits::enumerators);
    if(traits::sorted)
    {
        if(std::binary_search(first, last, v))
        {
            return T(v);
        }
    }
    else if(std::find(first, last, v) != last)
    {
        return T(v);
    }
    
    return *first;
}




#endif