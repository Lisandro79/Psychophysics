function timeForLoop

null= zeros(1,10000);
times=zeros(1,10000);
Priority(9);
for i=1:10000;
    times(i)=GetSecs;
%     if i<= 5000
%         null(i)=10;
%     else
%         null(i)=20;
%     end

%         switch i
%             case {i <= 5000}
%                null(i)=10;
%             otherwise
%                 null(i)=20;
%         end
end

Priority(0);
plot(times)
plot(diff(times))
