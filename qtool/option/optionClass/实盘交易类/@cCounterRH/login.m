function [] = login(obj)
%cCounterRH

counter_id = rh_counter_login(obj.serverAddr, obj.broker, obj.investor, obj.investorPassword, obj.product_info, obj.authentic_code);

if counter_id
    obj.counterId = counter_id;
    obj.is_Counter_Login = 1;
    obj.SetAvailableEntrustId(1);
end

end