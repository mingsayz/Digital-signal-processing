clear all;
close all;

f=1e7;
fs=10e7;
ts=1/fs;
tStart=0;
tEnd=3e-6;
t=tStart:ts:tEnd;

numSamples=length(t);

y=exp(-0.1.*f.*t).*cos(2.*pi.*f.*t.*(exp(-0.1.*f.*t)));


% figure(1)
% stem(t,y)

Q=4;% 콴타이제이션 order

minlevel=min(y);
maxlevel=max(y);

% levels=[minlevel:(maxlevel-minlevel)/((2^Q)-1):maxlevel];
% 
% yQuant=zeros(1,numSamples);
% errorQuant=zeros(1,numSamples);
% errorZeroQuant = zeros(1,9);
% 
% for i=1:numSamples
%     [Y,I]=min(abs(y(i)-levels));
%     yQuant(i)=levels(I);
% end
% 
% figure(2)
% stem(t,yQuant)
Q = 2:10;
yQuant=zeros(1,numSamples);
errorQuant = zeros(1,numSamples);
errorZeroQuant = zeros(1,length(Q));
for i = 1: length(Q) 
    levels=[minlevel:(maxlevel-minlevel)/((2^Q(i)-1)):maxlevel];
    for j=1:numSamples
        [Y,I]=min(abs(y(j)-levels));
        yQuant(j)=levels(I);
        errorQuant(j) = abs(y(j) - yQuant(j));
    end
    errorZeroQuant(i) = mean(errorQuant);
end

figure(3)
plot(Q,errorZeroQuant) 

Q = 4;
%bitStream = zeros(0,numSamples*Q);
levels =[minlevel:(maxlevel-minlevel)/((2^Q)-1):maxlevel];
for j= 1 : numSamples
    [Y,I] = min(abs(y(j)-levels));
    %bitStream((j-1)*Q+1 : j*Q) = dec2bin(I-1,Q);
    bitStream(j*Q-(Q-1) : j*Q) = de2bi(I-1,Q);
    %dec2bin 은 문자열(char)로 반환 de2bi 는 정수형으로 반환된다.
end

Pb = 0 : 0.05 : 0.5 ;
error_bitStream = zeros(length(Pb),length(bitStream));

% Pb 에러율에 따라 bitStream에 에러 생성함

for i=1 : length(Pb)
    for j=1 : length(bitStream)
        if rand < Pb(i)
            if (bitStream(j) == 0)
                error_bitStream(i,j) = 1;
            else 
                error_bitStream(i,j) = 0;
            end
        else
            error_bitStream(i,j) = bitStream(j);
        end
    end
end

%error_bitStream을 십진수로 다시 변환.

error_bitStream_row = zeros(1,length(bitStream)); %error_bitStream의 한행씩
error_index = zeros(length(Pb),length(numSamples)); % Q 자리 씩 끊어서 2진수를 10진수로 변환
rec_y = zeros(length(Pb),length(numSamples)); %10진수로 변환한 값 levels 값에 넣음

errorQuant = zeros(length(Pb),length(numSamples));
avgQuantError = zeros(length(Pb),1);

for i = 1 : length(Pb)
    error_bitStream_row = error_bitStream(i,:);
    for j = 1 : numSamples
        error_index(i,j) = bi2de(error_bitStream_row(j*Q: -1 : (j-1)*Q+1)) +1 ;
        rec_y(i,j) = levels(error_index(i,j));
        
        errorQuant(i,j) = abs(y(j) - rec_y(i,j));
    end
    avgQuantError(i) = mean(errorQuant(i,:));
    
end

figure
stem(t,rec_y(5,:))

figure
plot(Pb,avgQuantError) 