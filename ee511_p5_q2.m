%%--------------------------------------------------------------------------
%%Project-5:: Question - 1
%%To Simulate HOL Switch
%%an array of arrival time.
%%Author                Date               Revision
%%Rajasekar Raja     03/05/17         Initial Revision
%%--------------------------------------------------------------------------
Ri=input ('Enter the Ri');
Rj=input ('Enter the Rj');
no_of_time_slots=100;
P_arr=[1:100];
P_arr = P_arr./100;
ip1_buf=0;
ip2_buf=0;
op1_buf=0;
op2_buf=0;
cnt1=0;
cnt2=0;
pre_st_p1=0;
pre_st_p2=0;
for iter1=1:1:no_of_time_slots
    pckts_proc=0;
    if(rand()>P_arr(iter1))% Packets arriving at Input buffer 1
        ip1_buf=ip1_buf+1;
    end
    if(rand()>P_arr(iter1))% Packets arriving at Input buffer 2
        ip2_buf=ip2_buf+1;
    end
    swit_prob=rand();
    r_number=rand();
    if(ip1_buf>0 && ip2_buf>0)
        if(swit_prob>Ri && r_number<=Rj)% (1,0)
            pckts_proc=pckts_proc+1;
            if(pre_st_p1==0 && cnt1~=0)%(0,0)
                cnt1=cnt1+1;
                op1_buf=op1_buf+1;
                if(rand()<=Ri)
                    ip1_buf=ip1_buf-1;                    
                    pre_st_p2=0;
                else
                    ip2_buf=ip2_buf-1;
                    pre_st_p1=0;
                end
            elseif(pre_st_p2==1 && cnt2~=0)% (1,1)
                cnt2=cnt2+1;
                op2_buf=op2_buf+1;
                if(rand()<=Ri)
                    ip1_buf=ip1_buf-1;                    
                    pre_st_p2=1;
                else
                    ip2_buf=ip2_buf-1;
                    pre_st_p1=1;                    
                end
            else %(1,0)Both the packets will be delivered.
                ip1_buf=ip1_buf-1;
                ip2_buf=ip2_buf-1;
                op1_buf=op1_buf+1;
                op2_buf=op2_buf+1;
                pckts_proc=pckts_proc+1;
            end
        end
        if(swit_prob<=Ri && r_number>Rj)% (0,1)
            pckts_proc=pckts_proc+1;
            if(pre_st_p2==0 && cnt1~=0)%(0,0)
                cnt1=cnt1+1;
                op1_buf=op1_buf+1;
                if(rand()<=Ri)
                    ip1_buf=ip1_buf-1;                    
                    pre_st_p2=0;                    
                else
                    ip2_buf=ip2_buf-1;                    
                    pre_st_p1=0;
                end
            elseif(pre_st_p1==1 && cnt2~=0)% (1,1)
                cnt2=cnt2+1;
                op2_buf=op2_buf+1;
                if(rand()<=Ri)
                    ip1_buf=ip1_buf-1;                    
                    pre_st_p2=1;
                else
                    ip2_buf=ip2_buf-1;
                    pre_st_p1=1;
                end
            else %(0,1)Both the packets will be delivered.
                ip1_buf=ip1_buf-1;
                ip2_buf=ip2_buf-1;
                op1_buf=op1_buf+1;
                op2_buf=op2_buf+1;
                pckts_proc=pckts_proc+1;
            end
        end
        if(swit_prob<=Ri && r_number<=Rj)% (0,0)
            pckts_proc=pckts_proc+1;
            if((pre_st_p1==0 && cnt1~=0) || (pre_st_p2==1 && cnt2~=0))
                ip1_buf=ip1_buf-1;
                op1_buf=op1_buf+1;
                ip2_buf=ip2_buf-1;
                op2_buf=op2_buf+1;
                pckts_proc=pckts_proc+1;
            else %(0,0)Only one of thr packets will be delivered
                cnt1=cnt1+1;
                op1_buf=op1_buf+1;
                if(rand<=Ri)
                    ip1_buf=ip1_buf-1;
                    pre_st_p2=0;
                else
                    ip2_buf=ip2_buf-1;                    
                    pre_st_p1=0;                    
                end
            end
        end
        if(swit_prob>Ri && r_number>Rj)% (1,1)
            pckts_proc=pckts_proc+1;
            if(pre_st_p2==0 && cnt1~=0)||(pre_st_p1==0 && cnt2~=0)
                ip1_buf=ip1_buf-1;
                op1_buf=op1_buf+1;
                ip2_buf=ip2_buf-1;
                op2_buf=op2_buf+1;
                pckts_proc=pckts_proc+1;
            else %(1,1)Only one of thr packets will be delivered
                cnt2=cnt2+1;
                op1_buf=op1_buf+1;
                if(rand<=Ri)
                    ip1_buf=ip1_buf-1;
                    pre_st_p2=1;                    
                else
                    ip2_buf=ip2_buf-1;                    
                    pre_st_p1=1;
                end
            end
        end
    end
    Total_Buffer_Size(:,iter1)=ip2_buf+ip1_buf;
    buf_size1(:,iter1)=ip1_buf;
    buf_size2(:,iter1)=ip2_buf;
    %if(Packets_Processed~=0)
    Throughput(:,iter1)=(pckts_proc);
    Efficiency(:,iter1)=(Throughput(:,iter1)/2)*100;
    %end
    Packets_Processed_Switch(:,iter1)=pckts_proc;
end
Mean_Packets_Processed_Switch=mean(Packets_Processed_Switch);
Mean_ThroughPut=mean(Throughput);
Mean_Efficiency=mean(Efficiency);
disp(['The mean Efficiency = ',num2str(mean(Efficiency))]);
disp(['The mean Throughput = ',num2str(mean(Throughput))]);
disp(['The mean of the number of packets in the buffer at input 1 = ',num2str(mean(buf_size1))]);
disp(['The mean of the number of packets in the buffer at input 2 = ',num2str(mean(buf_size1))]);
disp(['The Mean of the total buffer size = ', num2str(mean(Total_Buffer_Size))]);
disp(['The Mean of the  packets processed by SWITCH in each slot = ', num2str(mean(Mean_Packets_Processed_Switch))]);
BOOT=bootci(no_of_time_slots,@mean,Efficiency);
disp('The bootstrap confidence interval of efficiency are');
disp(BOOT);
plot(P_arr,buf_size1,'r',P_arr,buf_size2,'b--o');
title('The distribution for Prob of arrival vs the Input1-Input-    2 Buffers');
xlabel('Probability of arrival');
ylabel('The Buffer at input-1 and input-2');
legend('Input Buffer1','Input Buffer2');