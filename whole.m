input = load('lines1.mat');
lines = input.lines;
% sort the lines so that x1 is always the left of x2. If x1 and x2 are the
% same, then y1 is always smaller than y2(y1 is above y2 on the image)
for a = 1:size(lines,2)
    if (lines(1,a)>lines(2,a) == 1)
        temp1 = lines(2,a);
        lines(2,a) = lines(1,a);
        lines(1,a) = temp1;
        temp2 = lines(3,a);
        lines(3,a) = lines(4,a);
        lines(4,a) = temp2;
    elseif ((lines(1,a) == lines(2,a)) && (lines(3,a)>lines(4,a)))
        temp3 = lines(2,a);
        lines(2,a) = lines(1,a);
        lines(1,a) = temp3;
        temp4 = lines(3,a);
        lines(3,a) = lines(4,a);
        lines(4,a) = temp4;
        
    end
        
      
end
parallels = cell(1,2);
count = 0;
% To find the parallel pairs in the whole image
for i = 1:size(lines,2)
    for j = 1:size(lines,2)
        if ~(i==j)
            % the window based method
            if (lines(1,j)<(lines(2,i)+10)) && (lines(1,j) > (lines(1,i)-10))
                % To check the values of y to see which one is bigger
                if (lines(3,i)<lines(4,i))
                    if (lines(3,j)<(lines(4,i)+15)) && (lines(3,j)>(lines(3,i)-15))
                        % To compute the slopes of the lines
                        slopei = (lines(4,i) - lines(3,i))/(lines(2,i)-lines(1,i));
                        slopej = (lines(4,j) - lines(3,j))/(lines(2,j)-lines(1,j));
                        if (-0.3 < (slopei-slopej))&&((slopei-slopej) < 0.3)
                            count = count+1;
                            parallels{count,1} = lines(:,i);
                            parallels{count,2} = lines(:,j);
                            
                        end
                    end
                else 
                    if (lines(3,j)<(lines(3,i)+10)) && (lines(3,j)>(lines(4,i)-10))
                        slopei = (lines(4,i) - lines(3,i))/(lines(2,i)-lines(1,i));
                        slopej = (lines(4,j) - lines(3,j))/(lines(2,j)-lines(1,j));
                        if (-0.2 < (slopei-slopej))&&((slopei-slopej) < 0.2)
                            count = count+1;
                            parallels{count,1} = lines(:,i);
                            parallels{count,2} = lines(:,j);
                        end
                    end
                end
            end
        end
    end
end

%Delete the repetive ones
for m=1:size(parallels,1)-1
    for n = m+1:size(parallels,1)
        if (all(parallels{m,1}==parallels{n,2})) && (all(parallels{m,2} == parallels{n,1}))
            parallels{n,1} = [0;0;0;0;0];
            parallels{n,2} = [0;0;0;0;0];
        end
    end
        
end

% for m = 1:size(parallels,1)
%     if (all(parallels{m,1}== 0))
%         parallels{m,1} = [];
%         parallels{m,2} = [];
%     end
% end

 %parallelsnew = parallels(~cellfun('isempty',parallels)) ; 
 roofhypo = cell(1,4);
 number = 0;
 % Find the perpendicular rooftop hypothesis
 for a = 1:size(parallels,1)-1
     for b = a+1:size(parallels,1)
         if ~any(parallels{a,1}==0) && ~any(parallels{b,1}==0)
             li1 = parallels{a,1};
             li12= parallels{a,2};
             li2 = parallels{b,1};
             li22 = parallels{b,2};
             slope1 = (li1(4,1) - li1(3,1))/(li1(2,1)-li1(1,1));
             slope2 = (li2(4,1) - li2(3,1))/(li2(2,1)-li2(1,1));
             if ((slope1*slope2) < -0.8) && ((slope1*slope2) > -1.2)  
                 % window based method
                 maxx = max([li1(2),li12(2),li2(2),li22(2)]);
                 minx = min([li1(1),li12(1),li2(1),li22(1)]);
                 maxy = max([li1(3),li12(3),li2(3),li22(3),li1(4),li12(4),li2(4),li22(4)]);
                 miny = min([li1(3),li12(3),li2(3),li22(3),li1(4),li12(4),li2(4),li22(4)]); 
                 if (li1(1)>minx-10) && (li1(1)< maxx+10) && (li2(1)>minx-10) && (li2(1)< maxx+10) && (li12(1)>minx-10) && (li12(1)< maxx+10) && (li22(1)>minx-10) && (li22(1)< maxx+10)
                     if (li1(2)>minx-10) && (li1(2)< maxx+10) && (li2(2)>minx-10) && (li2(2)< maxx+10) && (li12(2)>minx-10) && (li12(2)< maxx+10) && (li22(2)>minx-10) && (li22(2)< maxx+10)
                         if  (li1(3)>miny-10) && (li1(3)< maxy+10) && (li2(3)>miny-10) && (li2(3)< maxy+10) && (li12(3)>miny-10) && (li12(3)< maxy+10) && (li22(3)>miny-10) && (li22(3)< maxy+10)
                             if (li1(4)>miny-10) && (li1(4)< maxy+10) && (li2(4)>miny-10) && (li2(4)< maxy+10) && (li12(4)>miny-10) && (li12(4)< maxy+10) && (li22(4)>miny-10) && (li22(4)< maxy+10)
                                 number = number + 1;
                                 roofhypo{number,1} = li1;
                                 roofhypo{number,2} = li12;
                                 roofhypo{number,3} = li2;
                                 roofhypo{number,4} = li22;
                             end
                         end
                     end
                 end
             end
         end
     end
 end

    