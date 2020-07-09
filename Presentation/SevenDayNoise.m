%% Seven Day Noise
% The following code creates artificial noise which follows a seven day
% trend and applies it to generated data.
% It also attempts to reduce the effect the noise has on our ability to fit
% a curve to the data by smoothing out the noisy data
clear all;
% Create data to introduce noise to (Gaussian Curve)
t = linspace(0,100,55)';
A = 550; B = 50; C = 20;
Exact = A*exp(-((t - B)/C).^2);
Start = [4, 0, 1];
% Creat noise which follows weekly reporting issues
n = ones(1,5);
for i = 1:55;
    if floor(i/7) == i/7
        n(i) = 0.3.*Exact(i-1);         % Monday +30% sunday cases (unreported cases)
        n(i+1) = 0.1.*Exact(i+2);       % Tuesday with 10% under-report
        n(i+2) = -0.1.*Exact(i+2);      % Wednesday + Tuesdays missed cases
        n(i+3) = 0.5.*randn(size(i));         % Thursday with random noise
        n(i+4) = -0.5.*randn(size(i));         % Friday with random noise
        n(i+5) = 0.5.*randn(size(i));         % Saturday with random noise
        n(i+6) = -0.3.*Exact(i+6);      % Sunday with 30% Under-report
        
        
    end
end
% Make the noisy data
Noisey = Exact + n';
% smooth out the noise
Smooth = smoothdata(Noisey,'gaussian', 4);
%% Plot and fit a curve to the smooth data set
figure(1);
plot(t,Exact, 'bo')
ft1 = fittype('a*exp(-((x-b)/c)^2)');
[Graph3] = fit(t, Smooth, ft1, 'StartPoint', Start);
hold on;
plot(t,Noisey, 'r*-')
hold off;
legend('Original Data','Noisy Data');
title('Noisy Data VS Original Data');
xlabel('Days');
ylabel('Daily Cases');
grid on;

figure(2);
plot(t, Smooth, 'c*');
hold on;
plot(Graph3,'g-');
plot(t,Noisey, 'r*-')
hold off;
legend('Smooth Data','Smooth Fit','Noisy Data')
title('Reduced Noise Data VS Noisey Data');
xlabel('Days');
ylabel('Daily Cases');
grid on;