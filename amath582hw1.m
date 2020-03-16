%%%%%%%%%%%%%%%%%%%%%%%%% Save Fluffy %%%%%%%%%%%%%%%%%%%%%%%%%%%
% Name: Han Song
% Class: AMATH 582
% Due date: way past due 

clear all; close all; clc;
load Testdata
[n_measurement, ~] = size(Undata);
L=15; % spatial domain
n=64; % Fourier modes
x2=linspace(-L,L,n+1); x=x2(1:n); y=x; z=x;
k=(2*pi/(2*L))*[0:(n/2-1) -n/2:-1]; ks=fftshift(k);
[X,Y,Z]=meshgrid(x,y,z);
[Kx,Ky,Kz]=meshgrid(ks,ks,ks);

Uave = zeros(n,n,n);
for j = 1:n_measurement
    Utn(:,:,:) = fftn(reshape(Undata(j,:,:),n,n,n));
    Uave = Uave + Utn;
end
Uave = fftshift(Uave)./20;
[value,index] = max(Uave(:));
[a,b,c] = ind2sub(size(Uave),index); %extract coordinates of the marble
isosurface(Kx,Ky,Kz,abs(Uave)./max(abs(Uave(:))),0.4)
xlabel('Kx')
ylabel('Ky')
zlabel('Kz')
title('Frequency domain')
xx = Kx(a,b,c);
yy = Ky(a,b,c);
zz = Kz(a,b,c);
fprintf('Center frequency: %.3f %.3f %.3f\n',xx,yy,zz);

A = zeros(1,n_measurement);
B = A;
C = A;
filter=exp(-0.2*(((Kx-xx).^2)+((Ky-yy).^2)+((Kz-zz).^2)));
for i = 1:20
    data(:,:,:) = reshape(Undata(i,:),n,n,n);
    Un = fftn(data);
    Unft = filter.*fftshift(Un);
    Unf = ifftn(Unft);
    [value,index] = max(Unf(:));
    [b,a,c] = ind2sub(size(Unf),index);
    A(i) = a;
    B(i) = b;
    C(i) = c;
end
figure(2)
plot3(x(A),y(B),z(C))
xlabel('x')
ylabel('y')
zlabel('z')
title('Marble Movement Trajectory')
fprintf('Intense acoustic wave should be focused at %.3f %.3f %.3f\n',x(A(end)),y(B(end)),z(C(end)));