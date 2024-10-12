% Blockchain Data Safety Simulation (Corrected)

% Initialize parameters
num_users = 10;  % Number of users
num_businesses = 5;  % Number of businesses
num_blocks = 50;  % Number of blocks in the blockchain
data_safety_level = zeros(1, num_blocks);  % Safety level across blockchain
performance_metric = zeros(1, num_blocks); % Model performance

% Simulate User and Business Interaction
user_data = randi([0 1], num_users, num_blocks); % User transactions (1 for transaction, 0 for no transaction)
business_data = randi([0 1], num_businesses, num_blocks); % Business transactions

% Combine user and business data into a single transaction matrix
combined_data = [user_data; business_data]; % Now, size: (num_users + num_businesses) x num_blocks

% Blockchain Initialization
blockchain = struct('previous_hash', {}, 'data', {}, 'current_hash', {});

% Function to calculate hash (for simplicity, we use sum mod 100 here)
hash_function = @(data, previous_hash) mod(sum(data) + previous_hash, 100);

% Initial block setup
blockchain(1).previous_hash = 0;
blockchain(1).data = combined_data(:,1); % First column of combined data
blockchain(1).current_hash = hash_function(blockchain(1).data, blockchain(1).previous_hash);

% Iterate over blocks
for i = 2:num_blocks
    % Current block data is the transaction data for this block
    blockchain(i).data = combined_data(:,i);
    
    % Calculate hash based on previous block's hash
    blockchain(i).previous_hash = blockchain(i-1).current_hash;
    blockchain(i).current_hash = hash_function(blockchain(i).data, blockchain(i).previous_hash);
    
    % Calculate data safety level (1 - probability of tampered block)
    data_safety_level(i) = 1 - sum(abs(blockchain(i).data - blockchain(i-1).data))/(num_users + num_businesses);
    
    % Performance metric (for simplicity, based on transaction volume)
    performance_metric(i) = sum(blockchain(i).data) / (num_users + num_businesses);
end

% Plot Blockchain Performance
figure;
subplot(2,1,1);
plot(1:num_blocks, performance_metric, 'b-', 'LineWidth', 2);
title('Blockchain Model Performance');
xlabel('Block Number');
ylabel('Performance Metric (Transaction Volume)');

% Plot Data Safety Level
subplot(2,1,2);
plot(1:num_blocks, data_safety_level, 'r-', 'LineWidth', 2);
title('Blockchain Data Safety Level');
xlabel('Block Number');
ylabel('Data Safety Level (1 = safe, 0 = tampered)');
grid on;

% Display final blockchain
disp('Final Blockchain:');
for i = 1:num_blocks
    fprintf('Block %d: Previous Hash: %d, Current Hash: %d, Data Safety Level: %.2f\n', ...
        i, blockchain(i).previous_hash, blockchain(i).current_hash, data_safety_level(i));
end
