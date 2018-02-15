clear all, clc
Ns=100;
Nv=3;
h=0.1;
k=1:Ns-1;
t=sdpvar(Ns,Nv);
z=sdpvar(Ns,Nv);
dz=sdpvar(Ns,Nv);
ddz=sdpvar(Ns,Nv);
%A=zeros(Nv,Nv)
Asub=[1 h 0; 0 1 h; 0 0 1];
for i=1:Nv
    X(1+(i-1)*3,:)=t(:,i);
    X(2+(i-1)*3,:)=z(:,i);
    X((3+(i-1)*3),:)=dz(:,i);
end
%A(1:3,1:3)=Asub
A=zeros(3*Nv,3*Nv);
for i=1:Nv
    %A(i+3*(i-1):3*i-2,i+3*(i-1):i+3*(i-1)+3)=Asub;
    %3*i-2
    %3*i
    A(3*i-2:3*i,3*i-2:3*i)=Asub;
end
X(:,k+1)=A*X(:,k);
%X(1,1)
  
  