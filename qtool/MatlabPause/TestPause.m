myPause = MPause();
myPause.start();
for k =1:100
    disp(num2str(k));
    pause(1);
end
myPause.finish();

% t1 = Test();
% t1.start()
% for k =101:130
%     disp(num2str(k));
%     pause(1);
% end

% input('Press enter to continue...\n', 's');
