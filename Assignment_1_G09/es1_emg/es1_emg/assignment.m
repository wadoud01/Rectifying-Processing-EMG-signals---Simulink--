% Step 1: Load the data

load('ES1_emg.mat'); %loading data to matalb
Fs = 2000;  % Sampling frequency
load('ES2_emg.mat') %loading data to matalb

%%
% Extract EMG signal (Deltoid)
%emg_signal = Es1_emg(:, 1);
%emg_signal = Es1_emg(:, 1:size(Es1_emg, 2));  % Extract all columns
% Extract EMG signal (Deltoid) matrix from the cell array

emg_matrix = Es1_emg.matrix;  % Replacing 'matrix' with the actual field name

% Convert the data to 'double'
emg_signal = emg_matrix(:,1);

%% 

% Step 2: Design a bandpass FIR filter (30-450 Hz)
nyquist = Fs / 2;
low = 30 / nyquist;
high = 450 / nyquist; %adjust the freq as giving.

filter_order = 100;  % Adjust as needed

% calculating the coefficient of bandpass filter 
b = fir1(filter_order, [low, high], 'band'); 

%filtering the initial signal.
filtered_emg = filtfilt(b, 1, emg_signal); 

%%

% Step 3: Rectify the signal

%Using the absolute value in order to rectify the filtered signal
rectified_emg = abs(filtered_emg); 

%%

% Step 4: Design a low-pass FIR filter (3-6 Hz)
lowpass_low = 3 / nyquist;
lowpass_high = 6 / nyquist;
lp_filter_order = 50;  % Adjust as needed

% calculating the coefficient of lowband filter 
lp_b = fir1(lp_filter_order, lowpass_high, 'low'); 

%filtering the rectified signal with the respect to lp_b coefficient 
envelope_signal = filtfilt(lp_b, 1, rectified_emg);

% Use freqz to check the frequency response
figure;
freqz(lp_b, 1);
title('Frequency Response of Low-Pass FIR Filter');

% Step 5: Down-sample the envelope signal
downsampling_factor = 4;  % Adjust as needed
downsampled_envelope = downsample(envelope_signal, downsampling_factor);

% Optional: Create plots
t = (0:(length(emg_signal)-1)) / Fs;
t_downsampled = (0:(length(downsampled_envelope)-1)) / (Fs / downsampling_factor);

% Plot raw EMG signal overlaid with the filtered signal
figure;
subplot(3, 1, 1);
plot(t, emg_signal, 'b', 'LineWidth', 1.5);
hold on;
plot(t, filtered_emg, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
legend('Raw EMG', 'Filtered EMG');
title('Raw EMG vs. Filtered EMG');


% Plot rectified EMG signal overlaid with the envelope
subplot(3, 1, 2);
plot(t, rectified_emg, 'b', 'LineWidth', 1.5);
hold on;
plot(t, envelope_signal, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
legend('Rectified EMG', 'Envelope Signal');
title('Rectified EMG vs. Envelope Signal');

% Plot downsampled envelope signal
subplot(3, 1, 3);
plot(t_downsampled, downsampled_envelope, 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Downsampled Envelope Signal');

%%
%Figuring ou the motion graph

% Input velocities in the x, y, and z directions
movementx = Es1_emg.matrix(:,2);  % Obtaining the the movement around x axis.
movementy = Es1_emg.matrix(:,3);   % Obtaining the the movement around y axis.
movementz = Es1_emg.matrix(:,4);   % Obtaining the the movement around z axis.

%Ploting the the motion figure.
figure;
subplot(2, 1, 1);
plot(t, movementx, 'b', 'LineWidth', 1.5);
hold on;
plot(t, movementy, 'r', 'LineWidth', 1.5);
hold on;
plot(t, movementz, 'g', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
legend('X','Y','Z');
title('Motion Graph');

% Calculate the resultant motion
Mt = sqrt(movementx.^2 + movementy.^2 + movementz.^2);

% Ploting the motion figure
subplot(2, 1, 2);
plot(Mt, 'LineWidth', 1);
xlabel('Time (s)');
ylabel('Amplitude');
title('Resultant');

%%
% Comparing between acceleration and Envelop

figure;
subplot(2, 1, 1);
plot(t_downsampled, downsampled_envelope, 'b', 'LineWidth', 1.5);
hold on;
plot(t, (movementy*100)+70, 'r', 'LineWidth', 1.5); %Making signal bigger to be noticibale & modifiying the offset
xlabel('Time (s)');
ylabel('Amplitude');
legend('Envolop','Y Acceleration');
title('Motion Graph Vs Y acceleration');

subplot(2, 1, 2);
plot(t_downsampled, downsampled_envelope, 'b', 'LineWidth', 1.5);
hold on;
plot(t, (Mt*100), 'r', 'LineWidth', 1.5); %Making signal bigger to be noticibale
xlabel('Time (s)');
ylabel('Amplitude');
legend('Envolop','motion figure');
title('Motion Graph Vs Envelope Signal');


%Question A:
%Down-sampling is performed after envelope computation in signal processing to achieve benefits such as
% reducing data size, improving computational efficiency, reducing noise, limiting bandwidth, ensuring compatibility
% with other systems, and filtering out unwanted high-frequency components.
% This process helps make the data more manageable and suitable for various applications while preserving 
% essential information. However, proper anti-aliasing measures should be taken to prevent artifacts when 
% down-sampling.

%Question B:
%After comparing the motion figure with the envelope signal we concluded
%that the envelop graph start before the acceleration, which makes sense
%that in order the muscle to start moving it must recieves and activation
%first from noticing the graph we notices that the envelop lead the motion
%figure with a short period estimated to be arround 0.5 seconds.


%Question 5:Suggesting an other mapping 
%From our previous mappings approached the motion of the curson using position which comes from the the filtered 
%signal, the movevment of the curson could also be approached through
%velocity, in other words it is possoible to use the derivate block after 
% to obtain the velocity signal, then we have to use two thresholds in order
% to control each velocity for each muscle.
