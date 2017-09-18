#include "mex.h"
#include "fake_ctp_counter.h"

#  pragma comment(lib,"ctp_test_dll.lib")
#  define FUNCTION_CALL_MODE __stdcall
//FakeCounter cter;
//__declspec(dllimport) FakeCounter;
//FakeCounter *cter = new FakeCounter;
void mexFunction( int nlhs, mxArray *plhs[], int nrhs, const mxArray*prhs[])
{
    std::string address("123.123.123.123");
    std::string brokerid("12345");
    std::string password("password");
   
    mexWarnMsgTxt(address.c_str());
    
    //FakeCounter *cter = new FakeCounter;
    mexWarnMsgTxt(brokerid.c_str());
    
    
    std::string t = FakeCounter::GetInstance().Login(address, brokerid, password);
    
    mexWarnMsgTxt(t.c_str());
}


