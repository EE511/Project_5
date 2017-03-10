%%--------------------------------------------------------------------------
%%Project-5:: Question - 1
%%To Simulate Single Server Queue by using a functino which will derive
%%an array of arrival time.
%%Author                Date               Revision
%%Rajasekar Raja     03/05/17         Initial Revision
%%--------------------------------------------------------------------------
clc;
clear all;
% initial value of all variables
array_of_arr_time = 0; 
hrs_of_oper = 100; % the total time we want to analyze
index = 1;
j=1;
arr_cnt = 0;
dept_cnt = 0;
srvc_comp_time = inf;
given_mean = exprnd(1/25);
cust_cnt =0;
total_break_time=0;
curr_time=0;

while(array_of_arr_time(index) < hrs_of_oper)
    lamda = 19;
    curr_time = array_of_arr_time(index);
    while(curr_time<hrs_of_oper)
       u_rand1 = rand();
       curr_time = curr_time - log(u_rand1)/lamda;
       u_rand2 = rand();
       mod_time = mod(curr_time,10);
       if(mod_time < 6)
           comp_time=mod(4+3*mod_time,10);
       else
           comp_time = mod(19-3*(mod_time-5),10);
       end
       comp_time = comp_time/lamda;
       if (u_rand2 <= comp_time)
           array_of_arr_time(index+1) = curr_time;
           array_of_arr_time(index) = array_of_arr_time(index+1);
           index=index+1;
           break;
       end
    end
end    

breaktime = array_of_arr_time(1); 
arr_time = array_of_arr_time(1);
while arr_time < hrs_of_oper    
    %CASE-1 
    %service completion time of customer presently being served greater than arrival time        
    if((array_of_arr_time(index) <=srvc_comp_time) && (arr_time <=hrs_of_oper))
        curr_time=arr_time;
        arr_cnt = arr_cnt + 1;
        cust_cnt = cust_cnt +1;
        if index == length(array_of_arr_time)
            arr_time = array_of_arr_time(index);
        else
            arr_time = array_of_arr_time(index+1);
        end
        if(cust_cnt == 1)
            srvc_comp_time = breaktime+ exprnd(given_mean);
        end
        A(arr_cnt) = curr_time;
    end

    %CASE-2 
    %service completion time of customer presently being served lesser than arrival time    
    if((srvc_comp_time < arr_time) && (srvc_comp_time <= hrs_of_oper))
        curr_time = srvc_comp_time;
        cust_cnt = cust_cnt - 1;
        dept_cnt = dept_cnt +1;
        D(dept_cnt) = curr_time;        
        if(cust_cnt == 0)
            srvc_comp_time = inf;
            breaktime = curr_time;
            while(breaktime <arr_time)
                breaktime = breaktime + 0.3*rand();     
                total_break_time = total_break_time+  breaktime;
            end
        else
            srvc_comp_time = curr_time+ exprnd(1/25);         
        end
    end

    %CASE-3
    %Minimum of Arrival and service completime time > Num of Operational hours
    %The number of customers in the system > 0    
    if(min(arr_time,srvc_comp_time) > hrs_of_oper && cust_cnt >0)
        curr_time = srvc_comp_time;
        cust_cnt = cust_cnt - 1;  
        dept_cnt = dept_cnt +1;
        srvc_comp_time = curr_time+ exprnd(1/25);       
        D(dept_cnt) = curr_time;    
    end

    %CASE-4
    %Minimum of Arrival and service completime time > Num of Operational hours
    %The number of customers in the system == 0    
    if(min(arr_time,srvc_comp_time) > hrs_of_oper && cust_cnt == 0)
        Tp = max(curr_time-hrs_of_oper, 0);
    end
    index = index+1;
if arr_time > hrs_of_oper
    disp(['Total Number of Arrivals = ',num2str(arr_cnt)])
    disp(['Total Number of Departures = ',num2str(dept_cnt)])
    sprintf('Arrival time of the customer = %f',A)
    sprintf('Departure time of the customer = %f',D)
    disp(['Total break time = ',num2str(total_break_time)])
end    
end