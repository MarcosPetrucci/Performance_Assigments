% Assigment 1

%Reading values

%data = readtable(['barrier.log'],'FileType','text');

brute_file = importdata('barrier.log');
dim = length(brute_file);

index_A = 1;
index_C = 1;
current_line = 1;

A = datetime(0,0,0);
C = datetime(0,0,0);
while current_line ~= dim+1
    
    %Extract date_time information from brute file
    date_extract = sscanf(string(brute_file(current_line)),'[%4d:%3d:%2d:%2d:%2d:%1d]\n');
    date_extract = transpose(date_extract);
    date_extract = datetime(strjoin(string(date_extract)), 'InputFormat', 'uuuu DDD HH mm ss S');
    
    %Determine if it is an Output of Input
    in_out = sscanf(string(brute_file(current_line)),'[%d:%d:%d:%d:%d:%d][%4s]\n');
    in_out = in_out(8);
    
    %Do the test
    if in_out == 73 %ASCII for I --> Means input
        A(index_A) = date_extract;
        index_A = index_A + 1;
    else            %If not --> Means output
        C(index_C) = date_extract;
        index_C = index_C + 1;
    end

    current_line = current_line + 1;
end

% Arrival rate and throughput
% Average inter-arrival time
% Utilization
% Average Service Time
% Average Number of Jobs
% Average Response Time
% Probability of having m parts in the machine (with m = 0, 1, 2)
% Probability of having a response time less than r, (with r = 30 sec, 3 min)
% Probability of having an inter-arrival time shorter than r, (with r = 1 min)
% Probability of having a service time longer than , (with r = 1 min)