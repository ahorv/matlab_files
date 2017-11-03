clear 'all'
close 'all'

path = '20171025_140139'

file = fopen(strcat(path,'/data5_.data'), 'r');
raw = fread(file, [3296 2464], 'uint16');
fclose(file);

% BGBGBGBGBGBGBG
% GRGRGRGRGRGRGR
% BGBGBGBGBGBGBG
% GRGRGRGRGRGRGR

p1 = raw(1:2:end, 1:2:end);%blue channel
p2 = raw(1:2:end, 2:2:end);%1rst green channel
p3 = raw(2:2:end, 1:2:end);%2nd green channel
p4 = raw(2:2:end, 2:2:end);%red channel

maxVal = 255;
figure;imshow(p1', [0 maxVal]);title('BLUE: p1');
figure;imshow((p2+p3)'/2, [0 maxVal]);title('GREEN: (p2+p3)/2');
figure;imshow(p4', [0 maxVal]);title('RED: p4');

%try to create a "real" rgb-image
%overall scaling
scal = 0.5;
%gamma correction
gamma = 1.;
%b,g and r gain; wurden rausgelesen aus den picam Aufnahmedaten
vb = 87/64.;     % 87/64.
vg = 1.;   % 1.
vr = 235/128.;  % 235/128.
img = zeros(2464/2, 3296/2, 3);
img(:,:,1) = vr*1023*(p4(:,:)'/1023).^gamma;
img(:,:,2) = vg*1023*((p2(:,:)'+p3(:,:)')/(2*1023)).^gamma;
img(:,:,3) = vb*(1023*p1(:,:)'/1023).^gamma;

%result is clipped to ubyte [0 255]
figure;imshow(uint8(scal*img));title('RGB');

