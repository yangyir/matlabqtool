#ifndef FAKE_CTP_COUNTER_HH
#define FAKE_CTP_COUNTER_HH

#include <string>
#include <iostream>

class __declspec(dllexport) FakeCounter
{
public:
    static  FakeCounter& GetInstance();

private:
//public:
    FakeCounter();
    ~FakeCounter();
public:
    std::string Login(std::string& address, std::string& brokerid, std::string& passwd);

    void Logout();

private:
    static FakeCounter* inst_;
};

#endif