%%--------------------------------------------------------------------------
%%Project-5:: Question - 1
%%To Simulate Single Server Queue by using a functino which will derive
%%single arrival time everytime the function is invoked.
%%Author                Date               Revision
%%Rajasekar Raja     03/05/17         Initial Revision
%%--------------------------------------------------------------------------
function Single_Server_Queue()
%Initialize variables
mean=1/25;
curr_time=0;
arr_cnt=0;
dept_cnt=0;
cust_cnt=0;
hrs_of_oper=100;
srvc_time=0;
break_time=0;
total_break_time=0;
srvc_comp_time=inf;
[arr_time,srvc_time]=gen_arrival_time(hrs_of_oper,srvc_time);
breaktime=arr_time;

while arr_time<=hrs_of_oper
    %CASE-1 
    %service completion time of customer presently being served greater than arrival time    
    if arr_time<=srvc_comp_time && arr_time<=hrs_of_oper 
        curr_time=arr_time;
        arr_cnt=arr_cnt+1;
        cust_cnt=cust_cnt+1;
        [arr_time,srvc_time]=gen_arrival_time(hrs_of_oper,srvc_time);
        if cust_cnt==1
            srvc_comp_time=breaktime+exprnd(mean);
        end
        A(arr_cnt)=curr_time;
    end    
    
    %CASE-2 
    %service completion time of customer presently being served lesser than arrival time
    if arr_time>srvc_comp_time && srvc_comp_time<=hrs_of_oper
        curr_time=srvc_comp_time;
        cust_cnt=cust_cnt-1;
        dept_cnt=dept_cnt+1;
        D(dept_cnt)=curr_time;
        if cust_cnt==0
            srvc_comp_time=inf;
            breaktime=curr_time;
            while breaktime<arr_time
                break_time=0.3*rand;
                breaktime=breaktime+break_time;
                total_break_time=total_break_time+break_time;
            end
        else
            srvc_comp_time=curr_time+exprnd(mean);
        end    
    end        
    
    %CASE-3
    %Minimum of Arrival and service completime time > Num of Operational hours
    %The number of customers in the system > 0
    while min(arr_time,srvc_comp_time)>hrs_of_oper&& cust_cnt>0
        curr_time=srvc_comp_time;
        cust_cnt=cust_cnt-1;
        dept_cnt=dept_cnt+1;
        srvc_comp_time=curr_time+exprnd(mean);
        D(dept_cnt)=curr_time;
    end
    
    %CASE-4
    %Minimum of Arrival and service completime time > Num of Operational hours
    %The number of customers in the system == 0
    if cust_cnt==0 && min(arr_time,srvc_comp_time)>hrs_of_oper
        Tp=max(hrs_of_oper-curr_time,0);
    end
end

if arr_time > hrs_of_oper
    disp(['Total Number of Arrivals = ',num2str(arr_cnt)])
    disp(['Total Number of Departures = ',num2str(dept_cnt)])
    sprintf('Arrival time of the customer = %f',A)
    sprintf('Departure time of the customer = %f',D)
    disp(['Total break time = ',num2str(total_break_time)])
end
end

function[curr_time,serv_time]= gen_arrival_time(no_of_oper_hours,serv_time)
curr_time=serv_time;
lamda=19;
mod_time=0;
while(curr_time<no_of_oper_hours)
    u1 = rand ();
    curr_time = curr_time- log(u1)/lamda;
    u2 = rand();
    if mod(curr_time,10)<=5
        mod_time=mod(curr_time,10);
        if u2 <= (mod(4+3*mod_time,10)/lamda)
            serv_time = curr_time;
            break;
        end
    else
        mod_time=mod(curr_time,10);
        if u2 <= (mod(19-3*(mod_time-5),10)/lamda)
            serv_time = curr_time;
            break;
        end
    end
end
end