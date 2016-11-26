%% Read images
img1 = rgb2gray( imread('stereo-pairs\cones\imL.png'));
img2 = rgb2gray( imread('stereo-pairs\cones\imR.png'));
figure,imshow(img1);
[img1canny,threshOut] = edge(img1,'Canny');
%figure, imshow(img1canny);
threshold = threshOut*1.0;
BW1 = edge(img1,'Canny',threshold); 
[H,theta,rho] = hough(BW1);

% Find all the lines
P = houghpeaks(H, 1000, 'threshold', floor(min(H(:))));
lines = houghlines(BW1,theta,rho,P,'FillGap',1,'MinLength',1);
length(lines)

pointImg1 = zeros(size(img1));
xPoints = zeros(ceil(length(lines)/2),1);
yPoints = zeros(ceil(length(lines)/2),1);

%% Get lines
%figure, imshow(img1), hold on
i = 1;
for k = 1:length(lines)
    if(mod(k,2) ~= 0)
        xy = [lines(k).point1; lines(k).point2];
        x1 = ceil(sum(xy(:,1))/2);
        y1 = ceil(sum(xy(:,2))/2);
        xPoints(i) = x1;
        yPoints(i) = y1;
        i = i+1;
        pointImg1(y1, x1) = 1;
    end
   
   %plot(x1,y1,'r.','markerSize',5);
end

%plot(xy(:,1),xy(:,2),'LineWidth',5,'Color','blue');

%% Delaunay
figure, imshow(pointImg1);
%figure, imshow(img1);
DpointImg1 = delaunay(xPoints, yPoints);

%% Plotting
figure,imshow(img1), hold on
plot(xPoints, yPoints,'.','markersize',3);

%% Plot delaunay
triplot(DpointImg1,xPoints, yPoints); hold off
