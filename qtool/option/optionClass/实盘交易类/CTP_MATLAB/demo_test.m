function demo_test()
%     if not(libisloaded('ctp_test_dll'))
%         loadlibrary('ctp_test_dll', 'fake_ctp_counter.h')
%     end
%     
%     libfunctions('ctp_test_dll')

%     fake_ctp_test;
      if not(libisloaded('CTP_MarketData'))
          [notfound, warnings] = loadlibrary('CTP_MarketData', 'ctp_quote_listener_wrapper.hh');
          notfound
          warnings
      end
      test_ctp_md;
end