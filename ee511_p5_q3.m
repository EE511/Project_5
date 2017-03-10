%%--------------------------------------------------------------------------
%%Project-5:: Question - 3
%%To Simulate Wright Fisher model using Markov Chain for stochastic genotypic 
%%drift during successive generations.
%%Author                Date               Revision
%%Rajasekar Raja     03/07/17         Initial Revision
%%--------------------------------------------------------------------------
warning off;
clear all; close all; clc; 
no_of_ind = 100; % Number of individuals
num_gen=5000;   % Number of Generations
output=zeros(num_gen+1,2*no_of_ind+1); % clear out any old values
t=0:num_gen; % time indices
for iter=1:7
    input = zeros(201,1); % initial distribution
    %0's represent A1 and 1's represent A2 Alleles
    if iter == 1 %1 is in the middle(101 position) of 201 numbers
        position = 101;        
    elseif iter == 2 %1 is at the beginning of 201 numbers
        position = 1;        
    elseif iter == 3 %1 is at the end of 201 numbers
        position = 201;
    elseif iter == 4 %1 is in the 155th position of 201 numbers
        position = 155;
    elseif iter == 5
        position = 55;      
    elseif iter == 6
        position = 50;
        input([1:position],1) = 0.02;
    else
        position = 100;
        input([1:position],1) = 0.01;
    end
    if iter<6
        input(position,1) = 1;   
        disp(['The steady state for the initial distribution with 200 A1 and 1 A2 where 1 is placed in the ',num2str(position),' position is'])
    else
        disp(['The steady state for the initial distribution with ',num2str(position),' A2 and the remaining A1 is '])
    end
    output(1,:)=input;  % generate first output value

%Creation of transition matrix using the formula specified in the question
trans_matrx=zeros(2*no_of_ind+1,2*no_of_ind+1); 
for iter_i = 1:2*no_of_ind+1
    for iter_j = 1:2*no_of_ind+1
        trans_matrx(iter_i,iter_j) = nchoosek(2*no_of_ind,iter_j-1)*((iter_i-1)/(2*no_of_ind))^(iter_j-1)*(1-(iter_i-1)/(2*no_of_ind))^(2*no_of_ind-iter_j+1);
    end
end
 
for iter_steady_st=1:num_gen,
    output(iter_steady_st+1,:) = output(iter_steady_st,:)*trans_matrx;
    %a tolerance check to  automatically stop the simulation when the density is close to its steady-state
    steady_value = ismembertol(output(iter_steady_st+1,:),output(iter_steady_st,:));
    if all(steady_value == 1) 
        st_st = iter_steady_st;
        break;
    end
end
disp(['Steady State = ',num2str(iter_steady_st),' with Prob[A1-A1] = ',num2str(output(st_st,1)),' and Prob[A2-A2] ',num2str(output(st_st,201))])
end