clear all;
pixel= csvread('pixel.csv')
pixel;
length(pixel(:,1))
temp=[71320320,47531264]

xyvalue=[];
xyvalue1=[];
xyvalue2=[];
for i1=1:length(pixel(:,1))
    name=[int2str(i1),'.jpeg'];
    I=imread(name);
    %I=rgb2gray(I);
    %figure(i1), imshow(I), hold on
    BW=edge(I,'canny');
    [H,T,R]=hough(BW);
    P=houghpeaks(H,5,'threshold',ceil(0.3*max(H(:))));
    lines=houghlines(BW,T,R,P,'FillGap',5,'MinLength',7);
    max_len=0;
    max_len1=0;
    max_len2=0;
    xy_long=[];
    xy_long1=[];
    xy_long2=[];
    for k=1:length(lines)
        xy=[lines(k).point1;lines(k).point2];
        len=norm(lines(k).point1-lines(k).point2);
        if(len>max_len)
            max_len2=max_len1;
            xy_long2=xy_long1;
            max_len1=max_len;
            xy_long1=xy_long;
            max_len=len;
            xy_long=xy;
        elseif( len>max_len1)
            max_len2=max_len1
            xy_long2=xy_long1;
            max_len1=len;
            xy_long1=xy;
        elseif(len>max_len2)
            max_len2=len;
            xy_long2=xy;
        end
    end
    xy;
    xyvalue(i1*2-1,:)=pixel(i1,:)+xy_long(1,:)-temp;
    xyvalue(i1*2,:)=pixel(i1,:)+xy_long(2,:)-temp;
    xyvalue1(i1*2-1,:)=pixel(i1,:)+xy_long1(1,:)-temp;
    xyvalue1(i1*2,:)=pixel(i1,:)+xy_long1(2,:)-temp;
    xyvalue2(i1*2-1,:)=pixel(i1,:)+xy_long2(1,:)-temp;
    xyvalue2(i1*2,:)=pixel(i1,:)+xy_long2(2,:)-temp;
%figure(i1),plot(xy_long(:,1),xy_long(:,2),'LineWidth',2,'Color','cyan'),hold on;
%figure(i1),plot(xy_long1(:,1),xy_long1(:,2),'LineWidth',2,'Color','blue'),hold on;
%figure(i1),plot(xy_long2(:,1),xy_long2(:,2),'LineWidth',2,'Color','red');
end
traj= csvread('pixel_traj.csv')
xyvalue;
xyvalue1;
xyvalue2;
x=traj(:,1)-71320320
x=x'
y=traj(:,2)-47531265
y=y'
k=0
xp=0
yp=0
for i=1:1:100
    xp=xp+[1;x(i)]*[1,x(i)]
    yp=yp+[1;x(i)]*y(i)
    
end
ans1=linsolve(xp,yp)
figure(40)
plot(x,y,'p')
hold on
x1=0:2500
y1=(ans1(2,1)*x1+ans1(1,1))
Q1=[199;199*ans1(2,1)+ans1(1,1)];
Q2=[1000;1000*ans1(2,1)+ans1(1,1)];
d=0;
final=[,]
leftfinal=[,]
num=0;
numl=0;
raw=imread('rawImage.jpeg');
figure(41), imshow(raw), hold on
figure(99), imshow(raw), hold on

alldata=[xyvalue;xyvalue1;xyvalue2]
for c1=1:length(alldata(:,1))
    
    d = abs(det([Q2-Q1,alldata(c1,:)'-Q1]))/norm(Q2-Q1);
    if d<34.5
        num=num+1;
        final(num,:)=alldata(c1,:);
    else
        if d<69
            numl=numl+1;
            leftfinal(numl,:)=alldata(c1,:);
        end
    end
    
end

final;
x=final(:,1)
x=x'
y=final(:,2)
y=y'
k=0
xp=0
yp=0
for i=1:1:length(x)
    xp=xp+[1;x(i)]*[1,x(i)]
    yp=yp+[1;x(i)]*y(i)
    
end
ans2=linsolve(xp,yp)
xr=0:2500;
yr=(ans2(2,1)*xr+ans2(1,1))
figure(99),plot(xr,yr,'cyan','linewidth',3), hold on


x=leftfinal(:,1)
x=x'
y=leftfinal(:,2)
y=y'
k=0
xp=0
yp=0
for i=1:1:length(x)
    xp=xp+[1;x(i)]*[1,x(i)]
    yp=yp+[1;x(i)]*y(i)
    
end
ans3=linsolve(xp,yp)
xl=0:2500
yl=(ans3(2,1)*x1+ans3(1,1))
figure(99),plot(xl,yl,'red','linewidth',3), hold on
rightlane=[,];
rc=1;
midlane=[,];
mc=1;
for i=1:1:length(final)
    if(final(i,1)*ans2(2)+ans2(1)>final(i,2))
        midlane(mc,:)=final(i,:)
        mc=mc+1
    else
        rightlane(rc,:)=final(i,:)
        rc=rc+1
    end
end
figure(2),imshow(raw),hold on;
figure(2),plot(rightlane(:,1),rightlane(:,2),'r','linewidth',2), hold on   
figure(2),plot(midlane(:,1),midlane(:,2),'g','linewidth',2), hold on   
leftlane=[,];
lc=1;

for i=1:1:length(leftfinal)
    if(leftfinal(i,1)*ans3(2)+ans3(1)>leftfinal(i,2))
        leftlane(lc,:)=leftfinal(i,:)
        lc=lc+1

    end
end
mapsize=256*2^19;
rightll=[,]
midll=[,]
leftll=[,]
for i=1:1:length(rightlane)
    rightlane(i,1)=(rightlane(i,1)+71320320)/mapsize-0.5;
    rightlane(i,2)=0.5-(rightlane(i,2)+47531265)/mapsize;
       rightll(i,1)=90-360*atan(exp(-rightlane(i,2)*2*pi))/pi
     rightll(i,2)=360*rightlane(i,1)
end
for i=1:1:length(midlane)
    midlane(i,1)=(midlane(i,1)+71320320)/mapsize-0.5;
    midlane(i,2)=0.5-(midlane(i,2)+47531265)/mapsize;
       midll(i,1)=90-360*atan(exp(-midlane(i,2)*2*pi))/pi
     midll(i,2)=360*midlane(i,1)
end
for i=1:1:length(leftlane)
    leftlane(i,1)=(leftlane(i,1)+71320320)/mapsize-0.5;
    leftlane(i,2)=0.5-(leftlane(i,2)+47531265)/mapsize;
       leftll(i,1)=90-360*atan(exp(-leftlane(i,2)*2*pi))/pi
     leftll(i,2)=360*leftlane(i,1)
end

figure(2),plot(leftlane(:,1),leftlane(:,2),'b','linewidth',2), hold on   


csvwrite('D:\geo\right.csv',rightll);
csvwrite('D:\geo\left.csv',leftll);
csvwrite('D:\geo\mid.csv',midll);


