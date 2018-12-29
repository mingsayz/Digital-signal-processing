clear all;
clc

%------------- music cropping -----------------

[y,fs] = audioread('3_IMYours.wav');
y = y(:,1); 
ts = 1/fs;


start_time = 30; end_time = 35;
startSample  = floor(start_time/ts + 1);
endSample = floor(end_time/ts + 1); 


t_crop = 0:ts:end_time - start_time;
y_crop = y(startSample : endSample); 

subplot(411)
plot(t_crop, y_crop)
title('cropping')
axis tight
sound(y_cut,fs) 

%------------- Sample Ratio -----------------

underSampleRatio = 30; 
y_underSample = y_crop(1:underSampleRatio:length(y_crop)); 
t_underSample = (1:underSampleRatio:length(y_crop)) * ts; 

subplot(412)
plot(t_underSample,y_underSample)
title('undersampling')
axis tight
hold on
sound(y_underSample,fs/underSampleRatio) 


%------------- recovery using convolution-----------------

Fs = fs/underSampleRatio; Ts = 1/Fs;

num_under_Samples = length(y_undersample);
nTs = ( 0: (num_under_Samples -1 ) ) * Ts; 

tRec = 0:ts:end_time - start_time;
xRec = zeros(1,length(tRec));
perfectConv = 0;
convWidth = 50;
 
for i = 1:length(tRec)
    if perfectConv == 1 % 이것은 sinc 함수 그자체를 곱해주는것
        xRec(i) = sum(y_undersample .* sinc(Fs * (tRec(i) - t_undersample)));
    else
        [Y,centerSample] = min(abs(tRec(i) - t_undersample)); 
        convIndex = max(centerSample - floor(convWidth/2), 1) : min(centerSample + floor(convWidth/2),length(y_undersample));
        xRec(i) = sum(y_undersample(convIndex)' .* sinc(Fs * (tRec(i) - t_undersample(convIndex))));
    end
end
 
subplot(413)
plot(tRec,xRec)
title('recovery using convolution')
axis tight
hold on
sound(xRec,fs) 



%------------recovery using zero-hold-----------------

xRec_hold = zeros(1,length(t_underSample));
    
for i = 1:length(y_underSample)
    xRec_hold (underSampleRatio * (i-1) + 1 : underSampleRatio * i) = y_underSample(i);    
end

xRec_hold=xRec_hold(1:length(xRec_hold)-4);

subplot(414)
plot(t_crop, xRec_hold)
title('recovery using zero-hold')
axis tight
sound(xRec_hold,fs)
